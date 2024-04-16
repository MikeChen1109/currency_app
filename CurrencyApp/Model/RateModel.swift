//
//  RateModel.swift
//  CurrencyApp
//
//  Created by 逸唐陳 on 2023/6/5.
//

import Foundation

struct RateModel: Equatable {
    let currency: String
    let rate: Double
    
    // equatable
    static func == (lhs: RateModel, rhs: RateModel) -> Bool {
        return lhs.currency == rhs.currency &&
            lhs.rate == rhs.rate
    }
}
