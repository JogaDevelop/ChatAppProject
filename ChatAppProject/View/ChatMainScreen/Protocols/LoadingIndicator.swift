//
//  LoadingIndicator.swift
//  ChatAppProject
//

import UIKit

//MARK: LoadingIndicatorProtocol
protocol ILoadingIndicator {
	func isLoading()
	func isHidden()
}

/// Индиктор загрузки сообщений в чат, с сервера.
extension ILoadingIndicator {
	/// Индикатор включен - идет загрузка.
	func isLoading() {
		guard let self = self as? UIViewController else { return }
		guard let loadingView = self.view.viewWithTag(80) else { return }
		loadingView.removeFromSuperview()
		self.view.isUserInteractionEnabled = true
	}
	
	/// Индикатор выключен.
	func isHidden() {
		guard let self = self as? UIViewController else { return }
		let activityView = UIActivityIndicatorView(style: .large)
		activityView.tag = 80
		activityView.center = self.view.center
		self.view.addSubview(activityView)
		activityView.startAnimating()
		self.view.isUserInteractionEnabled = false
	}
}
