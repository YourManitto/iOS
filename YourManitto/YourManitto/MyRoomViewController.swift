//
//  MyRoomViewController.swift
//  YourManitto
//
//  Created by 이자민 on 2023/06/23.
//

import UIKit

class MyRoomViewController: UIViewController {

    @IBOutlet weak var deleteButton: defaultBtn!
    @IBOutlet weak var MyManittoButton: defaultBtn!
    override func viewDidLoad() {
        super.viewDidLoad()

        MyManittoButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    MyManittoButton.heightAnchor.constraint(equalToConstant: 90)
                ])
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([deleteButton.heightAnchor.constraint(equalToConstant: 40)
                                     ])
    }
    

    

}
