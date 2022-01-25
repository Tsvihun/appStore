//
//  AppFullscreenController.swift
//  AppStore
//
//  Created by Лилия on 16.11.2021.
//

import UIKit

class AppFullscreenController: UIViewController {
    
    // MARK: - Properties
    
    let tableView = UITableView(frame: .zero, style: .plain)
    let floatingContainerView = UIView()
    var floatingContainerViewIsHidden = true

    let statusBarHeight = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.keyWindow?.safeAreaInsets.bottom ?? 0
    let height: CGFloat = 90
    var transform: CGAffineTransform = .init()
    
    var todayItem: TodayItem?
    
    var dismissHandler: (() -> ())?
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.closeButton, for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.showsVerticalScrollIndicator = false
        view.clipsToBounds = true
        
        // Do any additional setup after loading the view.
        setupTableView()
        setupCloseButton()
        setupFloatingControls()
    }
    
    // MARK: - Helper Functions
    
    private func setupTableView() {
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        tableView.contentInset = .init(top: 0, left: 0, bottom: statusBarHeight + height, right: 0)
        
    }
    
    private func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 12, width: 80, height: 40)
    }
    
    private func setupFloatingControls() {
        
        floatingContainerView.layer.cornerRadius = 16
        floatingContainerView.layer.masksToBounds = true
        view.addSubview(floatingContainerView)
        floatingContainerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 16, paddingBottom: -height, paddingRight: 16, height: height)
        
        let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        floatingContainerView.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        //add our subviews
        
        let iv = UIImageView()
        iv.image = todayItem?.image
        iv.setDemensions(height: 68, width: 68)
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        
        let getButton = UIButton(type: .system)
        getButton.backgroundColor = .darkGray
        getButton.layer.cornerRadius = 16
        getButton.setTitle("MORE", for: .normal)
        getButton.setTitleColor( .white, for: .normal)
        getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        getButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        getButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        getButton.addTarget(self, action: #selector(handleGet), for: .touchUpInside)
        
        let name = UILabel()
        name.text = todayItem?.category
        name.font = .boldSystemFont(ofSize: 18)
        
        let title = UILabel()
        title.text = todayItem?.title
        title.font = .systemFont(ofSize: 16)
        
        let stack = UIStackView(arrangedSubviews: [iv, VerticalStackView(arrangedSubviews: [name, title], spacing: 4), getButton])
        stack.alignment = .center
        stack.spacing = 16
        
        floatingContainerView.addSubview(stack)
        stack.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    private func animateFloatingView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.floatingContainerView.transform = self.transform
        }, completion: nil)
    }
    
    // MARK: - Selectors
    
    @objc private func handleDismiss(button: UIButton) {
        transform = .identity
        animateFloatingView()
        button.isHidden = true
        print("DEBUG: Pressed close button ")
        dismissHandler?()
    }
    
    @objc private func handleTap() {
        transform = floatingContainerViewIsHidden ? .init(translationX: 0, y: -height - statusBarHeight) : .identity
        floatingContainerViewIsHidden.toggle()
        animateFloatingView()
    }
    
    @objc private func handleGet() {
        
        guard let app = todayItem?.app else { return }
        
        let detailController = AppDetailController(appId: String(app.trackId))

        let nav = UINavigationController(rootViewController: detailController)
        detailController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        detailController.navigationItem.title = app.trackName
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc private func handleBack() {
        dismiss(animated: true)
    }
}
// MARK: - UITableViewDataSource

extension AppFullscreenController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let headerCell = AppFullscreenHeaderCell()
            headerCell.todayCell.todayItem = todayItem
            headerCell.todayCell.backgroundView?.layer.cornerRadius = 0
            return headerCell
        } else {
            let descriptionCell = AppFullscreenDescriptionCell()
            descriptionCell.descriptionLabel.text = todayItem?.notes
            return descriptionCell
        }
    }
}

// MARK: - UITableViewDelegate

extension AppFullscreenController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 500
        } else {
            return UITableView.automaticDimension
        }
    }
}

// MARK: - UIScrollViewDelegate

extension AppFullscreenController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if tableView.contentOffset.y < 0 {
            tableView.isScrollEnabled = false
            tableView.isScrollEnabled = true
        }
        
        if tableView.contentOffset.y > 100 {
            transform = .init(translationX: 0, y: -height - statusBarHeight)
            floatingContainerViewIsHidden = false
        } else {
            transform = .identity
            floatingContainerViewIsHidden = true
        }
        
        animateFloatingView()
        
    }
}
