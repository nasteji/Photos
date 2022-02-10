//
//  DataExtention.swift
//  Photos
//
//  Created by Анастасия Живаева on 02.02.2022.
//

import Foundation

extension Data {
    ///Pretty print JSON string from data to Xcode console
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
    
}
