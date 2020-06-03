//
//  FormaPagamentoService.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-06.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import AlamofireObjectMapper
import Alamofire

class FormaPagamentoService: NSObject {

    private let baseUrl = "\(Constants.url)/formapagamento"
    
    let headers: HTTPHeaders = [
        .accept("application/json")
    ]
    
    func loadFormasPagamento(
        completionHandler: @escaping (DataResponse<CrudResultsResponse<FormaPagamento>, AFError>) -> Void) -> DataRequest {
        
        return AF
            .request(baseUrl, headers: headers)
            .validate()
            .responseObject(completionHandler: completionHandler)
    }
    
    func createFormaPagamento(_ formaPagamento: FormaPagamento,
        completionHandler: @escaping
        (DataResponse<FormaPagamento, AFError>) -> Void) -> DataRequest {
        
        return AF
        .request(baseUrl,
                 method: .post,
                 parameters: formaPagamento,
                 encoder: JSONParameterEncoder.default,
                 headers: headers)
        .validate()
        .responseObject(completionHandler: completionHandler)
    }
    
    func updateFormaPagamento(_ formaPagamento: FormaPagamento,
        completionHandler: @escaping
        (DataResponse<FormaPagamento, AFError>) -> Void) -> DataRequest {
        
        return AF
        .request("\(baseUrl)/\(formaPagamento.id!)",
                 method: .put,
                 parameters: formaPagamento,
                 encoder: JSONParameterEncoder.default,
                 headers: headers)
        .validate()
        .responseObject(completionHandler: completionHandler)
    }
    
    func deleteFormaPagamento(_ idFormaPagamento: Int, completionHandler: @escaping (DataResponse<Data?, AFError>) -> Void) -> DataRequest {
        return AF
        .request("\(baseUrl)/\(idFormaPagamento)",
                 method: .delete,
                 headers: headers)
        .validate()
        .response(completionHandler: completionHandler)
    }
}
