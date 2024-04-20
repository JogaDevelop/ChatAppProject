//
//  ChatViewController.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 09.04.2024.
//

import UIKit

protocol ChatMainScreen: AnyObject, ActivityIndicatorSpinner {
	func updateUI(with messages: [MessageViewModel]) async
	func showErrorDidFinishedRequestError(with response: ResponseWithError)
}

class ChatViewController: UIViewController {
	
	// MARK - Presenter
	
	var presenter: ChatPresentationLogic?
	
	// MARK - Views

	private lazy var headerLabel: UILabel = makeTitleScreen()
	private lazy var chatTableView: ChatTableView = makeTableView()
	private lazy var inputContainerView: InputContainerView = makeInputContainer()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConstraints()
		registerForKeyboardNotifications()
		setupSendButtonCallback()
		loadInitialData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupInterface()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		removeNotificationsForKeyboardAppearance()
	}
	
}

extension ChatViewController {
	// Инициализация коллбека onSend из inputConteiner при нажатии кнопки отправить
	private func setupSendButtonCallback() {
		inputContainerView.onSend = { [weak self] message in
			print("Отправленное сообщение: \(message)")
			self?.handleSentMessage(message)
		}
	}
	
	// Метод для обработки отправленного сообщения
	private func handleSentMessage(_ message: String) {
		let newMessage = MessageViewModel.init(
			image: "sd",
			date: "s",
			id: "s",
			message: message,
			isIncoming: true
		)
		chatTableView.messages.append(newMessage)
		chatTableView.reloadData()
		DispatchQueue.main.async {
			self.chatTableView.scrollToBottom(animated: false)
		}
	}
}

extension ChatViewController: ChatMainScreen {
	func showErrorDidFinishedRequestError(with response: ResponseWithError) {
		showErrorView(offSet :response.offSet, errorMessage: response.errorMessage)
	}
	
	func updateUI(with messages: [MessageViewModel]) async {
		DispatchQueue.main.async {
			self.chatTableView.fetchMessagesCount = messages.count
			self.chatTableView.fetchData(messages: messages)
		}
	}
}

extension ChatViewController {
	private func showErrorView(offSet: Int, errorMessage: String) {
		/// Настройка всплывающей вью при ошибке запроса на сервер, с предложением еще раз обновить данные
		let errorView = ErrorView()
		errorView.center = self.view.center
		errorView.titleLabel.text = errorMessage
		
		errorView.onRetry = { [weak self] in // Обработчики действий для кнопок во всплывающей вью
			Task {
				await self?.presenter?.fetchMessages(offset: offSet)// Повторная загрузка данных через презентер
			}
			self?.hideErrorView(errorView: errorView) // Скрыть и деинициализировать всплывающую вью
		}
		
		errorView.onCancel = { [weak self] in
			self?.hideErrorView(errorView: errorView) // Скрыть и деинициализировать всплывающую вью
		}
		self.view.addSubview(errorView)
	}
	
	private func hideErrorView(errorView: ErrorView) {
		// Удаление всплывающей вьюшки из иерархии вью и деинициализация
		errorView.removeFromSuperview()
		errorView.onRetry = nil
		errorView.onCancel = nil
	}
}

extension ChatViewController: TableViewInteractionDelegate {
	func requestNextPageMessages(offset: Int) {
		Task {
			await presenter?.fetchMessages(offset: offset)
		}
	}
	
	func showMessageDetail(with message: MessageViewModel, at index: Int) {
		
	}
}

extension ChatViewController {
	private func setupInterface() {
		navigationController?.navigationBar.isHidden = true
		view.backgroundColor = .systemBackground
	}
	
	private func loadInitialData() {
		chatTableView.eventsDelegate = self
		Task {
			await presenter?.fetchMessages(offset: 0)
			DispatchQueue.main.async {
				self.chatTableView.reloadData()
				self.chatTableView.scrollToBottom(animated: false)
			}
		}
	}
}

/// Методы для инициализации и настройки UI, lazy свойств наших Views.
extension ChatViewController {
	private func makeTitleScreen() -> UILabel {
		let label = UILabel()
		label.text = "Тестовое задание"
		label.font = .systemFont(ofSize: 30, weight: .black)
		return label
	}
	
	private func makeTableView() -> ChatTableView {
		let tableView = ChatTableView()
		return tableView
	}
	
	private func makeInputContainer() -> InputContainerView {
		let view = InputContainerView()
		view.backgroundColor = .secondarySystemBackground
		return view
	}
	
	private func setupConstraints() {
		view.addSubview(headerLabel)
		view.addSubview(chatTableView)
		view.addSubview(inputContainerView)
		
		headerLabel.translatesAutoresizingMaskIntoConstraints = false
		headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
		headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
		headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
		headerLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
		
		chatTableView.translatesAutoresizingMaskIntoConstraints = false
		chatTableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor).isActive = true
		chatTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		chatTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		chatTableView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true

		inputContainerView.translatesAutoresizingMaskIntoConstraints = false
		inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		inputContainerView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -16).isActive = true
	}
}

extension ChatViewController {
	private func removeNotificationsForKeyboardAppearance() {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	private func registerForKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	@objc private func keyboardWillShow(_ notification: NSNotification) {
		let userInfo = notification.userInfo!
		let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
		let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		
		if notification.name == UIResponder.keyboardWillShowNotification {
			if self.view.frame.origin.y == 0 {
				self.view.frame.origin.y -= keyboardScreenEndFrame.height
			}
		} else {
			if self.view.frame.origin.y != 0 {
				self.view.frame.origin.y = 0
			}
		}
		
		view.needsUpdateConstraints()
		
		UIView.animate(withDuration: animationDuration) {
			self.view.layoutIfNeeded()
		}
	}
}
