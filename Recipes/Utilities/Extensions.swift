//
//  Extensions.swift
//  Recipes
//
//  Created by Romaric Allahramadji on 8/9/24.
//

import Foundation

extension Recipe {
    var isValid: Bool {
        // Check that all necessary fields are not empty
        return !id.isEmpty && !name.isEmpty && !thumbnailURL.isEmpty
    }
}

extension RecipeDetailsModel {
    var isValid: Bool {
        // Check that all necessary fields are not empty
        return !recipeID.isEmpty && !recipeName.isEmpty && !instructions.isEmpty && !ingredients.isEmpty && !measurements.isEmpty
    }
}

// Extension to capitalize the first letter of a string (used for recipe names).
extension String {
    func titleCased() -> String {
        return self.capitalized
    }
}
