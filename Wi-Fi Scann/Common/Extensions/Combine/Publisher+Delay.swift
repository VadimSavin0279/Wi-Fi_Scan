//
//  Publisher+Delay.swift
//  FaxApp
//
//  Created by Eugene on 23.05.2022.
//

import Combine
import Foundation

extension Publisher {
    func retry<T, E>(interval: TimeInterval, retries: Int)
    -> Publishers.Catch<Self, AnyPublisher<T, E>> where T == Self.Output, E == Self.Failure
    {
        return self.catch { error -> AnyPublisher<T, E> in
            return Publishers.Delay(
                upstream: self,
                interval: 3,
                tolerance: 1,
                scheduler: DispatchQueue.main
            )
            .retry(retries)
            .eraseToAnyPublisher()
        }
    }
}
