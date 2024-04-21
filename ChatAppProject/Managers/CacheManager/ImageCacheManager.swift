//
//  ImageCacheManager.swift
//  ChatAppProject
//
//  Created by Evgeny Kislitsin on 21.04.2024.
//

import UIKit

class ImageCacheManager {
	
	private let cache = NSCache<NSString, UIImage>()
	
	static let shared = ImageCacheManager()
	
	private init() {}
	
	func getImage(forKey key: String) -> UIImage? {
		return cache.object(forKey: key as NSString)
	}
	
	func setImage(_ image: UIImage, forKey key: String) {
		cache.setObject(image, forKey: key as NSString)
	}
	
	func removeImage(forKey key: String) {
		cache.removeObject(forKey: key as NSString)
	}
}


