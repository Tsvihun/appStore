//
//  AppFullscreenHeaderCell.swift
//  AppStore
//
//  Created by Лилия on 17.11.2021.
//

import UIKit

class AppFullscreenHeaderCell: UITableViewCell {
    
    // MARK: - Properties
    
    let todayCell = TodayCell()
        
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        clipsToBounds = true // for delete shadow from TodayCell()
        addSubview(todayCell)
        todayCell.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
