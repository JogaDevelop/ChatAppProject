//
//  NetworkService.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 18.04.2024.
//

import UIKit




class NetworkServiceManager: NetworkService {
	
	private let cache = NSCache<NSString, UIImage>()
	
	func fetchMessages(offset: Int) async -> Result<MessagesResponse, RequestError> {
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
	
	func fetchAvatar(from urlString: String) async -> UIImage? {
		guard let url = URL(string: urlString) else   {
			return nil
		}
		do {
			let (data, response) = try await URLSession.shared.data(from: url)
			try handleResponse(response)
			return UIImage(data: data)
		} catch  {
			
			return nil
		}
	}
	
	func downloadImage(from urlString: String) async -> UIImage? {
		if let cachedImage = cache.object(forKey: NSString(string: urlString)) {
			return cachedImage
		} else if let fetchAvatar = await fetchAvatar(from: urlString) {
			cache.setObject(fetchAvatar, forKey: NSString(string: urlString))
			return fetchAvatar
		}
		return nil
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
