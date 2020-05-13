//
//  EspecialidadeService.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-06.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import AlamofireObjectMapper
import Alamofire

class EspecialidadeService: NSObject {

    private let baseUrl = "\(Constants.url)/especialidade"
    
    let headers: HTTPHeaders = [
        .accept("application/json")
    ]
    
    func loadEspecialidades(
        completionHandler: @escaping (DataResponse<CrudResultsResponse<Especialidade>, AFError>) -> Void) -> DataRequest {
        
        return AF
            .request(baseUrl, headers: headers)
            .validate()
            .responseObject(completionHandler: completionHandler)
    }
    
    func createEspecialidade(_ especialidade: Especialidade,
        completionHandler: @escaping
        (DataResponse<Especialidade, AFError>) -> Void) -> DataRequest {
        
        return AF
        .request(baseUrl,
                 method: .post,
                 parameters: especialidade,
                 encoder: JSONParameterEncoder.default,
                 headers: headers)
        .validate()
        .responseObject(completionHandler: completionHandler)
    }
    
    func updateEspecialidade(_ especialidade: Especialidade,
        completionHandler: @escaping
        (DataResponse<Especialidade, AFError>) -> Void) -> DataRequest {
        
        return AF
        .request("\(baseUrl)/\(especialidade.id!)",
                 method: .put,
                 parameters: especialidade,
                 encoder: JSONParameterEncoder.default,
                 headers: headers)
        .validate()
        .responseObject(completionHandler: completionHandler)
    }
    
    func deleteEspecialidade(_ idEspecialidade: Int, completionHandler: @escaping (DataResponse<Data?, AFError>) -> Void) -> DataRequest {
        return AF
        .request("\(baseUrl)/\(idEspecialidade)",
                 method: .delete,
                 headers: headers)
        .validate()
        .response(completionHandler: completionHandler)
    }
}
