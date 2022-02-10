//
//  ServiceLayer.swift
//  Photos
//
//  Created by Анастасия Живаева on 02.02.2022.
//

import Foundation
import Alamofire

class ServiceLayer {
    
    private let baseUrl = "https://api.unsplash.com/"
    private let accessKey = "8udp5aQskV8pRz75xo5iCZBczkKT6G3zkUskv05-gPo"
    private let userName = "nasteji"
    
    let favoritePhotoSingleton = FavoritePhotoSingleton.shared
    
    // MARK: - Load Random Photos
    func loadRandomPhotos(byText: String?, completion: @escaping([Photo]) -> Void) {
        let path = "photos/random"
        let url = baseUrl+path
        let parameters: [String : Any] = [
            "client_id": accessKey,
            "count": 30,
            "query": byText ?? ""
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseData {
            [weak self] response in
                guard let data = response.value else { return }
                do {
                    var photoArray = try JSONDecoder().decode(PhotoArray.self, from: data)
                    DispatchQueue.global(qos: .utility).async {
                        completion(photoArray)
                    }
                } catch {
                    print(error)
                }
        }
    }
    // MARK: - Load Favorite Photos
    func loadFavoritePhotos(completion: @escaping() -> Void) {
        let path = "users/\(userName)/likes"
        let url = baseUrl+path
        let parameters: [String : Any] = [
            "client_id": accessKey
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseData {
            [weak self] response in
                guard let data = response.value else { return }
                do {
                    var photoArray = try JSONDecoder().decode(PhotoArray.self, from: data)
                    //force the likedByUser value true, because there is no authorization
                    for photo in photoArray.enumerated() {
                        photoArray[photo.offset].likedByUser = true
                    }
                    self?.favoritePhotoSingleton.favoritePhotoArray.append(contentsOf: photoArray)
                    DispatchQueue.global(qos: .utility).async {
                        completion()
                    }
                } catch {
                    print(error)
                }
        }
    }
   
}
