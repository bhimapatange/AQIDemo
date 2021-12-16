//
//  HomeViewModel.swift
//  Created by Mayur on 16/12/21.
//

import Foundation
import UIKit

class HomeViewModel {
  private var airQualityDataSource: [AQIModel] = []
  private let socketManager = SocketManager()
  private var timer: Timer?
  
  func numberOfRows() -> Int {
    return airQualityDataSource.count
  }
  
  func refreshList(handler: @escaping () -> Void) {
    airQualityDataSource.removeAll()
    fetchAQI {
      handler()
    }
  }
  
  func refreshList(after: TimeInterval, handler: @escaping () -> Void) {
    refreshList(handler: handler)
    self.timer = Timer.scheduledTimer(withTimeInterval: after, repeats: true) { [weak self] _ in
      self?.refreshList(handler: handler)
    }
  }
  
  func getAQIModel(index: Int) -> AQIModel? {
    if (airQualityDataSource.count > 0) {
      return airQualityDataSource[index]
    }
    return nil
  }
  
  func openSocket() {
    socketManager.openSocket()
  }
  
  func closeSocket() {
    socketManager.closeSocket()
  }
  
  func stopFetchingData() {
    self.timer?.invalidate()
  }
  
  private func fetchAQI(handler: @escaping () -> Void) {
    socketManager.fetchData { result in
      switch result {
      case .success(let models):
        self.airQualityDataSource = models.sorted(by: { $0.city ?? "" < $1.city ?? "" })
        handler()
      case .failure(let error):
        print(error)
        handler()
      }
    }
  }
  
  
}
