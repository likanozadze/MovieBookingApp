//
//  FoodItemViewModel.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/20/24.
//

import Foundation

final class FoodViewModel {
    private let foodManager = FoodManager.shared

    var numberOfSections: Int {
        return foodManager.filteredFoodSections.count
    }

    func numberOfRows(in section: Int) -> Int {
        return foodManager.filteredFoodSections[section].sizes.count
    }

    func filterFoodItems(for segmentIndex: Int) {
        foodManager.filterFoodItems(for: segmentIndex)
    }

    func increaseQuantity(at indexPath: IndexPath) {
        let food = foodManager.filteredFoodSections[indexPath.section].food
        let size = foodManager.filteredFoodSections[indexPath.section].sizes[indexPath.row]
        foodManager.increaseQuantity(for: food, size: size)
    }

    func decreaseQuantity(at indexPath: IndexPath) {
        let food = foodManager.filteredFoodSections[indexPath.section].food
        let size = foodManager.filteredFoodSections[indexPath.section].sizes[indexPath.row]
        foodManager.decreaseQuantity(for: food, size: size)
    }

    func quantity(for food: Food, size: FoodSize) -> Int {
        return foodManager.quantity(for: food, size: size)
    }
}
