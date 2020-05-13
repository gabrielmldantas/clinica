//
//  EspecialidadeViewController.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-06.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit
import Alamofire

class EspecialidadeViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var descricaoEspecialidade: UITextField!
    
    private let especialidadeService = EspecialidadeService()
    private let loadingIndicator = UIUtilities.createLoadingIndicator()
    var crudViewDelegate: CrudViewDelegate?
    var especialidade: Especialidade!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descricaoEspecialidade.delegate = self
        
        if especialidade == nil {
            especialidade = Especialidade()
        } else {
            descricaoEspecialidade.text = especialidade.descricao
        }
        
        updateSaveButtonState()
    }

    // MARK: Actions
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        UIUtilities.showAlert(controller: self, alert: loadingIndicator)
        
        especialidade.descricao = trimWhitespace(value: descricaoEspecialidade.text)

        if especialidade.id == nil {
            _ = especialidadeService.createEspecialidade(especialidade, completionHandler: self.onCompleteSaveEspecialidade)
        } else {
            _ = especialidadeService.updateEspecialidade(especialidade, completionHandler: self.onCompleteSaveEspecialidade)
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            return
        }
        
        especialidade.descricao = trimWhitespace(value: descricaoEspecialidade.text)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Private Methods
    
    private func trimWhitespace(value: String?) -> String {
        return value ?? "" .trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    private func updateSaveButtonState() {
        saveButton.isEnabled = trimWhitespace(value: descricaoEspecialidade.text).count > 0
    }
    
    private func onCompleteSaveEspecialidade(response: DataResponse<Especialidade, AFError>) {
        switch response.result {
        case let .success(result):
            DispatchQueue.main.async {
                self.loadingIndicator.dismiss(
                    animated: true, completion: {
                        self.navigationController?.popViewController(animated: true)
                        if self.crudViewDelegate != nil {
                            self.crudViewDelegate?.didSave(value: result)
                        }
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
