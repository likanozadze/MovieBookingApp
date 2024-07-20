//
//  TabBarController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/12/24.
//

import UIKit

final class TabBarController: UITabBarController {

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

    let ticketsViewController = FoodViewController()
      
    let ticket = createNavigationController(
      title: "Ticket", image: UIImage(systemName: "ticket"),
      viewController: ticketsViewController
    )

//      let calendarViewController = CalendarViewController()
//        
//      let calendar = createNavigationController(
//        title: "Calendar", image: UIImage(systemName: "calendar"),
//        viewController: calendarViewController
//      )

      
    setViewControllers([home, ticket], animated: true)
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
}

