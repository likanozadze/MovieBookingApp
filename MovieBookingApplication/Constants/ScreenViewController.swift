//
//  ScreenViewController.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 8/31/24.
//

import UIKit

class ScreenViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.image = UIImage(named: "appicon")
        return imageView
    }()
    
    var animationCompletionHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
   
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        
     
            self.animate()
     
    }
    
    func animate() {
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 1.5
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            
            self.imageView.frame = CGRect(
                x: -(diffX/2),
                y: diffY/2,
                width: size,
                height: size
            )
        }) { _ in
            UIView.animate(withDuration: 1.5, animations: {
                self.imageView.alpha = 0
            }) { _ in
                self.animationCompletionHandler?()
            }
        }
    }
}
