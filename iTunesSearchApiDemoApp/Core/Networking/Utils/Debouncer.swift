//
//  Debouncer.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 2.10.2026.
//

import Foundation

final class Debouncer {
      private var workItem: DispatchWorkItem?
      private let delay: TimeInterval
      private let queue: DispatchQueue

      init(delay: TimeInterval, queue: DispatchQueue = .main) {
          self.delay = delay
          self.queue = queue
      }

      func debounce(action: @escaping () -> Void) {
          workItem?.cancel()

          let newWorkItem = DispatchWorkItem(block: action)
          workItem = newWorkItem

          queue.asyncAfter(deadline: .now() + delay, execute: newWorkItem)
      }

      func cancel() {
          workItem?.cancel()
      }
  }
