//
//  TodayCell.swift
//  AppStore
//
//  Created by Лилия on 16.11.2021.
//

import UIKit

class TodayCell: BaseTodayCell {
    
    // MARK: - Properties
    
    var topConstraint: NSLayoutConstraint!
    
    override var todayItem: TodayItem! {
        didSet {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
            imageView.image = todayItem.image
            descriptionLabel.text = todayItem.description
//            backgroundColor = todayItem.backgroudColor
            backgroundView?.backgroundColor = todayItem.backgroudColor
        }
    }
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        //label.backgroundColor = .red
        label.text = "LIFE HACK"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        //label.backgroundColor = .blue
        label.text = "Utilizing your Time"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView(image: .gardenImage)
        iv.contentMode = .scaleAspectFill
//        iv.clipsToBounds = true
//        iv.setDemensions(height: 240, width: 240)
        return iv
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        //label.backgroundColor = .green
        label.text = "All the tools and apps you need to intelligently organize your life the right way."
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let containerImageView = UIView()
        containerImageView.addSubview(imageView)
        imageView.centerXY(inView: containerImageView)
        imageView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 240).isActive = true
        containerImageView.clipsToBounds = true
        
        let stackView = VerticalStackView(arrangedSubviews: [categoryLabel, titleLabel, containerImageView, descriptionLabel], spacing: 8)
        
        addSubview(stackView)
        stackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 24, paddingBottom: 24, paddingRight: 24)
        self.topConstraint = stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24)
        topConstraint.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
