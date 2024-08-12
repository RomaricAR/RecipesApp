//
//  RecipesTests.swift
//  RecipesTests
//
//  Created by Romaric Allahramadji on 8/6/24.
//

import XCTest
@testable import Recipes

final class RecipeViewModel_Tests: XCTestCase {
    
    var recipesViewModel: RecipesViewModel!
    var recipeDetailsViewModel: RecipeDetailsViewModel!
    
    override func setUp() {
        super.setUp()
        let mockNetworkService = MockNetworkService()
        recipesViewModel = RecipesViewModel(networkService: mockNetworkService)
        recipeDetailsViewModel = RecipeDetailsViewModel(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        recipesViewModel = nil
        recipeDetailsViewModel = nil
        super.tearDown()
    }
    
    func test_RecipesViewModel_GetRecipes_ShouldNotBeEmpty() async {
        // Given
        let expectation = self.expectation(description: "Recipes loaded successfully")
        
        // When
        await recipesViewModel.fetchRecipes()
        
        // Then
        XCTAssertFalse(recipesViewModel.recipes.isEmpty, "Expected non-empty recipes array")
        expectation.fulfill()
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func test_RecipesViewModel_ShouldHandleNetworkError() async {
        // Given
        class FailingNetworkService: NetworkServiceProtocol {
            func fetchRecipes(category: String) async throws -> [Recipe] {
                throw URLError(.badURL)
            }
            func fetchRecipeDetails(id: String) async throws -> RecipeDetailsModel {
                throw URLError(.badURL)
            }
        }
        
        recipesViewModel = RecipesViewModel(networkService: FailingNetworkService())
        let expectation = self.expectation(description: "Network error handled")
        
        // When
        await recipesViewModel.fetchRecipes()
        
        // Then
        XCTAssertTrue(recipesViewModel.recipes.isEmpty, "Expected empty recipes array on network error")
        XCTAssertNotNil(recipesViewModel.errorMessage, "Expected error message to be set")
        expectation.fulfill()
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func test_RecipesViewModel_GetRecipes_ShouldHandleCancellationCorrectly() async {
        // Given
        let expectation = self.expectation(description: "Cancellation")
        
        // When
        let task = Task { await recipesViewModel.fetchRecipes() }
        task.cancel()
        
        // Then
        XCTAssertTrue(recipesViewModel.recipes.isEmpty, "Expected empty recipes array after cancellation")
        expectation.fulfill()
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
    func test_RecipeDetailsViewModel_ConstructsUrlProperly() {
        // Given
        let validID = "52893"
        let expectedURL = URL(string: "\(recipeDetailsViewModel.recipeDetailsUrlString)i=\(validID)")
        
        // When
        let constructedURL = recipeDetailsViewModel.constructRecipeDetailsURL(id: validID)
        
        // Then
        XCTAssertEqual(constructedURL, expectedURL, "URL is not constructed correctly")
    }
    
    func test_RecipeDetailsViewModel_GetRecipeDetails_ShouldFetchDetails() async {
        // Given
        let validID = "52893"
        let expectation = self.expectation(description: "Details Retrieval")
        
        // When
        await recipeDetailsViewModel.fetchRecipeDetails(id: validID, thumbnailURL: "https://example.com/image.jpg")
        
        // Then
        XCTAssertFalse(recipeDetailsViewModel.recipeDetails?.recipeID.isEmpty ?? true, "Expected non-empty recipe details")
        expectation.fulfill()
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    func test_RecipesViewModel_ShouldHandleUnexpectedData() async {
        // Given
        class UnexpectedDataNetworkService: NetworkServiceProtocol {
            func fetchRecipes(category: String) async throws -> [Recipe] {
                return [Recipe(id: "", name: "", thumbnailURL: "")]
            }
            func fetchRecipeDetails(id: String) async throws -> RecipeDetailsModel {
                return RecipeDetailsModel(
                    recipeName: "",
                    instructions: "",
                    recipeThumbnailURL: "",
                    recipeID: "",
                    ingredients: [],
                    measurements: []
                )
            }
        }
        
        recipesViewModel = RecipesViewModel(networkService: UnexpectedDataNetworkService())
        let expectation = self.expectation(description: "Handle unexpected data structure")
        
        // When
        await recipesViewModel.fetchRecipes()
        
        // Then
        XCTAssertTrue(recipesViewModel.recipes.isEmpty, "Expected empty recipes array with unexpected data")
        XCTAssertNotNil(recipesViewModel.errorMessage, "Expected error message to be set with unexpected data")
        expectation.fulfill()
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
    
   
    func test_RecipesViewModel_ShouldHandleInterruptedFetch() async {
        // Given
        class InterruptingNetworkService: NetworkServiceProtocol {
            func fetchRecipes(category: String) async throws -> [Recipe] {
                throw URLError(.networkConnectionLost)
            }
            func fetchRecipeDetails(id: String) async throws -> RecipeDetailsModel {
                throw URLError(.networkConnectionLost)
            }
        }
        
        recipesViewModel = RecipesViewModel(networkService: InterruptingNetworkService())
        let expectation = self.expectation(description: "Handle interrupted network fetch")
        
        // When
        await recipesViewModel.fetchRecipes()
        
        // Then
        XCTAssertTrue(recipesViewModel.recipes.isEmpty, "Expected empty recipes array on interrupted fetch")
        XCTAssertNotNil(recipesViewModel.errorMessage, "Expected error message to be set on interrupted fetch")
        expectation.fulfill()
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
}
