//
//  PhotoDetailsVC.swift
//  Photos
//
//  Created by Анастасия Живаева on 01.02.2022.
//

import UIKit

class PhotoDetailsVC: UIViewController {
    
    var photo: Photo?
    private let serviceLayer = ServiceLayer()
    let favoritePhotoSingleton = FavoritePhotoSingleton.shared
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStackView()
    }
    
    // MARK: - Setup Stack View
    func setupStackView() {
        view.backgroundColor = .white
        
        let photoDetailsStack = PhotoDetailsStackView()
        photoDetailsStack.likeButton.delegate = self
        view.addSubview(photoDetailsStack)
        
        photoDetailsStack.frame = view.bounds

        photo != nil ? photoDetailsStack.configure(photo: photo!) : nil
    }
    
}
// MARK: - Like Button Delegate
extension PhotoDetailsVC: LikeButtonDelegate {
    func addToFavorites() {
        guard var photo = photo, !favoritePhotoSingleton.favoritePhotoArray.contains(where: {$0.id == photo.id})
        else { return }
        photo.likedByUser.toggle()
        favoritePhotoSingleton.favoritePhotoArray.append(photo)
        alert(title: "successfully", message: "Photo added to favorites")
        self.photo? = photo
    }
    
    func removeFromFavorites() {
        guard var photo = photo else { return }
        photo.likedByUser.toggle()
        favoritePhotoSingleton.favoritePhotoArray.removeAll(where: {$0.id == photo.id})
        alert(title: "successfully", message: "Photo removed from favorites")
        self.photo? = photo
    }

}


