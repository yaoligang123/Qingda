//
//  WebViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/5/1.
//

import UIKit
import WebKit
import CleanJSON
import Toaster

enum WebViewType {
    case unknown
    case shijuan(id: String, title: String, pdf: String)
    case cuoti(subject: String)
    case pdf(url: String, title: String)
}

class WebViewController: UIViewController, WKScriptMessageHandler, UIDocumentInteractionControllerDelegate {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.name == "back") {
            self.navigationController?.popViewController(animated: true)
        } else if (message.name == "downLoadInfo") {
            if let body = message.body as? String,
               let jsonData = body.data(using: .utf8) {
                let decoder = CleanJSONDecoder()
                let option = try? decoder.decode([String:String].self, from: jsonData)
                if let objectId = option?["objectId"], let downType = option?["downType"] {
                    let dic = [
                        "objectId" : objectId,
                        "downType" : downType,
                    ]
                    NetWork.request(.downErrorBook,
                                    modelType: NoneResponseData.self,
                                    parameters: dic) { result, model, msg in
                        if let _ = model {
                            
                        }
                    }
                }
            }
        }
    }
    
    
    @IBOutlet weak var webContentView: UIView!
    var webView: WKWebView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var pdfId = ""
    var pdfUrl = ""
    var type = WebViewType.unknown
    var start: TimeInterval = Date().timeIntervalSince1970
    var fileURL: URL?
    var doc:UIDocumentInteractionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let contentController = WKUserContentController()
        contentController.add(self, name: "back")
        contentController.add(self, name: "downLoadInfo")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController

        webView = WKWebView(frame: .zero, configuration: configuration)
        webContentView.addSubview(self.webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leftAnchor.constraint(equalTo: webContentView.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: webContentView.rightAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: webContentView.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: webContentView.bottomAnchor).isActive = true
        
        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if case .cuoti = type {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
        start = Date().timeIntervalSince1970
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if case let .shijuan(id, _, _) = type {
            let time = String(Int(Date().timeIntervalSince1970 - start))
            let dic = [
                "objectId" : id,
                "time" : time,
                "category" : "3"
            ]
            NetWork.request(.updateStudyTimeCount,
                            modelType: NoneResponseData.self,
                            parameters: dic) { result, model, msg in
                if let _ = model {
                    
                }
            }
        }
    }
    
    func load() {
        let url = getUrl()

        if let url = URL.init(string: url) {
            self.webView.load(URLRequest.init(url: url))
        }
    }
        
    func getUrl() -> String{
        let baseURL = "https://app.jingkeys.com/apph5/index.html#/pages/"
        switch type {
        case .unknown:
            return ""
        case let .shijuan(id, title, pdf):
            self.title = title
            let share = UIBarButtonItem(image: IMAGE("组 61415-2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(share))
            
            navigationItem.rightBarButtonItem = share
            if !pdf.isEmpty {
                pdfId = id
                pdfUrl = pdf
                heightConstraint.constant = 70
                let url = getSavedPdf()
                fileURL = url
                if let url = url, !url.absoluteString.isEmpty {
                    return url.absoluteString
                }
                return pdf
            }
            return baseURL + "textpaper/paperDetail#/?id=\(id)&token=\(gToken ?? "")"
        case let .cuoti(subject):
            if let encode = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                return baseURL + "error-book/error-detail#/?subject=\(encode)&token=\(gToken ?? "")"
            }
        case let .pdf(url, title):
            self.title = title
            return url
        }
        return ""
    }
    
    @objc func share() {
        if let fileURL = fileURL {
            let doc = UIDocumentInteractionController.init(url: fileURL)
            doc.delegate = self
            doc.presentOpenInMenu(from: CGRect.zero, in: view, animated: true)
//            doc.uti =
            self.doc = doc
        } else {
            Toast(text: "需要先下载到本地", duration: 0.5).show()
        }
    }
    
    @IBAction func download() {
        Toast(text: "下载开始", duration: 0.5).show()
        savePdf()
    }
    
    func savePdf() {
        if pdfId.isEmpty || pdfUrl.isEmpty {
            return
        }
        DispatchQueue.main.async {
            let url = URL(string: self.pdfUrl)
            let pdfData = try? Data.init(contentsOf: url!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "\(self.pdfId).pdf"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            do {
                try pdfData?.write(to: actualPath, options: .atomic)
                self.fileURL = actualPath
                Toast(text: "下载成功", duration: 0.5).show()
                self.downTestPaper()
            } catch {
                Toast(text: "下载失败", duration: 0.5).show()
            }
        }
    }
    
    func downTestPaper() {
        NetWork.request(.downTestPaper,
                        modelType: NoneResponseData.self,
                        parameters: [
                            "downType" : "1",
                            "objectId" : pdfId
                        ]) { result, model, msg in
            if let _ = model {
            }
        }
    }
    
    func getSavedPdf() -> URL? {
        if #available(iOS 10.0, *) {
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains("\(self.pdfId).pdf") {
                        return url;
                    }
                }
            } catch {
                print("could not locate pdf file !!!!!!!")
            }
        }
        return nil
    }
}
