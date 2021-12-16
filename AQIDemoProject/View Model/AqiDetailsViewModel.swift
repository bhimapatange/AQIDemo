//
//  AqiDetailsViewModel.swift
//  AQIDemoProject
//
//  Created by Mayur on 15/12/21.
//

import Foundation
class AqiDetailsViewModel {
    var airQualityDataSource: [AQIModel] = []
    private var airQualityModel: AQIModel
    private let socketManager = SocketManager()
    private var timer: Timer?

    init(aqiModel : AQIModel) {
        self.airQualityModel = aqiModel
    }
    func getAqiModel() -> AQIModel {
        return self.airQualityModel
    }
    func refreshList(handler: @escaping () -> Void) {
//      airQualityDataSource.removeAll()
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
            let results = models.filter({ (model) -> Bool in
                return model.city == self.airQualityModel.city
            })
            if results.count > 0 {
              self.airQualityModel = results[0]
            }
            handler()
          case .failure(let error):
            print(error)
            handler()
          }
        }
      }
  
  
}
