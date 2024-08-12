//
//  MealDetailViewModel.swift
//  Recipes
//
//  Created by Romaric Allahramadji on 8/6/24.
//

import Foundation

class MealDetailViewModel: ObservableObject {
    @Published var mealDetail: MealDetail?
    @Published var strMealThumb: String?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchMealDetail(id: String, thumbnail: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.strMealThumb = thumbnail
        }
        
        do {
            let fetchedMealDetail = try await NetworkingService.shared.fetchMealDetails(id: id)
            DispatchQueue.main.async {
                self.mealDetail = fetchedMealDetail
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}



