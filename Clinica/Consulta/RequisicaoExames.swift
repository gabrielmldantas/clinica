//
//  RequisicaoExames.swift
//  Clinica
//
//  Created by Gabriel Morrison on 2020-06-03.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import ObjectMapper

class RequisicaoExames: Mappable, Encodable {

    var id: Int?
    var descricao: String?
    var data: String?
    
    required init?(map: Map) {
    }
    
    init() {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        descricao <- map["descricao"]
        data <- map["data"]
    }
}
