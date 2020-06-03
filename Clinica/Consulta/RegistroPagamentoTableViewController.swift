//
//  RegistroPagamentoTableViewController.swift
//  Clinica
//
//  Created by Gabriel Morrison on 2020-06-03.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit
import Alamofire

class RegistroPagamentoTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var formaPagamentoField: UITextField!
    @IBOutlet weak var valorConsultaField: UITextField!
    @IBOutlet weak var quantidadeParcelasField: UITextField!
    @IBOutlet weak var finalizarButton: UIBarButtonItem!
    
    var consulta: Consulta!
    var acoesViewController: AcoesConsultaTableViewController!
    private let consultaService = ConsultaService()
    private let formaPagamentoService = FormaPagamentoService()
    private let loadingIndicator = UIUtilities.createLoadingIndicator()
    
    private let formaPagamentoPicker = UIPickerView()
    private var formasPagamento = [FormaPagamento]()
    private var formaPagamentoSelecionada: FormaPagamento?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formaPagamentoPicker.dataSource = self
        formaPagamentoPicker.delegate = self
        
        if !consulta.pagamentos.isEmpty {
            formaPagamentoField.isEnabled = false
            valorConsultaField.isEnabled = false
            quantidadeParcelasField.isEnabled = false
            finalizarButton.isEnabled = false
            
            formaPagamentoSelecionada = consulta.pagamentos[0].formaPagamento
            formaPagamentoField.text = formaPagamentoSelecionada?.descricao
            
            var quantidadeParcelas = 0
            var valorTotal = 0.0
            for pagamento in consulta.pagamentos {
                quantidadeParcelas += 1
                valorTotal += pagamento.valor!
            }
            valorConsultaField.text = String(format: "%.02f", valorTotal).replacingOccurrences(of: ".", with: ",")
            quantidadeParcelasField.text = String(quantidadeParcelas)
        }
        
        _ = formaPagamentoService.loadFormasPagamento(completionHandler: self.onCompleteLoadFormasPagamento)
    }

    @IBAction func finalizar(_ sender: Any) {
        if formaPagamentoField.text?.count ?? 0 == 0 {
            let alert = UIUtilities.createDefaultAlert(title: "Erro", message: "Selecione a forma de pagamento para finalizar.")
            UIUtilities.showAlert(controller: self, alert: alert)
        }
        
        if valorConsultaField.text?.count ?? 0 == 0 || Double(valorConsultaField.text!.replacingOccurrences(of: ",", with: ".")) ?? 0.0 <= 0.0 {
            let alert = UIUtilities.createDefaultAlert(title: "Erro", message: "O valor da consulta deve ser preenchido com valor maior que 0.")
            UIUtilities.showAlert(controller: self, alert: alert)
        }
        
        if quantidadeParcelasField.text?.count ?? 0 == 0 || Int.init(quantidadeParcelasField.text!) ?? 0 == 0 {
            let alert = UIUtilities.createDefaultAlert(title: "Erro", message: "A quantidade de parcelas deve ser preenchida com valor maior que 0.")
            UIUtilities.showAlert(controller: self, alert: alert)
        }
        
        let registroPagamento = RegistroPagamento()
        registroPagamento.idFormaPagamento = formaPagamentoSelecionada?.id
        registroPagamento.valor = Float(valorConsultaField.text!.replacingOccurrences(of: ",", with: "."))
        if formaPagamentoSelecionada?.vista == "true" {
            registroPagamento.parcelas = 1
        } else {
            registroPagamento.parcelas = Int(quantidadeParcelasField.text!)
        }
        
        _ = consultaService.registrarPagamentos(consulta.id!, registroPagamento: registroPagamento, completionHandler: self.onCompleteSaveConsulta)
    }
    
    @IBAction func showFormaPagamentoPicker(_ sender: Any) {
        if formaPagamentoSelecionada != nil {
            formaPagamentoPicker.selectRow(formasPagamento.firstIndex(where: { $0.id == formaPagamentoSelecionada?.id} )!, inComponent: 0, animated: false)
        }
        formaPagamentoField.inputView = formaPagamentoPicker
        formaPagamentoField.inputAccessoryView = createPickerToolbar()
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return formasPagamento.count
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return formasPagamento[row].descricao
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
    
    private func onCompleteLoadFormasPagamento(response: DataResponse<CrudResultsResponse<FormaPagamento>, AFError>) {
    switch response.result {
    case let .success(result):
        self.formasPagamento = result.results
        formaPagamentoPicker.reloadComponent(0)
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
        formaPagamentoSelecionada = formasPagamento[formaPagamentoPicker.selectedRow(inComponent: 0)]
        formaPagamentoField.text = formaPagamentoSelecionada?.descricao
        if formaPagamentoSelecionada?.vista == "true" {
            quantidadeParcelasField.text = "1"
            quantidadeParcelasField.isEnabled = false
        } else {
            quantidadeParcelasField.isEnabled = true
        }
        self.view.endEditing(true)
    }
    
    @objc func cancelPicker() {
        self.view.endEditing(true)
    }
}
