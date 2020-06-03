//
//  RegistroRequisicaoExames.swift
//  Clinica
//
//  Created by Gabriel Morrison on 2020-06-03.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import ObjectMapper

class RegistroRequisicaoExames: Mappable, Encodable {

    var descricao: String?
    
    required init?(map: Map) {
    }
    
    init() {
    }
    
    func mapping(map: Map) {
        descricao <- map["descricao"]
    }
}
