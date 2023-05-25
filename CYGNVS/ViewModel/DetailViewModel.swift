//
//  DetailViewModel.swift
//  CYGNVS
//
//  Created by Subendran on 25/05/23.
//

import Foundation

class DetailViewModel {
    var albumInfoModel: AlbumInfoModel?
    var hideUpdateButton:((Bool)->())?
    var originalTitle: String = ""
    var setBannerImage:((Data)->())?
    var setThumbnailImage:((Data)->())?
    
    init(albumInfoModel: AlbumInfoModel?) {
        self.albumInfoModel = albumInfoModel
    }
    
    func getAlbumId()-> Int {
        albumInfoModel?.id ?? 0
    }
    
    func getTitle()-> String {
        albumInfoModel?.title ?? ""
    }
    
    func getUrl()-> String {
        albumInfoModel?.url ?? ""
    }
    
    func getThumbnailUrl()-> String {
        albumInfoModel?.thumbnailUrl ?? ""
    }
    
    func validateField(title: String) {
        if title == self.originalTitle {
            self.hideUpdateButton?(true)
        } else {
            self.albumInfoModel?.title = title
            self.hideUpdateButton?(false)
        }
    }
    
    func getThumbnailImage() {
        if  let url = URL(string: self.getThumbnailUrl()) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                // Error handling...
                guard let dataResponse = data else { return }
                DispatchQueue.main.async {
                    self.setThumbnailImage?(dataResponse)
                }
            }.resume()
        }
    }
    
    func getBannerImage() {
        if  let url = URL(string: self.getUrl()) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                // Error handling...
                guard let dataResponse = data else { return }
                DispatchQueue.main.async {
                    self.setBannerImage?(dataResponse)
                }
            }.resume()
        }
    }
}
