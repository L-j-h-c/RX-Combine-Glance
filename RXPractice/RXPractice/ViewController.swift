//
//  ViewController.swift
//  RXPractice
//
//  Created by Junho Lee on 2022/04/03.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    private let mySubject = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    private let mytableView = UITableView()
    
    private let testLabel: UILabel = {
        let lb = UILabel()
        lb.text = "테스트 ㅋㅋ"
        return lb
    }()
    
    private lazy var testButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("버튼이야", for: .normal)
        bt.setTitleColor(.blue, for: .normal)
        return bt
    }()
    
    private var myButton: UIButton = {
        let bt = UIButton()
        return bt
    }()
    
    private lazy var myTextField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.backgroundColor = .blue
        return tf
    }()
    
    private lazy var nextButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("다음 화면으로", for: .normal)
        bt.addAction(UIAction(handler: { _ in
            let nextVC = MergeSwitchLatestVC()
            self.present(nextVC, animated: true)
        }), for: .touchUpInside)
        return bt
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setLayout()
        makeObservable()
        makeSubject()
    }
    
    private func makeObservable() {
        // Event를 받아옴 인자의 name은 자율로 변경 가능
        let subscription1 = Observable.of(1,2,3).subscribe { t in
            print(t)
        }.dispose()
        
        // Event에 element를 받아서 어떠한 작업을 실행하는 클로저를 등록 가능.
        // func subscribe(onNext: ((Self.Element) -> Void)? = nil, onError: ((Error) -> Void)? = nil, onCompleted: (() -> Void)? = nil, onDisposed: (() -> Void)? = nil) -> Disposable
        let subscription2 = Observable.of(1,2,3).subscribe(onNext: { element in
            print(element)
        }).dispose()
        
        let subscription3 = Observable.of(1,2,3).subscribe(onNext: { t in
            print(t)
        }).dispose()
        
        // 아래의 방법이 Observer를 조금 더 세심하게 설정할 수 있는 거구나.
        Observable<String>.create { observer in
            // observer에 1이라는 element를 가진 Next이벤트를 보내는 것.
            observer.onNext("1")
            observer.onCompleted()
            // 이러한 옵저버를 가지는 Disposable를 아래에서 리턴한다.
            return Disposables.create()
        }
        .subscribe(
            onNext: { print($0) }
        ).dispose()
        
        myTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext:{
                print("감지")
            })
            .disposed(by: disposeBag)
        
        
        myTextField.rx.text
            .asDriver()
            .drive(testLabel.rx.text)
            .disposed(by: disposeBag)
        
        myTextField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext:{
                print("된다")
            })
            .disposed(by: disposeBag)
        

    }
    
    private func makeSubject() {
        // 이처럼 subject에 구독을 하고, 버튼을 누를때마다 event를 추가하면 print가 된다.
        let subscription = mySubject.subscribe(onNext: {
            string in print(string)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now()+10) {
            subscription.dispose()
        }
    }
    
    private func configureUI() {
        testButton.addTarget(self, action: #selector(changeLabel), for: .touchUpInside)
    }
    
    @objc
    private func changeLabel() {
        testLabel.text = "바꿈"
        mySubject.on(.next("Is anyone here?"))
    }

}

extension ViewController {
    private func setLayout() {
        view.addSubview(testLabel)
        view.addSubview(testButton)
        view.addSubview(myTextField)
        view.addSubview(nextButton)
        
        testLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        testButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(testLabel.snp.bottom).offset(30)
        }
        
        myTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(testButton.snp.bottom).offset(50)
            make.width.equalTo(300)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(myTextField.snp.bottom).offset(50)
        }
    }
}
