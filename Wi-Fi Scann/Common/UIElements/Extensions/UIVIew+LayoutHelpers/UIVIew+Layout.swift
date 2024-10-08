//
//  UIVIew+Layout.swift
//  FaxApp
//
//  Created by Eugene on 07.04.2022.
//

import UIKit

extension UIView {
    // MARK: - View alignment
    
    func alignView(x: LXAlignment) {
        switch x {
        case let .left(offset):
            pinEdge(toSuperviewEdge: .left, withInset: offset)
        case let .center(offset):
            alignAxis(toSuperviewAxis: .x, withOffset: offset)
        case let .right(offset):
            pinEdge(toSuperviewEdge: .right, withInset: offset)
        }
    }
    
    func alignView(y: LYAlignment) {
        switch y {
        case let .top(offset):
            pinEdge(toSuperviewEdge: .top, withInset: offset)
        case let .center(offset):
            alignAxis(toSuperviewAxis: .y, withOffset: offset)
        case let .bottom(offset):
            pinEdge(toSuperviewEdge: .bottom, withInset: offset)
        }
    }
    
    // MARK: - Center & Align in Superview
    
    @discardableResult
    func alignAxis(toSuperviewAxis axis: LAxis, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        
        guard let superview = self.superview else {
            fatalError(noSuperviewMessage)
        }
        
        return alignAxis(axis, toSameAxisOf: superview, withOffset: offset)
    }
    
    @discardableResult
    func centerInSuperview() -> [NSLayoutConstraint] {
        
        guard let superview = self.superview else {
            fatalError(noSuperviewMessage)
        }
        
        let xConstraint = alignAxis(.x, toSameAxisOf: superview, withOffset: 0)
        let yConstraint = alignAxis(.y, toSameAxisOf: superview, withOffset: 0)
        
        let constraints = [xConstraint, yConstraint]
        
        return constraints
    }
    
    
    // MARK: - Pin Edges to Superview
    
    @discardableResult
    func pinEdgesToSuperviewEdges(with insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let edges = allEdges
        return constraintsToSuperview(for: edges, insets: insets)
    }
    
