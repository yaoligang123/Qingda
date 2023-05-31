//
//  DownloadVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/29.
//

import UIKit

class DownloadVC: UIViewController {
    
    var items: [GetMyDownItem] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        getMyDown()
    }
    
    func setUI() {
        self.title = "我的下载"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.register(UINib(nibName: "DownloadCell", bundle: nil), forCellReuseIdentifier: "DownloadCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }


    func getMyDown() {
        let dic = [
            "pageNumber" : 1,
            "pageSize" : 100,
        ]
        NetWork.request(.getMyDown,
                        modelType: GetMyDownResponse.self,
                        parameters: dic) { result, model, msg in
            if let model = model {
                self.items = model.records
                self.tableView.reloadData()
            }
        }
    }
}

extension DownloadVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadCell", for: indexPath) as! DownloadCell
        cell.config(items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        174
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
