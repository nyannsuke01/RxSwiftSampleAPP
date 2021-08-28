//
//  WikipediaSearchViewController.swift
//  RxSample3
//
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class WikipediaSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchBar.rx.text.orEmpty
            .filter { $0.count >= 3 }
            .map {
                let urlStr = "https://ja.wikipedia.org/w/api.php?format=json&action=query&list=search&srsearch=\($0)"
                return URL(string:urlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
            }
            .flatMapLatest { URLSession.shared.rx.json(url: $0) }
            .map { self.parseJson($0) }
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { index, result, cell in
                cell.textLabel?.text = result.title
                cell.detailTextLabel?.text = "https://ja.wikipedia.org/w/index.php?curid=\(result.pageid)"
            }
            .disposed(by: disposeBag)

        // セル選択時の処理
        self.tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.tableView.cellForRow(at: indexPath)
                if let urlStr = cell?.detailTextLabel?.text, let url = URL(string: urlStr) {
                    let safariViewController = SFSafariViewController(url: url)
                    self?.present(safariViewController, animated: true)
                }
            }).disposed(by: disposeBag)
    }

    func parseJson(_ json: Any) -> [Result] {
        guard let items = json as? [String: Any] else { return [] }
        var results = [Result]()
        // JSONの階層を追って検索結果を配列で返す
        if let queryItems = items["query"] as? [String:Any] {
            if let searchItems  = queryItems["search"] as? [[String: Any]] {
                searchItems.forEach{
                    guard let title = $0["title"] as? String,
                        let pageid = $0["pageid"] as? Int else {
                        return
                    }
                    results.append(Result(title: title, pageid: pageid))
                }
            }
        }
        return results
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// 検索結果を格納する構造体
struct Result {
    let title: String
    let pageid: Int
}

