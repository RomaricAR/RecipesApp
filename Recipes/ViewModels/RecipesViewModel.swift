//
//  RecipesViewModel.swift
//  Recipes
//
//  Created by Romaric Allahramadji on 8/6/24.
//

import Foundation
import CoreData

class RecipesViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedCategory: String = "Dessert"
    private var networkService: NetworkServiceProtocol
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    @MainActor
    func fetchRecipes() async {
        self.isLoading = true
        defer { self.isLoading = false }
        // Load cached recipes if they exist
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<CachedRecipe> = CachedRecipe.fetchRequest()
        do {
            let cachedRecipes = try context.fetch(fetchRequest)
            self.recipes = cachedRecipes.map {
                Recipe(id: $0.id ?? "", name: $0.name ?? "", thumbnailURL: $0.thumbnailURL ?? "")
            }.sorted { $0.name < $1.name }
            return
        } catch {
            print("❌ Error fetching cached recipes: \(error.localizedDescription)")
        }
        // Fetch fresh recipes from the network
        do {
            let data: RecipesResponse = try await networkService.fetchData(
                endPoint: RecipeEndpoint.recipesList(category: selectedCategory).urlString
            )
            let validRecipes = data.recipes.filter { $0.isValid }
            if validRecipes.isEmpty {
                throw RecipeError.noValidRecipes
            }
            self.recipes = validRecipes.sorted { $0.name < $1.name }
            CoreDataManager.shared.cacheRecipes(self.recipes)
        } catch {
            handle(error.asRecipeError)
        }
    }
    private func handle(_ error: RecipeError) {
        errorMessage = error.errorDescription
    }
}
