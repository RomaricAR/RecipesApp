//
//  NetworkingService.swift
//  Recipes
//
//  Created by Romaric Allahramadji on 8/6/24.
//

import Foundation

class NetworkingService: NetworkServiceProtocol {
    static let shared = NetworkingService()
    private init() {}
    func fetchData<T>(endPoint: String) async throws -> T where T : Decodable {
        guard let url = URL(string: endPoint) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        let jsonResult = try JSONDecoder().decode(T.self, from: data)
        return jsonResult
    }
}
struct RecipesResponse: Codable {
    let recipes: [Recipe]
    enum CodingKeys: String, CodingKey {
        case recipes = "meals"
    }
}
struct RecipeDetailResponse: Codable {
    let details: [RecipeDetailsModel]
    enum CodingKeys: String, CodingKey {
        case details = "meals"
    }
}

