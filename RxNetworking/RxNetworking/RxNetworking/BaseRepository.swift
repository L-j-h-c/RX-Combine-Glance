//
//  BaseRepository.swift
//  RxNetworking
//
//  Created by Junho Lee on 2022/05/11.
//

import Foundation

import RxSwift
import RxMoya
import Moya

class BaseRepository<API: TargetType> {
    let disposeBag = DisposeBag()
    private let provider = MoyaProvider<API>()
    lazy var rx = provider.rx
}
