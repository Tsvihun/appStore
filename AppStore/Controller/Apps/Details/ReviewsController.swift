//
//  ReviewsController.swift
//  AppStore
//
//  Created by Лилия on 15.11.2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class ReviewsController: HorizontalSnappingController {
    
    // MARK: - Properies
    
    var reviews: Reviews? {
        didSet {
            collectionView.reloadData()
        }
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return reviews?.feed.entry.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ReviewCell
    
        // Configure the cell
        let entry = reviews?.feed.entry[indexPath.item]
        cell.authorLabel.text = entry?.author.name.label
        cell.titleLabel.text = entry?.title.label
        cell.bodyLabel.text = entry?.content.label
        
        for (index, view) in cell.starStackView.arrangedSubviews.enumerated() {
            
            if let ratingInt = Int(entry!.rating.label) {
                view.alpha = index >= ratingInt ? 0 : 1
            }
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ReviewsController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 32, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return .init(top: topBottomSpacing, left: 0, bottom: topBottomSpacing, right: 0)
    //    }
}

