//
//  AppsController.swift
//  AppStore
//
//  Created by Лилия on 04.11.2021.
//

import UIKit

class AppsController: UICollectionViewController {
    
    // MARK: - Properties

    private let cellId = "cellId"
    private let headerId = "headerId"
    
    var socialApps = [SocialApp]()
    var groups = [AppGroup]()
    
    let activityIdicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.color = .black
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        // Do any additional setup after loading the view.
        collectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(activityIdicator)
        activityIdicator.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        fetchApps()
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    
    private func fetchApps() {
        
        var group1: AppGroup?
        var group2: AppGroup?
        var group3: AppGroup?
        
        // sync data fetches together
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Service.shared.fetchTopFreeApps(completionHandler: { (appGroup) in
            dispatchGroup.leave()
            group1 = appGroup
        })
        dispatchGroup.enter()
        Service.shared.fetchTopPaidApps(completionHandler: { (appGroup) in
            dispatchGroup.leave()
            group2 = appGroup
        })
        dispatchGroup.enter()
        Service.shared.fetchAppGroup(urlString: "https://rss.applemarketingtools.com/api/v2/ua/apps/top-free/10/apps.json", completionHandler: { (appGroup) in
            dispatchGroup.leave()
            group3 = appGroup
        })
        
        dispatchGroup.enter()
        Service.shared.fetchSocialApps(completionHandler: { (apps) in
            dispatchGroup.leave()
            self.socialApps = apps
        })
        
        // completion block
        dispatchGroup.notify(queue: .main, execute: {
            print("DEBUG: completed dispatch group tasks...")
            
            self.activityIdicator.stopAnimating()
            
            if let group = group1 {
                self.groups.append(group)
            }
            if let group = group2 {
                self.groups.append(group)
            }
            if let group = group3 {
                self.groups.append(group)
            }

            self.collectionView.reloadData()
        })
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return groups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsGroupCell
        
        // Configure the cell
        let group = groups[indexPath.item]
        
        cell.titleLabel.text = groups[indexPath.item].feed.title
        cell.containerView.appGroup = group
        cell.containerView.collectionView.reloadData()
        
        cell.containerView.didSelectHandler = { [weak self] feedResult in
            let controller = AppDetailController(appId: feedResult.id)
            controller.navigationItem.title = feedResult.name
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppsPageHeader
        header.appsHeaderHorizontalController.socialApps = self.socialApps
        header.appsHeaderHorizontalController.collectionView.reloadData()
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }

}

// MARK: - UICollectionViewDelegate

extension AppsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
}
