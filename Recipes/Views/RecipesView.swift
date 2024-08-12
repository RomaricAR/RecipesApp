//
//  ContentView.swift
//  Recipes
//
//  Created by Romaric Allahramadji on 8/6/24.
//

import SwiftUI

// View responsible for displaying a list of dessert recipes.
struct RecipesView: View {
    @StateObject var viewModel = RecipesViewModel()
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    // Show a loading indicator while data is being fetched.
                    ProgressView("Loading Recipes...")
                } else if !viewModel.recipes.isEmpty {
                    // Display the list of recipes using LazyVStack to optimize performance.
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            ForEach(viewModel.recipes, id: \.id) { recipe in
                                NavigationLink(destination: RecipeDetailsView(recipeID: recipe.id, recipeThumbnailURL: recipe.thumbnailURL)) {
                                    HStack {
                                        AsyncImage(url: URL(string: recipe.thumbnailURL)) { image in
                                            image.resizable()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        Text(recipe.name.titleCased())
                                            .font(.title3)
                                            .bold()
                                        Spacer()
                                        Image(systemName: "chevron.forward")
                                    }
                                    .foregroundStyle(Color.primary)
                                    .padding(.vertical, 5)
                                    .frame(minWidth: 360, alignment: .leading)
                                }
                                Divider()
                            }
                        }
                        .padding(.horizontal)
                    }
                } else {
                    Text("No recipes found.")
                }
            }
            .navigationTitle("Desserts")
            .alert(isPresented: $showAlert) {
                // Show an alert if an error occurs during data fetching.
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "An unknown error occurred."), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                // Fetch the initial list of recipes when the view appears.
                Task {
                    await viewModel.fetchRecipes()
                    if viewModel.errorMessage != nil {
                        showAlert = true
                    }
                }
            }
        }
    }
}





#Preview {
    RecipesView()
}
