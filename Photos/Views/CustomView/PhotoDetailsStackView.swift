//
//  PhotoDetailsStack.swift
//  Photos
//
//  Created by Анастасия Живаева on 02.02.2022.
//

import Foundation
import UIKit

class PhotoDetailsStackView: UIView {

    private let dateFormatterISO8601 = ISO8601DateFormatter()
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    private let marginFromEdge: CGFloat = 20.0
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let authorsNameLabel = UILabel()
    private let dateOfCreationLabel = UILabel()
    private let locationLabel = UILabel()
    private let numberOfDownloadsLabel = UILabel()
    
    let likeButton = LikeButton()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View
    private func setup() {
        let stackArray = [photoImageView, authorsNameLabel, dateOfCreationLabel, locationLabel, numberOfDownloadsLabel, likeButton]
        
        stackArray.forEach { stackView.addArrangedSubview($0) }
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: marginFromEdge),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: marginFromEdge),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -marginFromEdge),
            
            photoImageView.topAnchor.constraint(equalTo: stackView.topAnchor),
            photoImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor),
            
            likeButton.widthAnchor.constraint(equalTo: likeButton.heightAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    // MARK: - Configure
    func configure(photo: Photo) {
        let dispatchGroup = DispatchGroup()
        
        DispatchQueue.global().async(group: dispatchGroup) {
            if let url = URL(string: photo.urls.small),
               let data = try? Data(contentsOf: url) {
                dispatchGroup.notify(queue: .main) {
                    self.photoImageView.image = UIImage(data: data)!
                }
            }
            let location = String(photo.location?.title ?? "no location")
            let numberOfDownloads = String(photo.downloads ?? 0)
            let autor = photo.user.name
            let likedByUser = photo.likedByUser
            let date = self.convertDateInISO8601Format(from: photo.createdAt)
           
            dispatchGroup.notify(queue: .main) {
                self.locationLabel.text = location
                self.numberOfDownloadsLabel.text = "number of downloads: \(numberOfDownloads)"
                self.authorsNameLabel.text = "made by: \(autor)"
                self.likeButton.isSelected = likedByUser
                self.dateOfCreationLabel.text = date
            }
        }
    }
    
    private func convertDateInISO8601Format(from date: String) -> String {
        dateFormatter.string(from: dateFormatterISO8601.date(from: date)!)
    }
    
}
