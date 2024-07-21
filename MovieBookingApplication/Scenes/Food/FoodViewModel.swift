//
//  FoodItemViewModel.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/20/24.
//

import Foundation

final class FoodViewModel {
    private var allFoodItems: [Food]
    private(set) var filteredFoodSections: [(food: Food, sizes: [FoodSize])] = []

    init(foodItems: [Food]) {
        self.allFoodItems = foodItems
        filterFoodItems(for: 0)
    }

    var numberOfSections: Int {
        return filteredFoodSections.count
    }

    func numberOfRows(in section: Int) -> Int {
        return filteredFoodSections[section].sizes.count
    }

    func filterFoodItems(for segmentIndex: Int) {
        switch segmentIndex {
        case 0:
            filteredFoodSections = allFoodItems.filter { $0.name.lowercased().contains("cola") }.map { (food: $0, sizes: $0.sizes) }
        case 1:
            filteredFoodSections = allFoodItems.filter { $0.name.lowercased().contains("popcorn") }.map { (food: $0, sizes: $0.sizes) }
        case 2:
            filteredFoodSections = allFoodItems.filter { $0.name.lowercased().contains("nachos") }.map { (food: $0, sizes: $0.sizes) }
        default:
            filteredFoodSections = allFoodItems.map { (food: $0, sizes: $0.sizes) }
        }
    }

    func increaseQuantity(at indexPath: IndexPath) {
        let food = filteredFoodSections[indexPath.section].food
        let size = filteredFoodSections[indexPath.section].sizes[indexPath.row]
        if let index = allFoodItems.firstIndex(where: { $0.id == food.id }) {
            allFoodItems[index].quantityPerSize[size.name, default: 0] += 1
        }
        filteredFoodSections[indexPath.section].food.quantityPerSize[size.name, default: 0] += 1
    }

    func decreaseQuantity(at indexPath: IndexPath) {
        let food = filteredFoodSections[indexPath.section].food
        let size = filteredFoodSections[indexPath.section].sizes[indexPath.row]
        if let index = allFoodItems.firstIndex(where: { $0.id == food.id }) {
            allFoodItems[index].quantityPerSize[size.name, default: 0] = max(0, allFoodItems[index].quantityPerSize[size.name, default: 0] - 1)
        }
        filteredFoodSections[indexPath.section].food.quantityPerSize[size.name, default: 0] = max(0, filteredFoodSections[indexPath.section].food.quantityPerSize[size.name, default: 0] - 1)
    }

    func quantity(for food: Food, size: FoodSize) -> Int {
        return food.quantityPerSize[size.name, default: 0]
    }
}
