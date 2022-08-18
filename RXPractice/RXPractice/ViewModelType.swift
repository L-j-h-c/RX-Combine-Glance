//
//  ViewModelType.swift
//  RXPractice
//
//  Created by Junho Lee on 2022/08/18.
//

import Foundation
import RxSwift

protocol ViewModelType {
  associatedtype Input
  associatedtype Output
  
  func transform(from input: Input, disposeBag: DisposeBag) -> Output
}
