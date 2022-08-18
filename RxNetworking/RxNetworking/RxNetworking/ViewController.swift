//
//  ViewController.swift
//  RxNetworking
//
//  Created by Junho Lee on 2022/05/11.
//

import UIKit

import RxSwift
import RxMoya
import Moya

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var testLabel: UILabel!
    
    @IBOutlet weak var testLabel2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bind()
    }
    
    private func bind() {
        downloadJson(urlString: "https://asia-northeast3-vegin-2a51e.cloudfunctions.net/api/post/34")
            .debug()
            .subscribe { event in
                switch event {
                case .next(let postData):
                    DispatchQueue.main.async {
                        self.testLabel.text = postData.content
                        self.testLabel.sizeToFit()
                    }
                case .completed:
                    break
                case .error:
                    break
                }
            }.disposed(by: disposeBag)
        
        fetchData()
    }
    
    func downloadJson(urlString: String) -> Observable<PostData> {
        // 비동기로 생기는 데이터를 Observable로 감싸서 리턴
        return Observable.create { emitter in
            
            guard let url = URL(string: urlString) else {
                print("Error: cannot create URL")
                return Disposables.create()
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzcsImVtYWlsIjoicnhzd2lmdEBnbWFpbC5jb20iLCJuaWNrbmFtZSI6IuyVjO2MjOqzoCIsImZpcmViYXNlSWQiOiJ0TkduU2NUQk1FZ09keUExbjBVREFTNDVEazIyIiwiaWF0IjoxNjUxNzI1MjI3LCJleHAiOjE2NjAzNjUyMjcsImlzcyI6InZlZ2luIn0.AMMoc813wUVe8wa65-39EqQmUZ5dWP9CtI2hTgenXP0", forHTTPHeaderField: "accesstoken")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard error == nil else {
                    emitter.onError(error!)
                    return
                }
                
                guard data != nil else { return }
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Response.self, from: data!)
                    // 데이터 전달
                    let postData = response.data
                    emitter.onNext(postData)
                } catch let error {
                    emitter.onError(error)
                }
                
                // 완료 처리
                emitter.onCompleted()
            }
            task.resume()
            // 취소되었을때 어떻게 처리할건지 전달
            return Disposables.create() {
                task.cancel()
            }
        }
    }
    
    
}

extension ViewController {
    func fetchData() {
        NetworkMoya.shared.getRecentUpdateCenter { postdata, error in
            self.testLabel2.text = postdata?.data.title
            self.testLabel2.sizeToFit()
        }
    }
}
