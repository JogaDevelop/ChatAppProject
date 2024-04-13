//
//  ChatBubbleViewswift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 11.04.2024.
//

import UIKit


final class ChatBubbleView: UIView {
	
	lazy var messageLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		return label
	}()
	
	var incoming = false
	
		
	override func didMoveToSuperview() {
		super.didMoveToSuperview()
		setupConstraint()
		setupConfigure()
	}
	
	private func setupConfigure() {
		backgroundColor = incoming ? .systemGray4 : .systemBlue
		layer.cornerRadius = 20
		clipsToBounds = true
		messageLabel.textColor = incoming ? .black : .white
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
	
	
	
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	
	
}



