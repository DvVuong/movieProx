//
//  DateExtension.swift
//  Moffy
//
//  Created by MRX on 22/12/2023.
//

import UIKit

extension Date {
    func asString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
    
    func asFormatterString(with formatter: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.string(from: self)
    }
    
    func asStringTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy - HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func asStringEnglish() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
    
    func asStringPDF() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: self)
    }
    
    func toLocalTime() -> Date {
        return Date(timeInterval: TimeInterval(TimeZone.current.secondsFromGMT(for: self)), since: self)
    }
    
    func resetTime(_ hour: Int = 0, _ minute: Int = 0, _ second: Int = 0) -> Date {
        return Calendar.current.date(bySettingHour: hour, minute: minute, second: second, of: self)!
    }
    
    func nextDate(_ number: Int = 100) -> Date {
        return Calendar.current.date(byAdding: .day, value: number, to: self)!
    }
    
    func settingDate(year: Int,
                     month: Int,
                     day: Int,
                     hour: Int,
                     minute: Int
    ) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = 0
        return Calendar(identifier: .gregorian).date(from: dateComponents)!
    }
    
    func getYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
  
  func getYearToInt() -> Int {
    let calendar = Calendar.current
    let yearNumber = calendar.component(.year, from: self)
    return yearNumber
  }
  
  func getMonth() -> Int {
    let calendar = Calendar.current
    let monthNumber = calendar.component(.month, from: self)
    return monthNumber
  }
    
    func getTimestamp() -> Int {
        return Int(self.timeIntervalSince1970)
    }
}

extension Date {
    func add(day: Int? = nil, month: Int? = nil, year: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil, calendar: Calendar = Calendar.current) -> Date? {
        var dateComponent = DateComponents()
        if let year = year { dateComponent.year = year }
        if let month = month { dateComponent.month = month }
        if let day = day { dateComponent.day = day }
        if let hour = hour { dateComponent.hour = hour }
        if let minute = minute { dateComponent.minute = minute }
        if let second = second { dateComponent.second = second }
        return calendar.date(byAdding: dateComponent, to: self)
    }
}

extension Data {
  func fecthYear() {
    
  }
}
