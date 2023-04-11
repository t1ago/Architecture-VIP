//
//  ViewUIScrollView.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 29/03/23.
//

import UIKit

class ViewUIScrollView: UIScrollView {
    
    lazy var layout: UIView = {
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(layout)
    }
    
    override func didMoveToSuperview() {
        NSLayoutConstraint.activate([
            layout.topAnchor.constraint(equalTo: self.topAnchor),
            layout.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            layout.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            layout.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            layout.widthAnchor.constraint(equalTo: self.widthAnchor),
        ])
    }
}
