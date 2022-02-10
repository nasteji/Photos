//
//  SearchCollectionViewCell.swift
//  Photos
//
//  Created by Анастасия Живаева on 01.02.2022.
//

import UIKit

class SearchCollectionCell: UICollectionViewCell {
    
    static let reuseId = "SearchCollectionViewCell"

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(photoImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Configure cell
    func configure(photo: Photo) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let url = URL(string: photo.urls.small),
                  let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.photoImageView.image = UIImage(data: data)!
            }
        }
    }
    
    // MARK: - Layout Subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.frame = bounds
    }
    
}
