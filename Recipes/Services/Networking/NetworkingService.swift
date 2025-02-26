//
//  NetworkingService.swift
//  Recipes
//
//  Created by Romaric Allahramadji on 8/6/24.
//

import Foundation

class NetworkingService: NetworkServiceProtocol {
    static let shared = NetworkingService()
    private init() {}
    func fetchRecipes(category: String) async throws -> [Recipe] {
        let urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(category)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        let recipesResponse = try JSONDecoder().decode(RecipesResponse.self, from: data)
        return recipesResponse.recipes.sorted { $0.name < $1.name }
    }
    func fetchRecipeDetails(id: String) async throws -> RecipeDetailsModel {
        let urlString = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(id)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        let recipeDetailResponse = try JSONDecoder().decode(RecipeDetailResponse.self, from: data)
        guard let recipeDetails = recipeDetailResponse.recipes.first else {
            throw URLError(.badServerResponse)
        }
        return recipeDetails
    }
}
