//
//  ChatTableView.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 09.04.2024.
//

import UIKit

protocol TableViewInteractionDelegate: AnyObject {
	func requestNextPageMessages(offset: Int)
	func showMessageDetail(with message: MessageViewModel, at index: Int)
}

final class ChatTableView: UITableView {
	// масcив текста для проверки работы таблицы
	
	weak var eventsDelegate: TableViewInteractionDelegate?
	
	private var offSet = 0
	
	var fetchMessagesCount = 0 {
		didSet {
			offSet += fetchMessagesCount
		}
	}

	var isLoading = false
	
	var messages: [MessageViewModel] = [] {
		didSet {
			self.reloadData()
			
			guard isLoading else {
				return
			}
			scrollToRow(at: IndexPath(row: fetchMessagesCount - 1, section: 0), at: .top, animated: false)
			isLoading = false
		}
	}

	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		configureTableVIew()
	}
	
	private func configureTableVIew() {
		register(ChatTableViewCell.self, forCellReuseIdentifier: .messagesCell)
		self.separatorStyle = .none
		delegate = self
		dataSource = self
	}

	func removeSelectedMessage() {
		// Код для удаления сообщений из данных и обновления таблицы
	}
}

extension ChatTableView: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: .messagesCell, for: indexPath) as! ChatTableViewCell
		let message = messages[indexPath.row]
		cell.configure(with: ChatTableViewCell.ModelCell.init(message: message))
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		eventsDelegate?.showMessageDetail(with: messages[indexPath.row], at: indexPath.row)
	}
}

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
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let tableView = scrollView as! ChatTableView
		guard isLoading == false else { return }
		let position = tableView.contentOffset.y
		
		if position < 150 { // Проверка, что скроллим вверх и достигли верхней границы с некоторым запасом
			eventsDelegate?.requestNextPageMessages(offset: offSet)
			isLoading = true
		}
	}
}

private extension String {
	static let messagesCell = "MessagesCell"
}

