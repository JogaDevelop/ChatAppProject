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
	/// не забыдь
	private var isLoading = false
	
	var messages: [MessageViewModel] = [] {
		didSet {
			self.reloadData()
			
			guard isLoading else {
				print("JJDsjkdjsk")
				return
			}
			scrollToRow(at: IndexPath(row: fetchMessagesCount - 1, section: 0), at: .top, animated: false)
			isLoading = false
		}
	}

	
	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		configureTableVIew()
//		timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(receiveMessage), userInfo: nil, repeats: false)
	}
	
	
	
	private func configureTableVIew() {
		register(ChatTableViewCell.self, forCellReuseIdentifier: .messagesCell)
		self.separatorStyle = .none
		delegate = self
		dataSource = self
	}

	
}

extension ChatTableView: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		mokMessages.count
		return messages.count
	}
	
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: .messagesCell, for: indexPath) as! ChatTableViewCell
		
//		let model = MessageViewModel(image: "", date: "23", id: "", message: mokMessages[indexPath.row].message, isIncoming: true)
//		mokMessages.append(model)
		
		cell.configure(with: ChatTableViewCell.ModelCell.init(message: messages[indexPath.row]))
//		self.scrollToRow(at: indexPath, at: .bottom, animated: true)
	
		return cell
		
	
	}
	
//	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//		guard isLoading == false, numberOfRowsToEndFrom(indexPath: indexPath) + savedMessagesCount < 5 else {
//			return
//		}
//
//		eventsDelegate?.requestForNextPage(offset: messages.count)
//		isLoading = true
//	}
//
	
	
}

extension ChatTableView {
	// Метод для прокрутки к последней ячейке
	func scrollToBottom(animated: Bool = true) {
		let lastSection = numberOfSections - 1
		let lastRow = numberOfRows(inSection: lastSection) - 1
		if lastSection >= 0 && lastRow >= 0 {
			let indexPath = IndexPath(row: lastRow, section: lastSection)
//			isLoading = true
			scrollToRow(at: indexPath, at: .bottom, animated: animated)
		}
//		isLoading = false
	}
	
	func removeSelectedMessage() {
		// Код для удаления сообщений из данных и обновления таблицы
	}
	
	//	func scrollToTop(animated: Bool = true) {
	//		let indexPath = IndexPath(row: 0, section: 0)
	//	}
	
	
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		//			let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
		let tableView = scrollView as! ChatTableView

		guard isLoading == false else { return }

		//
		
		let position = tableView.contentOffset.y
		
		
		

		if position < 150 { // Проверка, что скроллим вверх и достигли верхней границы с некоторым запасом
			print("загрузка новыых")
		


//						scrollView.isScrollEnabled = false

			eventsDelegate?.requestNextPageMessages(offset: offSet)
			isLoading = true
		}
		//		scrollView.isScrollEnabled = true

	}
	
	func fetchData(messages: [MessageViewModel])  {
		let newMessages = messages
		self.messages.insert(contentsOf: newMessages, at: 0)
	}
}

private extension String {
	static let messagesCell = "MessagesCell"
}
