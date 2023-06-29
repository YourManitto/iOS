//
//  defaultBtn.swift
//  YourManitto
//
//  Created by 이자민 on 2023/06/30.
//

import UIKit

class defaultBtn: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 12
        NSLayoutConstraint.activate([
                    heightAnchor.constraint(equalToConstant: 45)
                ])
    }


}
