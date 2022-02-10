//
//  FavoritePhotosTableCell.swift
//  Photos
//
//  Created by Анастасия Живаева on 01.02.2022.
//

import UIKit

class FavoritePhotosTableCell: UITableViewCell {

    static let reuseId = "FavoritePhotosTableCell"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let authorsNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = .bitWidth
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "FavoritePhotosTableCell")
        
        contentView.addSubview(photoImageView)
        contentView.addSubview(authorsNameLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                constant: 5),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                   constant: -5),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                    constant: 5),
            photoImageView.widthAnchor.constraint(equalTo: photoImageView.heightAnchor),

            authorsNameLabel.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor),
            authorsNameLabel.heightAnchor.constraint(lessThanOrEqualTo: photoImageView.heightAnchor, multiplier: 1 / 2),
            authorsNameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 10),
            authorsNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
    }
    
    // MARK: - Layout If Needed
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        photoImageView.layer.cornerRadius = photoImageView.frame.width / 2
    }
    
    // MARK: - Configure cell
    func configure(photo: Photo) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let url = URL(string: photo.urls.small),
                  let data = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.authorsNameLabel.text = photo.user.name
                self.photoImageView.image = UIImage(data: data)!
            }
        }
    }
    
}
