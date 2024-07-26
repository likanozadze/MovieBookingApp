//
//  File.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/26/24.
//

import Foundation
import UIKit

final class SeatCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            
    
            if layoutAttribute.indexPath.item % 10 == 3 || layoutAttribute.indexPath.item % 10 == 7 {
                leftMargin += 10.0
            }
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY) 
        }
        
        return attributes
    }
}
