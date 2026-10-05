//
//  ImageCache.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 3.10.2026.
//

import UIKit

final class ImageCache {
    
    static let shared = ImageCache()
    private let memoryCache = NSCache<NSURL, UIImage>()
    
    private init(memoryLimit: Int = 50 * 1024 * 1024) {
        memoryCache.totalCostLimit = memoryLimit
    }
    
    func memoryImage(for url: URL) -> UIImage? {
        memoryCache.object(forKey: url as NSURL)
    }
    
    func store(_ image: UIImage, for url: URL) {
        memoryCache.setObject(image, forKey: url as NSURL, cost: image.memoryCost)
    }
    
    func clearMemory() {
        memoryCache.removeAllObjects()
    }
}
