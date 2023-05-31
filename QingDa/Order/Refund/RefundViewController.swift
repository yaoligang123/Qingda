//
//  RefundViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/2/28.
//

//https://lanhuapp.com/web/#/item/project/detailDetach?pid=d3693407-b39d-4202-b06f-77fb15a220b0&project_id=d3693407-b39d-4202-b06f-77fb15a220b0&image_id=79c7b910-d85b-4cfa-b3b3-e5b1676ba60b&fromEditor=true

//0.0:无售后1.0:退款申请中1.1:退款成功1.2退款失败2.0:退货退款申请中2.1:商家同意2.2商家拒绝2.3用户填写退货单号等待退款2.4退款成功2.5退款失败

import UIKit

enum RefundType {
    case RefundTypeMoney
    case RefundTypeProduct
}


class RefundViewController: UIViewController {
    
    @IBOutlet weak var itemView:ServiceApplyItemView!
    @IBOutlet weak var state:UILabel!
    @IBOutlet weak var productStateRow:TitleValueRow!
    @IBOutlet weak var priceRow:TitleValueRow!
    @IBOutlet weak var deliveryRow:TitleValueRow!
    @IBOutlet weak var deliveryNoRow:TitleValueRow!
    @IBOutlet weak var textRow:TextViewRow!
    @IBOutlet weak var addressView:UIView!
    @IBOutlet weak var returnNamePhone:UILabel!
    @IBOutlet weak var returnAddress:UILabel!
    @IBOutlet weak var deliveryView:UIView!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var editView:UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var isAdd = false
    var imgs: [String] = []
    var type: RefundType = .RefundTypeMoney
    var data: ProductOrderData?
    var afterSaleData: GetOrderAfterSaleData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        getOrderAfterSaleDetils()
    }
    
    func setUI() {
        self.title = "devolução e reembolso"
        
        collectionView.register(UINib(nibName: "RefundImgCell", bundle: nil), forCellWithReuseIdentifier: "RefundImgCell")
        
        productStateRow.textField.placeholder = "Por favor, selecione"
        productStateRow.textField.isUserInteractionEnabled = false
        deliveryRow.textField.isUserInteractionEnabled = false
        priceRow.textField.textColor = HEX(kSubColor1)
        priceRow.textField.isUserInteractionEnabled = false
    }
    
    func getOrderAfterSaleDetils() {
        guard let data = data else {
            return
        }
        startLoading(transparent: false)
        let dic = [
            "orderNumber" : data.orderNumber
        ]
        NetWork.request(.getOrderAfterSaleDetils,
                        modelType: GetOrderAfterSaleDetils.self,
                        parameters: dic) { result, model, msg in
            if let model = model {
                self.afterSaleData = model.detils
                self.config()
                self.stopLoading()
            } else {
                self.showError()
            }
        }
    }
    
    func config() {
        if let model = afterSaleData, let data = data {
            //state
            let returnService = model.returnService
            //let returnService = 2.5
            let service = stateString(returnService: returnService)
            if service.isEmpty {
                state.isHidden = true
            } else {
                state.text = service
            }
            
            //商品
            if data.list.count > 0 {
                let item = data.list[0]
                itemView.title.text = item.title
                itemView.thumbnail.load(item.thumbnail)
                itemView.norm.text = item.norm
                itemView.amount.text = String(item.amount) + " itens"
            }
            
            //写评论
            isAdd = returnService == 0
            if isAdd {
                state.isHidden = true
                addressView.isHidden = true
                deliveryView.isHidden = true
                productStateRow.arrow.isHidden = false
                productStateRow.tapAction = { [weak self] in
                    self?.showPicker()
                }
                collectionView.reloadData()
            } else {
                state.isHidden = false
                textRow.input.isUserInteractionEnabled = false
                productStateRow.arrow.isHidden = true
                productStateRow.textField.isUserInteractionEnabled = false
                productStateRow.textField.text = model.productState
                productStateRow.tapAction = nil
                //退款原因
                textRow.input.text = model.depict
                //上传图片
                imgs = model.image.components(separatedBy: ",")
                collectionView.reloadData()
            }
            
            if returnService == 2.1 {
                addressView.isHidden = false
                returnNamePhone.text = model.returnName + " " + model.returnPhone
                returnAddress.text = model.returnAddress
                editView.isHidden = true
            } else {
                addressView.isHidden = true
                editView.isHidden = false
            }
            
            if returnService == 2.1 || returnService == 2.3 || returnService == 2.4 || returnService == 2.5 {
                deliveryView.isHidden = false
                if returnService == 2.1 {
                    deliveryRow.arrow.isHidden = false
                    deliveryRow.textField.placeholder = "Por favor, selecione"
                    deliveryNoRow.textField.placeholder = "Por favor, entre"
                    deliveryRow.tapAction = { [weak self] in
                        self?.showDeliveryPicker()
                    }
                } else {
                    deliveryRow.arrow.isHidden = true
                    deliveryRow.textField.text = model.expressDelivery
                    deliveryNoRow.isUserInteractionEnabled = false
                    deliveryNoRow.textField.text = model.expressDeliveryNumber
                    deliveryRow.textField.placeholder = ""
                    deliveryNoRow.textField.placeholder = ""
                    deliveryRow.tapAction = nil
                }
            } else {
                deliveryView.isHidden = true
            }
            
            //退款价格
            priceRow.textField.text = kUnit + data.orderPrice
            
            if returnService == 0 || returnService == 1.2 || returnService == 2.1 || returnService == 2.2 || returnService == 2.5 {
                if returnService == 0 || returnService == 2.1 {
                    confirmBtn.setTitle("Enviar", for: .normal)
                } else {
                    confirmBtn.setTitle("Fazer novo requerimento", for: .normal)
                }
                confirmBtn.isHidden = false
            } else {
                confirmBtn.isHidden = true
            }
            changeBtnState(isEnabled:returnService != 0)
            bottomConstraint.constant = confirmBtn.isHidden ? 0 : 108
        }
    }
    
    func changeBtnState(isEnabled: Bool) {
        confirmBtn.isEnabled = isEnabled
        confirmBtn.backgroundColor = isEnabled ? HEX(kMainColor1) :  HEX(kSubColor4)
    }
    
    func stateString(returnService:Double) -> String {
        if returnService == 1 || returnService == 2 || returnService == 2.3 {
            return "Sistema em processessamento, favor aguardar."
        } else if returnService == 2.1 { //商家同意
            return "A plataforma concorda em devolução e reembolso, favor enviar a devolução o mais breve possível."
        } else if returnService == 1.1 || returnService == 2.4 { //成功
            return "Reembolso com sucesso."
        } else if returnService == 1.2 || returnService == 2.2 || returnService == 2.5 { //失败
            return "Reembolso cancelado, este produto não tem reembolso após a compra."
        }
        return ""
    }
    
    @IBAction func tap() {
        guard let model = afterSaleData, let data = data else {
            return
        }
        
        let returnService = model.returnService
        if returnService == 0 {
            orderAfterSale(orderNumber:data.orderNumber)
        } else if returnService == 2.1 {
            saveOrderAfterExpress(orderNumber:data.orderNumber)
        } else {
            againApplyReturn()
        }
    }
    
    func orderAfterSale(orderNumber:String) {
        startLoading()
        let dic = [
            "orderNumber" : orderNumber,
            "returnType" : type == .RefundTypeMoney ? "1" : "2",
            "depict" : textRow.input.text ?? "",
            "image" : imgs.joined(separator: ","),
            "productState" : self.productStateRow.textField.text ?? ""
        ]
        NetWork.request(.orderAfterSale,
                        modelType: NoneResponseData.self,
                        parameters: dic) { result, model, msg in
            if let _ = model {
                self.getOrderAfterSaleDetils()
                NotificationCenter.default.post(name: RefreshOrderNotification, object: nil)
            }
            self.stopLoading()
        }
    }
    
    func saveOrderAfterExpress(orderNumber:String) {
        startLoading()
        let dic = [
            "orderNumber" : orderNumber,
            "expressDelivery" : deliveryRow.textField.text ?? "",
            "expressDeliveryNumber" : deliveryNoRow.textField.text ?? "",
        ]
        NetWork.request(.saveOrderAfterExpress,
                        modelType: NoneResponseData.self,
                        parameters: dic) { result, model, msg in
            if let _ = model {
                self.getOrderAfterSaleDetils()
                NotificationCenter.default.post(name: RefreshOrderNotification, object: nil)
            }
            self.stopLoading()
        }
    }
    
    func againApplyReturn() {
        guard let model = afterSaleData else {
            return
        }
        startLoading()
        let dic = [
            "orderNumber" : model.orderNumber,
            "returnType" : model.returnType,
            "depict" : model.depict,
            "image" : model.image,
            "productState" : model.productState
        ]
        NetWork.request(.orderAfterSale,
                        modelType: NoneResponseData.self,
                        parameters: dic) { result, model, msg in
            if let _ = model {
                self.getOrderAfterSaleDetils()
                NotificationCenter.default.post(name: RefreshOrderNotification, object: nil)
            }
            self.stopLoading()
        }
    }
    
    func showPicker() {
        let menu = UIAlertController(title: nil, message: "Status da encomenda", preferredStyle: .actionSheet)
        let unReceive = UIAlertAction(title: "Entrega a receber", style: .default) { _ in
            self.productStateRow.textField.text = "Entrega a receber"
            self.changeBtnState(isEnabled:true)
        }
        let receive = UIAlertAction(title: "Status da encomenda", style: .default) { _ in
            self.productStateRow.textField.text = "Status da encomenda"
            self.changeBtnState(isEnabled:true)
        }
        
        menu.addAction(unReceive)
        menu.addAction(receive)
        self.present(menu, animated: true, completion: nil)
    }
    
    func showDeliveryPicker() {
        guard let gReturn = gReturn else { return }
        
        let menu = UIAlertController(title: nil, message: "Escolha a forma de entrega", preferredStyle: .actionSheet)
        
        for item in gReturn.expressDeliveryList {
            let option = UIAlertAction(title: item.content, style: .default) { _ in
                self.deliveryRow.textField.text = item.content
            }
            menu.addAction(option)
        }
        
        self.present(menu, animated: true, completion: nil)
    }
}


extension RefundViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RefundImgCell", for: indexPath) as! RefundImgCell
        cell.add.isHidden = !(isAdd && indexPath.row == imgs.count)
        cell.close.isHidden = !isAdd || !cell.add.isHidden
        cell.tapAdd = { [weak self] in
            guard let self = self else { return }
            PhotoLib.shared.showPhotoLib(self) { [weak self] (data, url) in
                guard let self = self else { return }
                self.imgs.append(url)
                self.collectionView.reloadData()
            }
        }
        cell.tapClose = { [weak self] in
            self?.imgs.remove(at: indexPath.row)
            self?.collectionView.reloadData()
        }
        
        if indexPath.row < imgs.count {
            cell.imageView.load(imgs[indexPath.row])
        } else {
            cell.imageView.image = nil
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let num = imgs.count + (isAdd ? 1 : 0)
        return num > 9 ? 9 : num
    }
}

extension RefundViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension RefundViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int((collectionView.bounds.width - 12) / 3)
        
        let num = imgs.count + (isAdd ? 1 : 0)
        let row = Int(num / 3)
        heightConstraint.constant = CGFloat(row * 12 + (row + 1) * width)
        return CGSize(width: width, height: width)
    }
}
