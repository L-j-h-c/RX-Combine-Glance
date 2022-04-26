//
//  TextFieldTestVC.swift
//  RXPractice
//
//  Created by Junho Lee on 2022/04/26.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class TextFieldTestVC: UIViewController {
    
    private let mySubject = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    private let mytableView = UITableView()
    
    private let testLabel: UILabel = {
        let lb = UILabel()
        lb.text = "테스트 라벨"
        lb.backgroundColor = .systemYellow
        lb.layer.cornerRadius = 5
        lb.clipsToBounds = true
        return lb
    }()
    
    private lazy var testButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("테스트 버튼", for: .normal)
        bt.setTitleColor(.blue, for: .normal)
        return bt
    }()
    
    private lazy var myTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.textColor = .black
        return tf
    }()
    
    private lazy var nextButton: UIButton = {
        let bt = UIButton()
        bt.setTitle("다음 화면으로", for: .normal)
        bt.addAction(UIAction(handler: { _ in
            let nextVC = MergeSwitchLatestVC()
            nextVC.modalPresentationStyle = .overFullScreen
            self.present(nextVC, animated: true)
        }), for: .touchUpInside)
        bt.setTitleColor(UIColor.black, for: .normal)
        return bt
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setLayout()
        bind()
    }
    
    private func bind() {
        // MARK: 텍스트필드 입력 수 제한하기
        // 1. 컨트롤 이벤트 이용
        myTextField.rx.controlEvent(.editingChanged).subscribe(onNext: { [unowned self] in
            if let text = self.myTextField.text {
                self.myTextField.text = String(text.prefix(15))
            }
        }).disposed(by: disposeBag)
        
        // 2. rx.text 및 scan 이용
//        myTextField.rx.text.orEmpty
//        .scan("") { (previous, new) -> String in
//            if new.count > 10 {
//                return previous ?? String(new.prefix(10))
//            } else {
//                return new
//            }
//        }
//        .subscribe(myTextField.rx.text)
//        .disposed(by: disposeBag)
        
        // 텍스트필드 글자 수 표시하기
        myTextField.rx.text.orEmpty
            .map { "\($0.count)" }
            .subscribe(testLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        view.backgroundColor = .lightGray
        
        testButton.addTarget(self, action: #selector(changeLabel), for: .touchUpInside)
    }
    
    @objc
    private func changeLabel() {
        testLabel.text = "바꿈"
        mySubject.on(.next("Is anyone here?"))
    }

}

extension TextFieldTestVC {
    private func setLayout() {
        view.addSubview(testLabel)
        view.addSubview(testButton)
        view.addSubview(myTextField)
        view.addSubview(nextButton)
        
        testLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(200)
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

