//
//  AppsHorizontalController.swift
//  AppStore
//
//  Created by Лилия on 04.11.2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class AppsHorizontalController: HorizontalSnappingController {
    
    // MARK: - Properties
    
    let topBottomSpacing: CGFloat = 12
    let lineSpacing: CGFloat = 10
    
    var appGroup: AppGroup?
    var didSelectHandler: ((FeedResult) -> ())?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .init(top: topBottomSpacing, left: 16, bottom: topBottomSpacing, right: 16)
        
        //        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
        //        layout.scrollDirection = .horizontal
        //        }
        //        collectionView.isPagingEnabled = true
        
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return appGroup?.feed.results.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AppRowCell
        
        // Configure the cell
        let app = appGroup?.feed.results[indexPath.item]
        cell.app = app
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let app = appGroup?.feed.results[indexPath.item] {
            didSelectHandler?(app)
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension AppsHorizontalController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 48, height: (view.frame.height - 2*topBottomSpacing - 2*lineSpacing) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return .init(top: topBottomSpacing, left: 0, bottom: topBottomSpacing, right: 0)
    //    }
}

