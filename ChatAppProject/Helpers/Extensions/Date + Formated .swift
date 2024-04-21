//
//  Date + Formated .swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 21.04.2024.
//

import Foundation

extension Date {
	static func formattedCurrentTimeWithDayTime() -> String {
		let currentDate = Date()
		let formatter = DateFormatter()
		formatter.dateFormat = "h:mm a"
		return formatter.string(from: currentDate)
	}
}
