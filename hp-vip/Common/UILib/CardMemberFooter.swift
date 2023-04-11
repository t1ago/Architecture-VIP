//
//  CardMemberFooter.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 20/03/23.
//

import UIKit

class CardMemberFooter: UIView {
    lazy var total: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var totalAlive: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.backgroundColor = .white
        self.addSubview(total)
        self.addSubview(totalAlive)
        adjustConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateData(total: Int, totalAlive: Int) {
        self.total.text = "Total: \(total)"
        self.totalAlive.text = "Total vivos: \(totalAlive)"
    }
    
    private func adjustConstraint() {
        NSLayoutConstraint.activate([
            total.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            total.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            total.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 25),
            
            totalAlive.topAnchor.constraint(equalTo: total.bottomAnchor, constant: 10),
            totalAlive.leadingAnchor.constraint(equalTo: total.leadingAnchor),
            totalAlive.trailingAnchor.constraint(equalTo: total.trailingAnchor),
            totalAlive.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }
}
