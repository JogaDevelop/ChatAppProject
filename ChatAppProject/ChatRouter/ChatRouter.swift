//
//  ChatRouter.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 21.04.2024.
//

import UIKit

protocol RouterProtocol {
	func assemblyChatScreen()
	func openErrorView(messageError: String, delegate: ErrorViewDelegate, offSet: Int)
	func openMessageDetailScreen(with message: MessageViewModel, at index: Int, delegate: DetailMessageScreenDelegate)
}

final class Router: RouterProtocol {
	
	// MARK: - Singelton patern
	
	static let shared = Router()
	private init() {}
	
	// MARK: - Properties
	
	let navigationController = UINavigationController()
	
	// MARK: - assemblyScreen
	
	func assemblyChatScreen() {
		let chatScreenVC = ChatViewController()
		let networkManager = NetworkServiceManager()
		let presenter = ChatPresenter(view: chatScreenVC, networkManager: networkManager)
		chatScreenVC.presenter = presenter
		navigationController.viewControllers = [chatScreenVC]
	}
	
	func openMessageDetailScreen(with message: MessageViewModel, at index: Int, delegate: DetailMessageScreenDelegate) {
		let messageDetailScreen = ChatDetailMessageViewController(message: message, index: index, delegate: delegate)
		navigationController.pushViewController(messageDetailScreen, animated: true)
	}
	
	func openErrorView(messageError: String, delegate: ErrorViewDelegate, offSet: Int) {
		let errorView = ErrorView()
		errorView.titleLabel.text = messageError
		errorView.delegate = delegate
		errorView.offSet = offSet
		
		if let topViewController = navigationController.topViewController {
			errorView.center = topViewController.view.center
			topViewController.view.addSubview(errorView)
		}
	}
}


