//
//  GuideTypeCell.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 20.09.2023.
//

import UIKit

struct GuideTypeCellModel: DiffableCollectionItem {
    var reuseIdentifier: StringIdentifier {
        GuideTypeCell.identifier
    }
    var indexPath: IndexPath?
    
    let id: String = UUID().uuidString
    let imageName: String
    let title: String
    let subtitle: String
    
    func configure(cell: UICollectionViewCell, indexPath: IndexPath) {
        var l = self
        l.indexPath = indexPath
        cell.setup(GuideTypeCell.self, model: l)
    }
}

class GuideTypeCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let result = UIImageView()
        result.contentMode = .scaleAspectFit
        result.match(.width, to: .height, of: result)
        return result
    }()
    
    private lazy var titleLabel: UILabel = {
        let result = UILabel()
        result.sizeToFit()
        result.font = .systemFont(ofSize: 17)
        result.textColor = .black
        return result
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let result = UILabel()
        result.sizeToFit()
        result.font = .systemFont(ofSize: 15)
        result.textColor = Asset.Colors.gray3C.color.withAlphaComponent(0.6)
        return result
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure() {
        let stackViewLabel = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackViewLabel.axis = .vertical
        stackViewLabel.alignment = .center
        stackViewLabel.distribution = .fillProportionally
        stackViewLabel.spacing = -12
        
        let stackView = UIStackView(arrangedSubviews: [imageView, stackViewLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        addSubview(stackView)
        stackView.centerInSuperview()
        stackView.match(.height, to: .height, of: self, withMultiplier: 0.8)
        
        backgroundColor = .white
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GuideTypeCell: SetupableCell {
    typealias Model = GuideTypeCellModel
    func setup(model: Model) {
        imageView.image = UIImage(named: model.imageName)
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
    }
}

enum CollectionViewSectionModel: DiffableTableSection {
  
    case main(Int)
    
    var sectionIndex: Int {
        switch self {
        case .main(let index):
            return index
        }
    }
    
    func createHeader() -> UIView? {
        nil
    }
    
    static func == (lhs: CollectionViewSectionModel, rhs: CollectionViewSectionModel) -> Bool {
        lhs.sectionIndex == rhs.sectionIndex
    }
}
