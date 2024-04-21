//
//  ChatViewController.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 09.04.2024.
//

import UIKit

protocol ChatMainScreen: AnyObject, ActivityIndicatorSpinner {
	func updateUI(with messages: [MessageViewModel]) async
	func fetchMessagesDidFinishedError(with response: ErrorFetchMessages)
	var isFirstLaunch: Bool { get set }
}

class ChatViewController: UIViewController {
	// MARK - Property
	
	var isFirstLaunch: Bool = true
	
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

extension ChatViewController: DetailMessageScreenDelegate {
	func deleteMessage(index: Int) {
		chatTableView.messages.remove(at: index)
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
			date: Date.formattedCurrentTimeWithDayTime(),
			id: "s",
			message: message,
			isIncoming: false
		)
		chatTableView.messages.append(newMessage)
		DispatchQueue.main.async {
			self.chatTableView.scrollToBottom(animated: false)
		}
	}
}

extension ChatViewController: ChatMainScreen {
	func fetchMessagesDidFinishedError(with response: ErrorFetchMessages) {
		Router.shared.openErrorView(messageError: response.errorMessage, delegate: self, offSet: response.offSet)
	}
	
	func updateUI(with messages: [MessageViewModel]) async {
		chatTableView.fetchMessagesCount = messages.count
		chatTableView.messages.insert(contentsOf: messages, at: 0)
		if isFirstLaunch {
			self.chatTableView.scrollToBottom(animated: false)
		}
		
	}
}

extension ChatViewController: ErrorViewDelegate {
	func onCancel() {
		chatTableView.isLoading = false
	}
	
	func onRetry(offSet: Int) {
		Task {
			await self.presenter?.fetchMessages(offset: offSet)// Повторная загрузка данных через презентер
		}
		// Скрыть и деинициализировать всплывающую вью
	}
}

extension ChatViewController: TableViewInteractionDelegate {
	func requestNextPageMessages(offset: Int) {
		Task {
			await presenter?.fetchMessages(offset: offset)
		}
	}
	
	func showMessageDetail(with message: MessageViewModel, at index: Int) {
		Router.shared.openMessageDetailScreen(with: message, at: index, delegate: self)
	}
}

extension ChatViewController {
	private func setupInterface() {
		navigationController?.navigationBar.isHidden = true
		view.backgroundColor = .systemBackground
	}
	
	private func loadInitialData() {
		Task {
			await presenter?.fetchAvatars()
			await presenter?.fetchMessages(offset: 0)
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
		tableView.eventsDelegate = self
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
