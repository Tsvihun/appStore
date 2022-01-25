//
//  TodayMultipleAppsController.swift
//  AppStore
//
//  Created by Лилия on 23.11.2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class TodayMultipleAppsController: UICollectionViewController {
    
    // MARK: - Properties
    
    private let mode: Mode
    
    enum Mode {
        case small, fullscreen
    }
    
    private let spacing: CGFloat = 16
    var apps = [FeedResult]()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.closeButton, for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    override var prefersStatusBarHidden: Bool { return true }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        
        if mode == .fullscreen {
            setupCloseButton()
            navigationController?.isNavigationBarHidden = true
        } else {
            collectionView.isScrollEnabled = false
        }
        
    }
    
    init(mode: Mode) {
        self.mode = mode
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Function
    
    private func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 16, paddingRight: 16, width: 44, height: 44)
    }
    
    // MARK: - Selectors
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if mode == .fullscreen {
            return apps.count
        }
        
        return min(4, apps.count)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MultipleAppCell
        
        // Configure the cell
        let app = apps[indexPath.item]
        cell.imageView.sd_setImage(with: URL(string: app.artworkUrl100), completed: nil)
        cell.companyLabel.text = app.artistName
        cell.nameLabel.text = app.name
        cell.appUrl = app.url
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let app = apps[indexPath.item]
        
        let detailController = AppDetailController(appId: app.id)
        detailController.navigationItem.title = app.name
        navigationController?.pushViewController(detailController, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegate

extension TodayMultipleAppsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if mode == .fullscreen {
            return .init(width: view.frame.width - 2 * spacing, height: 64)
        } else {
            let height = (view.frame.height - 3 * spacing) / 4
            return .init(width: view.frame.width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if mode == .fullscreen {
            return .init(top: 12, left: spacing, bottom: 12, right: spacing)
        } else {
            return .zero
        }
    }
}
