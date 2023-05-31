//
//  BankViewController.swift
//  PhoneRepair
//
//  Created by develop on 2022/4/20.
//

import UIKit
import Braspag3Ds
import DatePickerDialog

class BankViewController: UIViewController {
    
    @IBOutlet weak var securityCode:BankInput!
    @IBOutlet weak var brand:BankInput!
    @IBOutlet weak var cardNumber:BankInput!
    @IBOutlet weak var holder:BankInput!
    @IBOutlet weak var expirationDate:BankInput!
    
    @IBOutlet weak var info:UILabel!
    @IBOutlet weak var infoImage:UIImageView!
    @IBOutlet weak var infoView:UIView!
    
    var order: GetPayProductData!
    var category = ""
    var sdk: Braspag3dsProtocol!
    @IBOutlet weak var confirm: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    func setUI() {
        self.title = "Informações do cartão bancário"
        
        securityCode.textFieldChangeAction = { [weak self] in
            self?.changeBtnState()
        }
        brand.input.isEnabled = false
        brand.tapAction = { [weak self] in
            self?.showBrandPicker()
        }
        cardNumber.textFieldChangeAction = { [weak self] in
            self?.changeBtnState()
        }
        holder.textFieldChangeAction = { [weak self] in
            self?.changeBtnState()
        }
        expirationDate.input.isEnabled = false
        expirationDate.tapAction = { [weak self] in
            self?.showDatePicker()
        }
        
        securityCode.input.text = "480"
        brand.input.text = "visa"
        cardNumber.input.text = "4000000000001000"
        expirationDate.input.text = "06/2029"
        holder.input.text = "Tom"
        
        changeBtnState()
    }


    @IBAction func tap() {
        startSdkProcess()
    }
    
    func changeBtnState() {
        confirm.isEnabled = !securityCode.input.text!.isEmpty &&
        !brand.input.text!.isEmpty &&
        !cardNumber.input.text!.isEmpty &&
        !holder.input.text!.isEmpty &&
        !expirationDate.input.text!.isEmpty
        
        confirm.backgroundColor = confirm.isEnabled ? HEX(kMainColor1) :  HEX(kSubColor4)
    }
    
    func initiatePayment(_ auth: AuthenticationResponse) {

        let dic = [
            "orderNumber" : order.orderNumber,
            "securityCode" : securityCode.input.text!,
            "brand" : brand.input.text!,
            "expirationDate" : expirationDate.input.text!,
            "cardNumber" : cardNumber.input.text!,
            "holder" : holder.input.text!,
            "category" : category,
            "cavv" : auth.cavv,
            "xid" : auth.xId,
            "eci" : auth.eci,
            "version" : auth.version,
            "referenceId" : auth.referenceId
        ]
        
        startLoading()
        NetWork.request(.initiatePayment,
                        modelType: GetInitiatePaymentData.self,
                        parameters: dic) { result, model, msg in
            if let _ = model {
                self.paySuccess()
            }
            self.stopLoading()
        }
    }
    
    func showBrandPicker() {
        let menu = UIAlertController(title: nil, message: "Marca", preferredStyle: .actionSheet)
        let visa = UIAlertAction(title: "visa", style: .default) { _ in
            self.brand.input.text = "visa"
            self.changeBtnState()
        }
        menu.addAction(visa)
        self.present(menu, animated: true, completion: nil)
    }
    
    func showDatePicker() {
        DatePickerDialog(locale: Locale(identifier: "pt_BR"), showCancelButton: false).show("Expiração",
                                doneButtonTitle: "confirmar",
                                datePickerMode: .date) { [weak self] date in
            if let dt = date {
                formatter.dateFormat = "MM/yyyy"
                self?.expirationDate.input.text = formatter.string(from: dt)
                self?.changeBtnState()
            }
        }
    }
    
