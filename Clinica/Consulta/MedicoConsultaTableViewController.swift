//
//  MedicoConsultaTableViewController.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-13.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit
import Alamofire

class MedicoConsultaTableViewController: UITableViewController {

    private var medicos = [Medico]()
    private let medicoService = MedicoService()
    private let loadingIndicator = UIUtilities.createLoadingIndicator()
    private var selectedIndex : Int?
    var consulta: Consulta!
    var consultaTableViewController: ConsultaTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Atualizando médicos...")
        refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)

        reloadTable()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selecionarMedicoCell", for: indexPath) as! MedicoConsultaTableViewCell
        
        let medico = medicos[indexPath.row]
        cell.nome.text = medico.nome
        cell.crm.text = medico.crm
        cell.especialidade.text = medico.especialidade?.descricao
        
        return cell
    }

    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "SelecionarCobertura", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextController = segue.destination as? CoberturaConsultaTableViewController {
            if let selectedIndex = self.selectedIndex {
                consulta.medico = medicos[selectedIndex]
                nextController.consulta = consulta
                nextController.consultaTableViewController = consultaTableViewController
                self.selectedIndex = nil
            }
        }
    }
    
    // MARK: Private methods
    
    private func onCompleteLoadMedicos(response: DataResponse<CrudResultsResponse<Medico>, AFError>) {
        switch response.result {
        case let .success(crudResponse):
            self.medicos = crudResponse.results
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
        _ = medicoService.loadMedicos(completionHandler: self.onCompleteLoadMedicos)
    }
    
    private func reloadTable() {
        refreshControl?.beginRefreshing()
        handleRefreshControl(self)
    }
}
