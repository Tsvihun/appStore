//
//  AppDetailController.swift
//  AppStore
//
//  Created by Лилия on 12.11.2021.
//

import UIKit

private let detailCellId = "detailCellId"
private let previewCellId = "previewCellId"
private let reviewCellId = "reviewCellId"

class AppDetailController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var app: Result?
    private var reviews: Reviews?
    private let appId: String
    
    let activityIdicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: detailCellId)
        collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: previewCellId)
        collectionView.register(ReviewRowCell.self, forCellWithReuseIdentifier: reviewCellId)
        
        
        // Do any additional setup after loading the view.
        collectionView.showsVerticalScrollIndicator = false
        
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(activityIdicator)
        activityIdicator.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        fetchData()
    }
    // dependency injection constructor 
    init(appId: String) {
        self.appId = appId
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    
    private func fetchData() {
        
        let url = "https://itunes.apple.com/lookup?id=\(appId)"
        Service.shared.fetchGenericJSONData(urlString: url, completionHandler: { (result: SearchResult) in
            let app = result.results.first
            self.app = app
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
        
        let reviewsUrl = "https://itunes.apple.com/us/rss/customerreviews/id=\(appId)/mostrecent/json?l=en&cc=us"
        Service.shared.fetchGenericJSONData(urlString: reviewsUrl, completionHandler: {(reviews: Reviews) in
            self.reviews = reviews
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
        
        print("DEBUG: Finished fetching app")
        self.activityIdicator.stopAnimating()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath) as! AppDetailCell
            // Configure the cell
            cell.app = app
            return cell
        } else if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewCellId, for: indexPath) as! PreviewCell
            // Configure the cell
            cell.containerController.app = app
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellId, for: indexPath) as! ReviewRowCell
            // Configure the cell
            cell.containerController.reviews = reviews
            return cell
        }
        
    }
    
}

// MARK: - UICollectionViewDelegate

extension AppDetailController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 0 {
            
            // calculate the necessary size for our cell
            let dummyCell = AppDetailCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
            dummyCell.app = app
            dummyCell.layoutIfNeeded()
            let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
            return .init(width: view.frame.width, height: estimatedSize.height)
            
        } else if indexPath.item == 1 {
            return .init(width: view.frame.width, height: 500)
        } else {
            return .init(width: view.frame.width, height: 280)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
}
