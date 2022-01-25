//
//  PreviewScreenshotsController.swift
//  AppStore
//
//  Created by Лилия on 15.11.2021.
//

import UIKit

private let cellId = "cellId"

class PreviewScreenshotsController: HorizontalSnappingController {
    
    // MARK: - Properties
    
    var app: Result? {
        didSet {
            collectionView.reloadData()
        }
        
    }
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        collectionView.register(ScreenshotCell.self, forCellWithReuseIdentifier: cellId)
        
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
        return app?.screenshotUrls!.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScreenshotCell
        
        // Configure the cell
        let screenshotUrl = self.app?.screenshotUrls![indexPath.item]
        cell.screenShotImage.sd_setImage(with: URL(string: screenshotUrl ?? ""), completed: nil)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension PreviewScreenshotsController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 250, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return .init(top: topBottomSpacing, left: 0, bottom: topBottomSpacing, right: 0)
    //    }
}
