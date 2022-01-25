//
//  Today.swift
//  AppStore
//
//  Created by Лилия on 16.11.2021.
//

import UIKit


class TodayController: UICollectionViewController {
    
    // MARK: - Properties
    
    var items = [TodayItem]()
    let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    var appFullscreenBeginOffset: CGFloat = 0
    
    let activityIdicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    var appFullscreenController: AppFullscreenController!
    var startingFrame: CGRect?
    
    var topConstraint: NSLayoutConstraint?
    var leftConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
        
        // Do any additional setup after loading the view.
        collectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0
        
        collectionView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(activityIdicator)
        activityIdicator.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
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
        
        //dispatchGroup
        let dispatchGroup = DispatchGroup()
        var cleanAppToday: Result?
        var musicAppToday: Result?
        var scanAppToday: Result?
        var topFreeApps: AppGroup?
        var topPaidApps: AppGroup?
       
        dispatchGroup.enter()
        let cleanAppTodayUrl = "https://itunes.apple.com/lookup?id=1194582243"
        Service.shared.fetchGenericJSONData(urlString: cleanAppTodayUrl, completionHandler: { (app: SearchResult) in
            cleanAppToday = app.results.first
            dispatchGroup.leave()
        })
        
        dispatchGroup.enter()
        let musicAppTodayUrl = "https://itunes.apple.com/lookup?id=1289293705"
        Service.shared.fetchGenericJSONData(urlString: musicAppTodayUrl, completionHandler: { (app: SearchResult) in
            musicAppToday = app.results.first
            dispatchGroup.leave()
        })
        
        dispatchGroup.enter()
        let scanAppTodayUrl = "https://itunes.apple.com/lookup?id=1458733185"
        Service.shared.fetchGenericJSONData(urlString: scanAppTodayUrl, completionHandler: { (app: SearchResult) in
            scanAppToday = app.results.first
            dispatchGroup.leave()
        })
        
        dispatchGroup.enter()
        Service.shared.fetchTopFreeApps(completionHandler: {(appGroup) in
            topFreeApps = appGroup
            dispatchGroup.leave()
        })
        
        dispatchGroup.enter()
        Service.shared.fetchTopPaidApps(completionHandler: {(appGroup) in
            topPaidApps = appGroup
            dispatchGroup.leave()
        })
        
