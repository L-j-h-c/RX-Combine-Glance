//
//  SecondVC.swift
//  RxTableView
//
//  Created by Junho Lee on 2022/05/04.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class SecondVC: UIViewController {
    
    // MARK: - Properties
    
    var posts = BehaviorRelay<[Chocolate]>(value: Chocolate.ofEurope)
    
    var disposeBag = DisposeBag()
    
    private let myTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemGreen
        return tv
    }()
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 20)
        lb.backgroundColor = .systemGray5
        lb.layer.borderColor = UIColor.black.cgColor
        lb.layer.cornerRadius = 6
        lb.layer.borderWidth = 1
        lb.text = "선택하세요"
        lb.textAlignment = .center
        return lb
    }()
    
    private lazy var nextButton: UIButton = {
        let bt = UIButton()
        bt.setTitleColor(.black, for: .normal)
        bt.setTitle("다음 화면", for: .normal)
        bt.addAction(UIAction(handler: { _ in
            let nextVC = SecondVC()
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
        
        posts.observe(on: MainScheduler.instance)
            .scan([], accumulator: { $0 + $1 })
            .bind(to: myTableView.rx.items) { tableView, row, item in
                if(row < 2) {
                    guard let cell = self.myTableView.dequeueReusableCell(withIdentifier: MainTVC.Identifier) as? MainTVC else { return UITableViewCell() }
                    cell.bind(chocolate: item)
                    return cell
                } else {
                    guard let cell = self.myTableView.dequeueReusableCell(withIdentifier: SecondTVC.Identifier) as? SecondTVC else { return UITableViewCell() }
                    cell.bind(chocolate: item)
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        Observable.zip(myTableView.rx.modelSelected(Chocolate.self), myTableView.rx.itemSelected)
            .bind { (item, indexPath) in
                self.titleLabel.text = item.countryName
            }
            .disposed(by: disposeBag)
        
    }
    
    private func setDelegate() {
        
    }
    
    private func setLayout() {
        view.addSubview(myTableView)
        view.addSubview(titleLabel)
        view.addSubview(nextButton)
        
        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(54)
        }
        
        myTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-5)
        }
    }
}

extension SecondVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        textField.text = ""
        return true
    }
}
