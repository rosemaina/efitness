//
//  AboutAppScene.swift
//  eFitness
//
//  Created by Rose Maina on 21/11/2021.
//

import UIKit

class AboutAppScene: UIViewController {
    
    // MARK: - Public Properties
    var viewModel: AboutAppViewModel?
    private let spacing: CGFloat = 10.0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTable: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: - Ovveride Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: - Instance Methods
    @IBAction func backBtnTapped() {
        presentAccountScene()
    }
    
    func configureViews() {
        viewModel = AboutAppViewModel()
        setupTable()
    }
    
    func presentAccountScene() {
        let tabVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainTabBarController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootVC(tabVC)
    }
    
    func setupTable() {
        contentTable.delegate = self
        contentTable.dataSource = self
        contentTable.separatorStyle = .none
        contentTable.tableFooterView = UIView()
        contentTable.showsVerticalScrollIndicator = false
        contentTable.backgroundColor = Colors.backgroundGreen
        contentTable.register(AboutAppCollectionCell.self, forCellReuseIdentifier: AboutAppCollectionCell.identifier)
    }
}

// MARK: - TableView Methods
extension AboutAppScene: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.detailsList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: AboutAppCollectionCell.identifier, for: indexPath) as? AboutAppCollectionCell,
            let viewModel = viewModel
        else { return UITableViewCell() }
        
                let info = viewModel.detailsList[indexPath.section].info
                cell.aboutImage.image = info.image
                cell.titleLabel.text = info.text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
