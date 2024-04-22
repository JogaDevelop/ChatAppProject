//
//  ErrorRequest.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 21.04.2024.
//

import Foundation

enum RequestError: String, Error {
	case statusCodeError = "status code Error"
	case invalidResponseError = "invalid response Error"
	case connectionError = "connection Error"
	case decodingError = "decoding Error"
	case unknownError = "unknown Error"
	case badUrl = "invalid url adress"
}
