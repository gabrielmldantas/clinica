//
//  MainViewController.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-12.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var labelWelcome: UILabel!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    private var menuItems = [
        "Especialidade",
        "Médico",
        "Paciente",
        "Cobertura",
        "Consulta"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if SessaoUsuario.usuarioLogado?.username == "admin" {
            menuItems.append("Usuário")
        }
        
        menuItems.sort()
        
        let nomeExibicao = SessaoUsuario.usuarioLogado!.nome!.split(separator: " ")[0]
        labelWelcome.text = "Bem-vindo, \(nomeExibicao). Escolha uma opção abaixo."
        
        if let flowLayout = menuCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: flowLayout.itemSize.width, height: flowLayout.itemSize.height)
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath as IndexPath) as! MenuCollectionViewCell

        cell.label.text = menuItems[indexPath.item]

        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MenuCollectionViewCell
        if let selectedMenu = cell.label.text {
            if selectedMenu == "Especialidade" {
                self.performSegue(withIdentifier: "Especialidade", sender: nil)
            } else if selectedMenu == "Médico" {
                self.performSegue(withIdentifier: "Medico", sender: nil)
            } else if selectedMenu == "Cobertura" {
                self.performSegue(withIdentifier: "Cobertura", sender: nil)
            } else if selectedMenu == "Paciente" {
                self.performSegue(withIdentifier: "Paciente", sender: nil)
            } else if selectedMenu == "Usuário" {
                self.performSegue(withIdentifier: "Usuario", sender: nil)
            } else if selectedMenu == "Consulta" {
                self.performSegue(withIdentifier: "Consulta", sender: nil)
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        SessaoUsuario.usuarioLogado = nil
        self.navigationController?.popViewController(animated: true)
    }
}
