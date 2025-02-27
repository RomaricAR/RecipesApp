//
//  RecipeDetailsViewModel.swift
//  Recipes
//
//  Created by Romaric Allahramadji on 8/6/24.
//

import Foundation

class RecipeDetailsViewModel: ObservableObject {
    @Published private(set) var recipeDetails: RecipeDetailsModel?
    @Published private(set) var isLoading = false
    @Published var recipeThumbnailURL: String?
    @Published private(set) var errorMessage: String?
    var recipeDetailsUrlString = "https://www.themealdb.com/api/json/v1/1/lookup.php?"
    private let networkService: NetworkServiceProtocol
    init(networkService: NetworkServiceProtocol ) {
        self.networkService = networkService
    }
    @MainActor
    func fetchRecipeDetails(id: String) async {
        self.isLoading = true
        do {
            let data: RecipeDetailResponse = try await networkService.fetchData(endPoint: RecipeEndpoint.recipeDetails(id: id).urlString)
            guard let recipeDetails = data.details.first else {
                throw URLError(.badServerResponse)
            }
            self.recipeDetails = recipeDetails
        } catch {
            handle(error.asRecipeError)
            }
            self.isLoading = false
    }
    private func handle(_ error: RecipeError) {
        errorMessage = error.errorDescription
    }
}
