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
	private lazy var chatTableView: ChatTableView = makeTableView()
	private lazy var messageContainerView: UIView = makeContainerView()
	private lazy var messageTextView: UITextView = makeMessageView()
	private lazy var buttonSendMessage: UIButton = makeSendButton()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConstraints()
		
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
	
	private func makeMessageView() -> UITextView {
		let textView = UITextView()
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
		label.font = .systemFont(ofSize: 26, weight: .black)
		return label
	}
	
	private func setupConstraints() {
		view.addSubview(titleChatScreen)
		view.addSubview(chatTableView)
		view.addSubview(messageContainerView)
		messageContainerView.addSubview(messageTextView)
		messageContainerView.addSubview(buttonSendMessage)
		
		titleChatScreen.translatesAutoresizingMaskIntoConstraints = false
		titleChatScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
		titleChatScreen.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
		
		chatTableView.translatesAutoresizingMaskIntoConstraints = false
		chatTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
		chatTableView.topAnchor.constraint(equalTo: titleChatScreen.bottomAnchor, constant: 8).isActive = true
		chatTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
		chatTableView.bottomAnchor.constraint(equalTo: messageTextView.topAnchor, constant: -16).isActive = true
		
		messageContainerView.translatesAutoresizingMaskIntoConstraints = false
		messageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
		messageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
		messageContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
		
		messageTextView.translatesAutoresizingMaskIntoConstraints = false
		messageTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
		messageTextView.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: 8).isActive = true
		messageTextView.trailingAnchor.constraint(equalTo: buttonSendMessage.leadingAnchor, constant: -8).isActive = true
		messageTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
		
		buttonSendMessage.translatesAutoresizingMaskIntoConstraints = false
		buttonSendMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
		buttonSendMessage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
		buttonSendMessage.heightAnchor.constraint(equalToConstant: 30).isActive = true
		buttonSendMessage.widthAnchor.constraint(equalToConstant: 30).isActive = true
	}
}
