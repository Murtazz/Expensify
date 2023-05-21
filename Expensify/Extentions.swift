//
//  Extentions.swift
//  khal3470_finalProject
//
//  Created by Murtaza Khalid on 2023-04-15.
//

import Foundation
import SwiftUI

extension Color {
    static let bg = Color("bg")
    static let icon = Color("icon")
    static let text = Color("text")
    static let systemBackground = Color(uiColor: .systemBackground)
}

extension DateFormatter {
    static let formattedDate: DateFormatter = {
        print("starting date format")
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy"
        print("done formatting date")
        return format
    }()
}

extension String {
    func dateFormat() -> Date {
        guard let parsedDate = DateFormatter.formattedDate.date(from: self) else {
            return Date()
            
        }
        return parsedDate
    }
}
