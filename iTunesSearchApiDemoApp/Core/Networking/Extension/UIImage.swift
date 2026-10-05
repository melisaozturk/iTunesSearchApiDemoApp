//
//  UIImage.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 4.10.2026.
//

import UIKit

extension UIImage {
    var memoryCost: Int {
        guard let cgImage else { return 0 }
        return cgImage.bytesPerRow * cgImage.height
    }
}
