//
//  MergeSwitchLatest.swift
//  RXPractice
//
//  Created by Junho Lee on 2022/04/26.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class MergeSwitchLatestVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    let one = PublishSubject<String>()
    let two = PublishSubject<String>()
    let three = PublishSubject<String>()
    let source = PublishSubject<Observable<String>>()
    
    // switch 기능 + SwitchLatest
    let firstTFBehavior = BehaviorRelay<String>(value: " ")
    let secondTFBehavior = BehaviorRelay<String>(value: " ")
    lazy var switchSource = BehaviorSubject<BehaviorRelay<String>>(value: firstTFBehavior)
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "SwitchLatest"
        lb.backgroundColor = .systemYellow
        lb.layer.cornerRadius = 5
        lb.clipsToBounds = true
        return lb
    }()
    
    private let mySwitch: UISwitch = {
        let sw = UISwitch()
        return sw
    }()
    
    private let testLabel: UILabel = {
        let lb = UILabel()
        lb.text = "테스트 라벨"
        lb.backgroundColor = .systemYellow
        lb.layer.cornerRadius = 5
        lb.clipsToBounds = true
        return lb
    }()
    
    private lazy var firstTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.textColor = .black
        return tf
    }()

    private lazy var secondTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.textColor = .black
        return tf
    }()
    
    private lazy var nextButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("메인 화면으로", for: .normal)
        bt.addAction(UIAction(handler: { _ in
            self.dismiss(animated: true)
        }), for: .touchUpInside)
        bt.setTitleColor(UIColor.black, for: .normal)
        return bt
    }()
    
    private let mergeLabel: UILabel = {
        let lb = UILabel()
        lb.text = "테스트 라벨"
        lb.backgroundColor = .systemYellow
        lb.layer.cornerRadius = 5
        lb.clipsToBounds = true
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureUI()
        testSwitchLatestByConsole()
        bind()
        setLayout()
    }
    
    private func configureUI() {
        view.backgroundColor = .lightGray
    }
    
    private func testSwitchLatestByConsole() {
        source
            .switchLatest()
            .subscribe(onNext: { value in print(value) })
            .disposed(by: disposeBag)
        
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
    
    private func bind() {
        
        // MARK: SwitchLatest Operator 예시
        
        firstTextField.rx.text.orEmpty
            .bind(to: firstTFBehavior)
            .disposed(by: disposeBag)
        
        secondTextField.rx.text.orEmpty
            .bind(to: secondTFBehavior)
            .disposed(by: disposeBag)
        
        mySwitch.rx.isOn
            .subscribe(onNext: { isOn in
                isOn
                ? self.switchSource.onNext(self.secondTFBehavior)
                : self.switchSource.onNext(self.firstTFBehavior)
            })
            .disposed(by: disposeBag)
        
        switchSource
            .switchLatest()
            .map { "SwitchLatest : " + $0 }
            .asDriver(onErrorJustReturn: "오류")
            .drive(testLabel.rx.text)
            .disposed(by: disposeBag)
        
        // MARK: Merge 기능
//        let observable = Observable.of(firstTextField.rx.text, secondTextField.rx.text)
        Observable.of(firstTFBehavior, secondTFBehavior)
            .merge()
            .map { "Merge : " + $0 }
            .bind(to: mergeLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

extension MergeSwitchLatestVC {
    private func setLayout() {
        view.addSubview(titleLabel)
        view.addSubview(mySwitch)
        view.addSubview(testLabel)
        view.addSubview(firstTextField)
        view.addSubview(secondTextField)
        view.addSubview(nextButton)
        view.addSubview(mergeLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(70)
        }
        
        mySwitch.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(200)
        }
        
        testLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mySwitch.snp.bottom).offset(30)
        }
        
        firstTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(testLabel.snp.bottom).offset(50)
            make.width.equalTo(300)
        }
        
        secondTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(firstTextField.snp.bottom).offset(30)
            make.width.equalTo(300)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(secondTextField.snp.bottom).offset(50)
        }
        
        mergeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nextButton.snp.bottom).offset(50)
        }
    }
}
