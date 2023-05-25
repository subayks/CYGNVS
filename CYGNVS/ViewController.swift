//
//  ViewController.swift
//  CYGNVS
//
//  Created by Subendran on 25/05/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var albumTableView: UITableView!
    var viewModel = BaseViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Album List"
        self.viewModel.makeApiCall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.albumTableView.reloadData()
            }
        }
        
        self.viewModel.alertClosure = { [weak self] (error) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                let alert = UIAlertController(title: "", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
        self.viewModel.showLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.showSpinner(onView: self.view)
            }
        }
        
        self.viewModel.hideLoadingIndicatorClosure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else {return}
                self.removeSpinner()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumNameCell", for: indexPath) as! AlbumNameCell
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = self.viewModel.albumName(index: indexPath.row)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = self.storyboard?.instantiateViewController(withIdentifier: "DetailView") as! DetailView
        detailView.detailViewModel = self.viewModel.getDetailViewModel(index: indexPath.row)
        detailView.detailClosure = { albumInfo in
            self.viewModel.updateValues(albumInfoModel: albumInfo!)
        }
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}

