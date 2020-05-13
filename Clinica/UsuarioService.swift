//
//  UsuarioService.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-13.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import UIKit
import Alamofire

class UsuarioService: NSObject {

    let baseUrl = "\(Constants.url)/usuario"
    let headers: HTTPHeaders = [
        .accept("application/json")
    ]
    
    func createUsuario(_ usuario: Usuario,
        completionHandler: @escaping (DataResponse<Data?, AFError>) -> Void) -> DataRequest {
        
        return AF
        .request(baseUrl,
             method: .post,
             parameters: usuario,
             encoder: JSONParameterEncoder.default,
             headers: headers)
        .validate()
        .response(completionHandler: completionHandler)
    }
    
    func login(username: String, senha: String, completionHandler: @escaping (DataResponse<Usuario, AFError>) -> Void) -> DataRequest {
        var loginInfo = [String: String]()
        loginInfo["username"] = username
        loginInfo["senha"] = senha
        return AF
        .request("\(baseUrl)/login",
            method: .post,
            parameters: loginInfo,
            encoder: JSONParameterEncoder.default,
            headers: headers)
        .validate()
        .responseObject(completionHandler: completionHandler)
    }
}
