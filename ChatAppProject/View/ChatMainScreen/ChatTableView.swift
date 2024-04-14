//
//  ChatTableView.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 09.04.2024.
//

import UIKit



final class ChatTableView: UITableView {
	// масcив текста для проверки работы таблицы
	var mokMessages = [
		MessageViewModel(image: "", date: "25.02", id: "", message: "Hello", isIncoming: false),
		MessageViewModel(image: "", date: "25.02", id: "", message: "Helsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdlo", isIncoming: false),
		MessageViewModel(image: "", date: "25.02", id: "", message: "Helwewlo", isIncoming: false),
		MessageViewModel(image: "", date: "25.02", id: "", message: "Hellwsdso", isIncoming: true),
		MessageViewModel(image: "", date: "25.02", id: "", message: "Hello", isIncoming: false),
		MessageViewModel(image: "", date: "25.02", id: "", message: "Helsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdlo", isIncoming: false),
		MessageViewModel(image: "", date: "25.02", id: "", message: "Helwewlo", isIncoming: false),
		MessageViewModel(image: "", date: "25.02", id: "", message: "Hellwsdso", isIncoming: true),
	]
	
	var timer: Timer?
	
	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		configureTableVIew()
//		timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(receiveMessage), userInfo: nil, repeats: false)
	}
	
	private func configureTableVIew() {
		register(ChatTableViewCell.self, forCellReuseIdentifier: "Cell")
		self.separatorStyle = .none
		delegate = self
		dataSource = self
	}
	
	
	
	// иммитация работы сервера
	
	@objc func receiveMessage() {
		// Добавляем новое сообщение в массив
		let newMessage = "Новое сообщение \(mokMessages.count + 1)"
		mokMessages.append(MessageViewModel.init(image: "sd", date: "s", id: "s", message: newMessage, isIncoming: true))
		
		// Обновляем tableView
		self.reloadData()
		
		// Прокручиваем tableView к последнему сообщению
		scrollToLastMessage()
	}
	
	// Метод для прокрутки к последнему сообщению
	func scrollToLastMessage() {
		if !mokMessages.isEmpty {
			let lastRowIndexPath = IndexPath(row: mokMessages.count - 1, section: 0)
			self.scrollToRow(at: lastRowIndexPath, at: .bottom, animated: true)
		}
	}
	
}

extension ChatTableView: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		mokMessages.count
		return mokMessages.count
	}
	
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatTableViewCell
		
//		let model = MessageViewModel(image: "", date: "23", id: "", message: mokMessages[indexPath.row].message, isIncoming: true)
//		mokMessages.append(model)
		
		cell.configure(with: ChatTableViewCell.ModelCell.init(message: mokMessages[indexPath.row]))
//		self.scrollToRow(at: indexPath, at: .bottom, animated: true)
	
		return cell
		
	
	}
	
	
	
	
}
