//
//  CustomHeader.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 20.09.2023.
//

import UIKit
protocol SectionModel {
    func configure(section: UIView)
}
struct CustomHeaderModel: SectionModel {
    var sectionIndex: Int
    
    func configure(section: UIView) {
        var l = self
        section.setupHeader(CustomHeader.self, model: l)
    }
    
    let leftText: String
    let rightText: String
    
    init(sectionIndex: Int, leftText: String = "", rightText: String = "") {
        self.sectionIndex = sectionIndex
        self.leftText = leftText
        self.rightText = rightText
    }
}
extension CustomHeaderModel: DiffableTableSection {
    
}
class CustomHeader: UITableViewHeaderFooterView {
    
    private(set) lazy var leftLabel: UILabel = {
        let result = UILabel()
        result.font = .systemFont(ofSize: 13)
        result.textColor = Asset.Colors.gray3C.color.withAlphaComponent(0.6)
        result.sizeToFit()
        return result
    }()
    
    private(set) lazy var rightLabel: UILabel = {
        let result = UILabel()
        result.font = .systemFont(ofSize: 13)
        result.textColor = Asset.Colors.gray3C.color.withAlphaComponent(0.6)
        result.sizeToFit()
        return result
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(leftLabel)
        addSubview(rightLabel)
        
        leftLabel.alignView(y: .center(offset: 0))
        rightLabel.alignView(y: .center(offset: 0))
        rightLabel.pinEdge(toSuperviewEdge: .right, withInset: 32)
        leftLabel.pinEdge(toSuperviewEdge: .left, withInset: 32)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomHeader: SetupableCell {
    typealias Model = CustomHeaderModel
    
    func setup(model: Model) {
        leftLabel.text = model.leftText
        rightLabel.text = model.rightText
    }
}
