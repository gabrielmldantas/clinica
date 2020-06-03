//
//  AcoesConsultaTableViewController.swift
//  Clinica
//
//  Created by Gabriel Morrison on 2020-06-03.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit

class AcoesConsultaTableViewController: UITableViewController {

    @IBOutlet weak var dataConsulta: UILabel!
    @IBOutlet weak var nomeMedico: UILabel!
    @IBOutlet weak var crmMedico: UILabel!
    @IBOutlet weak var especialidadeMedico: UILabel!
    @IBOutlet weak var nomePaciente: UILabel!
    @IBOutlet weak var cpfPaciente: UILabel!
    @IBOutlet weak var labelCobertura: UILabel!
    @IBOutlet weak var registrarPagamentoButton: UIButton!
    @IBOutlet weak var registrarExamesButton: UIButton!
    @IBOutlet weak var registrarReceitaButton: UIButton!
    @IBOutlet weak var remarcarConsultaButton: UIButton!
    
    var consulta: Consulta!
    var tableViewController: ConsultaTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reload()
    }

    func reload() {
        nomeMedico.text = consulta.medico?.nome
        crmMedico.text = consulta.medico?.crm
        especialidadeMedico.text = consulta.medico?.especialidade?.descricao
        nomePaciente.text = consulta.paciente?.nome
        cpfPaciente.text = consulta.paciente?.cpf
        labelCobertura.text = consulta.cobertura?.descricao
        dataConsulta.text = consulta.data
        
        remarcarConsultaButton.isEnabled = consulta.pagamentos.isEmpty && consulta.requisicoesExames.isEmpty && consulta.receitasMedicas.isEmpty
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextController = segue.destination as? RemarcarConsultaViewController {
            nextController.consulta = consulta
            nextController.acoesViewController = self
        } else if let nextController = segue.destination as? RegistroPagamentoTableViewController {
            nextController.consulta = consulta
            nextController.acoesViewController = self
        } else if let nextController = segue.destination as? RegistroExamesTableViewController {
            nextController.consulta = consulta
            nextController.acoesViewController = self
        } else if let nextController = segue.destination as? RegistroReceitaTableViewController {
           nextController.consulta = consulta
           nextController.acoesViewController = self
       }
    }
}
