//
//  SimpleMVVMViewModel.swift
//  RXPractice
//
//  Created by Junho Lee on 2022/08/18.
//

import RxSwift
import RxCocoa

final class SimpleMVVMViewModel: ViewModelType {

    private let disposeBag = DisposeBag()
  
    // MARK: - Inputs
    
    struct Input {
        let sampleTextFieldChanged: Observable<String>
    }
  
    // MARK: - Outputs
    
    struct Output {
        var sampleLabelString = PublishSubject<String>()
    }
  
    init() {
        
    }
}

extension SimpleMVVMViewModel {
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.sampleTextFieldChanged.subscribe { textFieldValue in
            if let receivedText = textFieldValue.element {
                let newString = receivedText + "뷰모델에서 스트링 더해줬습니다"
                output.sampleLabelString.onNext(newString)
            }
        }
        
        return output
    }
}
