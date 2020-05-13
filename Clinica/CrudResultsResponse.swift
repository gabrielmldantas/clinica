//
//  CrudResultsResponse.swift
//  Clinica
//
//  Created by Gabriel on 2020-05-06.
//  Copyright © 2020 Gabriel. All rights reserved.
//

import ObjectMapper

class CrudResultsResponse<T: Mappable>: Mappable {
    
    var results = [T]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        results <- map["results"]
    }
}
