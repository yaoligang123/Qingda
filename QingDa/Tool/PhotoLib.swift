//
//  PhotoLib.swift
//  PhoneRepair
//
//  Created by develop on 2022/3/13.
//

import Foundation

class PhotoLib: NSObject {
    static let shared = PhotoLib()
    weak var vc:UIViewController?
    var finish: ((UIImage, String) -> Void)? = nil
    
    func showPhotoLib(_ vc:UIViewController, finish:((UIImage, String) -> Void)?) {
        let pickerVC = UIImagePickerController()
        pickerVC.delegate = self
        pickerVC.allowsEditing = true
        pickerVC.sourceType = .photoLibrary
        pickerVC.modalPresentationStyle = .fullScreen
        vc.present(pickerVC, animated: true, completion: nil)
        self.finish = finish
    }
}

extension PhotoLib: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.editedImage] as? UIImage,
           let data = image.jpegData(compressionQuality: 0.8),
           let url = info[.imageURL] as? NSURL,
            let name = url.lastPathComponent {
            
            vc?.startLoading()
            NetWork.upload(data,
                           name: name,
                           modelType: String.self) { result, model, msg in
                if let model = model, !model.isEmpty {
                    self.finish?(image, model)
                }
                self.vc?.stopLoading()
            }
        }
    }
}
