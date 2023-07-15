//
//  SuperPayRepository.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/07/07.
//

import Foundation
import Combine
import CombineUtil

protocol SuperPayRepository {
  var balance: ReadOnlyCurrentValuePublisher<Double> { get }
  func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error>
}

final class SuperPayRepositoryImp: SuperPayRepository {
  var balance: ReadOnlyCurrentValuePublisher<Double> { balanceSubject }
  private let balanceSubject = CurrentValuePublisher<Double>(0)
  
  func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error> {
    return Future<Void, Error> { [weak self] promise in
      self?.bgQueue.async {
        Thread.sleep(forTimeInterval: 2)
        promise(.success(()))
        let newBalance = (self?.balance.value).map { $0 + amount }
        newBalance.map { self?.balanceSubject.send($0) }
      }
    }
    .eraseToAnyPublisher()
  }
  
  private let bgQueue = DispatchQueue(label: "topup.repository.queue")
}
