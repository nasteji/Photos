//
//  LikeButton.swift
//  Photos
//
//  Created by Анастасия Живаева on 01.02.2022.
//

import Foundation
import UIKit

protocol LikeButtonDelegate: AnyObject {
    func addToFavorites()
    func removeFromFavorites()
}

class LikeButton: UIButton {
    
    weak var delegate: LikeButtonDelegate?
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
                tintColor = .red
            } else {
                setImage(UIImage(systemName: "suit.heart"), for: .normal)
                tintColor = .black
            }
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup button
    private func setup() {
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill

        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    @objc private func tapped(_ sender: UIButton) {
        isSelected ? delegate?.removeFromFavorites() : delegate?.addToFavorites()
        isSelected.toggle()
    }

}
