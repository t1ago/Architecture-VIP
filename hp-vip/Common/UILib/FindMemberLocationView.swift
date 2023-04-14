//
//  FindMemberLocationView.swift
//  hp-vip
//
//  Created by Tiago Henrique Piantavinha on 14/04/23.
//

import Foundation
import MapKit

class FindMemberLocationView: MKAnnotationView {
    
    lazy var photo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.addSubview(photo)
        self.addSubview(name)
        adjustConstraint()
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
    }
    
    private func adjustConstraint() {
        NSLayoutConstraint.activate([
            photo.heightAnchor.constraint(equalToConstant: 40),
            photo.widthAnchor.constraint(equalTo: photo.heightAnchor),
            photo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            photo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            name.topAnchor.constraint(equalTo: photo.bottomAnchor),
            name.centerXAnchor.constraint(equalTo: photo.centerXAnchor)
        ])
    }
}
