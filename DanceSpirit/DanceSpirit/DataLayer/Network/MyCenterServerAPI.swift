//
//  MyCenterServerAPI.swift
//  DanceSpirit
//
//  Created by zj－db0737 on 2017/12/10.
//  Copyright © 2017年 zj－db0737. All rights reserved.
//

import Foundation
import Alamofire
import Moya

enum MyCenterServerAPI {
    case requestList()
}

extension MyCenterServerAPI : TargetType {
    var baseURL: URL {
        let str:String = "https://www.easy-mock.com/mock/5a2ce8e9b1f96e7063596c9e/dancespirit"
        return URL(string: str)!
    }

    var path: String {
        switch self {
        case .requestList():
            return "/test"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .requestList():
            return .get
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .requestList():
            return URLEncoding.default // Send parameters in URL
        }
    }
    
    var sampleData: Data {
        switch self {
        case .requestList():
            return "{}".data(using: .utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .requestList():
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
