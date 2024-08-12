//
//  RecipeDetailView.swift
//  Recipes
//
//  Created by Romaric Allahramadji on 8/6/24.
//

import SwiftUI

struct RecipeDetailsView: View {
    let recipeID: String
     let recipeThumbnailURL: String
     @StateObject var viewModel = RecipeDetailsViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if let recipe = viewModel.recipeDetails {
                    Text(recipe.recipeName)
                        .font(.title)
                    
                    AsyncImage(url: URL(string: recipe.recipeThumbnailURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .frame(width: 320)
                            .shadow(radius: 3)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Text("Instructions:")
                        .font(.system(size: 22))
                        .padding(.vertical)
                    
                    Text(recipe.instructions)
                       
                    Text("Ingredients/Measurements:")
                        .font(.system(size: 22))
                        .padding(.vertical)
                        
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(Array(zip(recipe.ingredients, recipe.measurements)), id: \.0) { ingredient, measure in
                            Text("\(ingredient): \(measure)")
                        }
                    }
                } else {
                    ProgressView()
                     
                }
            }.padding()
            .task {
                await viewModel.fetchRecipeDetails(id: recipeID, thumbnailURL: recipeThumbnailURL)
            }
        }
    }
}




#Preview {
    RecipeDetailsView(recipeID: "52893", recipeThumbnailURL: "")
}
