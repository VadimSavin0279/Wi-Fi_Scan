//
//  GuideDetailViewController.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 20.09.2023.
//

import UIKit

class GuideDetailViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let result = UITableView(frame: .zero, style: .plain)
        result.register(GuideDetailCell.self, forCellReuseIdentifier: GuideDetailCell.identifier)
        result.backgroundColor = Asset.Colors.whiteF2.color
        result.rowHeight = UITableView.automaticDimension
        result.delegate = self
        result.separatorStyle = .none
        return result
    }()
    
    private lazy var dataSource = DiffableTableDataSource<CollectionViewSectionModel, GuideDetailCellModel>(tableView: tableView)
    
    private let model: [GuideDetailCellModel]
    
    init(model: [GuideDetailCellModel], title: String) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.pinEdges(toSuperviewEdges: [.right, .left])
        tableView.pin(toTopLayoutGuideOf: self)
        tableView.pin(toBottomLayoutGuideOf: self)
        
        dataSource.reloadData(section: .main(0), with: model, animated: true)
    }
}

extension GuideDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
