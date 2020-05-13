//
//  Cobertura.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-06.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import AlamofireObjectMapper
import Alamofire

class CoberturaService: NSObject {

    private let baseUrl = "\(Constants.url)/cobertura"
    
    let headers: HTTPHeaders = [
        .accept("application/json")
    ]
    
    func loadCoberturas(
        completionHandler: @escaping (DataResponse<CrudResultsResponse<Cobertura>, AFError>) -> Void) -> DataRequest {
        
        return AF
            .request(baseUrl, headers: headers)
            .validate()
            .responseObject(completionHandler: completionHandler)
    }
    
    func createCobertura(_ cobertura: Cobertura,
        completionHandler: @escaping
        (DataResponse<Cobertura, AFError>) -> Void) -> DataRequest {
        
        return AF
        .request(baseUrl,
                 method: .post,
                 parameters: cobertura,
                 encoder: JSONParameterEncoder.default,
                 headers: headers)
        .validate()
        .responseObject(completionHandler: completionHandler)
    }
    
    func updateCobertura(_ cobertura: Cobertura,
        completionHandler: @escaping
        (DataResponse<Cobertura, AFError>) -> Void) -> DataRequest {
        
        return AF
        .request("\(baseUrl)/\(cobertura.id!)",
                 method: .put,
                 parameters: cobertura,
                 encoder: JSONParameterEncoder.default,
                 headers: headers)
        .validate()
        .responseObject(completionHandler: completionHandler)
    }
    
    func deleteCobertura(_ idCobertura: Int, completionHandler: @escaping (DataResponse<Data?, AFError>) -> Void) -> DataRequest {
        return AF
        .request("\(baseUrl)/\(idCobertura)",
                 method: .delete,
                 headers: headers)
        .validate()
        .response(completionHandler: completionHandler)
    }
}
