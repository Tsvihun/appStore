//
//  AppsHeaderCell.swift
//  AppStore
//
//  Created by Лилия on 08.11.2021.
//

import UIKit

class AppsHeaderCell: UICollectionViewCell {
    
    // MARK: - Properties
    var app: SocialApp! {
        didSet {
            companyLabel.text = app.name
            titleLabel.text = app.tagline
            imageView.sd_setImage(with: URL(string: app.imageUrl), completed: nil)
        }
    }
    
    let companyLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .brown
        label.text = "Company Name"
        label.textColor = .systemBlue
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .orange
        label.text = "App description in one or two lines length"
        label.font = .systemFont(ofSize: 24)
        label.numberOfLines = 2
        return label
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(white: 0.95, alpha: 1)
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .red
        
        let stackView = VerticalStackView(arrangedSubviews: [companyLabel, titleLabel, imageView], spacing: 12)
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
