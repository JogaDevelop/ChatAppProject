//
//  ChatBubbleViewswift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 11.04.2024.
//

import UIKit

final class ChatBubbleView: UIView {
	
	// MARK: - Views
	
	lazy var messageLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		return label
	}()
	
	// MARK: - Property
	
	var incoming = false {
		didSet {
			backgroundColor = incoming ? .systemGray4: .systemBlue
			messageLabel.textColor = incoming ? .black: .white 
		}
	}
	
	// MARK: - Lifecycle
		
	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		setupConstraint()
		setupConfigure()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
	}
	
	// MARK: Setup configure
	
	private func setupConfigure() {
		layer.cornerRadius = 20
		clipsToBounds = true
	}
	
	private func setupConstraint() {
		addSubview(messageLabel)
		messageLabel.translatesAutoresizingMaskIntoConstraints = false
		messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
		messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
		messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
		messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
		messageLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
	}
}