    func startSdkProcess() {
        startLoading()
        getAccessToken { (result) in
            
            guard let accessToken = result else { return }
            guard let price = Int64(self.order.orderprice) else { return }
            
            self.sdk = Braspag3ds(accessToken: accessToken, environment: .sandbox)
            let options = OptionsData()
            let arr = self.expirationDate.input.text!.components(separatedBy: "/")
            let order = OrderData(orderNumber: self.order.orderNumber,
                                  currencyCode: "986",
                                  totalAmount: price * 100,
                                  paymentMethod: .credit,
                                  transactionId: nil,
                                  installments: 1,
                                  recurrence: false,
                                  productCode: .goodsPurchase,
                                  countLast24Hours: nil,
                                  countLast6Months: nil,
                                  countLast1Year: nil,
                                  cardAttemptsLast24Hours: nil,
                                  marketingOptIn: nil,
                                  marketingSource: nil,
                                  transactionMode: nil,
                                  merchantUrl: nil)
             let card = CardData(number: self.cardNumber.input.text!, expirationMonth: arr[0], expirationYear: arr[1], cardAlias: nil, defaultCard: nil)
            
            self.sdk.authenticate(orderData: order,
                                 cardData: card,
                                 authOptions: options,
                                 billToData: nil,
                                 shipToData: nil,
                                 cart: nil,
                                 deviceData: nil,
                                 userData: nil,
                                 airlineData: nil,
                                 mdd: nil,
                                 recurringData: nil,
                                 deviceIpAddress: nil) { (status, authentication, error) in

                                    print("Status: \(status)")
                                    print("Deu erro: \(error ?? "não")")
                    self.stopLoading()
                    switch status {
                    case .success:
                        if let authentication = authentication {
                            self.initiatePayment(authentication)
                        } else {
                            self.payFail()
                        }
                        break
                    case .unenrolled, .unsupportedBrand, .failure, .error:
                        self.payFail()
                        break
                    }
                }
        }
    }
    
    func paySuccess() {
        self.infoView.isHidden = false
        self.infoImage.image = IMAGE("组 56749")
        self.info.text = "Parabéns, pagamento concluído."
        NotificationCenter.default.post(name: RefreshOrderNotification, object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.removeInfo()
            
            if let home = self.navigationController?.viewControllers[0] as? HomeViewController {
                home.fromPay = true
            }
            NotificationCenter.default.post(name: RefreshOrderNotification, object: nil)
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    func payFail() {
        self.infoView.isHidden = false
        self.infoImage.image = IMAGE("组 56750")
        self.info.text = "Não, o pagamento falhou."
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.removeInfo()
        }
    }
    
    func removeInfo() {
        self.infoView.isHidden = true
    }
    
    func getAccessToken(completion: @escaping (String?) -> Void) {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: config)
        
        guard let urlRequest: URL = URL(string: "https://mpisandbox.braspag.com.br/v2/auth/token") else {
            completion(nil)
            return
        }
        var request: URLRequest = URLRequest(url: urlRequest)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let params = ["EstablishmentCode": "1006993069",
                      "MerchantName": "Maurici's store",
                      "MCC": "5912"]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            completion(nil)
            return
        }
        
        request.httpBody = postData as Data
        
        // Sandbox
        let token = "ZGJhM2E4ZGItZmE1NC00MGUwLThiYWItN2JmYjliNmYyZTJlOkQvaWxSc2ZvcUhsU1VDaHdBTW5seUtkRE5kN0ZNc003Y1Uvdm8wMlJFYWc9"
        
        request.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request, completionHandler: { (result, _, error) in
            guard error == nil else {
                completion(nil)
                return
            }
            guard let data = result else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let decodableData: ResponseOauthToken = try decoder.decode(ResponseOauthToken.self, from: data)
                debugPrint("AccessToken: \(decodableData.accessToken ?? "FALHOU")")
                
                DispatchQueue.main.async {
                    completion(decodableData.accessToken)
                }
            } catch let exception {
                debugPrint(exception.localizedDescription)
                completion(nil)
            }
        })
        
        task.resume()
    }
}
