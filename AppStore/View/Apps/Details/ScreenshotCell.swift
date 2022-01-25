//
//  ScreenshotCell.swift
//  AppStore
//
//  Created by Лилия on 15.11.2021.
//

import UIKit

class ScreenshotCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let screenShotImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(white: 0.95, alpha: 1)
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(screenShotImage)
        screenShotImage.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
