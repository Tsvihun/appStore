//
//  PreviewCell.swift
//  AppStore
//
//  Created by Лилия on 15.11.2021.
//

import UIKit

class PreviewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let previewLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .orange
        label.text = "Preview"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    let containerController = PreviewScreenshotsController()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .systemMint
        
        addSubview(previewLabel)
        previewLabel.anchor(top: topAnchor, left: leftAnchor, paddingLeft: 16)
        
        addSubview(containerController.view)
        containerController.view.anchor(top: previewLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
