//
//  CadastroUsuarioTableViewController.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-13.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit
import Alamofire

class CadastroUsuarioTableViewController: UITableViewController {

    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var senha: UITextField!
    
    private let usuarioService = UsuarioService()
    private let loadingIndicator = UIUtilities.createLoadingIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        if (validate()) {
            UIUtilities.showAlert(controller: self, alert: self.loadingIndicator)
            
            let usuario = Usuario()
            usuario.nome = trimWhitespace(value: nome.text)
            usuario.username = trimWhitespace(value: self.usuario.text)
            usuario.email = trimWhitespace(value: email.text)
            usuario.senha = trimWhitespace(value: senha.text)
            
            _ = usuarioService.createUsuario(usuario, completionHandler: self.onCompleteCreateUsuario)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    private func validate() -> Bool {
        var campos = [String]()
        if trimWhitespace(value: nome.text).count == 0 {
            campos.append("Nome")
        }
        if trimWhitespace(value: usuario.text).count == 0 {
            campos.append("Usuário")
        }
        if trimWhitespace(value: email.text).count == 0 {
            campos.append("Email")
        }
        if trimWhitespace(value: senha.text).count == 0 {
            campos.append("Senha")
        }
        
        if campos.count > 0 {
            let message = "Os seguintes campos são obrigatórios: \(campos.joined(separator: ", "))"
            let alert = UIUtilities.createDefaultAlert(title: "Erro", message: message)
            UIUtilities.showAlert(controller: self, alert: alert)
        }
        
        return campos.count == 0
    }
    
    private func trimWhitespace(value: String?) -> String {
        return value ?? "" .trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    private func onCompleteCreateUsuario(response: DataResponse<Data?, AFError>) {
        switch response.result {
        case .success:
            DispatchQueue.main.async {
                self.loadingIndicator.dismiss(
                    animated: true, completion: {
                        self.navigationController?.popViewController(animated: true)
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
