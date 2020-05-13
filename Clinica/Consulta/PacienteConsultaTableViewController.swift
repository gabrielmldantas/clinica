//
//  PacienteConsultaTableViewController.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-13.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit
import Alamofire

class PacienteConsultaTableViewController: UITableViewController {

    private var pacientes = [Paciente]()
    private let pacienteService = PacienteService()
    private let loadingIndicator = UIUtilities.createLoadingIndicator()
    private var selectedIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Atualizando pacientes...")
        refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        reloadTable()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pacientes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selecionarPacienteCell", for: indexPath) as! PacienteConsultaTableViewCell
        
        let paciente = pacientes[indexPath.row]
        cell.nome.text = paciente.nome
        cell.cpf.text = paciente.cpf
        cell.telefone.text = String(paciente.telefone!)
        cell.paciente = paciente
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "SelecionarMedico", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextController = segue.destination as? MedicoConsultaTableViewController {
            if let selectedIndex = self.selectedIndex {
                nextController.pacienteSelecionado = pacientes[selectedIndex]
                self.selectedIndex = nil
            }
        }
    }
    
    // MARK: Private methods
    
    private func onCompleteLoadPacientes(response: DataResponse<CrudResultsResponse<Paciente>, AFError>) {
        switch response.result {
        case let .success(crudResponse):
            self.pacientes = crudResponse.results
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
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
    
    @objc private func handleRefreshControl(_ sender: Any) {
        _ = pacienteService.loadPacientes(completionHandler: self.onCompleteLoadPacientes)
    }
    
    private func reloadTable() {
        refreshControl?.beginRefreshing()
        handleRefreshControl(self)
    }
}
