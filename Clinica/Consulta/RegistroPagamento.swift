//
//  RegistroPagamento.swift
//  Clinica
//
//  Created by Gabriel Morrison on 2020-06-03.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import ObjectMapper

class RegistroPagamento: Mappable, Encodable {

    var idFormaPagamento: Int?
    var valor: Float?
    var parcelas: Int?
    
    required init?(map: Map) {
    }
    
    init() {
    }
    
    func mapping(map: Map) {
        idFormaPagamento <- map["idFormaPagamento"]
        valor <- map["valor"]
        parcelas <- map["parcelas"]
    }
}
