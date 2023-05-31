//
//  ShareVC.swift
//  PhoneRepair
//
//  Created by develop on 2022/12/8.
//

import UIKit

class ShareVC: UIViewController {
    
    @IBOutlet weak var imageView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = createQRForString(qrString: "ssss", qrImageName: "组 56896")
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
