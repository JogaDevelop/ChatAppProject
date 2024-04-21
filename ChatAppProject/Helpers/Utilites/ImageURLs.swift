//
//  ImageURLs.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 21.04.2024.
//

enum ImageURLs {
	case myPhoto
	case otherPhoto
	
	var urlString: String {
		switch self {
		case .myPhoto:
			return "https://cdn1.iconfinder.com/data/icons/user-pictures/100/male3-256.png"
		case .otherPhoto:
			return "https://cdn4.iconfinder.com/data/icons/avatars-xmas-giveaway/128/man_male_avatar_portrait-256.png"
		}
	}
}
