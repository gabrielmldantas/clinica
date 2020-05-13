//
//  Medico.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-06.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import ObjectMapper

class Medico: Mappable, Encodable {
    var id: Int?
    var nome: String?
    var crm: String?
    var especialidade: Especialidade?
    
    required init?(map: Map) {
    }
    
    init() {
    }
    
    init(withId: Int, withNome: String, withCrm: String, withEspecialidade: Especialidade) {
        self.id = withId
        self.nome = withNome
        self.crm = withCrm
        self.especialidade = withEspecialidade
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        nome <- map["nome"]
        crm <- map["crm"]
        especialidade <- map["especialidade"]
    }
}
