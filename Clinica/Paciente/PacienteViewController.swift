//
//  PacienteViewController.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-06.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit
import Alamofire

class PacienteViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var cpf: UITextField!
    @IBOutlet weak var rg: UITextField!
    @IBOutlet weak var telefone: UITextField!
    @IBOutlet weak var rua: UITextField!
    @IBOutlet weak var bairro: UITextField!
    @IBOutlet weak var numero: UITextField!
    @IBOutlet weak var dataNascimento: UITextField!
    
    private let dataNascimentoPicker = UIDatePicker()
    private let pacienteService = PacienteService()
    private let loadingIndicator = UIUtilities.createLoadingIndicator()
    private let dateFormatter = DateFormatter()
    var crudViewDelegate: CrudViewDelegate?
    var paciente: Paciente!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        configureDatePicker(dataNascimentoPicker)
        
        if paciente == nil {
            paciente = Paciente()
        } else {
            nome.text = paciente.nome
            cpf.text = paciente.cpf
            rg.text = paciente.rg
            telefone.text = paciente.telefone
            dataNascimento.text = paciente.dataNascimento
            
            rua.text = paciente.endereco!.rua
            bairro.text = paciente.endereco!.bairro
            numero.text = String(paciente.endereco!.numero!)
        }
        
        updateSaveButtonState()
    }

    // MARK: Actions
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        UIUtilities.showAlert(controller: self, alert: loadingIndicator)
        
        updateDadosPaciente()
        
        if paciente.id == nil {
            _ = pacienteService.createPaciente(paciente, completionHandler: self.onCompleteSavePaciente)
        } else {
            _ = pacienteService.updatePaciente(paciente, completionHandler: self.onCompleteSavePaciente)
        }
    }
    
    @IBAction func showDatePicker(_ sender: Any) {
        if dataNascimento.text?.count ?? 0 > 0 {
            dataNascimentoPicker.date = dateFormatter.date(from: dataNascimento.text!)!
        }
        dataNascimento.inputView = dataNascimentoPicker
        dataNascimento.inputAccessoryView = createDatePickerToolbar()
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            return
        }
        
        updateDadosPaciente()
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
        saveButton.isEnabled = trimWhitespace(value: nome.text).count > 0
            && trimWhitespace(value: cpf.text).count > 0
            && trimWhitespace(value: rg.text).count > 0
            && trimWhitespace(value: telefone.text).count > 0
            && dataNascimento.text?.count ?? 0 > 0
            && trimWhitespace(value: rua.text).count > 0
            && trimWhitespace(value: bairro.text).count > 0
            && trimWhitespace(value: numero.text).count > 0
    }
    
    private func onCompleteSavePaciente(response: DataResponse<Paciente, AFError>) {
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
    
    private func updateDadosPaciente() {
        paciente.nome = trimWhitespace(value: nome.text)
        paciente.cpf = trimWhitespace(value: cpf.text)
        paciente.rg = trimWhitespace(value: rg.text)
        paciente.telefone = trimWhitespace(value: telefone.text)
        paciente.dataNascimento = dataNascimento.text
        
        if paciente.endereco == nil {
            paciente.endereco = Endereco()
        }
        
        paciente.endereco!.rua = trimWhitespace(value: rua.text)
        paciente.endereco!.bairro = trimWhitespace(value: bairro.text)
        paciente.endereco!.numero = Int(trimWhitespace(value: numero.text))
    }
    
    private func configureDatePicker(_ datePicker: UIDatePicker) {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.locale = Locale.init(identifier: "pt-BR")
    }
    
    private func createDatePickerToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDataNascimentoPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelDataNascimentoPicker))

        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        
        return toolbar
    }
    
    @objc func doneDataNascimentoPicker() {
        dataNascimento.text = dateFormatter.string(from: dataNascimentoPicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDataNascimentoPicker() {
        self.view.endEditing(true)
    }
}
