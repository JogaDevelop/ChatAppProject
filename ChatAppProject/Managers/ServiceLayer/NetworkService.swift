//
//  NetworkService.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 18.04.2024.
//

import UIKit




class NetworkServiceManager: NetworkService {
	
	func fetchMessages(offset: Int) async -> Result<MessageResponse, RequestError> {
		guard let url = Endpoint.getMessages(offset: offset).url else { return .failure(.badUrl) }
		
		do {
			// Попытка получения данных по указанному URL
			let (data, response) = try await URLSession.shared.data(from: url)
			guard let response = response as? HTTPURLResponse else {
				return .failure(.invalidResponseError)
			}
			
			// Проверка, что ответ это HTTPURLResponse с кодом 200
			try handleResponse(response)
			// Декодирование полученных данных
			let decodedResponse = try decode(from: data)
			
			return .success(decodedResponse)
		} catch {
			// Ошибка
			return .failure(.connectionError)
		}
	}
	
	func fetchAvatars(from url: URL) async -> UIImage? {
		do {
			let (data, response) = try await URLSession.shared.data(from: url)
			try handleResponse(response)
			return UIImage(data: data)
		} catch  {
			
			return nil
		}
	}
	
	
}


enum RequestError:String, Error {
	case statusCodeError = "status code Error"
	case invalidResponseError = "invalid response Error"
	case connectionError = "connection Error"
	case decodingError = "decoding Error"
	case unknownError = "unknown Error"
	case badUrl = "invalid url adress"
}
