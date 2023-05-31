//
//  StudyViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/7.
//

//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=0500cfba-0b72-408d-be8f-28ac616c8696&fromEditor=true

import UIKit
import WebKit
import AVKit

class StudyViewController: UIViewController {
    
    var studyId = ""
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var web: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        getStudyDetils()
    }
    
    func setUI() {
        self.title = "Dica do dia"
    }
    
    func getStudyDetils() {
        let dic = [
            "studyId" :studyId
        ]
        
        startLoading(transparent: false)
        NetWork.request(.getStudyDetils,
                        modelType: GetStudyDetilsData.self,
                        parameters: dic) { result, model, msg in
            if let model = model {
                self.config(model.detils)
                self.stopLoading()
            } else {
                self.showError()
            }
        }
    }
    
    func config(_ data:StudyDetilsData) {
        
        if let url = URL(string: NetWork.baseURL + data.videoUrl) {
            let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            playerViewController.view.frame = thumbnail.frame
            self.addChild(playerViewController)
            thumbnail.superview?.addSubview(playerViewController.view)
        } else {
            thumbnail.load(data.thumbnail)
        }
        
        titleLabel.text = data.title
        timeLabel.text = data.updateDate
        web.loadHTMLString(data.content, baseURL: nil)
    }
}
