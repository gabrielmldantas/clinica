//
//  Usuario.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-13.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit
import ObjectMapper

class Usuario: Mappable, Encodable {
    
    var id: Int?
    var nome: String?
    var username: String?
    var email: String?
    var senha: String?
    
    required init?(map: Map) {
    }
    
    init() {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        nome <- map["nome"]
        username <- map["username"]
        email <- map["email"]
        senha <- map["senha"]
    }
}
