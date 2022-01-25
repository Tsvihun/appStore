//
//  TodayItem.swift
//  AppStore
//
//  Created by Лилия on 18.11.2021.
//

import UIKit

struct TodayItem {
    
    let category: String
    let title: String
    let image: UIImage
    let description: String
    let backgroudColor: UIColor
    
    let cellType: CellType
    
    var apps: [FeedResult]?
    var app: Result?
    let notes: String
    
    enum CellType: String {
        case single, multiple
    }
}
