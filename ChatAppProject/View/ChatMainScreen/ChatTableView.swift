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
	
	// MARK: - Property
	
	weak var eventsDelegate: TableViewInteractionDelegate?
	
	/// Переменые для логики отображения данных
	private var offSet = 0									 // offset по которому грузятся новые сообщения с сервера
	var localMessageCount = 0								 // счетчик локальные сообщений
	var fetchMessagesCount = 0								 // счетчик загруженных сообщений за один раз
	var isLoading = false									 // флаг, идет загрузка
	
	var fetchMessages: [MessageViewModel] = [] { 			 // массив сообщений из которого обновляется таблица
		didSet {
			self.reloadData()								 // если массив изменяется обновляем таблицу
			offSet = fetchMessages.count - localMessageCount // обновляем  offSet, количество загруженных сообщений минус локальные,
															 // чтобы сохранить хронологию и нумерации при загрузке новых сообщений
			guard isLoading else { return }					 // если флаг загрузки true идем дальше
			scrollToRow(at: IndexPath(row: fetchMessagesCount - 1, section: 0), at: .top, animated: false) // скролим на место на котором остановислись при скроле вверх
			isLoading = false								 // флаг загрузки ставим в false, чтобы можно было снова загружать новые сообщения при скроле вверх
		}
	}

	// MARK: - Lifecycle
	
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
}

extension ChatTableView: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fetchMessages.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: .messagesCell, for: indexPath) as! ChatTableViewCell
		let message = fetchMessages[indexPath.row]
		cell.configure(with: ChatTableViewCell.ModelCell.init(message: message))
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		eventsDelegate?.showMessageDetail(with: fetchMessages[indexPath.row], at: indexPath.row)
	}
}

extension ChatTableView {
	/// Метод для прокрутки к последней ячейке
	func scrollToBottom(animated: Bool = true) {
		let lastSection = numberOfSections - 1
		let lastRow = numberOfRows(inSection: lastSection) - 1
		
		if lastSection >= 0 && lastRow >= 0 {
			let indexPath = IndexPath(row: lastRow, section: lastSection)
			scrollToRow(at: indexPath, at: .bottom, animated: animated)
		}
	}
	
	/// метод отрабатывающий при скроле вверх и дергающий делегат загрузки новых данных
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let tableView = scrollView as! ChatTableView                // проверяем что скрол отработал именно в нашем tableView
		guard isLoading == false else { return }			        // ставим флаг в true чтобы не было бесконечной загрузки пока пользователь скролит вверх
		let position = tableView.contentOffset.y				    // поцизия на которой находимся в таблицу
		
		if position < 150 { 									    // Проверка, что при скроле вверх достигли верхней границы с некоторым запасом
			eventsDelegate?.requestNextPageMessages(offset: offSet) // загружаем новые данные по offset
			isLoading = true										// флаг загрузки ставим в true, чтобы не сработала снова загрузка если пользователь не отпустил скрол вверх
		}
	}
}

private extension String {											
	static let messagesCell = "MessagesCell"
}

