//
//  ChatPresenter.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 09.04.2024.
//

import UIKit

protocol ChatPresentationLogic: AnyObject {
	func fetchMessages(offset: Int) async
	func fetchAvatars() async
	func saveMessageInDataManager(message: MessageViewModel)
	func deleteMessageInDataManager(message: MessageViewModel)
}

final class ChatPresenter: ChatPresentationLogic {

	// MARK: - Property
	
	private weak var view: ChatMainScreen?
	private let networkManager: NetworkService
	private let dataManager = CoreDataManager.shared
	private let cacheManager = ImageCacheManager.shared
	
	init(view: ChatMainScreen? = nil, networkManager: NetworkService) {
		self.view = view
		self.networkManager = networkManager
	}
	
	/// Мапим при удачной загрузке данных в нашу модель, на выходе массив сообщений
	private func mapMessageData(messages: [String]) -> [MessageViewModel] {
		var messagesArray: [MessageViewModel] = []							// создаем пустой массив
		messages.indices.forEach {											// проходимся по массиву который до этого пришел с сервера и передан в эту функцию
			messagesArray.append(											// добавляем каждое сообщение в наш пустой массив в нужной нам модели данных
				MessageViewModel(
					image: ImageURLs.otherPhoto.urlString,
					date: Date.formattedCurrentTimeWithDayTime(),
					id: String($0),
					message: messages[$0],
					isIncoming: true)
			)
		}
		let sortedMessage = messagesArray.sorted(by: { Int($0.id)! > Int($1.id)! }) // сортируем по id чтобы получить правильный порядок сообщений, снизу вверх
		return sortedMessage
	}
	
	/// Метод загрузки данных с сервера и логика какие сообщения будут отправлены, вызываем  error view с предложением еще раз загрузить данные в случае неудачи
	@MainActor func fetchMessages(offset: Int) async {
		var localMessageCount = 0 										// счетчик локальных сообшений который будем передавать в tableView для правильного подсчета offset
		var messages: [MessageViewModel] = []							// создаем пустой массив
		view?.showSpinner()												// включаем спинер загрузки
		let result = await networkManager.fetchMessages(offset: offset) // пытаемся получить данные с сервера по offset
		
		if let isFirstLaunch = view?.isFirstLaunch, isFirstLaunch {     // проверяем если зашли в приложение первый раз загружаем локальные данные
			if let localMessages = await fetchSavedMessages() {			// пытаемся получить даные с coreData
				messages += localMessages								// добавляем нашему пустому массиву данные
				localMessageCount = localMessages.count					// меняем значения счетчика с нуля до количества скачаных локальных сообщений
			}
		}
		
		/// Обрабатываем данные, в случае удачной загрузки передаем данные для отображения
		switch result {
		case .success(let data):
			guard data.result.count > 0 else {                          // проверяем что загруженные данные больше нуля в другом случае выходим
				view?.hideSpinner()										// выключаем спинер загрузки
				return
			}
			let mapMessages = mapMessageData(messages: data.result)     // подготоавливаем загруженные данные в нужную нам модель через функцию mapMessageData
			messages.insert(contentsOf: mapMessages, at: 0)				// добавляем в начало пустого масива на случай если там есть локальные сообщения
			await view?.updateUI(with: messages, localMessageCount: localMessageCount) // передача данных для отображения, в случаем первого входа отпрвавим локальные и скачаные сообщения, в дальнейшем будут только скачаные
			DispatchQueue.main.async {									// меняем флаг первой загрузки в false
				self.view?.isFirstLaunch = false
			}
			view?.hideSpinner()											// скрываем спинер загрузки
		/// Обрабатываем данные, в случае неудачной загрузки передаем данные для отображения
		case .failure(let error):
			let flag = view?.isFirstLaunch ?? false					    // вытаскиваем значение, первый ли это вход в приложение
			if !messages.isEmpty || flag {  							// если первый вход и данные не загружены, грузим мок данные вместе с локальными данными если они есть,
				await mockLaunchingMessages(messages: messages, localCount: localMessageCount) // сработает если до этого были локальные сообщения и это первый вход в приложение, грузим мок сообщения вместе с локальными если они есть
			}
			view?.hideSpinner()											// скрываем спинер
			if messages.isEmpty {									    // данные не пришли и это не первый вход в приложение, вызываем errorView с предложением загрузить сноав
				view?.fetchMessagesDidFinishedError(with: ErrorFetchMessages(offSet: offset, errorMessage: error.rawValue))
			}
			print(error.rawValue)
		}
	}
	
	
	/// Метод для получения мок данных, при первом входе в приложение будет вызван в обработке неудачного запроса, в него будут переданы локальные сообщения если такие есть и счетчик локальных сообщений
	func mockLaunchingMessages(messages: [MessageViewModel], localCount: Int) async {
		var newArrayMessages = messages									// создаем пустой массив передаем в него принятые сообщения
		let mockMessages = await MockChatService().fetchMessages()		// получем массив мок сообщений
		let mapMessages = mapMessageData(messages: mockMessages)		// мапим для нужной нам модели данных через функцию mapMessageData
		newArrayMessages.insert(contentsOf: mapMessages, at: 0)			// добавляем в пустой массив новые сообщений
		await self.view?.updateUI(with: newArrayMessages, localMessageCount: localCount) // передаем получившийся массив из локальных сообщений и мок сообщений + счетчик локальных сообщений
		view?.isFirstLaunch = false										// выключаем флаг первого входа в приложение в false
	}
	
	/// Загружаем по urlStrings аватарки из интернета, в случае удачной загрузки отправляем в кешменеджр
	func fetchAvatars() async {
		let myUrlAvatar = ImageURLs.myPhoto.urlString
		if let myAvatar = await networkManager.fetchImage(from: myUrlAvatar) {
			cacheManager.setImage(myAvatar, forKey: myUrlAvatar)
		}
		
		let otherUrlAvatar = ImageURLs.otherPhoto.urlString
		if let otherAvatar = await networkManager.fetchImage(from: ImageURLs.otherPhoto.urlString) {
			cacheManager.setImage(otherAvatar, forKey: otherUrlAvatar)
		}
	}
	
	/// Загрузка локальных сообщений из coredata
	private func fetchSavedMessages() async -> [MessageViewModel]? {
		guard dataManager.fetchData().isEmpty == false else {
			return nil
		}
		
		return dataManager.fetchData().map(
			{
				MessageViewModel(
					image: $0.value(forKeyPath: "avatarUrl") as! String,
					date: $0.value(forKeyPath: "date") as! String,
					id: $0.value(forKeyPath: "id") as! String,
					message: $0.value(forKeyPath: "message") as! String,
					isIncoming: false
				)
			}
		)
	}
	
	/// Удаляем сообщение из coredata
	func deleteMessageInDataManager(message: MessageViewModel) {
		CoreDataManager.shared.deleteEntity(message: message)
	}
	
	/// Сохраняем введеное сообщение в coredata
	func saveMessageInDataManager(message: MessageViewModel) {
		CoreDataManager.shared.saveData(message: message)
	}
}

