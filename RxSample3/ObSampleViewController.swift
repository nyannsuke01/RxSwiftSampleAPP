//
//  ObSampleViewController.swift
//  RxSample3
//
//

import UIKit
import RxSwift
import RxCocoa

class ObSampleViewController: UIViewController {

    let inputText = Variable<String>("")        // 入力テキスト用
    let submitTrigger = PublishSubject<Void>()  // 送信処理定義用
    let disposeBag = DisposeBag()               // メモリ解放用

    @IBOutlet weak var textView: UITextView!   // 入力欄
    @IBOutlet weak var restLabel: UILabel!     // 文字数表示ラベル
    @IBOutlet weak var submitButton: UIButton! // 送信ボタン

    override func viewDidLoad() {
        super.viewDidLoad()

        // 入力欄の内容をinputTextにbind
        self.textView.rx.text.orEmpty.bind(to: self.inputText).disposed(by: disposeBag)

        // inputTextを監視
        self.inputText.asObservable().subscribe(onNext: { [weak self] str in
            self?.submitButton.isEnabled = str.count > 10
            self?.restLabel.text = "残り\(200-str.count)文字"
        }).disposed(by: disposeBag)

        // 送信ボタン押下時に実行される処理を定義
        submitTrigger
            .subscribe(onNext: {
                print("送信処理を実行します")
            }).disposed(by: disposeBag)

        // 送信ボタン押下時にsubmitTriggerの処理内容を実行
        submitButton.rx.tap.asDriver()
            .drive(self.submitTrigger)
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
