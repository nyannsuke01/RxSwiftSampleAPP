//
//  UISampleViewController.swift
//  RxSample3
//
//

import UIKit
import RxSwift
import RxCocoa

class UISampleViewController: UIViewController {

    @IBOutlet weak var sampleButton: UIButton!
    @IBOutlet weak var sampleSwitch: UISwitch!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        sampleButton.rx.tap.asDriver().drive(
            onNext: {
                print( " tap " )
        }
            ).disposed(by: disposeBag)

        sampleSwitch.rx.isOn.asDriver().drive(
            onNext: { bool in
                print( bool ? " ON " : " OFF " )
        }
            ).disposed(by: disposeBag)
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
