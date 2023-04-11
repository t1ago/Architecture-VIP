//
//  LoadingUIActivityIndicatior.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 15/03/23.
//

import UIKit

class LoadingUIActivityIndicatior: UIActivityIndicatorView {
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.translatesAutoresizingMaskIntoConstraints = false
        self.style = .large
        self.hidesWhenStopped = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
