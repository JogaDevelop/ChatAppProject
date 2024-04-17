//
//  InputContainerView.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 14.04.2024.
//

import UIKit



class InputContainerView: UIView, UITextViewDelegate {
	// Создание элементов интерфейса: текстовое поле и кнопка отправки
	var messageTextView = UITextView()
	var sendMessageButton = UIButton(type: .system)
	
	private lazy var placeholder: UILabel = {
		let label = UILabel()
		label.textColor = .lightGray
		label.text = "Введите сообщение"
		return label
	}()
	
	
	// Коллбек, вызываемый при отправке сообщения
	var onSend: ((String) -> Void)?
	
	// Инициализаторы для создания view программно или из Interface Builder
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupViews()
	}
	
	// Метод для настройки внешнего вида и расположения элементов внутри view
	private func setupViews() {
		// Настройка текстового поля
		messageTextView.delegate = self
		messageTextView.isScrollEnabled = false
		messageTextView.layer.cornerRadius = 5
		messageTextView.layer.borderWidth = 1
		messageTextView.layer.borderColor = UIColor.gray.cgColor
		messageTextView.font = UIFont.systemFont(ofSize: 16)
		messageTextView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(messageTextView)
		
		// Настройка кнопки отправки
		sendMessageButton.setTitle("Send", for: .normal)
		sendMessageButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
		sendMessageButton.translatesAutoresizingMaskIntoConstraints = false
		addSubview(sendMessageButton)
		
		addSubview(placeholder)
		placeholder.translatesAutoresizingMaskIntoConstraints = false
		
		
		// Автоматическая настройка констрейнтов для элементов внутри контейнера
		NSLayoutConstraint.activate([
			messageTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
			messageTextView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
			messageTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
			
			sendMessageButton.leadingAnchor.constraint(equalTo: messageTextView.trailingAnchor, constant: 10),
			sendMessageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
			sendMessageButton.centerYAnchor.constraint(equalTo: centerYAnchor),
			sendMessageButton.heightAnchor.constraint(equalToConstant: 30),
			sendMessageButton.widthAnchor.constraint(equalToConstant: 80),
			
			placeholder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			placeholder.topAnchor.constraint(equalTo: topAnchor, constant: 5),
			placeholder.trailingAnchor.constraint(equalTo: sendMessageButton.leadingAnchor, constant: -16),
			placeholder.heightAnchor.constraint(equalToConstant: 30)
		])
	}
	
	func textViewDidChange(_ textView: UITextView) {
		if let text = messageTextView.text, !text.isEmpty {
			placeholder.isHidden = true
		}
	}
	
	// Метод, вызываемый при нажатии на кнопку отправки
	@objc func sendMessage() {
		if let text = messageTextView.text, !text.isEmpty {
			onSend?(text)  // Вызов коллбека с отправленным текстом
			messageTextView.text = "" // Очистка текстового поля после отправки
			placeholder.isHidden = false
			messageTextView.resignFirstResponder()
		}
	}
	
	
}
