//
//  ActivityIndicatorVIew.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 09.04.2024.
//

import UIKit

protocol ActivityIndicatorSpinner {
	func showSpinner()
	func hideSpinner()
}

/// Индиктор загрузки сообщений в чат, с сервера.
extension ActivityIndicatorSpinner  {
	/// Индикатор включен - идет загрузка.
	func showSpinner() {
		guard let self = self as? UIViewController else { return }
		let activityView = UIActivityIndicatorView(style: .large)
		activityView.center = self.view.center
		activityView.tag = 80
		let overlayView = UIView(frame: UIScreen.main.bounds)
		overlayView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
		overlayView.tag = 81
		self.view.addSubview(overlayView)
		self.view.addSubview(activityView)
		activityView.startAnimating()
		self.view.isUserInteractionEnabled = false
	}

	/// Индикатор выключен.
	func hideSpinner() {
		guard let self = self as? UIViewController else { return }
		guard let loadingView = self.view.viewWithTag(80) else { return }
		guard let overlayView = self.view.viewWithTag(81) else { return }
		overlayView.removeFromSuperview()
		loadingView.removeFromSuperview()
		self.view.isUserInteractionEnabled = true
	}
}
