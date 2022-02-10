//
//  SearchByPhotoVC.swift
//  Photos
//
//  Created by Анастасия Живаева on 01.02.2022.
//

import UIKit

class SearchByPhotoVC: UIViewController {
    
    private var collectionView: UICollectionView?
    
    private let serviceLayer = ServiceLayer()
    var photoArray: [Photo] = []
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBar()
        setupCollectionView()
        
        loadRandomPhotos()
    }
    
    // MARK: - Load Random Photos
    func loadRandomPhotos() {
        serviceLayer.loadRandomPhotos(byText: nil) { [weak self] photoArray in
            guard let self = self else { return }
            self.photoArray = photoArray
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
}

extension SearchByPhotoVC: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - Setup CollectionView
    func setupCollectionView() {
        let collectionViewFrame = CGRect(x: 0.0,
                                         y: ScreenSizes.statusBarHeight + ScreenSizes.searchBarHeight,
                                         width: ScreenSizes.fullScreenWidth,
                                         height: ScreenSizes.fullScreenHeight - ScreenSizes.statusBarHeight - ScreenSizes.searchBarHeight)
        let collectionViewlayout = UICollectionViewFlowLayout()
        let numberOfItemsPerRow = 2
        let leftOrRightIndent: Double = 10
        collectionViewlayout.sectionInset = UIEdgeInsets(top: 20,
                                                         left: leftOrRightIndent,
                                                         bottom: 20,
                                                         right: leftOrRightIndent)
        let itemWidth = (ScreenSizes.fullScreenWidth - (Double(numberOfItemsPerRow + 1) * leftOrRightIndent)) / Double(numberOfItemsPerRow)
        collectionViewlayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            
        collectionView = UICollectionView(frame: collectionViewFrame,
                                          collectionViewLayout: collectionViewlayout)
        
        guard let collectionView = self.collectionView else { return }
        collectionView.register(SearchCollectionCell.self, forCellWithReuseIdentifier: SearchCollectionCell.reuseId)
        collectionView.delegate = self
        collectionView.dataSource = self
            
        view.addSubview(collectionView)
    }
    
    // MARK: - CollectionView Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionCell.reuseId, for: indexPath) as! SearchCollectionCell
       
       cell.configure(photo: photoArray[indexPath.row])
        return cell
    }
    
    // MARK: - Segue
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoDetailsVC = PhotoDetailsVC()
        photoDetailsVC.photo = photoArray[indexPath.row]
        
        present(photoDetailsVC, animated: true, completion: nil)
    }
    
}

// MARK: - Search Bar
extension SearchByPhotoVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        serviceLayer.loadRandomPhotos(byText: searchText.lowercased()) { [weak self] photoArray in
            guard let self = self else { return }
            self.photoArray = photoArray
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    func setupSearchBar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0.0,
                                              y: ScreenSizes.statusBarHeight,
                                              width: ScreenSizes.fullScreenWidth,
                                              height: ScreenSizes.searchBarHeight))
        searchBar.searchBarStyle = .default
        searchBar.placeholder = "search"
        searchBar.sizeToFit()
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        view.endEditingByTap()
    }
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}
