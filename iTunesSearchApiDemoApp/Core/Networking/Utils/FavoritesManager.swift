//
//  FavoritesManager.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 13.10.2026.
//

import Foundation

protocol FavoritesManagerProtocol {
    var favorites: [String] { get }
    func add(url: String)
    func remove(url: String)
}

final class FavoritesManager: FavoritesManagerProtocol {
    private let userDefaults: UserDefaults = .standard
    private let favoritesKey = "favorites"
    
    static let shared = FavoritesManager()
    
    private init() { }
  
    private(set) var favorites: [String] {
          get { userDefaults.stringArray(forKey: favoritesKey) ?? [] }
          set { userDefaults.set(newValue, forKey: favoritesKey) }
      }

      func add(url: String) {
          if !favorites.contains(url) {
              favorites.append(url)
          }
      }
    
    func remove(url: String) {
        favorites.removeAll { $0 == url }
    }
}
