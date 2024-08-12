//
//  NetworkingService.swift
//  Recipes
//
//  Created by Romaric Allahramadji on 8/6/24.
//

import Foundation

// Networking service responsible for making API requests to fetch recipes and their details.
class NetworkingService: NetworkServiceProtocol {
    // Singleton instance of NetworkingService to be used throughout the app.
    static let shared = NetworkingService()

    // Private initializer to ensure that the service can only be instantiated once (singleton pattern).
    private init() {}

    // Fetches a list of recipes from the API based on the provided category.
    func fetchRecipes(category: String) async throws -> [Recipe] {
        
        let urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(category)"
        
        // Ensure the URL is valid; throw an error if it is not.
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        // Perform the network request and fetch the data from the API.
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Decode the JSON response into a RecipesResponse object.
        let recipesResponse = try JSONDecoder().decode(RecipesResponse.self, from: data)
        
        // Return the list of recipes, sorted alphabetically by name.
        return recipesResponse.recipes.sorted { $0.name < $1.name }
    }

    // Fetches the details of a specific recipe from the API based on the provided recipe ID.
    func fetchRecipeDetails(id: String) async throws -> RecipeDetailsModel {
        
        let urlString = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(id)"
        
        // Ensure the URL is valid; throw an error if it is not.
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        // Perform the network request and fetch the data from the API.
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Decode the JSON response into a RecipeDetailResponse object.
        let recipeDetailResponse = try JSONDecoder().decode(RecipeDetailResponse.self, from: data)
        
        
        // Safely unwrap the first recipe in the response, throwing an error if it's nil.
        guard let recipeDetails = recipeDetailResponse.recipes.first else {
            throw URLError(.badServerResponse)
        }
        return recipeDetails
    }
}

// Model representing the response for a list of recipes from the API.
struct RecipesResponse: Codable {
    let recipes: [Recipe]

    // Custom coding keys to map the "meals" key from the API response to "recipes".
    enum CodingKeys: String, CodingKey {
        case recipes = "meals"
    }
}

// Model representing the response for a single recipe detail from the API.
struct RecipeDetailResponse: Codable {
    let recipes: [RecipeDetailsModel]

    // Custom coding keys to map the "meals" key from the API response to "recipes".
    enum CodingKeys: String, CodingKey {
        case recipes = "meals"
    }
}

