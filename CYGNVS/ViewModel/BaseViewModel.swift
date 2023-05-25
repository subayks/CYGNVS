//
//  BaseViewModel.swift
//  CYGNVS
//
//  Created by Subendran on 25/05/23.
//

import Foundation

class BaseViewModel {
    
    var albumInfoModel: [AlbumInfoModel]?
    var reloadTableViewClosure:(()->())?
    var alertClosure:((String)->())?
    var showLoadingIndicatorClosure:(()->())?
    var hideLoadingIndicatorClosure:(()->())?
    
    func makeApiCall() {
        if Reachability.isConnectedToNetwork() {
            self.showLoadingIndicatorClosure?()
            let urlString = Constants.Common.finalURL
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    self.hideLoadingIndicatorClosure?()
                    guard let dataResponse = data else { return }
                    DispatchQueue.main.async {
                        self.parse(json: dataResponse)
                    }
                }.resume()
            }
        } else {
            self.alertClosure?("Check your internet connection")
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode([AlbumInfoModel].self, from: json) {
            print(jsonPetitions)
            albumInfoModel = jsonPetitions
            self.reloadTableViewClosure?()
        }
    }
    
    func numberOfRows()->Int {
        self.albumInfoModel?.count ?? 0
    }
    
    func albumName(index: Int)-> String {
        self.albumInfoModel?[index].title ?? ""
    }
    
    func getDetailViewModel(index: Int) ->DetailViewModel {
        DetailViewModel(albumInfoModel: self.albumInfoModel?[index])
    }
    
    func updateValues(albumInfoModel: AlbumInfoModel) {
        let index = self.albumInfoModel?.firstIndex(where: {$0.id == albumInfoModel.id}) ?? 0
        self.albumInfoModel?[index].title = albumInfoModel.title
        self.reloadTableViewClosure?()
    }
}
