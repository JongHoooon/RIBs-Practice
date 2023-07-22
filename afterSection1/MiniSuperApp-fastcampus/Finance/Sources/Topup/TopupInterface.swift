//
//  TopupInterface.swift
//  
//
//  Created by JongHoon on 2023/07/22.
//

import Foundation
import ModernRIBs

public protocol TopupBuildable: Buildable {
  func build(withListener listener: TopupListener) -> Routing
}

public protocol TopupListener: AnyObject {
  func topupDidClose()
  func topupDidFinish()
}
