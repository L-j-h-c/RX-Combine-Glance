//
//  MainTVC.swift
//  RxTableView
//
//  Created by Junho Lee on 2022/05/04.
//

import UIKit
import RxSwift

class MainTVC: UITableViewCell {
    
    // MARK: - Properties
    
    static let Identifier = "MainTVC"
    
    private let chatLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 15)
        return lb
    }()
    
    private let emojiLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 15)
        return lb
    }()
    
    // MARK: - View Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.backgroundColor = .systemYellow
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Methods
    
    func bind(chocolate: Chocolate) {
        chatLabel.text = chocolate.countryName
        emojiLabel.text = chocolate.countryFlagEmoji
    }
    
    private func setLayout() {
        self.addSubview(chatLabel)
        self.addSubview(emojiLabel)
        
        chatLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }
        
        emojiLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }

}
