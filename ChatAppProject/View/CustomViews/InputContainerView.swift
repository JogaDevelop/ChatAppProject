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
		messageTextView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(messageTextView)
		
		// Настройка кнопки отправки
		sendMessageButton.setTitle("Send", for: .normal)
		sendMessageButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
		sendMessageButton.translatesAutoresizingMaskIntoConstraints = false
		addSubview(sendMessageButton)
		
		// Автоматическая настройка констрейнтов для элементов внутри контейнера
		NSLayoutConstraint.activate([
			messageTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
			messageTextView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
			messageTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
			
			sendMessageButton.leadingAnchor.constraint(equalTo: messageTextView.trailingAnchor, constant: 10),
			sendMessageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
			sendMessageButton.centerYAnchor.constraint(equalTo: centerYAnchor),
			sendMessageButton.heightAnchor.constraint(equalToConstant: 30),
			sendMessageButton.widthAnchor.constraint(equalToConstant: 80)
		])
	}
	
	// Метод, вызываемый при нажатии на кнопку отправки
	@objc func sendMessage() {
		if let text = messageTextView.text, !text.isEmpty {
			onSend?(text)  // Вызов коллбека с отправленным текстом
			messageTextView.text = "" // Очистка текстового поля после отправки
			
		}
	}
	
	// Делегат UITextView для обработки изменений в текстовом поле
	func textViewDidChange(_ textView: UITextView) {
		// Здесь можно добавить логику для автоматического изменения размера поля
	}
}
