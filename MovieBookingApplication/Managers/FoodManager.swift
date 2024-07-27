//
//  FoodManager.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/24/24.
//

import Foundation

final class FoodManager {
    
    // MARK: - Shared Instance
    static let shared = FoodManager()
    
    
    // MARK: - Private Init
    private init() {}
    
    
    // MARK: - Properties
    private(set) var allFoodItems: [Food] = FoodData.generateFakeData()
    private(set) var filteredFoodSections: [(food: Food, sizes: [FoodSize])] = []
    
    
    // MARK: - Methods
    func filterFoodItems(for segmentIndex: Int) {
        switch segmentIndex {
        case 0:
            filteredFoodSections = allFoodItems.filter { $0.category == "Drinks" }.map { (food: $0, sizes: $0.sizes) }
        case 1:
            filteredFoodSections = allFoodItems.filter { $0.category == "Popcorn" }.map { (food: $0, sizes: $0.sizes) }
        case 2:
            filteredFoodSections = allFoodItems.filter { $0.category == "Food" }.map { (food: $0, sizes: $0.sizes) }
        default:
            filteredFoodSections = allFoodItems.map { (food: $0, sizes: $0.sizes) }
        }
    }
    func updateFilteredSections() {
           let currentFilter = filteredFoodSections.first?.food.name.lowercased()
           if currentFilter?.contains("cola") == true {
               filterFoodItems(for: 0)
           } else if currentFilter?.contains("popcorn") == true {
               filterFoodItems(for: 1)
           } else if currentFilter?.contains("nachos") == true {
               filterFoodItems(for: 2)
           } else {
               filterFoodItems(for: 3)
           }
       }
       

    func increaseQuantity(for food: Food, size: FoodSize) {
        if let index = allFoodItems.firstIndex(where: { $0.id == food.id }) {
            allFoodItems[index].quantityPerSize[size.name, default: 0] += 1
        }
        updateFilteredSections()
    }
    
    func decreaseQuantity(for food: Food, size: FoodSize) {
        if let index = allFoodItems.firstIndex(where: { $0.id == food.id }) {
            allFoodItems[index].quantityPerSize[size.name, default: 0] = max(0, allFoodItems[index].quantityPerSize[size.name, default: 0] - 1)
        }
        updateFilteredSections()
    }
    
    func quantity(for food: Food, size: FoodSize) -> Int {
        return food.quantityPerSize[size.name, default: 0]
    }
    
    func resetQuantities() {
        for index in allFoodItems.indices {
            for size in allFoodItems[index].sizes {
                allFoodItems[index].quantityPerSize[size.name] = 0
            }
        }
    }
}
