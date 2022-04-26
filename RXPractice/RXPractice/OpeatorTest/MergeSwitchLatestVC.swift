//
//  MergeSwitchLatest.swift
//  RXPractice
//
//  Created by Junho Lee on 2022/04/26.
//

import UIKit

import RxSwift
import RxCocoa

class MergeSwitchLatestVC: UIViewController {
    
    let one = PublishSubject<String>()
    let two = PublishSubject<String>()
    let three = PublishSubject<String>()
    let source = PublishSubject<Observable<String>>()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureUI()
        let observable = source.switchLatest()
        let disposable = observable.subscribe(onNext: { value in print(value) })
        bind()
    }
    
    private func configureUI() {
        view.backgroundColor = .lightGray
    }
    
    private func bind() {
        source.onNext(one) // switched one
        one.onNext("one 1") // one 1
        two.onNext("two 1") //
        
        source.onNext(two) // switched two
        two.onNext("two 2") // two 2
        one.onNext("one 2") //
        
        source.onNext(three) // switched three
        two.onNext("two 3") //
        one.onNext("one 3") //
        three.onNext("three 1") // three 1
        
        source.onNext(one) // switched one
        one.onNext("one 4") // one 4
    }

}
