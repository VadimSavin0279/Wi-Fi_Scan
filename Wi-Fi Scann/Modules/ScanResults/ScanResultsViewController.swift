//
//  ScanResultsViewController.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 28.09.2023.
//

import UIKit

typealias DataSource = DiffableTableDataSource<CustomHeaderModel, ContentCellModel>
typealias Delegate = DiffableTableViewDelegateProxy

protocol ScanResultsViewControllerProtocol: AnyObject {
    var dataSource: DataSource { get }
}

class ScanResultsViewController: UIViewController {
    private let presenter: ScanResultsPresenterProtocol
    
    private lazy var tableView = TableViewResults(delegate: presenter.getDelegate())
    
    private(set) lazy var dataSource = DataSource(tableView: tableView.tableView)
    
    init(presenter: ScanResultsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.configureModel()
        
        view.addSubview(tableView)
        tableView.pinEdges(toSuperviewEdges: [.left, .right])
        tableView.pin(toTopLayoutGuideOf: self)
        tableView.pin(toBottomLayoutGuideOf: self)
        
        (navigationController as? NavigationController)?.addCustomBottomLine(color: .black.withAlphaComponent(0.3), height: 0.3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (navigationController as? NavigationController)?.hideCustomBottomLine(false)
    }
}

extension ScanResultsViewController: ScanResultsViewControllerProtocol {
    
}
