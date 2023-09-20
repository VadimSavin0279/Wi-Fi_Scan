//
//  TableViewResults.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 19.09.2023.
//

import UIKit

typealias DataSource = DiffableTableDataSource<CustomHeaderModel, ContentCellModel>
typealias Delegate = DiffableTableViewDelegateProxy

class TableViewResults: UIView {
    private lazy var tableView: UITableView = {
        let result = UITableView(frame: .zero, style: .insetGrouped)
        result.register(ContentCell.self, forCellReuseIdentifier: "UITableViewCell")
        result.register(CustomHeader.self, forHeaderFooterViewReuseIdentifier: "\(CustomHeader.self)")
        result.delegate = delegate
        return result
    }()
    private lazy var dataSource = DataSource(tableView: tableView)
    
    private var delegate: DiffableTableViewDelegateProxy
    
    override init(frame: CGRect) {
        let section1 = CustomHeaderModel(sectionIndex: 0, leftText: "nj", rightText: "jnn")
        let section2 = CustomHeaderModel(sectionIndex: 1, leftText: "nakj", rightText: "jnnsn")
        let section3 = CustomHeaderModel(sectionIndex: 2, leftText: "nakj", rightText: "jnnsn")
        let result = Delegate(models: [section1, section2, section3])
        result.identifierForHeaderInSection = { _ in "\(CustomHeader.self)" }
        result.heightForHeaderInSection = { _ in 32 }
        self.delegate = result
        super.init(frame: .zero)
        addSubview(tableView)
        tableView.pinEdgesToSuperviewEdges()
        let cells: [ContentCellModel] = [
            .init(title: "vfd", subtitle: "dav", image: Asset.Assets.historyIcon.image),
            .init(title: "fdsv", subtitle: "fea", image: nil),
            .init(title: "feafedsaa", subtitle: "va", image: nil)
        ]
        let model = DiffableTableSectionModel(section: section1, items: cells)
        
        let cells1: [ContentCellModel] = [
            .init(title: "vfd", subtitle: "dav", image: Asset.Assets.historyIcon.image),
            .init(title: "fdsv", subtitle: "fea", image: nil),
            .init(title: "feafedsaa", subtitle: "va", image: nil)
        ]
        let model1 = DiffableTableSectionModel(section: section2, items: cells1)
        
        let cells2: [ContentCellModel] = [
            .init(title: "vfd", subtitle: "dav", image: Asset.Assets.historyIcon.image),
            .init(title: "fdsv", subtitle: "fea", image: nil),
            .init(title: "feafedsaa", subtitle: "va", image: nil)
        ]
        let model2 = DiffableTableSectionModel(section: section3, items: cells2)
        dataSource.reloadData([model, model1, model2], animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TableViewResults: UITableViewDelegate {
    
}

struct ContentCellModel: DiffableTableItem {
    var reuseIdentifier: StringIdentifier {
        UITableViewCell.identifier
    }
    
    let id: String = UUID().uuidString
    let title: String
    let subtitle: String
    let image: UIImage?
    
    var indexPath: IndexPath?
    
    func configure(cell: UITableViewCell, indexPath: IndexPath) {
        var l = self
        l.indexPath = indexPath
        cell.setup(ContentCell.self, model: l)
    }
    
    static func == (lhs: ContentCellModel, rhs: ContentCellModel) -> Bool {
        return lhs.id == rhs.id
    }
}

enum ContentSectionModel: DiffableTableSection {
  
    case main(Int)
    
    var sectionIndex: Int {
        switch self {
        case .main(let index):
            return index
        }
    }
    
    func createHeader() -> UIView? {
        return nil
    }
    
    static func == (lhs: ContentSectionModel, rhs: ContentSectionModel) -> Bool {
        lhs.sectionIndex == rhs.sectionIndex
    }
}

class ContentCell: UITableViewCell {}

extension ContentCell: SetupableCell {
    typealias Model = ContentCellModel
    
    func setup(model: Model) {
        var config = defaultContentConfiguration()
        config.text = model.title
        config.secondaryText = model.subtitle
        config.image = model.image
        accessoryType = .disclosureIndicator
        contentConfiguration = config
    }
}
