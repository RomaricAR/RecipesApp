//
//  RecipeDetailsViewModel.swift
//  Recipes
//
//  Created by Romaric Allahramadji on 8/6/24.
//

import Foundation

// ViewModel responsible for managing the state and data logic for displaying details of a selected recipe.
class RecipeDetailsViewModel: ObservableObject {
    @Published var recipeDetails: RecipeDetailsModel?
    @Published var recipeThumbnailURL: String?
    @Published var isLoading = false
    var errorMessage: String?

    // Network service for fetching recipe details.
    private var networkService: NetworkServiceProtocol
    
    var recipeDetailsUrlString = "https://www.themealdb.com/api/json/v1/1/lookup.php?"

    // Initializer that accepts a network service dependency.
    init(networkService: NetworkServiceProtocol = NetworkingService.shared) {
        self.networkService = networkService
    }

    // Fetches the details of a recipe from the API by its ID.
    @MainActor
    func fetchRecipeDetails(id: String, thumbnailURL: String) async {
        self.isLoading = true
        self.recipeThumbnailURL = thumbnailURL
        
        do {
            let fetchedRecipeDetails = try await networkService.fetchRecipeDetails(id: id)
            
            // Validate the fetched details and ensure they are complete.
            guard fetchedRecipeDetails.isValid else {
                throw ErrorType.validationError
            }
            
            self.recipeDetails = fetchedRecipeDetails
        } catch {
            self.errorMessage = error.localizedDescription
        }
        self.isLoading = false
    }
    
    //For unit testing purposes only
    func constructRecipeDetailsURL(id: String) -> URL? {
        return URL(string: "\(recipeDetailsUrlString)i=\(id)")
    }
}

