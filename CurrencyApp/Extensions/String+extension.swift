//
//  String+extension.swift
//  CurrencyApp
//
//  Created by 逸唐陳 on 2023/6/5.
//

import Foundation

extension String {
    var doubleValue: Double {
        return Double(self) ?? 0
    }
}
