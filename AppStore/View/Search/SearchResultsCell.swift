//
//  SearchResultsCell.swift
//  AppStore
//
//  Created by Лилия on 03.11.2021.
//

import UIKit
import SDWebImage


class SearchResultsCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var appResult: Result! {
        didSet {
            nameLabel.text = appResult.trackName
            categoryLabel.text = appResult.primaryGenreName
            if let rate = appResult.averageUserRating {
                ratingsLabel.text = "Ratings: \(round(rate * 10) / 10)"
            }
            
            let url = URL(string: appResult.artworkUrl100)
            appIconImageView.sd_setImage(with: url, completed: nil)
            
            let url1 = URL(string: appResult.screenshotUrls![0])
            screenshot1ImageView.sd_setImage(with: url1, completed: nil)
            
            if appResult.screenshotUrls!.count > 1 {
                let url2 = URL(string: appResult.screenshotUrls![1])
                screenshot2ImageView.sd_setImage(with: url2, completed: nil)}
            
            if appResult.screenshotUrls!.count > 2 {
                let url3 = URL(string: appResult.screenshotUrls![2])
                screenshot3ImageView.sd_setImage(with: url3, completed: nil)}
            appUrl = appResult.trackViewUrl ?? ""
        }
    }
    
    var appUrl = ""
    
    let appIconImageView: UIImageView = {
        let iv = UIImageView()
        //iv.backgroundColor = .red
        iv.widthAnchor.constraint(equalToConstant: 64).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 64).isActive = true
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        //label.backgroundColor = .orange
        label.text = "APP NAME"
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        //label.backgroundColor = .brown
        label.text = "Photos & Video"
        return label
    }()
    
    let ratingsLabel: UILabel = {
        let label = UILabel()
        //label.backgroundColor = .systemPink
        label.text = ""
        return label
    }()
    
    let getButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.layer.cornerRadius = 16
        button.setTitle("GET", for: .normal)
        button.setTitleColor( .systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        //button.addTarget(self, action: #selector(handleGet), for: .touchUpInside)
        return button
    }()
    
    lazy var screenshot1ImageView = self.createScreenshotImageView()
    lazy var screenshot2ImageView = self.createScreenshotImageView()
    lazy var screenshot3ImageView = self.createScreenshotImageView()
    
    func createScreenshotImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //backgroundColor = .green
        
        let labelsStackView = VerticalStackView(arrangedSubviews: [nameLabel, categoryLabel, ratingsLabel])
        
        let infoTopStackView = UIStackView(arrangedSubviews: [appIconImageView, labelsStackView, getButton])
        infoTopStackView.spacing = 12
        infoTopStackView.alignment = .center
        
        getButton.addTarget(self, action: #selector(handleGet), for: .touchUpInside)
        
        let screenshotsStackView = UIStackView(arrangedSubviews: [screenshot1ImageView, screenshot2ImageView, screenshot3ImageView])
        screenshotsStackView.spacing = 12
        screenshotsStackView.axis = .horizontal
        screenshotsStackView.distribution = .fillEqually
        
        let overallStackView = VerticalStackView(arrangedSubviews: [infoTopStackView, screenshotsStackView], spacing: 16)
        
        addSubview(overallStackView)
        
        overallStackView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor,
                                paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleGet() {
        print("DEBUG: Tap get button")
        if let url = URL(string: appUrl) {
            UIApplication.shared.open(url)
        }
    }
    
}
