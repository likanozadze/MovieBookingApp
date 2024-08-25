//
//  NavigationManager.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/21/24.
//

import UIKit
import SwiftUI

class NavigationManager {
    // MARK: - Shared Instance
    static let shared = NavigationManager()
    
    // MARK: - Private Init
    private init() {}
    
    
    // MARK: - Methods
    func navigateToMovieDetails(from presentingViewController: UIViewController, movieId: Int) {
        let movieDetailsViewController = MovieDetailsViewController(movieId: movieId)
        pushOrPresent(viewController: movieDetailsViewController, from: presentingViewController)
    }
    
    func navigateToFoodViewController(from presenter: UIViewController) {
        let foodViewController = FoodViewController()
        pushOrPresent(viewController: foodViewController, from: presenter)
    }
    
    func navigateToOrderViewController(from presentingViewController: UIViewController, with orderViewController: OrderViewController) {
        pushOrPresent(viewController: orderViewController, from: presentingViewController)
    }
    
    func navigateToTicketViewController(from presentingViewController: UIViewController) {
        let ticketViewController = TicketViewController()
        pushOrPresent(viewController: ticketViewController, from: presentingViewController)
    }
    
    func navigateToUpcomingMovieDetails(from viewController: UIViewController, movie: MockMovie) {
        let upcomingDetailsVC = UpcomingMoviesDetailsViewController(movieId: movie.id)
        viewController.navigationController?.pushViewController(upcomingDetailsVC, animated: true)
    }
    
    private func pushOrPresent(viewController: UIViewController, from presenter: UIViewController) {
        if let navigationController = presenter.navigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            viewController.modalPresentationStyle = .fullScreen
            presenter.present(viewController, animated: true, completion: nil)
        }
    }
}
