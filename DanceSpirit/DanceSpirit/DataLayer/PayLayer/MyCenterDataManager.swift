//
//  MyCenterDataManager.swift
//  DanceSpirit
//
//  Created by zj－db0737 on 2017/12/11.
//  Copyright © 2017年 zj－db0737. All rights reserved.
//

import Foundation

final class MyCenterDataManager: NSObject {
    fileprivate var networkManager: MyCenterNetworkManager = MyCenterNetworkManager()
    fileprivate var myCenterDataStorer: MyCenterDataStorer = MyCenterDataStorer()
    
    @objc static let shared = MyCenterDataManager.init()
    private override init() {
        super.init()
    }
}

extension MyCenterDataManager {
    @objc func testTheData () {
        self.requestData { [weak self] result in
            switch result {
            case let .success(successfulResponse):
                print("\(successfulResponse.data)")
            default:
                print("errrrror!")
            }
        }
    }

    func requestData(completion: @escaping MyCenterNetworkManager.RequestDataCompletion) {
        networkManager.requestData(completion:completion)
    }
}
