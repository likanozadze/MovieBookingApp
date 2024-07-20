//
//  FoodItemViewModel.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/20/24.
//

import Foundation

final class FoodViewModel {
  private let foodItems: [Food]
  private var foodSections: [(food: Food, sizes: [FoodSize])] = []
  private(set) var filteredFoodSections: [(food: Food, sizes: [FoodSize])] = []

  init(foodItems: [Food]) {
    self.foodItems = foodItems
    prepareFoodSections()
  }

  var numberOfSections: Int {
    return filteredFoodSections.count
  }

  func numberOfRows(in section: Int) -> Int {
    return filteredFoodSections[section].sizes.count
  }

  func food(at indexPath: IndexPath) -> Food {
    return filteredFoodSections[indexPath.section].food
  }

  func size(at indexPath: IndexPath) -> FoodSize {
    return filteredFoodSections[indexPath.section].sizes[indexPath.row]
  }

  func filterFoodItems(for segmentIndex: Int) {
    switch segmentIndex {
    case 0:
      filteredFoodSections = foodSections.filter { $0.food.name.lowercased().contains("cola") }
    case 1:
      filteredFoodSections = foodSections.filter { $0.food.name.lowercased().contains("popcorn") }
    case 2:
      filteredFoodSections = foodSections.filter { $0.food.name.lowercased().contains("nachos") }
    default:
      filteredFoodSections = foodSections
    }
  }

  private func prepareFoodSections() {
    foodSections = foodItems.map { food in
        return (food: food, sizes: food.sizes)
    }
    filterFoodItems(for: 0)
  }

  func increaseQuantity(at indexPath: IndexPath) {
    var food = filteredFoodSections[indexPath.section].food
    food.selectedAmount = max(food.selectedAmount + 1, 0)
    filteredFoodSections[indexPath.section].food = food
  }

  func decreaseQuantity(at indexPath: IndexPath) {
    var food = filteredFoodSections[indexPath.section].food
    food.selectedAmount = max(food.selectedAmount - 1, 0)
    filteredFoodSections[indexPath.section].food = food
  }
}
