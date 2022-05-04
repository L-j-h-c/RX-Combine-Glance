//
//  MainViewController.swift
//  RxTableView
//
//  Created by Junho Lee on 2022/05/04.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private let myTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemGreen
        return tv
    }()
    
    private let chatTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .gray
        tf.layer.borderColor = UIColor.black.cgColor
        tf.layer.borderWidth = 1
        return tf
    }()
    
    var posts = BehaviorRelay<[Chocolate]>(value: Chocolate.ofEurope)
    var disposeBag = DisposeBag()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        
        view.backgroundColor = .systemGray5
        
        setTableView()
        setLayout()
    }
    
    private func setTableView() {
        myTableView.register(MainTVC.self, forCellReuseIdentifier: MainTVC.Identifier)
        
        posts.observe(on: MainScheduler.instance)
            .scan([], accumulator: { $0 + $1 })
            .bind(to: myTableView.rx.items(cellIdentifier: MainTVC.Identifier, cellType: MainTVC.self)) { index, item, cell in
                cell.bind(text: item.countryName)
            }
            .disposed(by: disposeBag)
        
        chatTextField.rx.controlEvent(.editingDidEnd)
            .bind {
                let new = Chocolate(priceInDollars: 0, countryName: self.chatTextField.text ?? "", countryFlagEmoji: "")
                self.posts.accept([new])
            }.disposed(by: disposeBag)
        
        chatTextField.delegate = self
    }
    
    private func setLayout() {
        view.addSubview(myTableView)
        view.addSubview(chatTextField)
        
        myTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        chatTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        textField.text = ""
        return true
    }
}
