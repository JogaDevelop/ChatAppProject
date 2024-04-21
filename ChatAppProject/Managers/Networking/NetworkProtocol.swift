//
//  NetworkProtocol.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 20.04.2024.
//

import UIKit

protocol NetworkService: AnyObject {
	func fetchMessages(offset: Int) async -> Result<MessagesResponse, RequestError>
	func fetchImage(from urlString: String) async -> UIImage?
}

extension NetworkService {
	// Проверка, что ответ это HTTPURLResponse с кодом 200
	func handleResponse(_ response: URLResponse) throws {
		
		guard let response = response as? HTTPURLResponse else {
			throw RequestError.invalidResponseError
		}
		
		if response.statusCode >= 200 && response.statusCode <= 300 {
			return
		} else {
			throw RequestError.statusCodeError
		}
	}
}

extension NetworkService {
	func decode(from data: Data) throws -> MessagesResponse {
		do {
			let decoded = try JSONDecoder().decode(MessagesResponse.self, from: data)
			return decoded
		} catch {
			throw RequestError.decodingError
		}
	}
}
