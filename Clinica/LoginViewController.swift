//
//  LoginViewController.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-13.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var senha: UITextField!
    
    private let loadingIndicator = UIUtilities.createLoadingIndicator()
    let usuarioService = UsuarioService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func login(_ sender: Any) {
        self.view.endEditing(true)
        UIUtilities.showAlert(controller: self, alert: loadingIndicator)
        _ = usuarioService.login(username: usuario.text ?? "", senha: senha.text ?? "", completionHandler: self.onCompleteLogin)
    }
    
    private func onCompleteLogin(response: DataResponse<Usuario, AFError>) {
        switch response.result {
        case let .success(result):
            SessaoUsuario.usuarioLogado = result
            usuario.text = nil
            senha.text = nil
            DispatchQueue.main.async {
                self.loadingIndicator.dismiss(
                    animated: true, completion: {
                        self.performSegue(withIdentifier: "Login", sender: nil)
                })
            }
        case let .failure(error):
            DispatchQueue.main.async {
                var errorMessage = error.errorDescription ?? "Erro desconhecido, por favor tente novamente"
                if response.data != nil {
                    let message = String(bytes: response.data!, encoding: .utf8)!
                    if !message.isEmpty {
                        errorMessage = message
                    }
                }
                let alert = UIUtilities.createDefaultAlert(
                    title: "Erro",
                    message: errorMessage)
                self.loadingIndicator
                    .dismiss(animated: true,
                             completion: { UIUtilities.showAlert(controller: self, alert: alert) })
            }
        }
    }
}
