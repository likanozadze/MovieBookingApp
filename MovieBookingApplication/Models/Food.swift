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
    var quantityPerSize: [String: Int]
    let category: String
}

struct FoodSize {
    let name: String
    let priceModifier: Double
}

struct OrderedFood {
    let food: Food
    let size: FoodSize
    let quantity: Int
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
        quantityPerSize: ["Small": 0, "Medium": 0, "Large": 0],
        category: "Drinks"
      ),
      Food(
        id: UUID(),
        name: "Sprite",
        sizes: [
          FoodSize(name: "Small", priceModifier: 0.0),
          FoodSize(name: "Medium", priceModifier: 0.5),
          FoodSize(name: "Large", priceModifier: 1.0)
        ],
        price: 3.50,
        imageName: "sprite",
        quantityPerSize: ["Small": 0, "Medium": 0, "Large": 0],
        category: "Drinks"
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
        quantityPerSize: ["Small": 0, "Medium": 0, "Large": 0],
        category: "Popcorn"
      ),
      Food(
        id: UUID(),
        name: "caramel popcorn",
        sizes: [
          FoodSize(name: "Small", priceModifier: 0.0),
          FoodSize(name: "Medium", priceModifier: 0.75),
          FoodSize(name: "Large", priceModifier: 1.25)
        ],
        price: 5.00,
        imageName: "caramelpop",
        quantityPerSize: ["Small": 0, "Medium": 0, "Large": 0],
        category: "Popcorn"
      ),
      Food(
        id: UUID(),
        name: "Nachos",
        sizes: [
          FoodSize(name: "Regular", priceModifier: 0.0),
        ],
        price: 4.50,
        imageName: "nachos",
        quantityPerSize: ["Small": 0, "Medium": 0, "Large": 0],
        category: "Food"
      ),
      Food(
        id: UUID(),
        name: "Fries",
        sizes: [
          FoodSize(name: "Regular", priceModifier: 0.0),
        ],
        price: 4.50,
        imageName: "fries",
        quantityPerSize: ["Small": 0, "Medium": 0, "Large": 0],
        category: "Food"
      ),
      Food(
        id: UUID(),
        name: "Hotdog",
        sizes: [
          FoodSize(name: "Regular", priceModifier: 0.0),
        ],
        price: 4.50,
        imageName: "hotdog",
        quantityPerSize: ["Small": 0, "Medium": 0, "Large": 0],
        category: "Food"
      ),
      Food(
        id: UUID(),
        name: "Onion rings",
        sizes: [
          FoodSize(name: "Regular", priceModifier: 0.0),
        ],
        price: 4.50,
        imageName: "onion",
        quantityPerSize: ["Small": 0, "Medium": 0, "Large": 0],
        category: "Food"
      )
    ]
  }
}
