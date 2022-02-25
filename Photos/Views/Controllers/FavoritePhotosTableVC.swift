//
//  FavoritePhotosTableVC.swift
//  Photos
//
//  Created by Анастасия Живаева on 01.02.2022.
//

import UIKit

class FavoritePhotosTableVC: UITableViewController {
    
    let favoritePhotoSingleton = FavoritePhotoSingleton.shared
    private let serviceLayer = ServiceLayer()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFavoritePhotos()
        
        tableView.register(FavoritePhotosTableCell.self, forCellReuseIdentifier: FavoritePhotosTableCell.reuseId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Load Favorite Photos
    func loadFavoritePhotos() {
        serviceLayer.loadFavoritePhotos {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        (ScreenSizes.fullScreenHeight - ScreenSizes.statusBarHeight - (self.tabBarController?.tabBar.frame.height ?? 0.0)) / 4
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoritePhotoSingleton.favoritePhotoArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritePhotosTableCell.reuseId, for: indexPath) as! FavoritePhotosTableCell

        cell.configure(photo: favoritePhotoSingleton.favoritePhotoArray[indexPath.row])
        return cell
    }
    
    // MARK: - Segues
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photoDetailsVC = PhotoDetailsVC()
        photoDetailsVC.photo = favoritePhotoSingleton.favoritePhotoArray[indexPath.row]
        
        present(photoDetailsVC, animated: true, completion: nil)
    }
}
