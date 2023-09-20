//
//  ScanningHistory.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 19.09.2023.
//

import UIKit

class ScanningHistory: UIViewController {
    override func viewDidLoad() {
        let tableView = TableViewResults()
        view.addSubview(tableView)
        tableView.pinEdgesToSuperviewEdges()
    }
}
