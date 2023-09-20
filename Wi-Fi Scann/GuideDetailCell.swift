//
//  GuideDetailCell.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 20.09.2023.
//

import Foundation
import UIKit

struct GuideDetailCellModel: DiffableTableItem {
    func configure(cell: UITableViewCell, indexPath: IndexPath) {
        var l = self
        l.indexPath = indexPath
        cell.setup(GuideDetailCell.self, model: l)
    }
    
    var reuseIdentifier: StringIdentifier {
        GuideDetailCell.identifier
    }
    var indexPath: IndexPath?
    
    let id: String = UUID().uuidString
    let title: String
    let subtitle: String
}

class GuideDetailCell: UITableViewCell {
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
        result.numberOfLines = 0
        result.textAlignment = .center
        return result
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    private func configure() {
        let view = UIView()
        view.backgroundColor = .white
        addSubview(view)
        view.pinEdgesToSuperviewEdges(with: .init(top: 8, left: 16, bottom: 8, right: 16))
        
        let stackViewLabel = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackViewLabel.axis = .vertical
        stackViewLabel.alignment = .center
        stackViewLabel.distribution = .fill
        stackViewLabel.spacing = 6
        
        view.addSubview(stackViewLabel)
        stackViewLabel.pinEdgesToSuperviewEdges(with: .init(top: 16, left: 30, bottom: 16, right: 30))
        
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GuideDetailCell: SetupableCell {
    typealias Model = GuideDetailCellModel
    func setup(model: Model) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
    }
}
