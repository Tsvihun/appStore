//
//  TodayMultipleAppCell.swift
//  AppStore
//
//  Created by Лилия on 21.11.2021.
//

import UIKit

class TodayMultipleAppCell: BaseTodayCell {
    
    // MARK: - Properties
    
    override var todayItem: TodayItem! {
        didSet {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
            backgroundView?.backgroundColor = todayItem.backgroudColor
            multipleAppsController.apps = todayItem.apps!
            multipleAppsController.collectionView.reloadData()
        }
    }
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        //label.backgroundColor = .red
        label.text = "THE DAILY LIST"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        //label.backgroundColor = .blue
        label.text = "Test-Drive These CarPlay Apps"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.numberOfLines = 2
        return label
    }()
    
    let multipleAppsController = TodayMultipleAppsController(mode: .small)
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = VerticalStackView(arrangedSubviews: [categoryLabel, titleLabel, multipleAppsController.view], spacing: 8)
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 24, paddingRight: 24)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
