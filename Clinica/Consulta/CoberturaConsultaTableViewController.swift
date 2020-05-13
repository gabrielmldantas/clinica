//
//  CoberturaConsultaTableViewController.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-13.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit
import Alamofire

class CoberturaConsultaTableViewController: UITableViewController {

    var pacienteSelecionado: Paciente!
    var medicoSelecionado: Medico!
    private var coberturas = [Cobertura]()
    private let coberturaService = CoberturaService()
    private let loadingIndicator = UIUtilities.createLoadingIndicator()
    private var selectedIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Atualizando coberturas...")
        refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        reloadTable()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coberturas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let cobertura = coberturas[indexPath.row]
        cell.textLabel?.text = cobertura.descricao
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "AdicionarInformacoesReceitasExames", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextController = segue.destination as? CoberturaViewController {
            if let selectedIndex = self.selectedIndex {
                nextController.cobertura = coberturas[selectedIndex]
                self.selectedIndex = nil
            }
        }
    }
    
    // MARK: Private methods
    
    private func onCompleteLoadCoberturas(response: DataResponse<CrudResultsResponse<Cobertura>, AFError>) {
        switch response.result {
        case let .success(crudResponse):
            self.coberturas = crudResponse.results
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
        _ = coberturaService.loadCoberturas(completionHandler: self.onCompleteLoadCoberturas)
    }
    
    private func reloadTable() {
        refreshControl?.beginRefreshing()
        handleRefreshControl(self)
    }
}
