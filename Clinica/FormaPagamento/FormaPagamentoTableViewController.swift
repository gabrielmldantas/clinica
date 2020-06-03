//
//  FormaPagamentoTableViewController.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-06.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit
import Alamofire

class FormaPagamentoTableViewController: UITableViewController, CrudViewDelegate {

    private var formasPagamento = [FormaPagamento]()
    private let formaPagamentoService = FormaPagamentoService()
    private let loadingIndicator = UIUtilities.createLoadingIndicator()
    private var selectedIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Atualizando formas de pagamento...")
        refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        reloadTable()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formasPagamento.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let formaPagamento = formasPagamento[indexPath.row]
        cell.textLabel?.text = formaPagamento.descricao
        
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            _ = formaPagamentoService.deleteFormaPagamento(formasPagamento[indexPath.row].id!, completionHandler: self.onCompleteDeleteCobertura)
        }
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "AdicionarFormaPagamento", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextController = segue.destination as? FormaPagamentoViewController {
            nextController.crudViewDelegate = self
            if let selectedIndex = self.selectedIndex {
                nextController.formaPagamento = formasPagamento[selectedIndex]
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
    
    private func onCompleteLoadFormasPagamento(response: DataResponse<CrudResultsResponse<FormaPagamento>, AFError>) {
        switch response.result {
        case let .success(crudResponse):
            self.formasPagamento = crudResponse.results
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
        _ = formaPagamentoService.loadFormasPagamento(completionHandler: self.onCompleteLoadFormasPagamento)
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
