//
//  MusicLoadingFooter.swift
//  AppStore
//
//  Created by Лилия on 01.12.2021.
//

import UIKit

class MusicLoadingFooter: UICollectionReusableView {
        
    // MARK: - Properties
    
    let activityIdicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Loading more..."
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        let stackView = VerticalStackView(arrangedSubviews: [activityIdicator, label], spacing: 8)
        addSubview(stackView)
        stackView.centerY(inView: self, left: leftAnchor, right: rightAnchor)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
