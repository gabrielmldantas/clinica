//
//  PacienteConsultaTableViewCell.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-13.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit

class PacienteConsultaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var cpf: UILabel!
    @IBOutlet weak var telefone: UILabel!
    
    var paciente: Paciente!
    
    @IBAction func showDetail(_ sender: Any) {
        let detalheStoryboard = UIStoryboard.init(name: "PacienteDetalhe", bundle: nil)
        let rootViewController = detalheStoryboard.instantiateInitialViewController() as! PacienteDetalheTableViewController
        rootViewController.paciente = paciente
        self.window?.rootViewController?.present(rootViewController, animated: true, completion: nil)
    }
}
