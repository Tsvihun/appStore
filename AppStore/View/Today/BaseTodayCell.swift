//
//  BaseTodayCell.swift
//  AppStore
//
//  Created by Лилия on 22.11.2021.
//

import UIKit

class BaseTodayCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var todayItem: TodayItem!
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                print("DEBUG: is highlighted: \(isHighlighted)")
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.transform = .init(scaleX: 0.9, y: 0.9)
                })
            } else {
                print("DEBUG: is highlighted: \(isHighlighted)")
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.transform = .identity
                })
            }
        }
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // setup backgroundView to provide better performance for cells degraded by shadow
        self.backgroundView = UIView()
        
        addSubview(self.backgroundView!)
        
        self.backgroundView?.fillSuperview()
        self.backgroundView?.layer.cornerRadius = 16
        self.backgroundView?.addShadow()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
