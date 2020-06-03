//
//  ConsultaService.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-16.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import AlamofireObjectMapper
import Alamofire

class ConsultaService: NSObject {
    private let baseUrl = "\(Constants.url)/consulta"
    
    let headers: HTTPHeaders = [
        .accept("application/json")
    ]
    
    func loadConsultas(
        completionHandler: @escaping (DataResponse<CrudResultsResponse<Consulta>, AFError>) -> Void) -> DataRequest {
        
        return AF
            .request(baseUrl, headers: headers)
            .validate()
            .responseObject(completionHandler: completionHandler)
    }
    
    func createConsulta(_ consulta: Consulta,
        completionHandler: @escaping
        (DataResponse<Consulta, AFError>) -> Void) -> DataRequest {
        
        return AF
        .request(baseUrl,
                 method: .post,
                 parameters: consulta,
                 encoder: JSONParameterEncoder.default,
                 headers: headers)
        .validate()
        .responseObject(completionHandler: completionHandler)
    }
    
    func updateConsulta(_ consulta: Consulta,
        completionHandler: @escaping
        (DataResponse<Consulta, AFError>) -> Void) -> DataRequest {
        
        return AF
        .request("\(baseUrl)/\(consulta.id!)",
                 method: .put,
                 parameters: consulta,
                 encoder: JSONParameterEncoder.default,
                 headers: headers)
        .validate()
        .responseObject(completionHandler: completionHandler)
    }
    
    func deleteConsulta(_ idConsulta: Int, completionHandler: @escaping (DataResponse<Data?, AFError>) -> Void) -> DataRequest {
        return AF
        .request("\(baseUrl)/\(idConsulta)",
                 method: .delete,
                 headers: headers)
        .validate()
        .response(completionHandler: completionHandler)
    }
    
    func registrarPagamentos(_ idConsulta: Int, registroPagamento: RegistroPagamento, completionHandler: @escaping (DataResponse<Data?, AFError>) -> Void) -> DataRequest {

        return AF
        .request("\(baseUrl)/\(idConsulta)/pagamento",
                 method: .post,
                 parameters: registroPagamento,
                 encoder: JSONParameterEncoder.default,
                 headers: headers)
        .validate()
        .response(completionHandler: completionHandler)
    }
    
    func requisitarExames(_ idConsulta: Int, registroRequisicaoExames: RegistroRequisicaoExames, completionHandler: @escaping (DataResponse<Data?, AFError>) -> Void) -> DataRequest {

        return AF
        .request("\(baseUrl)/\(idConsulta)/exames",
                 method: .post,
                 parameters: registroRequisicaoExames,
                 encoder: JSONParameterEncoder.default,
                 headers: headers)
        .validate()
        .response(completionHandler: completionHandler)
    }
    
    func registrarReceitaMedica(_ idConsulta: Int, registroReceitaMedica: RegistroReceitaMedica, completionHandler: @escaping (DataResponse<Data?, AFError>) -> Void) -> DataRequest {

        return AF
        .request("\(baseUrl)/\(idConsulta)/receita",
                 method: .post,
                 parameters: registroReceitaMedica,
                 encoder: JSONParameterEncoder.default,
                 headers: headers)
        .validate()
        .response(completionHandler: completionHandler)
    }
}
