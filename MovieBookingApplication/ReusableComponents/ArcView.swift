//
//  ArcView.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 7/20/24.
//

import UIKit

class ArcView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawCurvedLine()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        drawCurvedLine()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawCurvedLine()
    }
    
    private func drawCurvedLine() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let curvedPath = UIBezierPath()
        let startPoint = CGPoint(x: frame.midX - 150, y: frame.midY)
        let endPoint = CGPoint(x: frame.midX + 150, y: frame.midY)
        let controlPoint = CGPoint(x: frame.midX, y: frame.midY - 20)
        
        curvedPath.move(to: startPoint)
        curvedPath.addQuadCurve(to: endPoint, controlPoint: controlPoint)
        
        let curvedLineLayer = CAShapeLayer()
        curvedLineLayer.path = curvedPath.cgPath
        curvedLineLayer.strokeColor = UIColor.orange.cgColor
        curvedLineLayer.fillColor = UIColor.clear.cgColor
        curvedLineLayer.lineWidth = 2.0
        
        
        curvedLineLayer.shadowOffset = CGSize(width: 5, height: 5)
        curvedLineLayer.shadowOpacity = 1
        curvedLineLayer.shadowRadius = 5.0
        curvedLineLayer.shadowColor = UIColor.white.cgColor
        
        layer.addSublayer(curvedLineLayer)
    }
}
