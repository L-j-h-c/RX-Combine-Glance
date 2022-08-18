//
//  SimpleMVVMVC.swift
//  RXPractice
//
//  Created by Junho Lee on 2022/08/18.
//

import UIKit

import RxSwift
import SnapKit

class SimpleMVVMVC: UIViewController {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    var viewModel: SimpleMVVMViewModel!
  
    // MARK: - UI Components
    
    private let sampleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let sampleTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .systemPink
        return tf
    }()
    
    private let kakaoLoginButton = UIButton()
  
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
        setLayout()
    }
}

// MARK: - Methods

extension SimpleMVVMVC {
    
    private func setLayout() {
        self.view.addSubview(sampleLabel)
        self.view.addSubview(sampleTextField)
        
        sampleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.centerX.equalToSuperview()
        }
        
        sampleTextField.snp.makeConstraints { make in
            make.top.equalTo(sampleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
    }
  
    private func bindViewModels() {
        self.viewModel = SimpleMVVMViewModel()
        
        let input = SimpleMVVMViewModel.Input(sampleTextFieldChanged: sampleTextField.rx.text.orEmpty.asObservable(),
                                              kakaoLoginButtonTapped: kakaoLoginButton.rx.tap.asObservable())
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.sampleLabelString.asDriver(onErrorJustReturn: "")
            .drive() {
                self.sampleLabel.text = $0
            }.disposed(by: disposeBag)
    }

}
