//
//  ChatPresenter.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 09.04.2024.
//

import UIKit


protocol ChatPresentationLogic: AnyObject {
	func fetchMessages(offset: Int) async
//	func fetchLocalMessages() async -> [MessageViewModel]
//	func saveMessageInDataManager(message: MessageViewModel)
//	func showMessageDetailScreen(_ message: MessageViewModel, at index: Int)
}

final class ChatPresenter: ChatPresentationLogic {
	
	
	private weak var view: ChatMainScreen?
	private let networkManager: NetworkService
	//	private let storageManager: StorageManagerProtocol // потом добавить манаджер storageManager
	
	private(set) var messages: [MessageViewModel] = []
//	private var offSet = 0
	
	
	
	
	
	init(view: ChatMainScreen? = nil, networkManager: NetworkService) {
		self.view = view
		self.networkManager = networkManager
	}
	
	
	
	@MainActor func fetchMessages(offset: Int) async {
		view?.showSpinner()
		let network = NetworkServiceManager()
		let result = await network.fetchMessages(offset: offset)
		
		switch result {
		case .success(let data):
			guard data.result.count > 0 else {
				view?.hideSpinner()
				return
			}
			var messagesArray: [MessageViewModel] = []
			data.result.indices.forEach {
				messagesArray.append(
					MessageViewModel(
						image: "https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/man_male_avatar_portrait-256.png",
						date: Date.formattedCurrentTimeWithDayTime(),
						id: String($0),
						message: data.result[$0],
						isIncoming: true)
				)
			}
			let sortedMessage = messagesArray.sorted(by: { Int($0.id)! > Int($1.id)! })
			
			
			
			await view?.updateUI(with: sortedMessage)
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
