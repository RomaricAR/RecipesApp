//
//  Recipes.swift
//  Recipes
//
//  Created by Romaric Allahramadji on 8/6/24.
//

import Foundation

// Model representing a recipe in the app.
struct Recipe: Codable, Identifiable {
    let id: String
    let name: String
    let thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumbnailURL = "strMealThumb"
    }
}

