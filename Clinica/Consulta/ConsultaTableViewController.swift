//
//  ConsultaTableViewController.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-13.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit

class ConsultaTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    @IBAction func showMenu(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
