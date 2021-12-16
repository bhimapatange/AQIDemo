//
//  Service.swift
//  AQIDemoProject
//
//  Created by Mayur on 01/12/21.
//

import Foundation


class SocketManager {
  
  var webSocketTask: URLSessionWebSocketTask?

  func openSocket() {
    let urlSession = URLSession(configuration: .default)
    webSocketTask = urlSession.webSocketTask(with: URL(string: API.wsBaseUrl)!)
    webSocketTask?.resume()
  }
  
  func closeSocket() {
    webSocketTask?.cancel(with: .goingAway, reason: nil)
  }
  
  func fetchData(handler: @escaping (Result<[AQIModel], Error>) -> Void) {
    webSocketTask?.receive { [weak self] result in
      switch result {
      case .failure(let error):
        handler(.failure(error))
      case .success(let message):
        switch message {
        case .string(let text):
          if let data = text.data(using: .utf8),
             let models = self?.getAQIModels(data: data) {
            handler(.success(models))
          }
        case .data(let data):
          if let models = self?.getAQIModels(data: data) {
            handler(.success(models))
          }
        @unknown default:
          fatalError()
        }
      }
    }
  }
  
  private func getAQIModels(data: Data) -> [AQIModel] {
    do {
      let models = try JSONDecoder().decode([AQIModel].self, from: data)
      return models
    } catch {
      print(error)
    }
    return []
  }
}
