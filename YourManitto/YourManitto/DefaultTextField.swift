//
//  DefaultTextField.swift
//  YourManitto
//
//  Created by 이자민 on 2023/06/27.
//

import UIKit

class DefaultTextField: UITextField {

    override func awakeFromNib() {
            super.awakeFromNib()
            
            // 높이 설정
            self.heightAnchor.constraint(equalToConstant: 45).isActive = true
        }
}
