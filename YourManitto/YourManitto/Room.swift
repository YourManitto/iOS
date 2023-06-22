//
//  Room.swift
//  YourManitto
//
//  Created by 이자민 on 2023/06/22.
//

import UIKit

class Room: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 12
        widthAnchor.constraint(equalTo: heightAnchor).isActive = true
    }

}
