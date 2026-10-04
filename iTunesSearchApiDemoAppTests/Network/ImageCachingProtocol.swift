////
////  ImageCachingProtocol.swift
////  iTunesSearchApiDemoApp
////
////  Created by Melisa Öztürk on 5.10.2026.
////
//
//@testable import iTunesSearchApiDemoApp
//
//class ImageCachingProtocolSpy: ImageCachingProtocol {
//    var clearMemoryCalled = false
//    var storedImages: [URL: UIImage] = [:]
//
//    func memoryImage(for url: URL) -> UIImage? {
//        return storedImages[url]
//    }
//
//    func store(_ image: UIImage, for url: URL) {
//        storedImages[url] = image
//    }
//
//    func clearMemory() {
//        clearMemoryCalled = true
//        storedImages.removeAll()
//    }
//}
