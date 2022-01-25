//
//  TrackCell.swift
//  AppStore
//
//  Created by Лилия on 01.12.2021.
//

import UIKit

class TrackCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var track: Result! {
        didSet {
            imageView.sd_setImage(with: URL(string: track.artworkUrl100))
            nameLabel.text = track.trackName
            subtitleLabel.text = "\(track.artistName ?? "") • \(track.collectionName ?? "")"
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(white: 0.95, alpha: 1)
        iv.widthAnchor.constraint(equalToConstant: 84).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 84).isActive = true
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Track Name"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "subtitle Label"
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(arrangedSubviews: [imageView, VerticalStackView(arrangedSubviews: [nameLabel, subtitleLabel], spacing: 4)])
        stackView.alignment = .center
        stackView.spacing = 16
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        
        addSubview(separatorView)
        separatorView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
