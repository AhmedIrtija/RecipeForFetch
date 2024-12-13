//
//  ContentView.swift
//  RecipeForFetch
//
//  Created by Ahmed Irtija on 12/12/24.
//

import SwiftUI

struct ListView: View {
    @StateObject private var recipes = Recipes()
    @State private var selectedSortOption: SortOption = .none
    
    // URL for JSON (change this to test if it can fetch the recipes)
    @State private var JSONUrl: String = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    
    // Sorting type (Make sure it sorts correctly)
    enum SortOption: String, CaseIterable, Identifiable {
        case none = "None"
        case nameAZ = "A-Z"
        case nameZA = "Z-A"
        case cuisine = "Cuisine"
        
        var id: String { self.rawValue }
    }
    
    // So every recipe is sorted equally with no issue over spelling
    var sortedRecipes: [Recipes.Recipe] {
        switch selectedSortOption {
        case .none:
            return recipes.recipeList
        case .nameAZ:
            return recipes.recipeList.sorted { $0.name.lowercased() < $1.name.lowercased() }
        case .nameZA:
            return recipes.recipeList.sorted { $0.name.lowercased() > $1.name.lowercased() }
        case .cuisine:
            return recipes.recipeList.sorted { $0.cuisine.lowercased() < $1.cuisine.lowercased() }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    //App image
                    Image("AppImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .cornerRadius(10)
                        .padding(.leading)
                    
                    Text("Recipes")
                        .foregroundColor(.cyan)
                        .frame(alignment: .center)
                        .padding()
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    // Sort picker
                    Menu {
                        Picker("Sort By", selection: $selectedSortOption) {
                            ForEach(SortOption.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle")
                            .foregroundColor(.cyan)
                        Text("Sort by: \(selectedSortOption.rawValue)")
                            .font(.subheadline)
                            .foregroundColor(.cyan)
                    }
                    .padding()
                }
                
                // Checking for error
                if let errorMessage = recipes.errorMessage {
                    VStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.red)
                            .padding(.bottom, 20)
                        
                        Text("Error")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .padding(.bottom, 10)
                        
                        Text(errorMessage)
                            .foregroundColor(.white)
                            .font(.body)
                            .padding(.horizontal, 30)
                    }
                    
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
                    .edgesIgnoringSafeArea(.all)
                }
                
                // Listing all the recipes
                List(sortedRecipes) { recipe in
                    HStack {
                        if let photoURLSmall = recipe.photoURLSmall {
                            ImageCache(urlString: photoURLSmall, recipeUUID: recipe.uuid)
                                .frame(width: 50, height: 50)
                                .cornerRadius(10)
                        } else {
                            
                            // Default Image
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                        }
                        
                        VStack(alignment: .leading) {
                            if let sourceURL = recipe.sourceURL, let url = URL(string: sourceURL) {
                                Link(destination: url) {
                                    Text(recipe.name)
                                        .font(.headline)
                                }
                            } else {
                                Text(recipe.name)
                                    .font(.headline)
                                    .foregroundColor(.black)
                            }
                            Text("Cuisine type: \(recipe.cuisine)")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        if let youtubeURL = recipe.youtubeURL, let url = URL(string: youtubeURL) {
                            Link(destination: url) {
                                Image(systemName: "play.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.cyan)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical, 5)
                    .listRowBackground(Color.white)
                }
                
            }
            .refreshable {
                // Fetch recipes when user pulls up to refresh
                await recipes.fetchRecipes(urlString: JSONUrl)
            }
        }
        .task {
            // Initial loading data when it appears
            await recipes.fetchRecipes(urlString: JSONUrl)
        }
        .background(Color.white)
    }
}


struct ImageCache: View {
    let urlString: String
    //Using uuid so it doesnt use the same image for every recipes
    let recipeUUID: String
    
    @State private var image: UIImage? = nil
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            ProgressView()
                .onAppear {
                    loadImage()
                }
        }
    }
    
    private func loadImage() {
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileName = "\(recipeUUID)_\(urlString.components(separatedBy: "/").last ?? "image")"
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        
        if let cachedImage = UIImage(contentsOfFile: fileURL.path) {
            self.image = cachedImage
        } else if let url = URL(string: urlString) {
            Task {
                if let data = try? Data(contentsOf: url), let downloadedImage = UIImage(data: data) {
                    self.image = downloadedImage
                    try? data.write(to: fileURL)
                }
            }
        }
    }
}



#Preview {
    ListView()
}
