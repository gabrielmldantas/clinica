//
//  ConsultaTableViewController.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-13.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit
import Alamofire

class ConsultaTableViewController: UITableViewController {

    private var consultas = [Consulta]()
    private let consultaService = ConsultaService()
    private let loadingIndicator = UIUtilities.createLoadingIndicator()
    private var selectedIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Atualizando consultas...")
        refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        reloadTable()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consultas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConsultaTableViewCell
        
        let consulta = consultas[indexPath.row]
        cell.nomePaciente.text = consulta.paciente?.nome
        cell.cpfPaciente.text = consulta.paciente?.cpf
        cell.nomeMedico.text = consulta.medico?.nome
        cell.crmMedico.text = consulta.medico?.crm
        cell.dataConsulta.text = consulta.data
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "EditarConsulta", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            _ = consultaService.deleteConsulta(consultas[indexPath.row].id!, completionHandler: self.onCompleteDeleteConsulta)
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextController = segue.destination as? FinalizarConsultaTableViewController {
            if let selectedIndex = self.selectedIndex {
                nextController.consulta = consultas[selectedIndex]
                nextController.consultaTableViewController = self
                self.selectedIndex = nil
            }
        } else if let nextController = segue.destination as? PacienteConsultaTableViewController {
            nextController.consultaTableViewController = self
        }
    }
    
    @IBAction func showMenu(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Private methods
    
    private func onCompleteLoadConsultas(response: DataResponse<CrudResultsResponse<Consulta>, AFError>) {
        switch response.result {
        case let .success(crudResponse):
            self.consultas = crudResponse.results
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
        _ = consultaService.loadConsultas(completionHandler: self.onCompleteLoadConsultas)
    }
    
    func reloadTable() {
        refreshControl?.beginRefreshing()
        handleRefreshControl(self)
    }

    private func onCompleteDeleteConsulta(response: DataResponse<Data?, AFError>) {
        switch response.result {
        case .success:
            self.reloadTable()
        case let .failure(error):
            DispatchQueue.main.async {
                let alert = UIUtilities.createDefaultAlert(
                    title: "Erro",
                    message: error.errorDescription ?? "Erro desconhecido, por favor tente novamente")
                UIUtilities.showAlert(controller: self, alert: alert)
            }
        }
    }
}
