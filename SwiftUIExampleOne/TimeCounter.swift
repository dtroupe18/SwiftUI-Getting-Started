//
//  TimeCounter.swift
//  SwiftUIExampleOne
//
//  Created by Dave Troupe on 11/16/19.
//  Copyright © 2019 High Tree Development. All rights reserved.
//

import Foundation
import Combine

final class TimeCounter: ObservableObject {
  var timer: Timer?
  @Published var counter = 0

  // Inject interval and repeats so this class is more customizable.
  init(interval: Double = 1.0, repeats: Bool = true) {
    timer = Timer.scheduledTimer(
      timeInterval: interval,
      target: self,
      selector: #selector(self.updateCounter),
      userInfo: nil,
      repeats: repeats
    )
  }

  @objc private func updateCounter() {
    self.counter += 1
  }

  public func killTimer() {
    self.timer?.invalidate()
    self.timer = nil
  }
}
