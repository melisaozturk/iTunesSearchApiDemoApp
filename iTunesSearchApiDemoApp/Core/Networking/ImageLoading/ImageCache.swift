//
//  ImageCache.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 3.10.2026.
//

import UIKit

final class ImageCache {
 
    static let shared = ImageCache()
 
    // MARK: - Properties
 
    private let memoryCache = NSCache<NSURL, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let ioQueue = DispatchQueue(label: "com.itunes.imageCache", qos: .utility, attributes: .concurrent)
 
    // MARK: - Init
 
    // internal: unit test'te farklı klasörle oluşturulabilsin diye
    init(directoryName: String = "ImageCache", memoryLimit: Int = 50 * 1024 * 1024) {
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        cacheDirectory = caches.appendingPathComponent(directoryName, isDirectory: true)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        memoryCache.totalCostLimit = memoryLimit
    }
 
    // MARK: - Public Methods
 
    /// Sadece memory'ye bakar, main thread'den güvenle çağrılabilir.
    func memoryImage(for url: URL) -> UIImage? {
        memoryCache.object(forKey: url as NSURL)
    }
 
    /// Disk'i background'da okur. Bulursa memory'ye de ekler.
    func diskImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        ioQueue.async { [weak self] in
            guard let self, let image = self.loadImageFromDisk(for: url) else {
                completion(nil)
                return
            }
            self.memoryCache.setObject(image, forKey: url as NSURL, cost: image.memoryCost)
            completion(image)
        }
    }
 
    func store(_ image: UIImage, for url: URL) {
        memoryCache.setObject(image, forKey: url as NSURL, cost: image.memoryCost)
        ioQueue.async(flags: .barrier) { [weak self] in
            self?.saveImageToDisk(image, for: url)
        }
    }
 
    func clearMemory() {
        memoryCache.removeAllObjects()
    }
 
    func clearAll() {
        memoryCache.removeAllObjects()
        ioQueue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            try? self.fileManager.removeItem(at: self.cacheDirectory)
            try? self.fileManager.createDirectory(at: self.cacheDirectory, withIntermediateDirectories: true)
        }
    }
 
    // MARK: - Private Helpers
 
    private func diskCacheURL(for url: URL) -> URL {
        let fileName = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? UUID().uuidString
        return cacheDirectory.appendingPathComponent(fileName)
    }
 
    private func loadImageFromDisk(for url: URL) -> UIImage? {
        guard let data = try? Data(contentsOf: diskCacheURL(for: url)) else { return nil }
        return UIImage(data: data)
    }
 
    private func saveImageToDisk(_ image: UIImage, for url: URL) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        try? data.write(to: diskCacheURL(for: url), options: .atomic)
    }
}
 
private extension UIImage {
    /// Decode edilmiş bitmap'in yaklaşık bellek boyutu
    var memoryCost: Int {
        guard let cgImage else { return 0 }
        return cgImage.bytesPerRow * cgImage.height
    }
}
 
