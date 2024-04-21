//
//  ChatDetailMessageViewController.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 09.04.2024.
//

import UIKit

protocol DetailMessageScreenDelegate: AnyObject {
	func deleteMessage(index: Int)
}

class ChatDetailMessageViewController: UIViewController {
	
	var message: MessageViewModel
	var index: Int
	
	weak var delegate: DetailMessageScreenDelegate?
	
	init( message: MessageViewModel, index: Int, delegate: DetailMessageScreenDelegate) {
		self.message = message
		self.index = index
		self.delegate = delegate
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private lazy var avatarImageView: UIImageView = makeAvatarImageView()
	private lazy var messageStackView: UIStackView = makeStackView()
	private lazy var messageLabel: UILabel = makeMessageLabel()
	private lazy var dateLabel: UILabel = makeDateLabel()
	private lazy var deleteButton: UIButton = makeDeleteButton()
	
	//MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupInterface()
		setupConstraints()
		setupContent()
	}
	
	deinit {
		print("Deinit DetailVC")
	}
	
	override func viewDidAppear(_ animated: Bool) {
		UIView.animate(withDuration: 0.33) { [unowned self] in
			[avatarImageView, messageStackView, messageLabel, dateLabel, deleteButton].forEach( {$0.alpha = 1} )
		}
	}
	
	//MARK: - Actions
	
	@objc private func deleteButtonAction () {
		delegate?.deleteMessage(index: index)
		navigationController?.popViewController(animated: true)
	}
}

//MARK: - Setups

extension ChatDetailMessageViewController {
	private func setupInterface() {
		navigationController?.navigationBar.isHidden = false
		view.backgroundColor = .systemBackground
	}
	
	private func setupConstraints() {
		view.addSubview(avatarImageView)
		avatarImageView.translatesAutoresizingMaskIntoConstraints = false
		avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
		avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		avatarImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
		avatarImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
		
		view.addSubview(messageStackView)
		messageStackView.translatesAutoresizingMaskIntoConstraints = false
		messageStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
		messageStackView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16).isActive = true
		messageStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
		
		view.addSubview(deleteButton)
		deleteButton.translatesAutoresizingMaskIntoConstraints = false
		deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
		deleteButton.topAnchor.constraint(equalTo: messageStackView.bottomAnchor, constant: 16).isActive = true
		deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
	}
	
	private func setupContent() {
		messageLabel.text = message.message
		dateLabel.text = message.date
		avatarImageView.image = UIImage(systemName: "person")
	}
}


extension ChatDetailMessageViewController {
	func makeAvatarImageView() -> UIImageView {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.layer.cornerRadius = 100
		imageView.layer.masksToBounds = true
		imageView.tintColor = .systemGray6
		imageView.alpha = 0
		return imageView
	}
	
	func makeStackView() -> UIStackView {
		let stackView = UIStackView(arrangedSubviews: [dateLabel, messageLabel])
		stackView.layer.cornerRadius = 12
		stackView.backgroundColor = .secondarySystemBackground
		stackView.axis = .vertical
		stackView.distribution = .fill
		stackView.spacing = 12
		stackView.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
		stackView.isLayoutMarginsRelativeArrangement = true
		stackView.alpha = 0
		return stackView
	}
	
	func makeMessageLabel() -> UILabel {
		let label = UILabel()
		label.numberOfLines = 0
		label.font = .systemFont(ofSize: 16, weight: .regular)
		label.alpha = 0
		return label
	}
	
	func makeDateLabel() -> UILabel {
		let label = UILabel()
		label.numberOfLines = 1
		label.font = .systemFont(ofSize: 14, weight: .medium)
		label.alpha = 0
		return label
	}
	
	func makeDeleteButton() -> UIButton {
		let button = UIButton(type: .system)
		button.layer.cornerRadius = 12
		button.backgroundColor = .secondarySystemBackground
		button.setTitle("Удалить сообщение", for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
		button.setTitleColor(UIColor.red, for: .normal)
		button.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
		button.alpha = 0
		return button
	}
}