        // completion block
        dispatchGroup.notify(queue: .main, execute: {
            
            // I'll haave access to TopFreeApps and TopPaidApps
            print("DEBUG: Finished fetching")
            self.activityIdicator.stopAnimating()
            
            self.items = [TodayItem(category: "ENJOY MUSIC", title: "Offline Music Player", image: .melomanImage, description: "This app allows you to search and listen millions of Song. Listen to the songs you love and enjoy music from all over the world.", backgroudColor: #colorLiteral(red: 0.3066394925, green: 0.7434653044, blue: 0.8482935429, alpha: 1), cellType: .single, app: musicAppToday, notes: musicAppToday?.description ?? ""),
                          
                          TodayItem(category: "DAILY LIST", title: topFreeApps?.feed.title ?? "", image: .gardenImage, description: "", backgroudColor: .white, cellType: .multiple, apps: topFreeApps?.feed.results ?? [], notes: "2"),
                          
                          TodayItem(category: "WORK TIME", title: "This is genius", image: .scanImage, description: "Scanner will turn your device into a powerful digital office and help you become more productive in your work and daily life.", backgroudColor: #colorLiteral(red: 0.815244019, green: 0.1935699284, blue: 0.2488900423, alpha: 1), cellType: .single, app: scanAppToday, notes: scanAppToday?.description ?? ""),
                          
                          TodayItem(category: "DAILY LIST", title: topPaidApps?.feed.title ?? "", image: .gardenImage, description: "", backgroudColor: .white, cellType: .multiple, apps: topPaidApps?.feed.results ?? [], notes: "4"),
                          
                          TodayItem(category: "LIFE HACK", title: "Clean Storage", image: .cleanerImage, description: "Keep your contacts and photos in perfect order with Smart Cleaner! ", backgroudColor: #colorLiteral(red: 0.1450449228, green: 0.5374655724, blue: 0.9672048688, alpha: 1), cellType: .single, app: cleanAppToday, notes: cleanAppToday?.description ?? "")]
            
            self.collectionView.reloadData()
        })
        
    }
    
    private func showDailyListFullScreen(_ indexPath: IndexPath) {
        let controller = TodayMultipleAppsController(mode: .fullscreen)
        controller.apps = items[indexPath.item].apps!
        
        let navController = BackEnabledNavigationController(rootViewController: controller)
        navController.modalPresentationStyle = .fullScreen
        
        present(navController, animated: true, completion: nil)
    }
    
    private func showSingleAppFullScreen(_ indexPath: IndexPath) {
        // #1 setup fullscreen controller
        setupSingleAppFullscreenController(indexPath)
        //#2 setup fullscreen in its starting position
        setupAppFullscreenStartingPosition(indexPath)
        //#3 begin the fullscrenn animation
        beginAnimationAppFullscreen()
    }
    
    private func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
        let fullscreenController = AppFullscreenController()
        fullscreenController.todayItem = items[indexPath.item]
        fullscreenController.view.layer.cornerRadius = 16
        fullscreenController.dismissHandler = {
            self.handleRemoveFullscreenView()
        }
        self.appFullscreenController = fullscreenController
        
        // #1 setup pan gesture
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gesture.delegate = self
        fullscreenController.view.addGestureRecognizer(gesture)
    }
    
    private func setupAppFullscreenStartingPosition(_ indexPath: IndexPath) {
        
        let fullscreenView = self.appFullscreenController.view!
        
        view.addSubview(fullscreenView)
        addChild(self.appFullscreenController)
        self.collectionView.isUserInteractionEnabled = false
        
        setupStartingCellFrame(indexPath)
        
        // starting auto layot constraints
        fullscreenView.translatesAutoresizingMaskIntoConstraints = false
        guard let startingFrame = self.startingFrame else { return }
        
        topConstraint = fullscreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
        leftConstraint = fullscreenView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: startingFrame.origin.x)
        widthConstraint = fullscreenView.widthAnchor.constraint(equalToConstant: startingFrame.width)
        heightConstraint = fullscreenView.heightAnchor.constraint(equalToConstant: startingFrame.height)
        
        [topConstraint, leftConstraint, widthConstraint, heightConstraint].forEach({$0?.isActive = true})
        self.view.layoutIfNeeded()
    }
    
    private func setupStartingCellFrame(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        // absolute coordinates of cell
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        self.startingFrame = startingFrame
    }
    
    private func beginAnimationAppFullscreen() {
        
        
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.blurVisualEffectView.alpha = 1
            
            self.topConstraint?.constant = 0
            self.leftConstraint?.constant = 0
            self.widthConstraint?.constant = self.view.frame.width
            self.heightConstraint?.constant = self.view.frame.height
            
            self.tabBarController?.tabBar.frame.origin.y += 100
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
            self.view.layoutIfNeeded() // starts animations
            
        }, completion: nil)
    }
    
    private func handleRemoveFullscreenView() {
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.blurVisualEffectView.alpha = 0
            self.appFullscreenController.view.transform = .identity
            
            //self.appFullscreenController.tableView.contentOffset = .zero // 1st metod
            //self.appFullscreenController.tableView.scroll(to: .top, animated: true) // 2d metod
            
            let topIndex = IndexPath(row: 0, section: 0)
            self.appFullscreenController.tableView.scrollToRow(at: topIndex, at: .top, animated: true) // 3d metod
            //self.appFullscreenController.tableView.contentInsetAdjustmentBehavior = .never
            
            guard let startingFrame = self.startingFrame else { return }
            
            self.topConstraint?.constant = startingFrame.origin.y
            self.leftConstraint?.constant = startingFrame.origin.x
            self.widthConstraint?.constant = startingFrame.width
            self.heightConstraint?.constant = startingFrame.height
            
            self.tabBarController?.tabBar.frame.origin.y -= 100
            
            guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0, 0]) as? AppFullscreenHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 24
            self.appFullscreenController.closeButton.alpha = 0
            cell.layoutIfNeeded()
            self.view.layoutIfNeeded() // starts animations
            
        }, completion: { _ in
            
            self.appFullscreenController.view.removeFromSuperview()
            self.appFullscreenController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
    
    // MARK: - Selectors
    
    @objc private func handleMultipleAppsTap(gesture: UITapGestureRecognizer) {
        
        let collectionView = gesture.view
        
        var superview = collectionView?.superview
        
        while superview != nil {
            if let cell = superview as? TodayMultipleAppCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                let apps = self.items[indexPath.item].apps!
                let fullController = TodayMultipleAppsController(mode: .fullscreen)
                fullController.apps = apps
                
                
                let navController = BackEnabledNavigationController(rootViewController: fullController)
                navController.modalPresentationStyle = .fullScreen
                present(navController, animated: true, completion: nil)
                
                return
            }
            superview = superview?.superview
        }
    }
    
    @objc func handleDrag(gesture: UIPanGestureRecognizer) {
        
        let translationY = gesture.translation(in: self.appFullscreenController.view).y
        
        if gesture.state == .began {
            self.appFullscreenBeginOffset = appFullscreenController.tableView.contentOffset.y
        }
        
        if appFullscreenController.tableView.contentOffset.y > 0 {
            return
        }
        
        if gesture.state == .changed {
            if translationY > 0 {
                let trueOffset = translationY - appFullscreenBeginOffset
                
                var scale = 1 - trueOffset / 1000
                scale = min(1, scale)
                scale = max(0.5, scale)

                let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
                self.appFullscreenController.view.transform = transform
            }
        } else if gesture.state == .ended {
            if translationY > 0 {
                handleRemoveFullscreenView()
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellId = items[indexPath.item].cellType.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
        cell.todayItem = items[indexPath.item]
        
        (cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("DEBUG: Animate fullscreen cell")
        
        switch items[indexPath.item].cellType {
        case .single:
            showSingleAppFullScreen(indexPath)
        case .multiple:
            showDailyListFullScreen(indexPath)
        }
        
    }
    
}

// MARK: - UICollectionViewDelegate

extension TodayController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: 500)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension TodayController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
