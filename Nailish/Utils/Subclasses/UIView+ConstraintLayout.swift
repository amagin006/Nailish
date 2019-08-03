//
//  UIView+ConstraintLayout.swift
//  AppStore
//
//  Created by Derrick Park on 2019-04-29.
//  Copyright © 2019 Derrick Park. All rights reserved.
//

import UIKit

struct AnchoredConstraints {
  var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

extension UIView {
  
  func matchParent(padding: UIEdgeInsets = .zero) {
    translatesAutoresizingMaskIntoConstraints = false
    if let superTopAnchor = superview?.topAnchor {
      self.topAnchor.constraint(equalTo: superTopAnchor, constant: padding.top).isActive = true
    }
    if let superBottomAnchor = superview?.bottomAnchor {
      self.bottomAnchor.constraint(equalTo: superBottomAnchor, constant: -padding.bottom).isActive = true
    }
    if let superLeadingAnchor = superview?.leadingAnchor {
      self.leadingAnchor.constraint(equalTo: superLeadingAnchor, constant: padding.left).isActive = true
    }
    if let superTrailingAnchor = superview?.trailingAnchor {
      self.trailingAnchor.constraint(equalTo: superTrailingAnchor, constant: -padding.right).isActive = true
    }
  }
  
  @discardableResult
  func anchors(topAnchor: NSLayoutYAxisAnchor?, leadingAnchor: NSLayoutXAxisAnchor?, trailingAnchor: NSLayoutXAxisAnchor?, bottomAnchor: NSLayoutYAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
    
    translatesAutoresizingMaskIntoConstraints = false
    
    var anchoredConstraints = AnchoredConstraints()
    if let topAnchor = topAnchor {
      anchoredConstraints.top = self.topAnchor.constraint(equalTo: topAnchor, constant: padding.top)
    }
    if let bottomAnchor = bottomAnchor {
      anchoredConstraints.bottom = self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom)
    }
    if let leadingAnchor = leadingAnchor {
      anchoredConstraints.leading = self.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left)
    }
    if let trailingAnchor = trailingAnchor {
      anchoredConstraints.trailing = self.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.right)
    }
    if size.width != 0 {
      anchoredConstraints.width = self.widthAnchor.constraint(equalToConstant: size.width)
    }
    if size.height != 0 {
      anchoredConstraints.height = self.heightAnchor.constraint(equalToConstant: size.height)
    }
    
    [anchoredConstraints.top, anchoredConstraints.bottom, anchoredConstraints.leading, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach { $0?.isActive = true }
    
    return anchoredConstraints
  }
  
  func constraintWidth(equalToConstant: CGFloat) {
    translatesAutoresizingMaskIntoConstraints = false
    self.widthAnchor.constraint(equalToConstant: equalToConstant).isActive = true
  }
  
  func constraintHeight(equalToConstant: CGFloat) {
    translatesAutoresizingMaskIntoConstraints = false
    self.heightAnchor.constraint(equalToConstant: equalToConstant).isActive = true
  }
    
func addBorders(edges: UIRectEdge = .all, color: UIColor = .black, width: CGFloat = 1.0) {
        func createBorder() -> UIView {
            let borderView = UIView(frame: CGRect.zero)
            borderView.translatesAutoresizingMaskIntoConstraints = false
            borderView.backgroundColor = color
            return borderView
        }
    
        if (edges.contains(.all) || edges.contains(.top)) {
            let topBorder = createBorder()
            self.addSubview(topBorder)
            NSLayoutConstraint.activate([
                topBorder.topAnchor.constraint(equalTo: self.topAnchor),
                topBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                topBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                topBorder.heightAnchor.constraint(equalToConstant: width)
                ])
        }
        if (edges.contains(.all) || edges.contains(.left)) {
            let leftBorder = createBorder()
            self.addSubview(leftBorder)
            NSLayoutConstraint.activate([
                leftBorder.topAnchor.constraint(equalTo: self.topAnchor),
                leftBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                leftBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                leftBorder.widthAnchor.constraint(equalToConstant: width)
                ])
        }
        if (edges.contains(.all) || edges.contains(.right)) {
            let rightBorder = createBorder()
            self.addSubview(rightBorder)
            NSLayoutConstraint.activate([
                rightBorder.topAnchor.constraint(equalTo: self.topAnchor),
                rightBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                rightBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                rightBorder.widthAnchor.constraint(equalToConstant: width)
                ])
        }
        if (edges.contains(.all) || edges.contains(.bottom)) {
            let bottomBorder = createBorder()
            self.addSubview(bottomBorder)
            NSLayoutConstraint.activate([
                bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                bottomBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                bottomBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                bottomBorder.heightAnchor.constraint(equalToConstant: width)
                ])
        }
    }
}
