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
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Ovveride Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: - Instance Methods
    func configureViews() {
        viewModel = AboutAppViewModel()
        
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView.register(AboutAppCollectionCell.self, forCellWithReuseIdentifier: AboutAppCollectionCell.identifier)
    }
}

// MARK: -  Collection View Data Source and Delegate Methods
extension AboutAppScene: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 50), height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.detailsList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AboutAppCollectionCell.identifier, for: indexPath) as? AboutAppCollectionCell else {
            return UICollectionViewCell()
        }
        
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        let info = viewModel.detailsList[indexPath.row].info
        cell.aboutImage.image = info.image
        cell.titleLabel.text = info.text
        
        return cell
    }
}
