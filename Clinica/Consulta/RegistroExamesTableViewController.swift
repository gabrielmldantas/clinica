//
//  RegistroExamesTableViewController.swift
//  Clinica
//
//  Created by Gabriel Morrison on 2020-06-03.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit
import Alamofire

class RegistroExamesTableViewController: UITableViewController {

    @IBOutlet weak var examesField: UITextView!
    @IBOutlet weak var dataField: UILabel!
    
    var consulta: Consulta!
    var acoesViewController: AcoesConsultaTableViewController!
    @IBOutlet weak var finalizarButton: UIBarButtonItem!
    
    private let loadingIndicator = UIUtilities.createLoadingIndicator()
    private let consultaService = ConsultaService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !consulta.requisicoesExames.isEmpty {
            finalizarButton.isEnabled = false
            examesField.isEditable = false
            examesField.text = consulta.requisicoesExames[0].descricao
            dataField.text = consulta.requisicoesExames[0].data
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dataField.text = dateFormatter.string(from: Date())
        }
    }

    @IBAction func finalizar(_ sender: Any) {
        if examesField.text?.count ?? 0 == 0 {
            let alert = UIUtilities.createDefaultAlert(title: "Erro", message: "Informe os exames requeridos.")
            UIUtilities.showAlert(controller: self, alert: alert)
        }
        
        let registroExames = RegistroRequisicaoExames()
        registroExames.descricao = examesField.text!
        _ = consultaService.requisitarExames(consulta.id!, registroRequisicaoExames: registroExames, completionHandler: self.onCompleteSaveConsulta)
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
