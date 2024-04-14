//
//  ChatViewController + UITextFeieldDelegate.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 13.04.2024.
//

import UIKit

extension ChatViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		view.endEditing(true)
		return true
	}
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		return true
	}
}
