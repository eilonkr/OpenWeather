//
//  UIView+AutoLayout.swift
//  AppIconMaker
//
//  Created by Eilon Krauthammer on 10/11/2020.
//

import UIKit

extension UIView {
    func fix(in container: UIView, padding: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: container.topAnchor, constant: padding.top),
            bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -padding.bottom),
            leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding.left),
            trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -padding.right)
        ])
    }
    
    func hfix(in container: UIView, padding: CGFloat = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        leftAnchor.constraint(equalTo: container.leftAnchor, constant: padding).isActive = true
        rightAnchor.constraint(equalTo: container.rightAnchor, constant: -padding).isActive = true
    }
    
    func vfix(in container: UIView, padding: CGFloat = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        topAnchor.constraint(equalTo: container.topAnchor, constant: padding).isActive = true
        bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -padding).isActive = true
    }
    
    func constraintAspectRatio(_ ar: CGFloat, width: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let w = width {
            self.widthAnchor.constraint(equalToConstant: w).isActive = true
        }
        
        self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: ar).isActive = true
    }
    
    func equalLeadingTrailing(to view: UIView, margin: CGFloat = 0.0) {
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: margin).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: -margin).isActive = true
    }
    
    func center(in view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    @discardableResult
    func findConstraint(layoutAttribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        if let constraints = superview?.constraints {
            for constraint in constraints where itemMatch(constraint: constraint, layoutAttribute: layoutAttribute) {
                return constraint
            }
        }
        return nil
    }
    
    func itemMatch(constraint: NSLayoutConstraint, layoutAttribute: NSLayoutConstraint.Attribute) -> Bool {
        let firstItemMatch = constraint.firstItem as? UIView == self && constraint.firstAttribute == layoutAttribute
        let secondItemMatch = constraint.secondItem as? UIView == self && constraint.secondAttribute == layoutAttribute
        return firstItemMatch || secondItemMatch
    }
}

extension UIEdgeInsets {
    static func even(_ value: CGFloat) -> UIEdgeInsets {
        .init(top: value, left: value, bottom: value, right: value)
    }
}
