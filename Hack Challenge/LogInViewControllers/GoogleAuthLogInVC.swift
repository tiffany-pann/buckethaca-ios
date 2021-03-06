//
//  GoogleAuthLogInVC.swift
//  Hack Challenge
//
//  Created by Tiffany Pan on 5/4/22.
//


import UIKit
import GoogleSignIn
import Firebase

class GoogleAuthLoginVC: ViewController {
    
    private let label = UILabel()
    
    let signInButton = GIDSignInButton()
    
    let logoImage = UIImageView()
    
    override func viewDidLoad() {
        
        
        view.backgroundColor = .white
        
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        signInButton.style = .wide
        label.text = "Welcome, first time with Buckethaca? 🤗"
        label.font = UIFont(name: "Montserrat-Medium", size: 16)
        
        logoImage.image = UIImage(named: "logo")
        logoImage.contentMode = .scaleAspectFit
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImage)
        view.addSubview(label)
        view.addSubview(signInButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        signInButton.snp.makeConstraints { make in
            make.centerX.equalTo(label)
            make.top.equalTo(label.snp.bottom).offset(30)
        }
        
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            logoImage.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 350),
            logoImage.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    @objc func signIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let signInConfig = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            if let error = error {
                print(error.localizedDescription)
            }
            // TODO: make POST request to backend
           //  user?.profile.
            self.navigationController?.pushViewController(TabViewController(), animated: true)
            if let userToken = user?.authentication.idToken {
                NetworkManager.sendToken(token: userToken) { User in
                    print(User)
                }
            }
            
        }

    }
    
}
