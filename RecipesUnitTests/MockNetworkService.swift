//
//  MockNetworkService.swift
//  RecipesTests
//
//  Created by Romaric Allahramadji on 8/7/24.
//

import Foundation
@testable import Recipes

class MockNetworkService: NetworkServiceProtocol {
    var shouldReturnInvalidRecipes = false
    var shouldReturnInvalidDetails = false
    func fetchRecipes(category: String) async throws -> [Recipe] {
         if shouldReturnInvalidRecipes {
             return [Recipe(id: "", name: "", thumbnailURL: ""),
                     Recipe(id: "2", name: "", thumbnailURL: "https:")]
         } else {
             return [Recipe(id: "1", name: "Pasta", thumbnailURL: "https://example.com/pasta.jpg"),
                     Recipe(id: "2", name: "Pizza", thumbnailURL: "https://example.com/pizza.jpg")]
         }
     }

    func fetchRecipeDetails(id: String) async throws -> RecipeDetailsModel {
        if shouldReturnInvalidDetails {
            return RecipeDetailsModel(
                recipeName: "", // Empty name makes it invalid
                instructions: "",
                recipeThumbnailURL: "",
                recipeID: "",
                ingredients: [],
                measurements: []
            )
        } else {
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
}
