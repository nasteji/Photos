//
//  SearchByPhotoVC.swift
//  Photos
//
//  Created by Анастасия Живаева on 01.02.2022.
//

import UIKit

class SearchByPhotoVC: UIViewController {
    
    private var collectionView: UICollectionView?
    private var searchBar: UISearchBar?
    
    private let serviceLayer = ServiceLayer()
    var photoArray: [Photo] = []
    
    var isLoading = false
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBar()
        setupCollectionView()
        setupRefreshControl()
        
        loadRandomPhotos()
    }
    
    // MARK: - Load Random Photos
    func loadRandomPhotos() {
        serviceLayer.loadRandomPhotos() { [weak self] photoArray in
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
        
        guard let collectionView = collectionView else { return }
        collectionView.register(SearchCollectionCell.self, forCellWithReuseIdentifier: SearchCollectionCell.reuseId)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
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
        searchBar = UISearchBar(frame: CGRect(x: 0.0,
                                              y: ScreenSizes.statusBarHeight,
                                              width: ScreenSizes.fullScreenWidth,
                                              height: ScreenSizes.searchBarHeight))
        guard let searchBar = searchBar else { return }
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

// MARK: - Prefetching
extension SearchByPhotoVC: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let maxItem = indexPaths.map({ $0.item }).max(),
                maxItem > photoArray.count - 4,
                !isLoading else { return }
        isLoading = true

        serviceLayer.loadRandomPhotos(byText: searchBar?.text ?? "") { [weak self] photoArray in
            guard let self = self else { return }
            var indexPathForAdd: [IndexPath] = []
            
            var photoArrayForAdd = photoArray
            photoArrayForAdd.removeAll(where: { photo in
                self.photoArray.contains(where: { $0.id == photo.id })
            })
            
            let indexArray = self.photoArray.count..<self.photoArray.count + photoArrayForAdd.count
            indexArray.forEach { indexPathForAdd.append(IndexPath(item: $0, section: 0)) }
            self.photoArray.append(contentsOf: photoArrayForAdd)
            
            DispatchQueue.main.async {
                self.collectionView?.insertItems(at: indexPathForAdd)
            }
            self.isLoading = false
        }
    }
}
    
// MARK: - Refresh Control
extension SearchByPhotoVC {
    private func setupRefreshControl() {
        collectionView?.refreshControl = UIRefreshControl()
        collectionView?.refreshControl?.attributedTitle = NSAttributedString(string: "loading...")
        collectionView?.refreshControl?.addTarget(self, action: #selector(refreshPhotos), for: .valueChanged)
    }
    
    @objc func refreshPhotos() {
        serviceLayer.loadRandomPhotos(byText: searchBar?.text ?? "") { [weak self] photoArray in
            guard let self = self else { return }
            var photoArrayForAdd = photoArray
            photoArrayForAdd.removeAll(where: { photo in
                self.photoArray.contains(where: { $0.id == photo.id })
            })
            self.photoArray.insert(contentsOf: photoArrayForAdd, at: 0)
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
                self.collectionView?.refreshControl?.endRefreshing()
            }
        }
    }
    
}
