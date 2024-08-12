//
//  NetworkServiceProtocol.swift
//  Recipes
//
//  Created by Romaric Allahramadji on 8/7/24.
//

import Foundation

import Foundation

// Protocol defining the methods for network service interactions.
protocol NetworkServiceProtocol {
    // Fetches a list of recipes from the API based on the category.
    func fetchRecipes(category: String) async throws -> [Recipe]

    // Fetches detailed information about a specific recipe by its ID.
    func fetchRecipeDetails(id: String) async throws -> RecipeDetailsModel
}

