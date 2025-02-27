//
//  ContentView.swift
//  Recipes
//
//  Created by Romaric Allahramadji on 8/6/24.
//

import SwiftUI

struct RecipesView: View {
    let isRunningTests = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    @StateObject var viewModel = RecipesViewModel(networkService: NetworkingService.shared)
    @State private var showAlert = false
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading Recipes...")
                        .accessibilityIdentifier("loadingIndicator")
                        .progressViewStyle(CircularProgressViewStyle())
                } else if !viewModel.recipes.isEmpty {
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            ForEach(viewModel.recipes, id: \.id) { recipe in
                                NavigationLink(destination: RecipeDetailsView(recipeID: recipe.id, recipeThumbnailURL: recipe.thumbnailURL)) {
                                    HStack {
                                        AsyncImage(url: URL(string: recipe.thumbnailURL)) { image in
                                            image.resizable()
                                        } placeholder: {
                                            ProgressView()
                                                .accessibilityIdentifier("thumbnailLoading_\(recipe.id)")
                                        }
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .accessibilityIdentifier("thumbnailImage_\(recipe.id)")
                                        Text(recipe.name.titleCased())
                                            .font(.title3)
                                            .bold()
                                            .accessibilityIdentifier("recipeName_\(recipe.id)")
                                        Spacer()
                                        Image(systemName: "chevron.forward")
                                            .accessibilityIdentifier("chevron_\(recipe.id)")
                                    }
                                    .foregroundStyle(Color.primary)
                                    .padding(.vertical, 5)
                                    .frame(minWidth: 360, alignment: .leading)
                                }
                                .accessibilityIdentifier("recipeRow_\(recipe.id)")
                                Divider()
                            }
                        }
                        .padding(.horizontal)
                    }
                    .accessibilityIdentifier("recipesScrollView")
                } else {
                    Text("No recipes found.")
                        .accessibilityIdentifier("noRecipesLabel")
                }
            }
            .navigationTitle("Desserts")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "An unknown error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .accessibilityIdentifier("recipesView")
            .onAppear {
                Task {
                    if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
                        await viewModel.fetchRecipes()
                        if viewModel.errorMessage != nil {
                            showAlert = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RecipesView()
}
