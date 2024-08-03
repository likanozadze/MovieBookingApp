//
//  SegmentedControlComponent.swift
//  MovieBookingApplication
//
//  Created by Lika Nozadze on 8/3/24.
//

import Foundation
import UIKit

class SegmentedControlComponent: UIView {

    // MARK: - Properties

    var segmentTitles: [String] = [] {
        didSet {
            updateSegmentedControl()
        }
    }
    
    var selectedSegmentIndex: Int = 0 {
        didSet {
            segmentedControl.selectedSegmentIndex = selectedSegmentIndex
        }
    }

    var onSegmentChanged: ((Int) -> Void)?

    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.tintColor = .customSecondaryColor
        control.selectedSegmentTintColor = .customAccentColor
        control.addTarget(self, action: #selector(handleSegmentChange(_:)), for: .valueChanged)

        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.8),
            .font: UIFont.systemFont(ofSize: 14)
        ]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 14)
        ]
        control.setTitleTextAttributes(normalTextAttributes, for: .normal)
        control.setTitleTextAttributes(selectedTextAttributes, for: .selected)

        return control
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Private Methods

    private func updateSegmentedControl() {
        segmentedControl.removeAllSegments()
        for (index, title) in segmentTitles.enumerated() {
            segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = selectedSegmentIndex
    }

    @objc private func handleSegmentChange(_ sender: UISegmentedControl) {
        onSegmentChanged?(sender.selectedSegmentIndex)
    }
}
