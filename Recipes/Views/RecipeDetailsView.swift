//
//  RecipeDetailView.swift
//  Recipes
//
//  Created by Romaric Allahramadji on 8/6/24.
//

import SwiftUI

// View responsible for displaying the details of a selected recipe.
struct RecipeDetailsView: View {
    let recipeID: String
    let recipeThumbnailURL: String
    @StateObject var viewModel = RecipeDetailsViewModel()
    
    @State private var imageVisible = false
    @State private var showAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if viewModel.isLoading {
                    // Show a loading indicator while fetching recipe details.
                    ProgressView("Loading Recipe Details...")
                } else if let recipe = viewModel.recipeDetails {
                    Text(recipe.recipeName.titleCased())
                        .bold()
                        .font(.title)
                        .padding(.top, -30)
                    
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
                        .bold()
                        .font(.title2)
                        .padding(.vertical)
                    
                    Text(processInstructions(recipe.instructions))
                    
                    Text("Ingredients/Measurements:")
                        .bold()
                        .font(.title2)
                        .padding(.vertical)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        // Pair each ingredient with its measurement
                        let ingredientPairs = Array(zip(recipe.ingredients, recipe.measurements))
                        let uniquePairs = ingredientPairs.enumerated().map { index, pair in
                            return (id: "\(index)-\(pair.0)-\(pair.1)", pair: pair)
                        }
                        
                        // Display each ingredient and its measurement
                        ForEach(uniquePairs, id: \.id) { item in
                            HStack {
                                Text(processIngredientAndMeasurement(item.pair.0, with: item.pair.1))
                            }
                        }
                    }
                    
                } else {
                    Text("No details available.")                    }
            }
            .padding()
            .scaleEffect(imageVisible ? 1.0 : 0.8)  // Scale effect
            .animation(.easeInOut(duration: 0.5), value: imageVisible)
            .onAppear {
                imageVisible = true
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "An unknown error occurred."), dismissButton: .default(Text("OK")))
            }
            .task {
                await viewModel.fetchRecipeDetails(id: recipeID, thumbnailURL: recipeThumbnailURL)
                if viewModel.errorMessage != nil {
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    RecipeDetailsView(recipeID: "52893", recipeThumbnailURL: "")
}
