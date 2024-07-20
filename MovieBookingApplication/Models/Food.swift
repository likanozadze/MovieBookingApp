//
//  Food.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/20/24.
//

import UIKit

struct Food {
  let id: UUID
  let name: String
  let sizes: [FoodSize]
  let price: Double
  let imageName: String
  var selectedAmount: Int
}

struct FoodSize {
    let name: String
    let priceModifier: Double
}

class FoodData {

  static func generateFakeData() -> [Food] {
    return [
      Food(
        id: UUID(),
        name: "Cola",
        sizes: [
          FoodSize(name: "Small", priceModifier: 0.0),
          FoodSize(name: "Medium", priceModifier: 0.5),
          FoodSize(name: "Large", priceModifier: 1.0)
        ],
        price: 3.50,
        imageName: "coca",
        selectedAmount: 0
      ),
      Food(
        id: UUID(),
        name: "popcorn",
        sizes: [
          FoodSize(name: "Small", priceModifier: 0.0),
          FoodSize(name: "Medium", priceModifier: 0.75),
          FoodSize(name: "Large", priceModifier: 1.25)
        ],
        price: 5.00, 
        imageName: "popcorn",
        selectedAmount: 0
      ),
      Food(
        id: UUID(),
        name: "Nachos",
        sizes: [
          FoodSize(name: "Regular", priceModifier: 0.0),
        ],
        price: 4.50,
        imageName: "nachos",
        selectedAmount: 0
      )
    ]
  }
}
