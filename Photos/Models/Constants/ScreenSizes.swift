//
//  ScreenSizes.swift
//  Photos
//
//  Created by Анастасия Живаева on 01.02.2022.
//

import Foundation
import UIKit

struct ScreenSizes {
    static let fullScreenWidth = UIScreen.main.bounds.width
    static let fullScreenHeight = UIScreen.main.bounds.height
    static let statusBarHeight = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
    static let searchBarHeight = 50.0
}
