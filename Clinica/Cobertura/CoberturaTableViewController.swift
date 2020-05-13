//
//  EspecialidadeTableViewController.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-06.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit
import Alamofire

class CoberturaTableViewController: UITableViewController, CrudViewDelegate {

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

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            _ = coberturaService.deleteCobertura(coberturas[indexPath.row].id!, completionHandler: self.onCompleteDeleteCobertura)
        }
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "AdicionarCobertura", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextController = segue.destination as? CoberturaViewController {
            nextController.crudViewDelegate = self
            if let selectedIndex = self.selectedIndex {
                nextController.cobertura = coberturas[selectedIndex]
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
                self.refreshControl?.endRefreshing()
                let alert = UIUtilities.createDefaultAlert(
                    title: "Erro",
                    message: error.errorDescription ?? "Erro desconhecido, por favor tente novamente")
                UIUtilities.showAlert(controller: self, alert: alert)
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
    
    private func onCompleteDeleteCobertura(response: DataResponse<Data?, AFError>) {
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
