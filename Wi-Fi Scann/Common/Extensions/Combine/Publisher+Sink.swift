//
//  Publisher+Sink.swift
//  FaxApp
//
//  Created by Eugene on 11.05.2022.
//

import Combine

extension Publisher {
    public func sinkResult(_ completion: @escaping (Result<Self.Output, Self.Failure>) -> Void) -> AnyCancellable {
        return self.sink { compl in
            switch compl {
            case .failure(let error):
                completion(.failure(error))
            case .finished:
                break
            }
        } receiveValue: { output in
            return completion(.success(output))
        }
    }
    
    public func sinkSuccess(_ completion: @escaping (Output) -> Void) -> AnyCancellable {
        return self.sinkResult { result in
            switch result {
            case .success(let output):
                completion(output)
            case .failure:
                break
            }
        }
    }
}
