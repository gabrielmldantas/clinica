//
//  RemarcarConsultaViewController.swift
//  Clinica
//
//  Created by Gabriel Morrison on 2020-06-03.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit
import Alamofire

class RemarcarConsultaViewController: UITableViewController {

    @IBOutlet weak var dataConsulta: UITextField!
    
    private let dataConsultaPicker = UIDatePicker()
    private let dateFormatter = DateFormatter()
    private let loadingIndicator = UIUtilities.createLoadingIndicator()
    private let consultaService = ConsultaService()
    
    var consulta: Consulta!
    var acoesViewController: AcoesConsultaTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        configureDatePicker()
        
        dataConsulta.text = consulta.data
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
    
    @IBAction func finalizarConsulta(_ sender: Any) {
        if dataConsulta.text?.count ?? 0 == 0 {
            let alert = UIUtilities.createDefaultAlert(title: "Erro", message: "Selecione a data da consulta para finalizar.")
            UIUtilities.showAlert(controller: self, alert: alert)
        }
        
        consulta.data = dataConsulta.text
        _ = consultaService.updateConsulta(consulta, completionHandler: self.onCompleteSaveConsulta)
    }
    
    private func onCompleteSaveConsulta(response: DataResponse<Consulta, AFError>) {
        switch response.result {
        case let .success(result):
            acoesViewController.consulta = result
            DispatchQueue.main.async {
                self.acoesViewController.reload()
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
