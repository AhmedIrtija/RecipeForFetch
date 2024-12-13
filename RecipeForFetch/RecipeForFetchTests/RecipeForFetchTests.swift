//
//  RecipeForFetchTests.swift
//  RecipeForFetchTests
//
//  Created by Ahmed Irtija on 12/12/24.
//

import XCTest

@testable import RecipeForFetch
@MainActor
final class RecipeForFetchTests: XCTestCase {
    @Published var recipes = Recipes()
    
    // test correct url
    func testCorrectURL() async {
        // Arrange
        let url = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        
        // Act
        await recipes.fetchRecipes(urlString: url)
        
        // Assert
        XCTAssertTrue(!recipes.recipeList.isEmpty)
    }
    
    // test invalid url
    func testInvalidURL() async {
        // Arrange
        let url = "hhtps://thisisafakeurl.json"
        
        // Act
        await recipes.fetchRecipes(urlString: url)
        
        // Assert
        XCTAssertNotNil(recipes.errorMessage)
    }
    
    // test empty url
    func testEmptyURL() async {
        // Arrange
        let url = ""
        
        // Act
        await recipes.fetchRecipes(urlString: url)
        
        // Assert
        XCTAssertNotNil(recipes.errorMessage)
    }
    
    // test invalid json
    func testInvalidJSON() async {
        // Arrange
        let url = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
        
        // Act
        await recipes.fetchRecipes(urlString: url)
        
        // Assert
        XCTAssertNotNil(recipes.errorMessage)
    }
    
    // test empty json
    func testEmptyJSON() async {
        // Arrange
        let url = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
        
        // Act
        await recipes.fetchRecipes(urlString: url)
        
        // Assert
        XCTAssertTrue(recipes.recipeList.isEmpty)
    }
    
    
}
