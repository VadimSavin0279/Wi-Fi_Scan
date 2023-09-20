//
//  GuideViewController.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 20.09.2023.
//

import UIKit

class GuideViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let result = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout())
        result.register(GuideTypeCell.self, forCellWithReuseIdentifier: GuideTypeCell.identifier)
        result.backgroundColor = Asset.Colors.whiteF2.color
        return result
    }()
    
    private lazy var dataSource = DiffableCollectionDataSource<CollectionViewSectionModel, GuideTypeCellModel>(collectionView: collectionView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.pinEdgesToSuperviewEdges()
        dataSource.reloadData([.init(section: .main(0), items: [.init(imageName: Asset.Assets.scannerIcon.name, title: "jsjnjk", subtitle: "skms"), .init(imageName: Asset.Assets.scannerIcon.name, title: "jnnjfd", subtitle: "jnkjnfedr")])], animated: true)
    }
    
    private func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(105))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)
        return layout
    }
}
