//
//  UIViewExtention.swift
//  Photos
//
//  Created by Анастасия Живаева on 10.02.2022.
//

import Foundation
import UIKit

extension UIView {
    ///Ends editing the view when you tap on it.
    func endEditingByTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    
    @objc func viewTapped() {
        endEditing(true)
    }
}
