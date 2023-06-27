//
//  StartViewController.swift
//  YourManitto
//
//  Created by 이자민 on 2023/06/23.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var kakaoButton: UIButton!
    @IBAction func otherButtonTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        kakaoButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    kakaoButton.heightAnchor.constraint(equalToConstant: 40)
                ])
        otherButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    otherButton.heightAnchor.constraint(equalToConstant: 40)
                ])
    }
    
}
