//
//  RecipesViewModel.swift
//  Recipes
//
//  Created by Romaric Allahramadji on 8/6/24.
//

import Foundation

class RecipesViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // Network service for fetching recipes.
    private var networkService: NetworkServiceProtocol
    
    // Initializer that accepts a network service dependency.
    init(networkService: NetworkServiceProtocol = NetworkingService.shared) {
        self.networkService = networkService
    }

    // Fetches a list of recipes from the API, validating and sorting them before displaying.
    @MainActor
    func fetchRecipes() async {
        self.isLoading = true
        defer { self.isLoading = false }
        
        do {
            let fetchedRecipes = try await networkService.fetchRecipes(category: "Dessert")
            
            // Validate and filter out any recipes with invalid data
            let validRecipes = fetchedRecipes.filter { $0.isValid }
            
            // If no valid data is returned, throw a validation error.
            if validRecipes.isEmpty {
                throw ErrorType.validationError
            }
            
            // Append new valid recipes to the existing list and sort them alphabetically.
            self.recipes = validRecipes.sorted { $0.name < $1.name }
            
        } catch let error as URLError {
            self.errorMessage = ErrorType.networkError.localizedDescription
        } catch let error as ErrorType {
            self.errorMessage = error.localizedDescription
        } catch {
            self.errorMessage = ErrorType.unknownError.localizedDescription
        }
    }
}



