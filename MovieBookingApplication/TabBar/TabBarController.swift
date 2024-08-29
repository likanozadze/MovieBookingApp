//
//  TabBarController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/12/24.
//

import UIKit

final class TabBarController: UITabBarController {
    let homeViewModel = HomeViewModel()
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupTabs() {
        let home = createNavigationController(
            title: "Home", image: UIImage(systemName: "house"),
            viewController: HomeViewController()
        )
        
        let calendar = createNavigationController(
            title: "Calendar", image: UIImage(systemName: "calendar"),
            viewController: CalendarViewController()
        )
        let cinema = createNavigationController(
            title: "Cinema", image: UIImage(systemName: "movieclapper"),
            viewController: CinemaViewController(homeViewModel: homeViewModel)
        )
        
        let ticketViewController = TicketViewController()
        let ticket = createNavigationController(
            title: "Ticket", image: UIImage(systemName: "ticket"),
            viewController: ticketViewController
        )
        setViewControllers([home, calendar, cinema, ticket], animated: true)
    }
    
    // MARK: - NavigationController
    private func createNavigationController(title: String, image: UIImage?, viewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        viewController.title = title
        return navigationController
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        tabBar.tintColor = .customAccentColor
        tabBar.unselectedItemTintColor = .white
        tabBar.isTranslucent = true
        tabBar.standardAppearance = createTabBarAppearance()
        tabBar.scrollEdgeAppearance = createTabBarScrollEdgeAppearance()
    }
    
    private func createTabBarAppearance() -> UITabBarAppearance {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .customSecondaryColor
        return tabBarAppearance
    }
    
    private func createTabBarScrollEdgeAppearance() -> UITabBarAppearance {
        let tabBarScrollEdgeAppearance = UITabBarAppearance()
        tabBarScrollEdgeAppearance.backgroundColor = .customSecondaryColor
        return tabBarScrollEdgeAppearance
    }

    func updateBadgeCounts() {
        let ticketCount = BookingManager.shared.numberOfTickets
        DispatchQueue.main.async { [weak self] in
            if let ticketViewController = self?.viewControllers?[3] {
                ticketViewController.tabBarItem.badgeValue = ticketCount > 0 ? "\(ticketCount)" : nil
                print("Debug - Badge value set to: \(ticketViewController.tabBarItem.badgeValue ?? "nil")")
            } else {
                print("Debug - Failed to set badge value")
            }
        }
    }
}
