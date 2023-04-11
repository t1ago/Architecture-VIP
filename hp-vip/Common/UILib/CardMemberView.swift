//
//  CardMemberView.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 15/03/23.
//

import Foundation
import UIKit

class CardMemberView: UITableViewCell {

    lazy var photo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var yearOfBirth: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var alive: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(photo)
        self.addSubview(name)
        self.addSubview(yearOfBirth)
        self.addSubview(alive)
        adjustConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateData(member: MemberViewModel) {
        photo.image = nil
        if let imageData = member.image {
            photo.image = UIImage(data: imageData)
        }
        
        name.attributedText = nil
        if member.alive {
            name.text = member.name
        } else {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: member.name)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            name.attributedText = attributeString
        }
        
        if let year = member.yearOfBirth {
            yearOfBirth.text = "Nascido em \(year)"
        } else {
            yearOfBirth.text = "Ano de nascimento desconhecido"
        }
        
        alive.text = member.alive ? "Vivo" : "Morto"
    }
    
    private func adjustConstraint() {
        NSLayoutConstraint.activate([
            photo.heightAnchor.constraint(equalToConstant: 80),
            photo.widthAnchor.constraint(equalTo: photo.heightAnchor),
            photo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14.0),
            photo.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
            photo.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10.0),
            
            name.topAnchor.constraint(equalTo: photo.topAnchor),
            name.leadingAnchor.constraint(equalTo: photo.trailingAnchor, constant: 10),
            name.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            yearOfBirth.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10),
            yearOfBirth.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            yearOfBirth.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            
            alive.topAnchor.constraint(equalTo: yearOfBirth.bottomAnchor, constant: 5),
            alive.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            alive.trailingAnchor.constraint(equalTo: name.trailingAnchor)
        ])
    }

}
