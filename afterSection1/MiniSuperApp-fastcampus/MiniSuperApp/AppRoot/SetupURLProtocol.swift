//
//  SetupURLProtocol.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/07/23.
//

import Foundation

func setupURLProtocol() {
  
  // MARK: - Topup
  
  let topupRespones: [String: Any] = [
    "status": "success"
  ]
  
  let topupResponseData = try! JSONSerialization.data(
    withJSONObject: topupRespones,
    options: []
  )
  
  // MARK: - AddCard
  
  let addCardResponse: [String: Any] = [
    "card": [
      "id": "999",
      "name": "새 카드",
      "digits": "**** 0101",
      "color": "",
      "isPrimary": false
    ]
  ]
  
  let addCardResponseData = try! JSONSerialization.data(
    withJSONObject: addCardResponse,
    options: []
  )
  
  // MARK: - CardOnFile
  
  let cardOnFileResponse: [String: Any] = [
    "cards": [
      [
        "id": "0",
        "name": "우리은행",
        "digits": "0123",
        "color": "#f19a38ff",
        "isPrimary": false
      ],
      [
        "id": "1",
        "name": "신한카드",
        "digits": "0123",
        "color": "#3478f6ff",
        "isPrimary": false
      ],
      [
        "id": "3",
        "name": "국민은행",
        "digits": "0123",
        "color": "#65c466ff",
        "isPrimary": false
      ]
    ]
  ]
  
  let cardOnFileResponseData = try! JSONSerialization.data(
    withJSONObject: cardOnFileResponse,
    options: []
  )
  
  SuperAppURLProtocol.sucessMock = [
    "/api/v1/topup": (200, topupResponseData),
    "/api/v1/addCard": (200, addCardResponseData),
    "/api/v1/cards": (200, cardOnFileResponseData)
  ]
  
}

