//
//  Pagamento.swift
//  Clinica
//
//  Created by Gabriel Morrison on 2020-06-03.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import ObjectMapper

class Pagamento: Mappable, Encodable {

    var id: Int?
    var valor: Float?
    var dataPagamento: String?
    var formaPagamento: FormaPagamento?
    
    required init?(map: Map) {
    }
    
    init() {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        valor <- map["valor"]
        dataPagamento <- map["dataPagamento"]
        formaPagamento <- map["formaPagamento"]
    }
}
