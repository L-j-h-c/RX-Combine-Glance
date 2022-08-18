//
//  MoyaRouter.swift
//  RxNetworking
//
//  Created by Junho Lee on 2022/05/11.
//

import Foundation

import Moya

enum MoyaRouter  {
    ///클라이메이트 서비스에서 최근 업데이트 모델을 요청
    case getPostData
}

extension MoyaRouter: BaseAPI {
    
// 파라미터값을 제작
    
    public var method: Moya.Method {
// 파라미터값을 통신요청 타입을 제작
        switch self {
        case .getPostData:
            return .get
        }
    }
}
