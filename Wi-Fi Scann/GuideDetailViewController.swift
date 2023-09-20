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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.pinEdgesToSuperviewEdges()
        dataSource.reloadData([.init(section: .main(0), items: [.init(title: "jsjnjk", subtitle: "Check the sockets facing the bedside and bathroom, Pinhole cameras may be hidden in the jacks. These cameras generally require power supply, and this is the best position for shooting.")]), .init(section: .main(1), item: .init(title: "jnnjfd", subtitle: "jnkjnfedr"))], animated: true)
    }
}

extension GuideDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
