//
//  DetailView.swift
//  CYGNVS
//
//  Created by Subendran on 25/05/23.
//

import UIKit

class DetailView: UIViewController {
    var detailViewModel: DetailViewModel?
    var detailClosure:((AlbumInfoModel?)->())?
    
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var albumId: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Album Details"
        
        thumbnailImage.layer.borderWidth = 5
        thumbnailImage.layer.borderColor = UIColor(red: 249/255, green: 246/255, blue: 255/255, alpha: 1).cgColor
        thumbnailImage.layer.cornerRadius = thumbnailImage.frame.height/2
        thumbnailImage.clipsToBounds = true
        
        self.updateButton.isHidden = true
        self.detailViewModel?.originalTitle = self.detailViewModel?.albumInfoModel?.title ?? ""
        self.setupValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.detailViewModel?.hideUpdateButton = { [weak self] (bool) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.updateButton.isHidden = bool
            }
        }
        
        self.detailViewModel?.setBannerImage = { [weak self] (data) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.bannerImage.image = UIImage(data: data)
            }
        }
        
        self.detailViewModel?.setThumbnailImage = { [weak self] (data) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.thumbnailImage.image =  UIImage(data: data)
            }
        }
    }
    
    func setupValues() {
        self.detailViewModel?.getBannerImage()
        self.detailViewModel?.getThumbnailImage()
        
        titleTextField.layer.borderWidth = 0.5
        titleTextField.layer.borderColor = UIColor.black.cgColor
        
        self.albumId.text = "Album Id: \(self.detailViewModel?.getAlbumId() ?? 0)"
        self.titleTextField.text = self.detailViewModel?.getTitle()
        
        
    }
    
    @IBAction func actionUpdate(_ sender: Any) {
        self.detailClosure?((self.detailViewModel?.albumInfoModel!))
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.detailViewModel?.validateField(title: textField.text ?? "")
    }
}
