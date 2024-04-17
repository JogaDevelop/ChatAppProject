//
//  ChatViewController.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 09.04.2024.
//

import UIKit

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
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupInterface()
		DispatchQueue.main.async {
			self.chatTableView.scrollToBottom(animated: false)
		}
		print(chatTableView.frame.height)
	
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
	// Инициализация коллбека onSend
	func setupSendButtonCallback() {
		inputContainerView.onSend = { [weak self] message in
			print("Отправленное сообщение: \(message)")
			self?.handleSentMessage(message)
		}
	}
	
	// Метод для обработки отправленного сообщения
	func handleSentMessage(_ message: String) {
		let newMessage = MessageViewModel.init(image: "sd", date: "s", id: "s", message: message, isIncoming: true)
		chatTableView.mokMessages.append(newMessage)
		chatTableView.reloadData()
		DispatchQueue.main.async {
			self.chatTableView.scrollToBottom(animated: false)
		}
		// Добавление сообщения в массив
		
		
		// Обновление таблицы (если используется UITableView для отображения сообщений)
		// tableView.reloadData()
		
		// Прокрутка таблицы к новому сообщению
		// scrollToLastMessage()
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
		
		if notification.name == UIResponder.keyboardWillHideNotification {
			
		} else { // chatTableView.contentInset.bottom == 0
			print(chatTableView.frame.height)
			// Увеличение bottom inset на высоту клавиатуры
//			print("Before contentInset: \(chatTableView.contentInset)")
//			print("Before contentOffset: \(chatTableView.contentOffset)")
//			chatTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardScreenEndFrame.height + 200, right: 0)
//			chatTableView.setContentOffset(CGPoint(x: 0, y: -keyboardScreenEndFrame.height), animated: true)
			// Установка contentOffset для смещения контента таблицы вверх
		
//			print("After contentInset: \(chatTableView.contentInset)")
//			print("After contentOffset: \(chatTableView.contentOffset)")
			
			
		}
		
		view.needsUpdateConstraints()
		chatTableView.scrollToBottom(animated: false)
		UIView.animate(withDuration: animationDuration) {
		
			self.view.layoutIfNeeded()
		}
	}
	
}


extension ChatViewController {
	private func setupInterface() {
		navigationController?.navigationBar.isHidden = true
		view.backgroundColor = .systemBackground
	}
	
//	@objc private func sendMessage() {
//		
//		
//	}
//	
//		private func configureSendButton() {
//	
//			buttonSendMessage.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
//	
//			NSLayoutConstraint.activate([
//				buttonSendMessage.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
//				buttonSendMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//				buttonSendMessage.heightAnchor.constraint(equalToConstant: 40),
//				buttonSendMessage.widthAnchor.constraint(equalToConstant: 40)
//			])
//		}
//	
//	
//		@objc func sendButtonTapped() {
//			print("presed button")
//		}
}

/// Методы для инициализации и настройки UI, lazy свойств наших Views.
extension ChatViewController {
	private func makeTitleScreen() -> UILabel {
		let label = UILabel()
		label.text = "Тестовое задание"
		label.font = .systemFont(ofSize: 30, weight: .black)
		return label
	}
	
	private func makeSrollView() -> UIScrollView {
		let scrollView = UIScrollView()
		return scrollView
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
