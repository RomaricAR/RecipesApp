//
//  RecipeDetailsViewModel.swift
//  RecipesTests
//
//  Created by Romaric Allahramadji on 2/18/25.
//

import XCTest
@testable import Recipes

final class RecipeDetailsViewModelTests: XCTestCase {
    var mockNetworkService: MockNetworkService!
    var recipeDetailsViewModel: RecipeDetailsViewModel!
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        recipeDetailsViewModel = RecipeDetailsViewModel(networkService: mockNetworkService)
    }
    override func tearDown() {
        recipeDetailsViewModel = nil
        mockNetworkService = nil
        super.tearDown()
    }

    // MARK: - Fetching Recipe Details Tests
    func test_a_detail_is_fetched() async {
        // Given
        var details: RecipeDetailsModel?
        // When
        await recipeDetailsViewModel.fetchRecipeDetails(id: "1", thumbnailURL: "")
        details = recipeDetailsViewModel.recipeDetails
        // Then
        XCTAssertNotNil(details)
        XCTAssertEqual(details?.ingredients.count, 2)
    }
    func test_fetchRecipeDetails_whenNoValidData_throwsValidationError() async {
        // Given
        let viewModel = RecipeDetailsViewModel(networkService: FailingNetworkService(errorType: .invalidRecipeData))
        // When
        await viewModel.fetchRecipeDetails(id: "1", thumbnailURL: "")
        // Then
        XCTAssertEqual(viewModel.errorMessage, RecipeError.invalidRecipeData.errorDescription)
    }
    func test_fetchRecipeDetails_whenNetworkFails_throwsNetworkError() async {
        // Given
        let urlError = URLError(.notConnectedToInternet)
        let viewModel = RecipeDetailsViewModel(networkService: FailingNetworkService(errorType: .networkError(urlError)))
        // When
        await viewModel.fetchRecipeDetails(id: "1", thumbnailURL: "")
        // Then
        XCTAssertEqual(viewModel.errorMessage, RecipeError.networkError(urlError).errorDescription)
    }
    func test_fetchRecipeDetails_whenUnknownErrorOccurs_throwsUnknownError() async {
        // Given
        let unknownError = NSError(domain: "TestDomain", code: -1, userInfo: nil)
        let viewModel = RecipeDetailsViewModel(networkService: FailingNetworkService(errorType: .unknown(unknownError)))
        // When
        await viewModel.fetchRecipeDetails(id: "1", thumbnailURL: "")
        // Then
        XCTAssertEqual(viewModel.errorMessage, RecipeError.unknown(unknownError).errorDescription)
    }
    func test_fetchRecipeDetails_whenRecipeDetailsInvalid_throwsValidationError() async {
        // Given
        let invalidMockService = MockNetworkService()
        invalidMockService.shouldReturnInvalidDetails = true
        let viewModel = RecipeDetailsViewModel(networkService: invalidMockService)
        // When
        await viewModel.fetchRecipeDetails(id: "1", thumbnailURL: "")
        // Then
        XCTAssertEqual(viewModel.errorMessage, RecipeError.invalidRecipeData.errorDescription)
    }
    // MARK: - Recipe Details Validation Test
    func test_is_valid_recipe_details() async {
        // Given
        var isValid = false
        // When
        await recipeDetailsViewModel.fetchRecipeDetails(id: "1", thumbnailURL: "")
        isValid = recipeDetailsViewModel.recipeDetails?.isValid ?? false
        // Then
        XCTAssertTrue(isValid)
    }
}
