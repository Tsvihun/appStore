//
//  AppConpositionalView.swift
//  AppStore
//
//  Created by Лилия on 01.12.2021.
//

import SwiftUI

class CompositionalController: UICollectionViewController {
    
    // MARK: - Properties
    
    private let headerCellId = "headerCell"
    private let cellId = "cellId"
    private let header = "header"
    
    private var socialApps = [SocialApp]()
    private var freeApps: AppGroup?
    private var paidApps: AppGroup?
    private var freeAppsUkr: AppGroup?
    
    enum AppSection {
        case topSocial
        case topFree
        case topPaid
        case topFreeUkr
    }
    lazy var diffableDataSource: UICollectionViewDiffableDataSource<AppSection,AnyHashable> = .init(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, object) -> UICollectionViewCell? in
        
        if let object = object as? SocialApp {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.headerCellId, for: indexPath) as! AppsHeaderCell
        cell.app = object
        return cell
    } else if let object = object as? FeedResult {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! AppRowCell
        cell.app = object
        cell.getButton.addTarget(self, action: #selector(self.handleGet), for: .primaryActionTriggered)
        return cell
    }
        return nil
    })
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: headerCellId)
        collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: cellId)
        // Register header class
        collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: header)
        
        collectionView.backgroundColor = .systemBackground
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = .init(title: "Fetch Top Free", style: .plain, target: self, action: #selector(handleFetchTopFree))
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        //fetchApps()
        setupDiffableDataSource()
    }
    
    init() {
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionNumber, _) -> NSCollectionLayoutSection? in
            
            if sectionNumber == 0 {
                return CompositionalController.topSection()
            } else {
                return CompositionalController.secondSection()
            }
            
        })
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    
    static func topSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.trailing = 16
        item.contentInsets.bottom = 16
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 16
        
        return section
    }
    
    static func secondSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)))
        item.contentInsets.trailing = 16
        item.contentInsets.bottom = 16
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 16
        
        let kind = UICollectionView.elementKindSectionHeader
        section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)) , elementKind: kind, alignment: .topLeading)]
        
        return section
    }
    
    private func fetchApps() {
        Service.shared.fetchSocialApps(completionHandler: { (apps) in
            self.socialApps = apps
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
        Service.shared.fetchTopFreeApps(completionHandler: { (appGroup) in
            self.freeApps = appGroup
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
        Service.shared.fetchTopPaidApps(completionHandler: { (appGroup) in
            self.paidApps = appGroup
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
        Service.shared.fetchAppGroup(urlString: "https://rss.applemarketingtools.com/api/v2/ua/apps/top-free/10/apps.json", completionHandler: { (appGroup) in
            self.freeAppsUkr = appGroup
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
    
    private func setupDiffableDataSource() {
        collectionView.dataSource = diffableDataSource
        
        diffableDataSource.supplementaryViewProvider = .some({ (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: self.header, for: indexPath) as! CompositionalHeader
            
            let snapshot = self.diffableDataSource.snapshot()
            let object = self.diffableDataSource.itemIdentifier(for: indexPath)
            let section = snapshot.sectionIdentifier(containingItem: object!)
            
            if section == .topFree {
                header.titleLabel.text = "free"
            } else if section == .topPaid {
                header.titleLabel.text = "paid"
            } else if section == .topFreeUkr {
                header.titleLabel.text = "free in Ukraine"
            }
            return header
        })
        
        Service.shared.fetchSocialApps(completionHandler: { (socialApp) in
            
            Service.shared.fetchTopFreeApps(completionHandler: { (appGroupFree) in
                
                Service.shared.fetchTopPaidApps(completionHandler: { (appGroupPaid) in
                    
                    // adding data
                    var snapshot = self.diffableDataSource.snapshot()
                    
                    //top social
                    snapshot.appendSections([.topSocial, .topFree, .topPaid])
                    snapshot.appendItems(socialApp, toSection: .topSocial)
                    
                    //top free
                    let appsFree = appGroupFree.feed.results
                    snapshot.appendItems(appsFree, toSection: .topFree)
                    
                    //top paid
                    let appsPaid = appGroupPaid.feed.results
                    snapshot.appendItems(appsPaid, toSection: .topPaid)
                    
                    self.diffableDataSource.apply(snapshot)
                    
                })
            })
        })
    }
    
    // MARK: - UICollectionViewDataSource
    
    //    override func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        return 1
    //    }
    
    //    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //
    //        switch section {
    //        case 0:
    //            return socialApps.count
    //        case 1:
    //            return freeApps?.feed.results.count ?? 0
    //        case 2:
    //            return paidApps?.feed.results.count ?? 0
    //        case 3:
    //            return freeAppsUkr?.feed.results.count ?? 0
    //        default:
    //            return 1
    //        }
    //    }
    
    //    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //
    //        switch indexPath.section {
    //        case 0:
    //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCellId, for: indexPath) as! AppsHeaderCell
    //            let app = socialApps[indexPath.item]
    //            cell.companyLabel.text = app.name
    //            cell.titleLabel.text = app.tagline
    //            cell.imageView.sd_setImage(with: URL(string: app.imageUrl), completed: nil)
    //            return cell
    //        default:
    //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppRowCell
    //            var appGroup: AppGroup?
    //            if indexPath.section == 1 {
    //                appGroup = freeApps
    //            } else if indexPath.section == 2 {
    //                appGroup = paidApps
    //            } else {
    //                appGroup = freeAppsUkr
    //            }
    //            let app = appGroup?.feed.results[indexPath.item]
    //            cell.nameLabel.text = app?.name
    //            cell.companyLabel.text = app?.artistName
    //            cell.imageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""), completed: nil)
    //            return cell
    //        }
    //    }
    
    //        override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    //            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: header, for: indexPath) as! CompositionalHeader
    //            var title: String?
    //
    //            if indexPath.section == 1 {
    //                title = freeApps?.feed.title
    //            } else if indexPath.section == 2 {
    //                title = paidApps?.feed.title
    //            } else {
    //                title = (freeAppsUkr?.feed.title)! + " in Ukraine"
    //            }
    //
    //            header.titleLabel.text = title
    //            return header
    //        }
    
    //    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        let appId: String
    //
    //        if indexPath.section == 0 {
    //            appId = socialApps[indexPath.item].id
    //        } else if indexPath.section == 1 {
    //            appId = freeApps?.feed.results[indexPath.item].id ?? ""
    //        } else if indexPath.section == 2 {
    //            appId = paidApps?.feed.results[indexPath.item].id ?? ""
    //        } else {
    //            appId = freeAppsUkr?.feed.results[indexPath.item].id ?? ""
    //        }
    //        let appDetailController = AppDetailController(appId: appId)
    //        navigationController?.pushViewController(appDetailController, animated: true)
    //
    //    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let object = self.diffableDataSource.itemIdentifier(for: indexPath)
        if let object = object as? SocialApp {
            let appDetailController = AppDetailController(appId: object.id)
            navigationController?.pushViewController(appDetailController, animated: true)
        } else if let object = object as? FeedResult {
            let appDetailController = AppDetailController(appId: object.id)
            navigationController?.pushViewController(appDetailController, animated: true)
        }
    }
    
    // MARK: Selectors
    
    @objc func handleGet(button: UIView) {
        
        var superview = button.superview
        while superview != nil {
            if let cell = superview as? UICollectionViewCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                guard let objectClikedOnto = diffableDataSource.itemIdentifier(for: indexPath) else { return }
                
                var snapshot = diffableDataSource.snapshot()
                snapshot.deleteItems([objectClikedOnto])
                diffableDataSource.apply(snapshot)
            }
            superview = superview?.superview
        }
    }
    
    @objc func handleFetchTopFree() {
        
        Service.shared.fetchAppGroup(urlString: "https://rss.applemarketingtools.com/api/v2/ua/apps/top-free/10/apps.json", completionHandler: { (appGroup) in
            
            var snapshot  = self.diffableDataSource.snapshot()
            snapshot.insertSections([.topFreeUkr], afterSection: .topSocial)
            snapshot.appendItems(appGroup.feed.results, toSection: .topFreeUkr)
            self.diffableDataSource.apply(snapshot)
        })
    }
    
    @objc func handleRefresh() {
        collectionView.refreshControl?.endRefreshing()
        
        var snapshot = diffableDataSource.snapshot()
        snapshot.deleteSections([.topFreeUkr])
        diffableDataSource.apply(snapshot)
    }
}

class CompositionalHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    let titleLabel: UILabel = {
        let label = UILabel()
        //label.backgroundColor = .orange
        label.text = "App Section"
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: self, left: leftAnchor, right: rightAnchor)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct AppsView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = CompositionalController()
        return UINavigationController(rootViewController: controller)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        if #available(iOS 15, *) {
            let defaultTabBarAppearance = UITabBarAppearance()
            defaultTabBarAppearance.configureWithDefaultBackground() // for clarity
            UITabBar.appearance().standardAppearance = defaultTabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = defaultTabBarAppearance
            
            let defaultNavBarAppearance = UINavigationBarAppearance()
            defaultNavBarAppearance.configureWithDefaultBackground() // for clarity
            UINavigationBar.appearance().standardAppearance = defaultNavBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = defaultNavBarAppearance
        }
    }
    
    typealias UIViewControllerType = UIViewController
    
}

struct AppConpositionalView_Previews: PreviewProvider {
    static var previews: some View {
        AppsView()
            .edgesIgnoringSafeArea(.all)
    }
}
