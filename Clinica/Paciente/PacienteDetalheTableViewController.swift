//
//  PacienteDetalheTableViewController.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-13.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit

class PacienteDetalheTableViewController: UITableViewController {

    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var cpf: UITextField!
    @IBOutlet weak var rg: UITextField!
    @IBOutlet weak var dataNascimento: UITextField!
    @IBOutlet weak var telefone: UITextField!
    @IBOutlet weak var rua: UITextField!
    @IBOutlet weak var bairro: UITextField!
    @IBOutlet weak var numero: UITextField!
    
    var paciente: Paciente!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nome.text = paciente.nome
        cpf.text = paciente.cpf
        rg.text = paciente.rg
        dataNascimento.text = paciente.dataNascimento
        telefone.text = paciente.telefone
        rua.text = paciente.endereco!.rua
        bairro.text = paciente.endereco!.bairro
        numero.text = String(paciente.endereco!.numero!)
    }
    
    
}
