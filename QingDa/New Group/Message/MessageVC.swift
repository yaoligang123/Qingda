//
//  MessageVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/11/26.
//

import UIKit

class MessageVC: UIViewController {
    
    var items: [MessageListItem] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        messageList()
    }
    
    func messageList() {
        let dic = [
            "pageNumber" : 1,
            "pageSize" : 100
        ]
        NetWork.request(.messageList,
                        modelType: MessageListResponse.self,
                        parameters: dic) { result, model, msg in
            if let model = model {
                self.items = model.records
                self.tableView.reloadData()
            }
        }
    }
    
    func setUI() {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 164)
        gradient.colors = [HEX("#FDECD9").cgColor, HEX("FEF4E8").cgColor, HEX("FFFFFF").cgColor]
        gradient.locations = [0, 0.57, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradient, at: 0)
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
    }
}

extension MessageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.config(item: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].state = "1"
        tableView.reloadData()
        updateMessageState(id: items[indexPath.row].id)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func updateMessageState(id: String) {
        let dic = [
            "id" : id,
        ]
        NetWork.request(.updateMessageState,
                        modelType: NoneResponseData.self,
                        parameters: dic) { result, model, msg in
            if let _ = model {
            }
        }
    }
    
}
