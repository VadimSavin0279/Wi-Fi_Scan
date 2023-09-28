//
//  TableViewResults.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 19.09.2023.
//

import UIKit

class TableViewResults: UIView {
    private(set) lazy var tableView: UITableView = {
        let result = UITableView(frame: .zero, style: .insetGrouped)
        result.register(ContentCell.self, forCellReuseIdentifier: "UITableViewCell")
        result.register(CustomHeader.self, forHeaderFooterViewReuseIdentifier: "\(CustomHeader.self)")
        result.delegate = delegate
        return result
    }()
    
    private(set) var delegate: DiffableTableViewDelegateProxy
    
    init(delegate: DiffableTableViewDelegateProxy) {
        self.delegate = delegate
        super.init(frame: .zero)
        addSubview(tableView)
        tableView.pinEdgesToSuperviewEdges()
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
