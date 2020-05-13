//
//  Paciente.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-06.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import ObjectMapper

class Paciente: Mappable, Encodable {
    var id: Int?
    var nome: String?
    var dataNascimento: String?
    var telefone: String?
    var rg: String?
    var cpf: String?
    var endereco: Endereco?
    
    required init?(map: Map) {
    }
    
    init() {
    }
    
    init(withId: Int, withNome: String, withDataNascimento: String, withTelefone: String, withRg: String, withCpf: String, withEndereco: Endereco) {
        self.id = withId
        self.nome = withNome
        self.dataNascimento = withDataNascimento
        self.telefone = withTelefone
        self.rg = withRg
        self.cpf = withCpf
        self.endereco = withEndereco
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        nome <- map["nome"]
        dataNascimento <- map["dataNascimento"]
        telefone <- map["telefone"]
        rg <- map["rg"]
        cpf <- map["cpf"]
        endereco <- map["endereco"]
    }
}
