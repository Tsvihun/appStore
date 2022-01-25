//
//  ReviewRowCell.swift
//  AppStore
//
//  Created by Лилия on 15.11.2021.
//

import UIKit

class ReviewRowCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let reviewLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .orange
        label.text = "Reviews & Ratings"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    let containerController = ReviewsController()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .red
        
        addSubview(reviewLabel)
        reviewLabel.anchor(top: topAnchor, left: leftAnchor, paddingLeft: 16)
        
        addSubview(containerController.view)
        containerController.view.anchor(top: reviewLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
