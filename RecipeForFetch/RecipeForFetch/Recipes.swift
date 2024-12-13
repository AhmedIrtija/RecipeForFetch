//
//  Recipes.swift
//  RecipeForFetch
//
//  Created by Ahmed Irtija on 12/12/24.
//

import Foundation


// ObservableObject class to handle data fetching and storage
@MainActor
class Recipes: ObservableObject {
    @Published var recipeList: [Recipe] = []
    @Published var errorMessage: String?
    
    struct RecipeResponse: Codable {
        let recipes: [Recipe]
    }
    
    //Storing the recipes from the JSON URL
    struct Recipe: Codable, Identifiable {
        let id = UUID()
        let cuisine: String
        let name: String
        let photoURLLarge: String?
        let photoURLSmall: String?
        let uuid: String
        let sourceURL: String?
        let youtubeURL: String?
        
        enum CodingKeys: String, CodingKey {
            case cuisine, name
            case photoURLLarge = "photo_url_large"
            case photoURLSmall = "photo_url_small"
            case uuid
            case sourceURL = "source_url"
            case youtubeURL = "youtube_url"
        }
    }
    
    func fetchRecipes(urlString: String) async {
        // URL check
        guard let url = URL(string: urlString) else {
            print("Error: Invalid URL")
            self.errorMessage = "Invalid URL"
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard !data.isEmpty else {
                print("Error: No data received or data is empty")
                self.errorMessage = "No data received"
                return
            }
            
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(RecipeResponse.self, from: data)
            self.recipeList = decodedData.recipes.shuffled()
            if decodedData.recipes.isEmpty {
                self.errorMessage = "No recipes found"
            }
        } catch {
            print("Error: Failed to fetch or decode data - \(error.localizedDescription)")
            self.errorMessage = "Failed to fetch or decode data: \(error.localizedDescription)"
        }
    }
}
