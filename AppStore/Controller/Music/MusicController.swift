//
//  MusicController.swift
//  AppStore
//
//  Created by Лилия on 01.12.2021.
//

import UIKit

private let trackCellId = "TrackCell"
private let footerId = "footer"

class MusicController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var results = [Result]()
    private let searchTerm = "Taylor"
    private var isPaginating = false
    private var isDonePaginating = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: trackCellId)
        collectionView.register(MusicLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        // Do any additional setup after loading the view.
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        fetchData()
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
    // MARK: - Helper Functions
    
    private func fetchData() {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&offset=0&limit=10"
        Service.shared.fetchGenericJSONData(urlString: urlString, completionHandler: { (searchResult: SearchResult) in
            self.results = searchResult.results
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
}

// MARK: - UICollectionViewDataSource

extension MusicController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return results.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: trackCellId, for: indexPath) as! TrackCell
        // Configure the cell
        cell.track = results[indexPath.item]
        
        // initiate paginating
        if indexPath.item == results.count - 1 && !isPaginating {
            print("DEBUG: Fetch more data")
            self.isPaginating = true
            
            let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&offset=\(results.count)&limit=20"
            Service.shared.fetchGenericJSONData(urlString: urlString, completionHandler: { (searchResult: SearchResult) in
                
                if searchResult.results.count == 0 {
                    self.isDonePaginating = true
                }
                
                sleep(2)
                self.results += searchResult.results
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                self.isPaginating = false
            })
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath) as! MusicLoadingFooter
        return footer
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = isDonePaginating ? 0 : 100
        return .init(width: view.frame.width, height: height)
    }
    
}

// MARK: - UICollectionViewDelegate

extension MusicController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return .init(top: topBottomSpacing, left: 0, bottom: topBottomSpacing, right: 0)
    //    }
    
}
