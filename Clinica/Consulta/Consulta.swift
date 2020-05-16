//
//  Consulta.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-16.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import ObjectMapper

class Consulta: Mappable, Encodable {
    
    var id: Int?
    var data: String?
    var medico: Medico?
    var paciente: Paciente?
    var cobertura: Cobertura?
    
    required init?(map: Map) {
    }
    
    init() {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        data <- map["data"]
        medico <- map["medico"]
        paciente <- map["paciente"]
        cobertura <- map["cobertura"]
    }
}