    @discardableResult
    func pinEdgesToSuperviewEdges(with insets: UIEdgeInsets = .zero, excludingEdge edge: LEdge) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let edges = allEdges(except: edge)
        return constraintsToSuperview(for: edges, insets: insets)
    }
    
    @discardableResult
    func pinEdge(toSuperviewEdge edge: LEdge, withInset inset: CGFloat = 0) -> NSLayoutConstraint {
        return pinEdge(toSuperviewEdge: edge, withInset: inset, relation: .equal)
    }
    
    @discardableResult
    func pinEdges(toSuperviewEdges edges: [LEdge], withInset inset: CGFloat = 0) -> [NSLayoutConstraint] {
        return edges.map {
            return pinEdge(toSuperviewEdge: $0, withInset: inset, relation: .equal)
        }
    }
    
    @discardableResult
    func pinEdges(toSuperviewEdges edges: [LEdge], withInset insets: [CGFloat]) -> [NSLayoutConstraint] {
        return edges.enumerated().map { idx, edge in
            return pinEdge(toSuperviewEdge: edge, withInset: insets[idx], relation: .equal)
        }
    }
    
    @discardableResult
    func pinEdge(toSuperviewEdge edge: LEdge, withInset inset: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        
        guard let superview = self.superview else {
            fatalError(noSuperviewMessage)
        }
        
        let offset: CGFloat
        let editedRelation: NSLayoutConstraint.Relation
        
        switch edge {
        case .bottom, .right:
            offset = -inset
            editedRelation = reverseRelation(for: relation)
        default:
            offset = inset
            editedRelation = relation
        }
        
        return pinEdge(edge, to: edge, of: superview, withOffset: offset, relation: editedRelation)
    }
    
    
    // MARK: - Pin edges
    
    @discardableResult
    func pinEdge(_ edge: LEdge, to toEdge: LEdge, of otherView: UIView, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        return pinEdge(edge, to: toEdge, of: otherView, withOffset: offset, relation: .equal)
    }
    
    @discardableResult
    func pinEdge(_ edge: LEdge, to toEdge: LEdge, of otherView: UIView, withOffset offset: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        
        let axis = edge.axis
        let toAxis = toEdge.axis
        
        guard axis == toAxis else {
            fatalError(incorrectEdgesMessage)
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint
        
        switch axis {
        case .x:
            let xAnchor = getXAnchor(of: self, for: edge)
            let xToAnchor = getXAnchor(of: otherView, for: toEdge)
            constraint = xAxisConstraint(anchor: xAnchor, toAnchor: xToAnchor, offset: offset, relation: relation)
        case .y:
            let yAnchor = getYAnchor(of: self, for: edge)
            let yToAnchor = getYAnchor(of: otherView, for: toEdge)
            constraint = yAxisConstraint(anchor: yAnchor, toAnchor: yToAnchor, offset: offset, relation: relation)
        case .baseline:
            constraint = baselineConstraint(to: otherView, offset: offset, relation: relation)
        }
        
        constraint.isActive = true
        return constraint
    }
    
    
    // MARK: - Align Axes
    
    @discardableResult
    func alignAxis(_ axis: LAxis, toSameAxisOf otherView: UIView, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint
        
        switch axis {
            
        case .x:
            constraint = centerXAnchor.constraint(equalTo: otherView.centerXAnchor, constant: offset)
        case .y:
            constraint = centerYAnchor.constraint(equalTo: otherView.centerYAnchor, constant: offset)
        case .baseline:
            constraint = lastBaselineAnchor.constraint(equalTo: otherView.lastBaselineAnchor, constant: offset)
        }
        
        constraint.isActive = true
        return constraint
    }
    
    
    // MARK: - Set Dimensions
    
    @discardableResult
    func setDimension(_ dimension: LDimension, toSize size: CGFloat, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint
        let anchor = getDimensionAnchor(of: self, for: dimension)
        
        switch relation {
            
        case .equal:
            constraint = anchor.constraint(equalToConstant: size)
        case .greaterThanOrEqual:
            constraint = anchor.constraint(greaterThanOrEqualToConstant: size)
        case .lessThanOrEqual:
            constraint = anchor.constraint(lessThanOrEqualToConstant: size)
        @unknown default:
            fatalError()
        }
        
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func setDimensions(to size: CGSize) -> [NSLayoutConstraint] {
        
        let widthConstraint = setDimension(.width, toSize: size.width)
        let heightConstraint = setDimension(.height, toSize: size.height)
        
        return [widthConstraint, heightConstraint]
    }
    
    
    // MARK: - Match Dimensions
    
    @discardableResult
    func match(_ dimension: LDimension, to toDimension: LDimension, of otherView: UIView, withOffset offset: CGFloat = 0) -> NSLayoutConstraint {
        return match(dimension, to: toDimension, of: otherView, withOffset: offset, relation: .equal)
    }
    
    @discardableResult
    func match(_ dimension: LDimension, to toDimension: LDimension, of otherView: UIView, withOffset offset: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint
        
        let anchor = getDimensionAnchor(of: self, for: dimension)
        let toAnchor = getDimensionAnchor(of: otherView, for: toDimension)
        
        switch relation {
            
        case .equal:
            constraint = anchor.constraint(equalTo: toAnchor, constant: offset)
        case .greaterThanOrEqual:
            constraint = anchor.constraint(greaterThanOrEqualTo: toAnchor, constant: offset)
        case .lessThanOrEqual:
            constraint = anchor.constraint(lessThanOrEqualTo: toAnchor, constant: offset)
        @unknown default:
            fatalError()
        }
        
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func match(_ dimension: LDimension, to toDimension: LDimension, of otherView: UIView, withMultiplier multiplier: CGFloat) -> NSLayoutConstraint {
        return match(dimension, to: toDimension, of: otherView, withMultiplier: multiplier, relation: .equal)
    }
    
    @discardableResult
    func match(_ dimension: LDimension, to toDimension: LDimension, of otherView: UIView, withMultiplier multiplier: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint
        
        let anchor = getDimensionAnchor(of: self, for: dimension)
        let toAnchor = getDimensionAnchor(of: otherView, for: toDimension)
        
        switch relation {
            
        case .equal:
            constraint = anchor.constraint(equalTo: toAnchor, multiplier: multiplier)
        case .greaterThanOrEqual:
            constraint = anchor.constraint(greaterThanOrEqualTo: toAnchor, multiplier: multiplier)
        case .lessThanOrEqual:
            constraint = anchor.constraint(lessThanOrEqualTo: toAnchor, multiplier: multiplier)
        @unknown default:
            fatalError()
        }
        
        constraint.isActive = true
        return constraint
    }
    
    
    // MARK: - Pin to Layout Guides
    
    @discardableResult
    func pin(toTopLayoutGuideOf viewController: UIViewController, withInset inset: CGFloat = 0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11.0, tvOS 11.0, *) {
            
            guard let otherAnchor = viewController.view?.safeAreaLayoutGuide.topAnchor else {
                fatalError(noViewMessage)
            }
            
            return pin(anchor: topAnchor, toSafeAreaAnchor: otherAnchor, withInset: inset, relation: relation)
            
        } else {
            
            let constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: relation, toItem: viewController.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: inset)
            constraint.isActive = true
            return constraint
        }
    }
    
    @discardableResult
    func pin(toBottomLayoutGuideOf viewController: UIViewController, withInset inset: CGFloat = 0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        // we use reversed relation because at bottom of views insets and offsets behavior in a different way
        let editedRelation = reverseRelation(for: relation)
        let editedInset = -inset
        
        if #available(iOS 11.0, tvOS 11.0, *) {
            
            guard let otherAnchor = viewController.view?.safeAreaLayoutGuide.bottomAnchor else {
                fatalError(noViewMessage)
            }
            
            return pin(anchor: bottomAnchor, toSafeAreaAnchor: otherAnchor, withInset: editedInset, relation: editedRelation)
            
        } else {
            
            let constraint = NSLayoutConstraint(item: self,
                                                attribute: .top,
                                                relatedBy: editedRelation,
                                                toItem: viewController.bottomLayoutGuide,
                                                attribute: .bottom,
                                                multiplier: 1.0,
                                                constant: editedInset)
            addConstraint(constraint)
            constraint.isActive = true
            return constraint
        }
        
    }
    
    private func pin(anchor: NSLayoutYAxisAnchor, toSafeAreaAnchor otherAnchor: NSLayoutYAxisAnchor, withInset inset: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        
        guard #available(iOS 11.0, tvOS 11.0, *) else {
            fatalError("pin(anchor:toSafeAreaAnchor:) method should be called only on iOS and tvOS 11.0 or higher")
        }
        
        let constraint: NSLayoutConstraint
        
        switch relation {
            
        case .equal:
            constraint = anchor.constraint(equalTo: otherAnchor, constant: inset)
        case .greaterThanOrEqual:
            constraint = anchor.constraint(greaterThanOrEqualTo: otherAnchor, constant: inset)
        case .lessThanOrEqual:
            constraint = anchor.constraint(lessThanOrEqualTo: otherAnchor, constant: inset)
        @unknown default:
            fatalError()
        }
        
        constraint.isActive = true
        return constraint
    }
    
    
    // MARK: - Private methods
    
    private var allEdges: [LEdge] {
        return [.left, .top, .right, .bottom]
    }
    
    private func allEdges(except edge: LEdge) -> [LEdge] {
        var resultEdges: [LEdge] = []
        
        for e in allEdges {
            guard e != edge else { continue }
            resultEdges.append(e)
        }
        
        return resultEdges
    }
    
    private func getInset(from insets: UIEdgeInsets, for edge: LEdge) -> CGFloat {
        switch edge {
        case .top:      return insets.top
        case .left:     return insets.left
        case .bottom:   return insets.bottom
        case .right:    return insets.right
        }
    }
    
    private func constraintsToSuperview(for edges: [LEdge], insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        for edge in edges {
            let inset = getInset(from: insets, for: edge)
            let newConstraint = pinEdge(toSuperviewEdge: edge, withInset: inset)
            constraints.append(newConstraint)
        }
        
        constraints.forEach { $0.isActive = true }
        return constraints
    }
    
    private func getDimensionAnchor(of view: UIView, for dimension: LDimension) -> NSLayoutDimension {
        switch dimension {
        case .width:
            return view.widthAnchor
        case .height:
            return view.heightAnchor
        }
    }
    
    private func getXAnchor(of view: UIView, for edge: LEdge) -> NSLayoutXAxisAnchor {
        switch edge {
        case .left:
            return view.leftAnchor
        case .right:
            return view.rightAnchor
        default:
            fatalError("Wrong edge provided for X-Anchor")
        }
    }
    
    private func getYAnchor(of view: UIView, for edge: LEdge) -> NSLayoutYAxisAnchor {
        switch edge {
        case .top:
            return view.topAnchor
        case .bottom:
            return view.bottomAnchor
        default:
            fatalError("Wrong edge provided for Y-Anchor")
        }
    }
    
    private func xAxisConstraint(anchor: NSLayoutXAxisAnchor, toAnchor: NSLayoutXAxisAnchor, offset: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        switch relation {
        case .equal:
            return anchor.constraint(equalTo: toAnchor, constant: offset)
        case .greaterThanOrEqual:
            return anchor.constraint(greaterThanOrEqualTo: toAnchor, constant: offset)
        case .lessThanOrEqual:
            return anchor.constraint(lessThanOrEqualTo: toAnchor, constant: offset)
        @unknown default:
            fatalError()
        }
    }
    
    private func yAxisConstraint(anchor: NSLayoutYAxisAnchor, toAnchor: NSLayoutYAxisAnchor, offset: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        switch relation {
        case .equal:
            return anchor.constraint(equalTo: toAnchor, constant: offset)
        case .greaterThanOrEqual:
            return anchor.constraint(greaterThanOrEqualTo: toAnchor, constant: offset)
        case .lessThanOrEqual:
            return anchor.constraint(lessThanOrEqualTo: toAnchor, constant: offset)
        @unknown default:
            fatalError()
        }
    }
    
    private func baselineConstraint(to otherView: UIView, offset: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        
        let anchor = lastBaselineAnchor
        let toAnchor = otherView.lastBaselineAnchor
        
        switch relation {
        case .equal:
            return anchor.constraint(equalTo: toAnchor, constant: offset)
        case .greaterThanOrEqual:
            return anchor.constraint(greaterThanOrEqualTo: toAnchor, constant: offset)
        case .lessThanOrEqual:
            return anchor.constraint(lessThanOrEqualTo: toAnchor, constant: offset)
        @unknown default:
            fatalError()
        }
    }
    
    private func matchingConstraint(view: UIView, edge: LEdge, offset: CGFloat = 0) -> NSLayoutConstraint {
        switch edge {
        case .left:
            return leftAnchor.constraint(equalTo: view.leftAnchor, constant: offset)
        case .top:
            return topAnchor.constraint(equalTo: view.topAnchor, constant: offset)
        case .right:
            return rightAnchor.constraint(equalTo: view.rightAnchor, constant: offset)
        case .bottom:
            return bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: offset)
        }
    }
    
    private func reverseRelation(for relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint.Relation {
        switch relation {
        case .equal:                return .equal
        case .greaterThanOrEqual:   return .lessThanOrEqual
        case .lessThanOrEqual:      return .greaterThanOrEqual
        @unknown default:           fatalError()
        }
    }
    
    private var noSuperviewMessage: String {
        return "Failed to add constraint: Superview doesn't exist"
    }
    
    private var incorrectEdgesMessage: String {
        return "Failed to add constraint: Provided edges refer to different axes"
    }
    
    private var noViewMessage: String {
        return "Failed to add constraint: provided viewController's view is not loaded"
    }
}

