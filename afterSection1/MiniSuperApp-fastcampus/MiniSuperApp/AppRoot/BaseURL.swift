//
//  BaseURL.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/07/23.
//

import Foundation

struct BaseURL {
  var financeBaseURL: URL {
    return URL(string: "https://finance.superapp.com/api/v1")!
  }
}
