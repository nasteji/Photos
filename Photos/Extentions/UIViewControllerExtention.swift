//
//  UIViewControllerExtention.swift
//  Photos
//
//  Created by Анастасия Живаева on 02.02.2022.
//

import Foundation
import UIKit

extension UIViewController {
    ///Modally presents a UIAlertController with attached action object.
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
