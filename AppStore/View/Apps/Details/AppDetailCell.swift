//
//  AppDetailCell.swift
//  AppStore
//
//  Created by Лилия on 12.11.2021.
//

import UIKit

class AppDetailCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var app: Result! {
        didSet {
            nameLabel.text = app?.trackName
            releaseNotesLabel.text = app?.releaseNotes
            if let rate = app?.averageUserRating, let ratingCount = app?.userRatingCount, let price = app?.formattedPrice {
                infoLabel.text = "\(round(rate * 10) / 10)/5 • \(ratingCount) Ratings• \(price)"
            }
            appIconImageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""), completed: nil)
            appUrl = app?.trackViewUrl ?? ""
        }
    }
    
    var appUrl = ""
    
    let appIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(white: 0.95, alpha: 1)
        iv.setDemensions(height: 140, width: 140)
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .orange
        label.text = "APP NAME"
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(white: 0.2, alpha: 1)
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let appStoreLink: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.layer.cornerRadius = 30 / 2
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 0.5
        button.setTitle("   App Store View in \u{2197}   ", for: .normal)
        button.addTarget(self, action: #selector(handleGet), for: .touchUpInside)
        return button
    }()
    
    let whatNewLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .green
        label.text = "What's New"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    let releaseNotesLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .systemPink
        label.text = "Release Notes"
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .blue
        
        let stackLabels = VerticalStackView(arrangedSubviews: [nameLabel, infoLabel, appStoreLink, UIView()], spacing: 8)
        stackLabels.alignment = .leading
        
        let InfoStack = UIStackView(arrangedSubviews: [appIconImageView, stackLabels])
        InfoStack.spacing = 8
//        InfoStack.backgroundColor = .yellow
        
        let stackView = VerticalStackView(arrangedSubviews: [InfoStack, whatNewLabel, releaseNotesLabel], spacing: 16)
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,
                         paddingTop: 20, paddingLeft: 20, paddingBottom: 20, paddingRight: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleGet() {
        print("DEBUG: Taped link button")
        
        if let url = URL(string: appUrl) {
            UIApplication.shared.open(url)
        }

    }
    
}
