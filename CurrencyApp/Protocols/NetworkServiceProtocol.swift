//
//  NetworkServiceProtocol.swift
//  CurrencyApp
//
//  Created by 逸唐陳 on 2023/6/5.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func requestData(with urlRequest: URLRequest) -> AnyPublisher<Data, Error>
}
