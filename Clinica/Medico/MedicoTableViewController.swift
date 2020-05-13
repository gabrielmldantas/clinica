//
//  MedicoTableViewController.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-06.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit
import Alamofire

class MedicoTableViewController: UITableViewController, CrudViewDelegate {

    private var medicos = [Medico]()
    private let medicoService = MedicoService()
    private let loadingIndicator = UIUtilities.createLoadingIndicator()
    private var selectedIndex : Int?
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MedicoTableViewCell
        
        let medico = medicos[indexPath.row]
        cell.labelNome.text = medico.nome
        cell.labelCrm.text = medico.crm
        cell.labelEspecialidade.text = medico.especialidade?.descricao
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            _ = medicoService.deleteMedico(medicos[indexPath.row].id!, completionHandler: self.onCompleteDeleteMedico)
        }
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "AdicionarMedico", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextController = segue.destination as? MedicoViewController {
            nextController.crudViewDelegate = self
            if let selectedIndex = self.selectedIndex {
                nextController.medico = medicos[selectedIndex]
                self.selectedIndex = nil
            }
        }
    }
    
    @IBAction func showMenu(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: CrudViewDelegate
    
    func didSave(value: Any) {
        reloadTable()
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
    
    private func onCompleteDeleteMedico(response: DataResponse<Data?, AFError>) {
        switch response.result {
        case .success:
            self.reloadTable()
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
