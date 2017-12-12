//
//  MyCenterNetworkManager.swift
//  DanceSpirit
//
//  Created by zj－db0737 on 2017/12/10.
//  Copyright © 2017年 zj－db0737. All rights reserved.
//

import Foundation
import UIKit
import Result
import Moya
import ObjectMapper

final class MyCenterNetworkManager: NSObject {
    lazy private(set) var provider : MoyaProvider<MultiTarget> = {
        let requestClosure = { (endpoint: Moya.Endpoint<MultiTarget>, done: @escaping Moya.MoyaProvider.RequestResultClosure) in
            if var urlRequest = try? endpoint.urlRequest() {
                urlRequest.timeoutInterval = 30
                
                let urlRequestForReturn = urlRequest
                done(.success(urlRequestForReturn))
            }
        }
        return MoyaProvider<MultiTarget>(requestClosure: requestClosure)
    }()
    
    struct SuccessfulResponse : Mappable {
        var data : [Int] = []
        
        init?(map: Map) {
            
        }
        
        mutating func mapping(map: Map) {
            data          <- map["data"]
        }
    }
}

extension MyCenterNetworkManager {
    typealias RequestDataCompletion = (Result<SuccessfulResponse, MoyaError>) -> Void
    
    func requestData(completion: @escaping MyCenterNetworkManager.RequestDataCompletion) {
        let target: MyCenterServerAPI = .requestList()
        self.provider.request(MultiTarget(target), callbackQueue: .global(qos: .default)) { result in
            switch result {
            case let .success(moyaResponse):
                if let strJSONResponse = try? moyaResponse.mapString(), !strJSONResponse.isEmpty,
                    let response = Mapper<SuccessfulResponse>().map(JSONString: strJSONResponse) {
                    completion(.success(response))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}


