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
	
	private lazy var titleChatScreen: UILabel = makeTitleScreen()
	private lazy var chatTableView: UITableView = makeTableView()
	private lazy var messageContainerView: UIView = makeContainerView()
	private lazy var messageTextField: UITextField = makeMessageView()
	private lazy var buttonSendMessage: UIButton = makeSendButton()
	
	
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConstraints()
		registerForKeyboardNotifications()
		
		
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		setupInterface()
	}
}

extension ChatViewController {
	private func setupInterface() {
		navigationController?.navigationBar.isHidden = true
		view.backgroundColor = .systemBackground
	}
	
	@objc private func sendMessage() {}
}

extension ChatViewController {
	

	
//	private func configureSendButton() {
//		
//		buttonSendMessage.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
//		
//		NSLayoutConstraint.activate([
//			buttonSendMessage.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
//			buttonSendMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//			buttonSendMessage.heightAnchor.constraint(equalToConstant: 40),
//			buttonSendMessage.widthAnchor.constraint(equalToConstant: 40)
//		])
//	}
//	
//	
//	@objc func sendButtonTapped() {
//		print("presed button")
//	}
	
	
	private func registerForKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	@objc private func keyboardWillShow(_ notification: NSNotification) {
		let userInfo = notification.userInfo!
		let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
		let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		
		if notification.name == UIResponder.keyboardWillHideNotification {
			if self.view.frame.origin.y != 0 {
				self.view.frame.origin.y = 0
			}
		} else {
			if self.view.frame.origin.y == 0 {
				self.view.frame.origin.y -= keyboardScreenEndFrame.height
			}
		}
		
		view.needsUpdateConstraints()
		
		UIView.animate(withDuration: animationDuration) {
			self.view.layoutIfNeeded()
		}
	}
}


/// Методы для инициализации и настройки UI, lazy свойств наших Views.
extension ChatViewController {
	private func makeTableView() -> ChatTableView {
		let tableView = ChatTableView()
		return tableView
	}
	
	private func makeContainerView() -> UIView {
		let view = UIView()
		view.backgroundColor = .secondarySystemBackground
		return view
	}
	
	private func makeMessageView() -> UITextField {
		let textView = UITextField()
		textView.backgroundColor = .systemBackground
		textView.layer.cornerRadius = 8
		textView.layer.borderColor = UIColor.placeholderText.cgColor
		textView.layer.borderWidth = 0.5
		textView.font = .systemFont(ofSize: 16, weight: .regular)
		return textView
	}
	
	private func makeSendButton() -> UIButton {
		let button = UIButton()
		let configuration = UIImage.SymbolConfiguration(pointSize: 24)
		button.setImage(UIImage(systemName: "arrow.up.circle.fill", withConfiguration: configuration), for: .normal)
		button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
		button.tintColor = .blue
		return button
	}
	
	private func makeTitleScreen() -> UILabel {
		let label = UILabel()
		label.text = "Тестовое задание"
		label.font = .systemFont(ofSize: 30, weight: .black)
		return label
	}
	
	private func setupConstraints() {
		view.addSubview(titleChatScreen)
		view.addSubview(chatTableView)
		view.addSubview(messageContainerView)
		messageContainerView.addSubview(messageTextField)
		messageContainerView.addSubview(buttonSendMessage)
		
	
		
		
		
		titleChatScreen.translatesAutoresizingMaskIntoConstraints = false
		titleChatScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
		titleChatScreen.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
		
		chatTableView.translatesAutoresizingMaskIntoConstraints = false
		chatTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
		chatTableView.topAnchor.constraint(equalTo: titleChatScreen.bottomAnchor, constant: 8).isActive = true
		chatTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
		chatTableView.bottomAnchor.constraint(equalTo: messageTextField.topAnchor, constant: -20).isActive = true
		// не забыть поменять нижний kонстаринт на 20
		
		
		messageContainerView.translatesAutoresizingMaskIntoConstraints = false
		messageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
		messageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
		messageContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
	
		
		messageTextField.translatesAutoresizingMaskIntoConstraints = false
		messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
		messageTextField.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: 8).isActive = true
		messageTextField.trailingAnchor.constraint(equalTo: buttonSendMessage.leadingAnchor, constant: -8).isActive = true
		messageTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true

		buttonSendMessage.translatesAutoresizingMaskIntoConstraints = false
		buttonSendMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
		buttonSendMessage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
		buttonSendMessage.heightAnchor.constraint(equalToConstant: 30).isActive = true
		buttonSendMessage.widthAnchor.constraint(equalToConstant: 30).isActive = true
	}
}
