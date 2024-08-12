//
//  MockNetworkService.swift
//  RecipesTests
//
//  Created by Romaric Allahramadji on 8/7/24.
//

import Foundation
@testable import Recipes

// Concrete implementation of the network service that fetches data from the API.
class MockNetworkService: NetworkServiceProtocol {
    func fetchRecipes(category: String) async throws -> [Recipe] {
        return [
            Recipe(id: "1", name: "Test Recipe 1", thumbnailURL: "https://example.com/image1.jpg"),
            Recipe(id: "2", name: "Test Recipe 2", thumbnailURL: "https://example.com/image2.jpg")
        ]
    }
    // Fetches detailed information about a specific recipe by its ID.
    func fetchRecipeDetails(id: String) async throws -> RecipeDetailsModel {
        return RecipeDetailsModel(
            recipeName: "Test Recipe",
            instructions: "Test Instructions",
            recipeThumbnailURL: "https://example.com/image.jpg",
            recipeID: id,
            ingredients: ["Ingredient 1", "Ingredient 2"],
            measurements: ["1 cup", "2 tbsp"]
        )
    }
}
