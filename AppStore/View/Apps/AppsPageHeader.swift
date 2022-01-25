//
//  AppsPageHeader.swift
//  AppStore
//
//  Created by Лилия on 08.11.2021.
//

import UIKit

class AppsPageHeader: UICollectionReusableView {
     
    // MARK: - Properties
    
    let appsHeaderHorizontalController = AppsHeaderHorizontalController()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .red
        
        addSubview(appsHeaderHorizontalController.view)
        
        appsHeaderHorizontalController.view.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
