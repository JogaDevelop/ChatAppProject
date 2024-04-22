//
//  ChatErrorView.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 13.04.2024.
//

import UIKit

protocol ErrorViewDelegate: AnyObject {
	func onRetry(offSet: Int)
	func onCancel()
}

class ErrorView: UIView {
	
	// MARK - Property
	
	var offSet: Int = 0
	weak var delegate: ErrorViewDelegate?
	
	// MARK = Views
	
	let titleLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.text = "Ошибка"
		label.font = UIFont.boldSystemFont(ofSize: 18)
		return label
	}()
	
	private let messageLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.numberOfLines = 0
		label.text = "Не удалось загрузить данные. Попробовать снова?"
		return label
	}()
	
	private lazy var retryButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Повторить", for: .normal)
		button.layer.cornerRadius = 10
		button.layer.masksToBounds = true
		button.backgroundColor = .systemGray5
		button.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
		return button
	}()
	
	private lazy var cancelButton: UIButton = {
		let button = UIButton(type: .system)
		button.layer.cornerRadius = 10
		button.layer.masksToBounds = true
		button.backgroundColor = .systemGray5
		button.setTitle("Отмена", for: .normal)
		button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
		return button
	}()
	
	// MARK - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		print("deinit errorView")
	}
	
	// MARK - Setup configure
	
	private func setupViews() {
		backgroundColor = .white
		layer.cornerRadius = 10
		layer.masksToBounds = true
		frame = CGRect(x: 0, y: 0, width: 300, height: 200)
		layer.masksToBounds = true
		
		addSubview(titleLabel)
		addSubview(messageLabel)
		addSubview(retryButton)
		addSubview(cancelButton)
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		messageLabel.translatesAutoresizingMaskIntoConstraints = false
		retryButton.translatesAutoresizingMaskIntoConstraints = false
		cancelButton.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
			
			messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
			messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
			
			retryButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
			retryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			retryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
			
			cancelButton.topAnchor.constraint(equalTo: retryButton.bottomAnchor, constant: 8),
			cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
			cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
		])
	}
	
	// MARK: - Actions
	
	@objc private func didTapRetry() {
		delegate?.onRetry(offSet: offSet)
		removeFromSuperview()
	}
	
	@objc private func didTapCancel() {
		delegate?.onCancel()
		removeFromSuperview()
	}
}

