//
//  StringExtension.swift
//  Moffy
//
//  Created by MRX on 20/12/2023.
//

import UIKit

extension String {
    func converStringToDate() -> Int? {
        let iosDate = self
        let dateForMatter = DateFormatter()
        dateForMatter.dateFormat = "yyyy-MM-dd"
        if let date = dateForMatter.date(from: iosDate) {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            return year
        }
        return nil
    }
}

