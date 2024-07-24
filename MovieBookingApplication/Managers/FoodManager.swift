//
//  FoodManager.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/24/24.
//

import Foundation

final class FoodManager {
    static let shared = FoodManager()
    
    private init() {}
    
    private(set) var allFoodItems: [Food] = FoodData.generateFakeData()
    private(set) var filteredFoodSections: [(food: Food, sizes: [FoodSize])] = []
    
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

    func increaseQuantity(for food: Food, size: FoodSize) {
        if let index = allFoodItems.firstIndex(where: { $0.id == food.id }) {
            allFoodItems[index].quantityPerSize[size.name, default: 0] += 1
        }
    }
    
    func decreaseQuantity(for food: Food, size: FoodSize) {
        if let index = allFoodItems.firstIndex(where: { $0.id == food.id }) {
            allFoodItems[index].quantityPerSize[size.name, default: 0] = max(0, allFoodItems[index].quantityPerSize[size.name, default: 0] - 1)
        }
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
