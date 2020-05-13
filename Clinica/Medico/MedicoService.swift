//
//  MedicoService.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-06.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import AlamofireObjectMapper
import Alamofire

class MedicoService: NSObject {

    private let baseUrl = "\(Constants.url)/medico"
    
    let headers: HTTPHeaders = [
        .accept("application/json")
    ]
    
    func loadMedicos(
        completionHandler: @escaping (DataResponse<CrudResultsResponse<Medico>, AFError>) -> Void) -> DataRequest {
        
        return AF
            .request(baseUrl, headers: headers)
            .validate()
            .responseObject(completionHandler: completionHandler)
    }
    
    func createMedico(_ medico: Medico,
        completionHandler: @escaping
        (DataResponse<Medico, AFError>) -> Void) -> DataRequest {
        
        return AF
        .request(baseUrl,
                 method: .post,
                 parameters: medico,
                 encoder: JSONParameterEncoder.default,
                 headers: headers)
        .validate()
        .responseObject(completionHandler: completionHandler)
    }
    
    func updateMedico(_ medico: Medico,
        completionHandler: @escaping
        (DataResponse<Medico, AFError>) -> Void) -> DataRequest {
        
        return AF
        .request("\(baseUrl)/\(medico.id!)",
                 method: .put,
                 parameters: medico,
                 encoder: JSONParameterEncoder.default,
                 headers: headers)
        .validate()
        .responseObject(completionHandler: completionHandler)
    }
    
    func deleteMedico(_ idMedico: Int, completionHandler: @escaping (DataResponse<Data?, AFError>) -> Void) -> DataRequest {
        return AF
        .request("\(baseUrl)/\(idMedico)",
                 method: .delete,
                 headers: headers)
        .validate()
        .response(completionHandler: completionHandler)
    }
}
