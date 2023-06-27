//
//  LoginViewController.swift
//  YourManitto
//
//  Created by 이자민 on 2023/06/23.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let loadingView = UIView()  // 로딩 인디케이터를 표시할 뷰
        let activityIndicator = UIActivityIndicatorView(style: .gray)  // 로딩 인디케이터


    @IBOutlet weak var enterLoginButton: defaultBtn!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        // 로딩 인디케이터 설정
               activityIndicator.translatesAutoresizingMaskIntoConstraints = false
               activityIndicator.hidesWhenStopped = true
               loadingView.addSubview(activityIndicator)
               NSLayoutConstraint.activate([
                   activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
                   activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
               ])
    }
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            // 키보드 표시
            emailTextField.becomeFirstResponder()
        }
    @IBAction func emailLoginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        showLoadingIndicator()
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            self.hideLoadingIndicator()
            if let error = error {
                // 로그인 실패
                print("이메일 로그인 실패: \(error.localizedDescription)")
            } else {
                // 로그인 성공
                print("이메일 로그인 성공")
                
                // 로그인 후 처리할 작업 수행
                if let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController"){
                    self.navigationController?.pushViewController(mainVC, animated: true)
                }
            }
        }
    }
    
    func showLoadingIndicator() {
            // 로딩 인디케이터 표시
            activityIndicator.startAnimating()
            loadingView.frame = view.bounds
            view.addSubview(loadingView)
        }

        func hideLoadingIndicator() {
            // 로딩 인디케이터 숨김
            activityIndicator.stopAnimating()
            loadingView.removeFromSuperview()
        }

}
