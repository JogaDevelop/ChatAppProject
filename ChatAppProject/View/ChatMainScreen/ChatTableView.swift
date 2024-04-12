//
//  ChatTableView.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 09.04.2024.
//

import UIKit



final class ChatTableView: UITableView {
	// масcив текста для проверки работы таблицы
	let mokMessages = [
		MessageViewModel(image: "", date: "25.02", id: "", message: "Hello", isIncoming: false),
		MessageViewModel(image: "", date: "25.02", id: "", message: "Helsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdlo", isIncoming: false),
		MessageViewModel(image: "", date: "25.02", id: "", message: "Helwewlo", isIncoming: false),
		MessageViewModel(image: "", date: "25.02", id: "", message: "Hellwsdso", isIncoming: true),
	]
	
	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		registerTableViewCell()
		setupDelegate()
	}
	
	private func registerTableViewCell() {
		register(ChatTableViewCell.self, forCellReuseIdentifier: "Cell")
	}
	
	private func setupDelegate() {
		delegate = self
		dataSource = self
	}
	
	private func serrings() {
		self.separatorStyle = .none
	}
	
}

extension ChatTableView: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		mokMessages.count
	}
	
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatTableViewCell
		cell.configure(with: ChatTableViewCell.ModelCell.init(message: mokMessages[indexPath.row]))
		
		return cell
	}
	
	
}
