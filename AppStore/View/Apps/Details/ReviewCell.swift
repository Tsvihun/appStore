//
//  ReviewCell.swift
//  AppStore
//
//  Created by Лилия on 15.11.2021.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let titleLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .orange
        label.text = "Review Title"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .orange
        label.text = "Author"
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    let starStackView: UIStackView = {
        var arrangedSubviews = [UIView]()
        (0..<5).forEach { _ in
            let imageView = UIImageView(image: .starImage)
            imageView.setDemensions(height: 24, width: 24)
            arrangedSubviews.append(imageView)
        }
        arrangedSubviews.append(UIView())
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        return stackView
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .orange
        label.text = "Review body \nReview body \nReview body \nReview body"
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 6
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0.85, alpha: 1)
        layer.cornerRadius = 16
        
        let headStackView = UIStackView(arrangedSubviews: [titleLabel, authorLabel])
        headStackView.distribution = .fill
        headStackView.spacing = 8
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let stackView = VerticalStackView(arrangedSubviews: [headStackView, starStackView, bodyLabel], spacing: 12)
        
        
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
