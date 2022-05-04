//
//  ThirdVC.swift
//  RxTableView
//
//  Created by Junho Lee on 2022/05/04.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class ThirdVC: UIViewController {
    
    // MARK: - Properties
    
    var posts = BehaviorRelay<[Chocolate]>(value: Chocolate.ofEurope)
    
    var disposeBag = DisposeBag()
    
    private let myTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemGreen
        return tv
    }()
    
    private lazy var nextButton: UIButton = {
        let bt = UIButton()
        bt.setTitleColor(.black, for: .normal)
        bt.setTitle("다음 화면", for: .normal)
        bt.addAction(UIAction(handler: { _ in
            let nextVC = SecondVC()
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true)
        }), for: .touchUpInside)
        return bt
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        
        view.backgroundColor = .systemGray5
        
        setTableView()
        setLayout()
        setDelegate()
    }
    
    private func setTableView() {
        myTableView.register(MainTVC.self, forCellReuseIdentifier: MainTVC.Identifier)
        myTableView.register(SecondTVC.self, forCellReuseIdentifier: SecondTVC.Identifier)
        myTableView.isEditing = true
        
        posts.observe(on: MainScheduler.instance)
            .bind(to: myTableView.rx.items(cellIdentifier: MainTVC.Identifier, cellType: MainTVC.self)) { index, item, cell in
                cell.bind(chocolate: item)
            }
            .disposed(by: disposeBag)
        
        myTableView.rx.itemMoved .bind { sourceIndexPath, destinationIndexPath in
            var items = self.posts.value
            let item = items.remove(at: sourceIndexPath.row)
            items.insert(item, at: destinationIndexPath.row)
            self.posts.accept(items)
        }
        .disposed(by: disposeBag)
        
    }
    
    private func setDelegate() {
        
    }
    
    private func setLayout() {
        view.addSubview(myTableView)
        view.addSubview(nextButton)
        
        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(54)
        }
        
        myTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ThirdVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        textField.text = ""
        return true
    }
}
