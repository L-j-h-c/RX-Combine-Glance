//
//  BaseAPI.swift
//  RxNetworking
//
//  Created by Junho Lee on 2022/05/11.
//

import Foundation

import Moya

//Moya 라이브러리의 타겟타입을 기본적으로 종속한 BaseAPI
protocol BaseAPI: TargetType {
    
}
//기본값을 세팅
extension BaseAPI {
    var baseURL: URL {
        //서버의 URL을 리턴해주는 싱글톤 패턴
        let serverURL = "https://asia-northeast3-vegin-2a51e.cloudfunctions.net/api/post/34"
        //기본 URL 세팅
        return URL(string: serverURL)!
    }
    
    var path: String {
        return ""
    }
    
    // method 이 없을경우 기본적으로
    var method: Moya.Method { .get }
    
    var sampleData: Data { Data() }
    
    var task: Task { .requestPlain }
    
    var headers: [String: String]? { ["Content-Type" : "application/json", "accesstoken" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzcsImVtYWlsIjoicnhzd2lmdEBnbWFpbC5jb20iLCJuaWNrbmFtZSI6IuyVjO2MjOqzoCIsImZpcmViYXNlSWQiOiJ0TkduU2NUQk1FZ09keUExbjBVREFTNDVEazIyIiwiaWF0IjoxNjUxNzI1MjI3LCJleHAiOjE2NjAzNjUyMjcsImlzcyI6InZlZ2luIn0.AMMoc813wUVe8wa65-39EqQmUZ5dWP9CtI2hTgenXP0"] }
}
