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
}

final class ChatPresenter: ChatPresentationLogic {
	func fetchAvatars() async {
		let myUrlAvatar = ImageURLs.myPhoto.urlString
		if let myAvatar = await networkManager.fetchImage(from: myUrlAvatar) {
			ImageCacheManager.shared.setImage(myAvatar, forKey: myUrlAvatar)
		}
		
		let otherUrlAvatar = ImageURLs.otherPhoto.urlString
		if let otherAvatar = await networkManager.fetchImage(from: ImageURLs.otherPhoto.urlString) {
			ImageCacheManager.shared.setImage(otherAvatar, forKey: otherUrlAvatar)
		}
	}
	
	func saveMessageInDataManager(message: MessageViewModel) {
		
	}
	
	
	
	private weak var view: ChatMainScreen?
	private let networkManager: NetworkService
	//	private let storageManager: StorageManagerProtocol // потом добавить манаджер storageManager
	
	private(set) var messages: [MessageViewModel] = []
//	private var offSet = 0
	
	init(view: ChatMainScreen? = nil, networkManager: NetworkService) {
		self.view = view
		self.networkManager = networkManager
	}
	
	
	private func mapMessageData(messages: [String]) -> [MessageViewModel] {
		var messagesArray: [MessageViewModel] = []
		messages.indices.forEach {
			messagesArray.append(
				MessageViewModel(
					image: ImageURLs.otherPhoto.urlString,
					date: Date.formattedCurrentTimeWithDayTime(),
					id: String($0),
					message: messages[$0],
					isIncoming: true)
			)
		}
		let sortedMessage = messagesArray.sorted(by: { Int($0.id)! > Int($1.id)! })
		return sortedMessage
	}
	
	
	
	
	@MainActor func fetchMessages(offset: Int) async {
		view?.showSpinner()
		let result = await networkManager.fetchMessages(offset: offset)
		
		switch result {
		case .success(let data):
			guard data.result.count > 0 else {
				view?.hideSpinner()
				return
			}
			let messages = mapMessageData(messages: data.result)
	
			await view?.updateUI(with: messages)
			DispatchQueue.main.async {
				self.view?.isFirstLaunch = false
			}
			view?.hideSpinner()
		case .failure(let error):
			view?.hideSpinner()
			view?.fetchMessagesDidFinishedError(with: ErrorFetchMessages(offSet: offset, errorMessage: error.rawValue))
			print(error.rawValue)
		}
	}
	
	
	//MARK: - Properties
	
}

