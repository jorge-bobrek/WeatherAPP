//
//  DateFormatter.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

import Foundation

struct DateUtils {
    static func formatDateString(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = dateFormatter.date(from: dateString) else {
            return dateString
        }

        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        }

        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale.current 
        return dateFormatter.string(from: date)
    }
}
