//
//  InputFieldMessage.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 13.04.2024.
//

import UIKit

class InputFieldMessage: UITextField {
	
}




//extension Notification.Name {
//	static let internetDown = Notification.Name("internetDown")
//}
//
//NotificationCenter.default.addObserver(self, selector: #selector(performDeinit), name: .internetDown, object: nil) // subscribe
//
//NotificationCenter.default.post(name: .internetDown, object: nil, userInfo: nil) //send
//
//———————————————————
//
//
//import UIKit
//
//class SecondViewController: UIViewController {
//
//	@IBOutlet weak var scrollView: UIScrollView!
//	@IBOutlet weak var bottomConstraint: NSLayoutConstraint!
//	var text: String?
//
//	var textY: CGFloat = 0
//
//	override func viewDidLoad() {
//		super.viewDidLoad()
//
//		registerForKeyboardNotifications()
//	}
//
//	private func registerForKeyboardNotifications() {
//		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//	}
//
//	@IBAction func backButtonPressed(_ sender: UIButton) {
//		self.navigationController?.popViewController(animated: true) // go to previous
//	}
//
//
//	@objc private func keyboardWillShow(_ notification: NSNotification) {
//
//		let userInfo = notification.userInfo!
//		let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
//		let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//
//		if notification.name == UIResponder.keyboardWillHideNotification {
//			bottomConstraint.constant = 0
//		} else if textY > keyboardScreenEndFrame.origin.y {
//			bottomConstraint.constant = keyboardScreenEndFrame.height
//			scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height)
//		}
//
//		view.needsUpdateConstraints()
//
//		UIView.animate(withDuration: animationDuration) {
//			self.view.layoutIfNeeded()
//		}
//	}
//}
//
//extension SecondViewController: UITextFieldDelegate {
//	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//		view.endEditing(true)
//		return true
//	}
//
//	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//		textY = textField.frame.origin.y
//		return true
//	}
//}
//
//———————————————————————
//
//
//import UIKit
//
//class SecondViewController: UIViewController {
//
//	@IBOutlet weak var scrollView: UIScrollView!
//	@IBOutlet weak var bottomConstraint: NSLayoutConstraint!
//
//	override func viewDidLoad() {
//		super.viewDidLoad()
//
//		registerForKeyboardNotifications()
//	}
//
//	private func registerForKeyboardNotifications() {
//		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//	}
//
//	@objc private func keyboardWillShow(_ notification: NSNotification) {
//		guard let userInfo = notification.userInfo,
//			  let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
//			  let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
//
//		if notification.name == UIResponder.keyboardWillHideNotification {
//			bottomConstraint.constant = 0
//		} else {
//			bottomConstraint.constant = keyboardScreenEndFrame.height + 10
//		}
//
//		view.needsUpdateConstraints()
//		UIView.animate(withDuration: animationDuration) {
//			self.view.layoutIfNeeded()
//		}
//	}
//}
//
//extension SecondViewController: UITextFieldDelegate {
//	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//		view.endEditing(true)
//		return true
//	}
//
//}



// вырезано за ненадобностью
//

///	private func registerForKeyboardNotifications() {
	//		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
	//		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	//	}
	
	//	@objc private func keyboardWillShow(_ notification: NSNotification) {
	//		let userInfo = notification.userInfo!
	//		let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
	//		let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
	//
	//		if notification.name == UIResponder.keyboardWillHideNotification {
	//			if self.view.frame.origin.y != 0 {
	//				self.view.frame.origin.y = 0
	//
	//			}
	//		} else {
	//			if self.view.frame.origin.y == 0 {
	//				self.view.frame.origin.y -= keyboardScreenEndFrame.height
	//			}
	//		}
	//
	//
	//		view.needsUpdateConstraints()
	//
	//		UIView.animate(withDuration: animationDuration) {
	//			self.view.layoutIfNeeded()
	//		}
	//	}
