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
//        let vcName = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
//                vcName?.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
//                vcName?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
//                self.present(vcName!, animated: true, completion: nil)
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
