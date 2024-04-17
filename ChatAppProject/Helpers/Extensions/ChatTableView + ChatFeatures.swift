//
//  ChatTableView + ChatFeatures.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 15.04.2024.
//

import Foundation

extension ChatTableView {
	// Метод для прокрутки к последней ячейке
	func scrollToBottom(animated: Bool = true) {
		let lastSection = numberOfSections - 1
		let lastRow = numberOfRows(inSection: lastSection) - 1
		if lastSection >= 0 && lastRow >= 0 {
			let indexPath = IndexPath(row: lastRow, section: lastSection)
			scrollToRow(at: indexPath, at: .bottom, animated: animated)
		}
	}
	
	func removeSelectedMessage() {
		// Код для удаления сообщений из данных и обновления таблицы
	}
	

	

	
	
}
