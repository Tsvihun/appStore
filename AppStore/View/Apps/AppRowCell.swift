//
//  AppRowCell.swift
//  AppStore
//
//  Created by Лилия on 06.11.2021.
//

import UIKit

class AppRowCell: UICollectionViewCell {
 
    // MARK: - Properties
    
    var appUrl = ""
    
    var app: FeedResult! {
        didSet {
            companyLabel.text = app.artistName
            nameLabel.text = app.name
            imageView.sd_setImage(with: URL(string: app.artworkUrl100), completed: nil)
            appUrl = app.url
        }
    }
    
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
        infoStackView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleGet() {
        print("DEBUG: Taped get button")
//        let navController = UINavigationController(rootViewController: WebViewController())
//        navController.modalPresentationStyle = .fullScreen
//        present(navController, animated: true, completion: nil)
        
        if let url = URL(string: appUrl) {
            UIApplication.shared.open(url)
        }

    }
    
}
