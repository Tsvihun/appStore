//
//  AppFullscreenDescriptionCell.swift
//  AppStore
//
//  Created by Лилия on 16.11.2021.
//

import UIKit

class AppFullscreenDescriptionCell: UITableViewCell {
    
    // MARK: - Properties
    
//    var todayItem: TodayItem! {
//        didSet {
//            descriptionLabel.text = todayItem.notes
//        }
//    }
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        
//        let attributedText = NSMutableAttributedString(string: "Great games", attributes: [.foregroundColor: UIColor.black])
//
//        attributedText.append(NSAttributedString(string: " are all about the details, from subtle visual effects to imaginative art styles. In these titles, you're sure to find something to marvel at, whether you're into fantasy worlds or neon-soaked dartboards.", attributes: [.foregroundColor: UIColor.gray]))
//
//        attributedText.append(NSAttributedString(string: "\n\n\nHeroic adventure", attributes: [.foregroundColor: UIColor.black]))
//
//        attributedText.append(NSAttributedString(string: "\nBattle in dungeons. Collect treasure. Solve puzzles. Sail to new lands. Oceanhorn lets you do it all in a beautifully detailed world.", attributes: [.foregroundColor: UIColor.gray]))
//
//        attributedText.append(NSAttributedString(string: "\n\n\nExcellence", attributes: [.foregroundColor: UIColor.black]))
//
//        attributedText.append(NSAttributedString(string: "\nTest your abilities by going through many different challenges today.", attributes: [.foregroundColor: UIColor.gray]))
        
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
       // label.attributedText = attributedText
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(descriptionLabel)
        descriptionLabel.fillSuperview(padding: .init(top: 0, left: 24, bottom: 0, right: 24))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
