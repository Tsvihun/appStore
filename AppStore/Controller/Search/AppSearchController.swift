//
//  AppSearchController.swift
//  AppStore
//
//  Created by Лилия on 03.11.2021.
//

import UIKit

private let reuseIdentifier = "reuseIdentifier"

class AppSearchController: UICollectionViewController {
    
    // MARK: - Properties
    
    var appUrl = ""
    
    private let searchController = UISearchController(searchResultsController: nil)
    var timer: Timer?
    var appResults = [Result]()
    
    private let enterSearchTermLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter search term above..."
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(SearchResultsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        //collectionView.backgroundColor = .yellow
        setupSearchBar()
        collectionView.addSubview(enterSearchTermLabel)
        enterSearchTermLabel.anchor(top: collectionView.topAnchor, paddingTop: 100)
        enterSearchTermLabel.centerX(inView: collectionView)
        //fetchApps()
        
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    
    private func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func fetchApps() {
        
        Service.shared.fetchITunesApps(searchText: "instagram", completionHandler: { (searchResult) in
            self.appResults = searchResult.results
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        enterSearchTermLabel.isHidden = appResults.count != 0
        return appResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchResultsCell
        // Configure the cell
        let appResult = appResults[indexPath.item]
        cell.appResult = appResult
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let appResult = appResults[indexPath.item]
        
        let appDetailController = AppDetailController(appId: String(appResult.trackId))
        appDetailController.navigationItem.title = appResult.trackName
        navigationController?.pushViewController(appDetailController, animated: true)
    }
    
}

// MARK: - UICollectionViewDataSource

extension AppSearchController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 350)
    }
}

// MARK: - UISearchBarDelegate

extension AppSearchController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("DEBUG: Searching:", searchText)
        
        //podcasts = []          // setup view for
        //tableView.reloadData() // footer here, when text did change
        
        
        // introduce some delay before peforming the search
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
        Service.shared.fetchITunesApps(searchText: searchText, completionHandler: { (searchResult) in
            self.appResults = searchResult.results
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
        })
    }
    
}
