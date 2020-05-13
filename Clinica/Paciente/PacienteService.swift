//
//  PacienteService.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-06.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import AlamofireObjectMapper
import Alamofire

class PacienteService: NSObject {

    private let baseUrl = "\(Constants.url)/paciente"
    
    let headers: HTTPHeaders = [
        .accept("application/json")
    ]
    
    func loadPacientes(
        completionHandler: @escaping (DataResponse<CrudResultsResponse<Paciente>, AFError>) -> Void) -> DataRequest {
        
        return AF
            .request(baseUrl, headers: headers)
            .validate()
            .responseObject(completionHandler: completionHandler)
    }
    
    func createPaciente(_ paciente: Paciente,
        completionHandler: @escaping
        (DataResponse<Paciente, AFError>) -> Void) -> DataRequest {
        
        return AF
        .request(baseUrl,
                 method: .post,
                 parameters: paciente,
                 encoder: JSONParameterEncoder.default,
                 headers: headers)
        .validate()
        .responseObject(completionHandler: completionHandler)
    }
    
    func updatePaciente(_ paciente: Paciente,
        completionHandler: @escaping
        (DataResponse<Paciente, AFError>) -> Void) -> DataRequest {
        
        return AF
        .request("\(baseUrl)/\(paciente.id!)",
                 method: .put,
                 parameters: paciente,
                 encoder: JSONParameterEncoder.default,
                 headers: headers)
        .validate()
        .responseObject(completionHandler: completionHandler)
    }
    
    func deletePaciente(_ idPaciente: Int, completionHandler: @escaping (DataResponse<Data?, AFError>) -> Void) -> DataRequest {
        return AF
        .request("\(baseUrl)/\(idPaciente)",
                 method: .delete,
                 headers: headers)
        .validate()
        .response(completionHandler: completionHandler)
    }
}
