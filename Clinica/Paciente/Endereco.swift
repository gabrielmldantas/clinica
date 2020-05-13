//
//  Endereco.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-06.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import ObjectMapper

class Endereco: Mappable, Encodable {
    var id: Int?
    var rua: String?
    var bairro: String?
    var numero: Int?
    
    required init?(map: Map) {
    }
    
    init() {
    }
    
    init(withId: Int, withRua: String, withBairro: String, withNumero: Int) {
        self.id = withId
        self.rua = withRua
        self.bairro = withBairro
        self.numero = withNumero
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        rua <- map["rua"]
        bairro <- map["bairro"]
        numero <- map["numero"]
    }
}
