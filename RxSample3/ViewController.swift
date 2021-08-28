//
//  ViewController.swift
//  RxSample3
//
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // 初期化
        let subject = PublishSubject<String>()
        // subscribeでイベントが発生した際の処理を先に定義
        subject.subscribe({ print($0) }).disposed(by: disposeBag)
        // イベントを発生
        subject.on(.next("a"))
        subject.on(.next("b"))
        subject.on(.next("c"))
        subject.onCompleted()

        // 初期値を指定して初期化
        let variable = Variable<String>("text")
        // subscribeでイベントが発生した際の処理を先に定義
        variable.asObservable().subscribe(onNext: { print($0)} ).disposed(by: disposeBag)
        // 値を置き換えてonNextイベントを発生
        variable.value = "a"
        variable.value = "b"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

