//
//  ChatViewController.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 09.04.2024.
//

import UIKit

protocol ChatMainScreen: AnyObject, ActivityIndicatorSpinner {
	func updateUI(with messages: [MessageViewModel], localMessageCount: Int) async
	func fetchMessagesDidFinishedError(with response: ErrorFetchMessages)
	var isFirstLaunch: Bool { get set }
}

class ChatViewController: UIViewController {
	
	// MARK: - Property
	
	var isFirstLaunch: Bool = true
	
	// MARK: - Presenter
	
	var presenter: ChatPresentationLogic?
	
	// MARK: - Views

	private lazy var headerLabel: UILabel = makeTitleScreen()
	private lazy var chatTableView: ChatTableView = makeTableView()
	private lazy var inputContainerView: InputContainerView = makeInputContainer()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupConstraints()
		registerForKeyboardNotifications()
		setupSendButtonCallback()
		loadInitialData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupInterface()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		removeNotificationsForKeyboardAppearance()
	}
	
}

/// Метод делегата, удаления сообщения и из детального экрана
extension ChatViewController: DetailMessageScreenDelegate {
	func deleteMessage(index: Int) {
		if chatTableView.fetchMessages[index].isIncoming == false {
			CoreDataManager.shared.deleteEntity(message: chatTableView.fetchMessages[index])
		}
		chatTableView.localMessageCount -= 1
		chatTableView.fetchMessages.remove(at: index)
	}
}

extension ChatViewController {
	/// Инициализация коллбека onSend из inputConteiner при нажатии кнопки отправить
	private func setupSendButtonCallback() {
		inputContainerView.onSend = { [weak self] message in
			print("Отправленное сообщение: \(message)")
			self?.handleSentMessage(message)
		}
	}
	
	/// Метод для обработки отправленного сообщения
	private func handleSentMessage(_ message: String) {
		let newMessage = MessageViewModel.init(                  // создаем сообщение нашей модели данных
			image: ImageURLs.myPhoto.urlString,
			date: Date.formattedCurrentTimeWithDayTime(),
			id: String(0),
			message: message,
			isIncoming: false
		)
		presenter?.saveMessageInDataManager(message: newMessage) // вызываем в презентере метод сохранения в coreData
		chatTableView.localMessageCount += 1					 // добавляем +1 счетчику локальых переменных в tableView
		chatTableView.fetchMessages.append(newMessage)			 // добавляем сообщение в массив в tableView из которого обновляем данные
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {	 // после добавления в массив скролим вниз чтобы пользователь видил свое сообщение
			self.chatTableView.scrollToBottom(animated: false)
		}
	}
}

/// Методы делагата для для обновления ui в случае удачной и не удачной загрузки с сервера
extension ChatViewController: ChatMainScreen {
	func fetchMessagesDidFinishedError(with response: ErrorFetchMessages) {           // вызов errorView с предложением загрузить снова
		Router.shared.openErrorView(messageError: response.errorMessage, delegate: self, offSet: response.offSet)
	}
	
	func updateUI(with messages: [MessageViewModel], localMessageCount: Int) async {  // метод обновление нашего ui который будет вызываться из презентера
		chatTableView.localMessageCount += localMessageCount						  // добавляем счетчику локальных сообщений +1 в tableView
		chatTableView.fetchMessagesCount = messages.count							  // добавляем счетчику скачаных сообщений +1 в tableView
		chatTableView.fetchMessages.insert(contentsOf: messages, at: 0)				  // длбавляем сообщения в массив в самое начало в tableView
		if isFirstLaunch {															  // если пользователь зашел впервые, после загрузки локальных и загруженных данных скролим вниз
			self.chatTableView.scrollToBottom(animated: false)
		}
		
	}
}

/// Методы делеагата обработки нажатия кнопки из errorVIew
extension ChatViewController: ErrorViewDelegate {
	func onCancel() { 																  // если пользователь нажал cancel в errorView нечего не делаем, errorView деинициализируется
		chatTableView.isLoading = false
	}
	
	func onRetry(offSet: Int) {														  // если пользователь нажал повторить вызываем загрузку по новой, errorView деинициализируется
		Task {
			await self.presenter?.fetchMessages(offset: offSet)
		}
	}
}

/// Методы делегата таблицы при скроле вверх и нажатия на ячейку с сообщением
extension ChatViewController: TableViewInteractionDelegate {
	func requestNextPageMessages(offset: Int) {										  // загружаем следующие данные по offset отработает при скроле вверх
		Task {
			await presenter?.fetchMessages(offset: offset)
		}
	}
	
	func showMessageDetail(with message: MessageViewModel, at index: Int) {		      // показываем детальный экран при нажати ячейки и передаем туда индекс и само сообщение
		Router.shared.openMessageDetailScreen(with: message, at: index, delegate: self)
	}
}

/// Загрузка методов инициализации при первом входе в приложение
extension ChatViewController {
	private func setupInterface() {  												  // скрываем нативный navigationBar
		navigationController?.navigationBar.isHidden = true
		view.backgroundColor = .systemBackground
	}
	
	private func loadInitialData() {												  // метод при первом входе в приложение
		Task {
			await presenter?.fetchAvatars()											  // загружаем аватарки и сохраняем их в cacheManager
			await presenter?.fetchMessages(offset: 0)								  // загружаем данные с сервера и локальные данные, при первом входе загружаем эти данные
		}
	}
}

/// Методы для инициализации и настройки UI, lazy свойств наших Views.
extension ChatViewController {
	private func makeTitleScreen() -> UILabel {										  // инициализация заголовка экрана
		let label = UILabel()
		label.text = "Тестовое задание"
		label.font = .systemFont(ofSize: 30, weight: .black)
		return label
	}
	
	private func makeTableView() -> ChatTableView {									  // инициализация tableView
		let tableView = ChatTableView()
		tableView.eventsDelegate = self
		return tableView
	}
	
	private func makeInputContainer() -> InputContainerView {						  // инициализация контейнера с полем ввода и кнопкой отправить сообщение
		let view = InputContainerView()
		view.backgroundColor = .secondarySystemBackground
		return view
	}
	
	private func setupConstraints() {												  // загрузка констрейнтов
		view.addSubview(headerLabel)
		view.addSubview(chatTableView)
		view.addSubview(inputContainerView)
		
		headerLabel.translatesAutoresizingMaskIntoConstraints = false
		headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
		headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
		headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
		headerLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
		
		chatTableView.translatesAutoresizingMaskIntoConstraints = false
		chatTableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor).isActive = true
		chatTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		chatTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		chatTableView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true

		inputContainerView.translatesAutoresizingMaskIntoConstraints = false
		inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		inputContainerView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -16).isActive = true
	}
}

/// Наблюдатели при всплытии и закртии клавиатуры
extension ChatViewController {
	private func removeNotificationsForKeyboardAppearance() {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	private func registerForKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	@objc private func keyboardWillShow(_ notification: NSNotification) {
		let userInfo = notification.userInfo!
		let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
		let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		
		if notification.name == UIResponder.keyboardWillShowNotification {
			if self.view.frame.origin.y == 0 {
				self.view.frame.origin.y -= keyboardScreenEndFrame.height
			}
		} else {
			if self.view.frame.origin.y != 0 {
				self.view.frame.origin.y = 0
			}
		}
		
		view.needsUpdateConstraints()
		
		UIView.animate(withDuration: animationDuration) {
			self.view.layoutIfNeeded()
		}
	}
}
