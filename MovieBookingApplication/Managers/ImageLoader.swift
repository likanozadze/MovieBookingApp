//
//  ImageLoader.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/25/24.
//

import Foundation
import UIKit

class ImageLoader {
    static func loadImage(from path: String, completion: @escaping (UIImage?) -> Void) {
        print("Loading image from path: \(path)")
        NetworkManager.shared.downloadImage(from: path) { image in
            if image != nil {
            } else {
            }
            completion(image)
        }
    }
}
