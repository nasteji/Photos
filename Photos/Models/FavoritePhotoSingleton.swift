//
//  FavoritePhotoSingleton.swift
//  Photos
//
//  Created by Анастасия Живаева on 03.02.2022.
//

import Foundation

class FavoritePhotoSingleton {
    static let shared = FavoritePhotoSingleton()
    
    var favoritePhotoArray: [Photo] = []
}
