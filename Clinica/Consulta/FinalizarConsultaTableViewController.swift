//
//  FinalizarConsultaTableViewController.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-16.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit
import Alamofire

class FinalizarConsultaTableViewController: UITableViewController {

    @IBOutlet weak var dataConsulta: UITextField!
    @IBOutlet weak var nomeMedico: UILabel!
    @IBOutlet weak var crmMedico: UILabel!
    @IBOutlet weak var especialidadeMedico: UILabel!
    @IBOutlet weak var nomePaciente: UILabel!
    @IBOutlet weak var cpfPaciente: UILabel!
    @IBOutlet weak var labelCobertura: UILabel!
    
    var consulta: Consulta!
    var consultaTableViewController: ConsultaTableViewController!
    private let dataConsultaPicker = UIDatePicker()
    private let dateFormatter = DateFormatter()
    private let loadingIndicator = UIUtilities.createLoadingIndicator()
    private let consultaService = ConsultaService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        configureDatePicker()
        
        nomeMedico.text = consulta.medico?.nome
        crmMedico.text = consulta.medico?.crm
        especialidadeMedico.text = consulta.medico?.especialidade?.descricao
        nomePaciente.text = consulta.paciente?.nome
        cpfPaciente.text = consulta.paciente?.cpf
        labelCobertura.text = consulta.cobertura?.descricao
        dataConsulta.text = consulta.data
    }
    
    @IBAction func finalizarConsulta(_ sender: Any) {
        if dataConsulta.text?.count ?? 0 == 0 {
            let alert = UIUtilities.createDefaultAlert(title: "Erro", message: "Selecione a data da consulta para finalizar.")
            UIUtilities.showAlert(controller: self, alert: alert)
        }
        
        consulta.data = dataConsulta.text
        
        if consulta.id == nil {
            _ = consultaService.createConsulta(consulta, completionHandler: self.onCompleteSaveConsulta)
        } else {
            _ = consultaService.updateConsulta(consulta, completionHandler: self.onCompleteSaveConsulta)
        }
    }
    
    private func configureDatePicker() {
        dataConsultaPicker.datePickerMode = .dateAndTime
        let minimumDate = Calendar.current.nextDate(after: Date(), matching: DateComponents(minute: 0), matchingPolicy: .nextTime)
        dataConsultaPicker.minimumDate = minimumDate
        dataConsultaPicker.locale = Locale.init(identifier: "pt-BR")
        dataConsultaPicker.minuteInterval = 30
    }
    
    private func createDatePickerToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDataConsultaPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelDataConsultaPicker))

        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        
        return toolbar
    }
    
    @objc func doneDataConsultaPicker() {
        dataConsulta.text = dateFormatter.string(from: dataConsultaPicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDataConsultaPicker() {
        self.view.endEditing(true)
    }
    
    @IBAction func showDatePicker(_ sender: Any) {
        if dataConsulta.text?.count ?? 0 > 0 {
            dataConsultaPicker.date = dateFormatter.date(from: dataConsulta.text!)!
        }
        dataConsulta.inputView = dataConsultaPicker
        dataConsulta.inputAccessoryView = createDatePickerToolbar()
    }
    
    private func onCompleteSaveConsulta(response: DataResponse<Consulta, AFError>) {
        switch response.result {
        case .success:
            DispatchQueue.main.async {
                self.loadingIndicator.dismiss(
                    animated: true, completion: {
                        self.navigationController?.popToViewController(self.consultaTableViewController, animated: true)
                        self.consultaTableViewController.reloadTable()
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
