//
//  NavigationManager.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/21/24.
//

import UIKit
import SwiftUI

class NavigationManager {
    static let shared = NavigationManager()
    
    private init() {}
    
    func navigateToMovieDetails(from presentingViewController: UIViewController, movieId: Int) {
        let movieDetailsViewController = MovieDetailsViewController(movieId: movieId)
        
        if let navigationController = presentingViewController.navigationController {
            navigationController.pushViewController(movieDetailsViewController, animated: true)
        } else {
            
            movieDetailsViewController.modalPresentationStyle = .fullScreen
            presentingViewController.present(movieDetailsViewController, animated: true, completion: nil)
        }
    }
    
    func navigateToFoodViewController(from presentingViewController: UIViewController) {
        let foodViewController = FoodViewController()
        foodViewController.modalPresentationStyle = .fullScreen
        presentingViewController.present(foodViewController, animated: true, completion: nil)
    }
    
    func navigateToOrderViewController(from presentingViewController: UIViewController, with orderViewController: OrderViewController) {
        orderViewController.modalPresentationStyle = .fullScreen
        presentingViewController.present(orderViewController, animated: true, completion: nil)
    }
    
}
