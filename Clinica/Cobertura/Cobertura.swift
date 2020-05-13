//
//  Cobertura.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-06.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import ObjectMapper

class Cobertura: Mappable, Encodable {
    var id: Int?
    var descricao: String?
    
    required init?(map: Map) {
    }
    
    init() {
    }
    
    init(withId: Int, withDescricao: String) {
        self.id = withId
        self.descricao = withDescricao
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        descricao <- map["descricao"]
    }
}
