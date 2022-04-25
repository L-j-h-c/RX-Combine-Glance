//
//  supporting.swift
//  RXPractice
//
//  Created by Junho Lee on 2022/04/10.
//

import Foundation

public func example(of description: String, action: () -> Void) {
  print("\n--- Example of:", description, "---")
  action()
}
