//
//  ChatTableViewCell.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 09.04.2024.
//

import UIKit

protocol CellConfigurable {
	associatedtype Model
	func configure(with model: Model)
}

final class ChatTableViewCell: UITableViewCell  {
	
	private lazy var avatarImageView: UIImageView = makeImageView()
	private lazy var messageView: ChatBubbleView = makeMessageView()
	private lazy var dateLabel: UILabel = makeTimeLabel()

	override func didMoveToSuperview() {
		super.didMoveToSuperview()
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
	}
	
	private func setupConfigureCell(model: MessageViewModel) {
		messageView.incoming = model.isIncoming
		messageView.messageLabel.text = model.message
		dateLabel.text = model.date
		contentView.addSubview(avatarImageView)
		contentView.addSubview(dateLabel)
		contentView.addSubview(messageView)
		
		
		
		
		avatarImageView.image = UIImage(named: "arrow.up.circle.fill") // картинка на время не забыть поменять
		avatarImageView.translatesAutoresizingMaskIntoConstraints = false
		avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
		avatarImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
		avatarImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
		
		messageView.translatesAutoresizingMaskIntoConstraints = false
		messageView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.64).isActive = true
		messageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
		messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
		
		
		dateLabel.translatesAutoresizingMaskIntoConstraints = false
		dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
		dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
		dateLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
		dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
		
		switch model.isIncoming {
		case true:
			avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
			messageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 45).isActive = true
		case false:
			avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
			messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -45).isActive = true
		}
	}
}

extension ChatTableViewCell: CellConfigurable {
	
	
	typealias ModelCell = ChatTableViewCellModel
	
	struct ChatTableViewCellModel {
		let message: MessageViewModel
	}
	
	func configure(with model: ModelCell) {
		setupConfigureCell(model: model.message)
	}
	
}


extension ChatTableViewCell {
	private func makeImageView() -> UIImageView {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.layer.cornerRadius = 15
		imageView.layer.masksToBounds = true
		imageView.layer.borderWidth = 1
		imageView.layer.borderColor = UIColor.placeholderText.cgColor
		return imageView
	}
	
	private func makeMessageView() -> ChatBubbleView {
		let view = ChatBubbleView()
		return view
	}
	
	private func makeTimeLabel() -> UILabel {
		let label = UILabel()
		label.font = .systemFont(ofSize: 12, weight: .medium)
		label.numberOfLines = 1
		return label
	}
}
