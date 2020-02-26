//
//  Component.swift
//  mobileCashierApp
//
//  Created by Shafigh Khalili on 2020-02-25.
//  Copyright © 2020 Shafigh Khalili. All rights reserved.
//

import UIKit

class Component: UIView {
    
    let labelText = UILabel(frame: .zero)
    let labelTotalPrice = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(labelText)
        
        labelText.translatesAutoresizingMaskIntoConstraints = false
        labelText.numberOfLines = 0
        NSLayoutConstraint.activate([
            labelText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            labelText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -140.0),
            labelText.topAnchor.constraint(equalTo: topAnchor),
            labelText.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        addSubview(labelTotalPrice)
        
        labelTotalPrice.translatesAutoresizingMaskIntoConstraints = false
        labelTotalPrice.numberOfLines = 0
        NSLayoutConstraint.activate([
            labelTotalPrice.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 300.0),
            labelTotalPrice.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            labelTotalPrice.topAnchor.constraint(equalTo: topAnchor),
            labelTotalPrice.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func setupLabel(label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    func configure(text: String, price:String) {
        self.labelText.text = text
        self.labelTotalPrice.text = price
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
