//
//  MultipleAppCell.swift
//  AppStore
//
//  Created by Лилия on 23.11.2021.
//

import UIKit

class MultipleAppCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var appUrl = ""
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(white: 0.95, alpha: 1)
        iv.widthAnchor.constraint(equalToConstant: 64).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 64).isActive = true
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        //label.backgroundColor = .orange
        label.text = "App Name"
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    let companyLabel: UILabel = {
        let label = UILabel()
        //label.backgroundColor = .brown
        label.text = "Company Name"
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    let getButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.layer.cornerRadius = 16
        button.setTitle("GET", for: .normal)
        button.setTitleColor( .systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.addTarget(self, action: #selector(handleGet), for: .touchUpInside)
        return button
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .red
        
        let labelsStackView = VerticalStackView(arrangedSubviews: [nameLabel, companyLabel], spacing: 4)
        
        let infoStackView = UIStackView(arrangedSubviews: [imageView, labelsStackView, getButton])
        infoStackView.spacing = 16
        infoStackView.axis = .horizontal
        infoStackView.alignment = .center
        
        addSubview(infoStackView)
        infoStackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        addSubview(separatorView)
        separatorView.anchor(left: nameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingBottom: -8 , height: 0.5)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc private func handleGet() {
        print("DEBUG: Taped get button")
        
        if let url = URL(string: appUrl) {
            UIApplication.shared.open(url)
        }

    }
}
