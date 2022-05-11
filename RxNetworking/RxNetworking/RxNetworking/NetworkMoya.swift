//
//  NetworkMoya.swift
//  RxNetworking
//
//  Created by Junho Lee on 2022/05/11.
//

import Moya

///통신 객체
final class NetworkMoya: BaseRepository<MoyaRouter> {
    typealias DictionaryType = [String: Any]
    ///싱글톤 제작
    static let shared = NetworkMoya()
    
    /// 아이디로 사용자 정보 가져오기
    /// - Parameters:
    ///   - parameters: 통신에 필요한 파라미터
    /// 테스트서버에서 파라미터에 빈값이 들어올경우
    /// 에러값을 리턴하기때문에 파라미터에 빈값을 넣었을때 빈 제이슨을 넣어줌
    func getRecentUpdateCenter(_ parameters : DictionaryType = ["":""] ,   _ completion: @escaping (Response?, Error?) -> Void) {
        rx.request(.getPostData)
        /// StatusCodes 가 성공인지를 걸러내는 값
            .filterSuccessfulStatusCodes()
            //리턴값의 struct형태를 지정
            .map(Response.self)
            //      .debug()
            //리턴값
            .subscribe(onSuccess: { completion($0, nil) }, onFailure: { completion(nil, $0) })
            .disposed(by: disposeBag)
    }
    
    
}
