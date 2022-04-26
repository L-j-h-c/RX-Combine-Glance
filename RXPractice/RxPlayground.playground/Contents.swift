//import UIKit
//import RxSwift
//import RxCocoa
//public func example(of description: String, action: () -> Void) {
//  print("\n--- Example of:", description, "---")
//  action()
//}
//
//example(of: "just, of, from") {
//    // 1
//    let one = 1
//    let two = 2
//    let three = 3
//
//    // 2
//    let observable = Observable<Int>.just(one)
//    let observable2 = Observable.of(one, two, three)
//    let observable3 = Observable.of([one, two, three])
//    let observable4 = Observable.from([one, two, three])
//
//    observable.asObservable().asDriver(onErrorJustReturn: 3)
//        .drive()
//}
//
//example(of: "subscribe") {
//    let one = 1
//    let two = 2
//    let three = 3
//
//    let observable = Observable.of(one, two, three)
//
//    observable.subscribe { event in
//        print(event)
//    }
//}
//
//example(of: "create") {
//    Observable<String>.create { observer in
//      // 1
//      observer.onNext("1")
//
//      // 2
//      observer.onCompleted()
//
//      // 3
//      observer.onNext("?")
//
//      // 4
//      return Disposables.create()
//    }.subscribe(onNext: { t in
//        print(t)
//    }).dispose()
//
//    let subject = BehaviorSubject<String>(value: "나다")
//
//    let subscriptionOne = subject
//        .subscribe(onNext: { _ in
//            print("하이")
//        })
//    try? print(subject.value())
//
//
//    let relay = BehaviorRelay<String>(value: "너다")
//    let disposeBag = DisposeBag()
//
//    relay
//      .subscribe(onNext: {
//    print($0) })
//      .disposed(by: disposeBag)
//    relay.accept("1")
//    print(relay.value)
//}
