//
//  MedicoViewController.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-06.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit
import Alamofire

class MedicoViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nomeMedico: UITextField!
    @IBOutlet weak var numeroCrm: UITextField!
    @IBOutlet weak var ufCrm: UITextField!
    @IBOutlet weak var especialidade: UITextField!

    private let especialidadeService = EspecialidadeService()
    private let medicoService = MedicoService()
    private let loadingIndicator = UIUtilities.createLoadingIndicator()
    private let estados = ["AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PE", "PI", "PR",
        "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO"].sorted()
    private let ufPicker = UIPickerView()
    private let especialidadePicker = UIPickerView()
    var crudViewDelegate: CrudViewDelegate?
    var medico: Medico!
    private var especialidades = [Especialidade]()
    private var especialidadeSelecionada: Especialidade?
    private var selectingUf = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ufPicker.dataSource = self
        ufPicker.delegate = self
        especialidadePicker.dataSource = self
        especialidadePicker.delegate = self
        
        if medico == nil {
            medico = Medico()
        } else {
            nomeMedico.text = medico.nome
            let crmParts = medico.crm?.split(separator: "-")
            numeroCrm.text = String(crmParts![0])
            ufCrm.text = String(crmParts![1])
            especialidadeSelecionada = medico.especialidade
            especialidade.text = especialidadeSelecionada?.descricao
        }
        
        updateSaveButtonState()
        _ = especialidadeService.loadEspecialidades(completionHandler: self.onCompleteLoadEspecialidades)
    }

    // MARK: Actions
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        UIUtilities.showAlert(controller: self, alert: loadingIndicator)
        
        updateDadosMedico()

        if medico.id == nil {
            _ = medicoService.createMedico(medico, completionHandler: self.onCompleteSaveMedico)
        } else {
            _ = medicoService.updateMedico(medico, completionHandler: self.onCompleteSaveMedico)
        }
    }
    
    @IBAction func showUfPicker(_ sender: Any) {
        if ufCrm.text?.count ?? 0 > 0 {
            ufPicker.selectRow(estados.firstIndex(of: ufCrm.text!)!, inComponent: 0, animated: false)
        }
        ufCrm.inputView = ufPicker
        ufCrm.inputAccessoryView = createPickerToolbar()
        selectingUf = true
    }
    
    @IBAction func showEspecialidadePicker(_ sender: Any) {
        if especialidadeSelecionada != nil {
            especialidadePicker.selectRow(especialidades.firstIndex(where: { $0.id == especialidadeSelecionada?.id} )!, inComponent: 0, animated: false)
        }
        especialidade.inputView = especialidadePicker
        especialidade.inputAccessoryView = createPickerToolbar()
        selectingUf = false
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            return
        }
        
        updateDadosMedico()
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
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == ufPicker {
            return estados.count
        } else {
            return especialidades.count
        }
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == ufPicker {
            return estados[row]
        } else {
            return especialidades[row].descricao
        }
    }
    
    // MARK: Private Methods
    
    private func trimWhitespace(value: String?) -> String {
        return value ?? "" .trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    private func updateSaveButtonState() {
        saveButton.isEnabled = trimWhitespace(value: nomeMedico.text).count > 0
            && trimWhitespace(value: numeroCrm.text).count > 0
            && ufCrm.text?.count ?? 0 > 0
            && especialidade.text?.count ?? 0 > 0
    }
    
    private func onCompleteSaveMedico(response: DataResponse<Medico, AFError>) {
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
                let alert = UIUtilities.createDefaultAlert(
                    title: "Erro",
                    message: error.errorDescription ??
                        "Erro desconhecido, por favor tente novamente")
                self.loadingIndicator
                    .dismiss(animated: true,
                             completion: { UIUtilities.showAlert(controller: self, alert: alert) })
            }
        }
    }
    
    private func onCompleteLoadEspecialidades(response: DataResponse<CrudResultsResponse<Especialidade>, AFError>) {
        switch response.result {
        case let .success(result):
            self.especialidades = result.results
            especialidadePicker.reloadComponent(0)
        case let .failure(error):
            DispatchQueue.main.async {
                let alert = UIUtilities.createDefaultAlert(
                    title: "Erro",
                    message: error.errorDescription ??
                        "Erro desconhecido, por favor tente novamente")
                self.loadingIndicator
                    .dismiss(animated: true,
                             completion: { UIUtilities.showAlert(controller: self, alert: alert) })
            }
        }
    }
    
    private func updateDadosMedico() {
        medico.nome = trimWhitespace(value: nomeMedico.text)
        medico.crm = trimWhitespace(value: numeroCrm.text) + "-" + trimWhitespace(value: ufCrm.text)
        medico.especialidade = especialidadeSelecionada
    }
    
    private func createPickerToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelPicker))

        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        
        return toolbar
    }
    
    @objc func donePicker() {
        if selectingUf {
            ufCrm.text = estados[ufPicker.selectedRow(inComponent: 0)]
        } else {
            especialidadeSelecionada = especialidades[especialidadePicker.selectedRow(inComponent: 0)]
            especialidade.text = especialidadeSelecionada?.descricao
        }
        self.view.endEditing(true)
    }
    
    @objc func cancelPicker() {
        self.view.endEditing(true)
    }
}
