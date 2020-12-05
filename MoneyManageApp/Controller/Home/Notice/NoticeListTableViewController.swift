//
//  NoticeListTableViewController.swift
//  MoneyManageApp
//
//  Created by yuji nakamoto on 2020/12/04.
//

import UIKit
import EmptyDataSet_Swift

class NoticeListTableViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var noticeArray = [FNotice]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotice()
        setup()
    }

    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Fetch
    
    private func fetchNotice() {
        indicator.startAnimating()
        FNotice.fetchNoticeList { (notice) in
            self.noticeArray.append(notice)
            self.tableView.reloadData()
            self.indicator.stopAnimating()
        }
    }
    
    // MARK: - Helpers
    
    private func setup() {
        tableView.tableFooterView = UIView()
        navigationItem.title = "お知らせ"
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
}

// MARK: - Table view

extension NoticeListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NoticeListTableViewCell

        cell.configureCell(noticeArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            performSegue(withIdentifier: "Notice1VC", sender: nil)
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: "Notice2VC", sender: nil)
        } else if indexPath.row == 2 {
            performSegue(withIdentifier: "Notice3VC", sender: nil)
        } else if indexPath.row == 3 {
            performSegue(withIdentifier: "Notice4VC", sender: nil)
        } else if indexPath.row == 4 {
            performSegue(withIdentifier: "Notice5VC", sender: nil)
        }
    }
}

extension NoticeListTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "お知らせはありません", attributes: attributes)
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return 50
    }
}

extension NoticeListTableViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
