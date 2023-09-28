//
//  GuideViewController.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 20.09.2023.
//

import UIKit

protocol GuideViewControllerProtocol: AnyObject {
    var dataSource: DiffableCollectionDataSource<CollectionViewSectionModel, GuideTypeCellModel> { get }
}

class GuideViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let result = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout())
        result.register(GuideTypeCell.self, forCellWithReuseIdentifier: GuideTypeCell.identifier)
        result.backgroundColor = Asset.Colors.whiteF2.color
        result.delegate = self
        return result
    }()
    
    internal lazy var dataSource = DiffableCollectionDataSource<CollectionViewSectionModel, GuideTypeCellModel>(collectionView: collectionView)
    private var presenter: GuidePresenterProtocol
    
    init(presenter: GuidePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (navigationController as? NavigationController)?.addCustomBottomLine(color: .black.withAlphaComponent(0.3), height: 0.3)
        
        title = L10n.Guide.title
        view.addSubview(collectionView)
        collectionView.pinEdges(toSuperviewEdges: [.right, .left])
        collectionView.pin(toTopLayoutGuideOf: self)
        collectionView.pin(toBottomLayoutGuideOf: self)
        
        presenter.fetchInfo()
    }
    
    private func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)

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

extension GuideViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.tapGuideCell(with: indexPath)
    }
}

extension GuideViewController: GuideViewControllerProtocol {}
