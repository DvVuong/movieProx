//
//  BaseObject.swift
//  Moffy
//
//  Created by MRX on 18/12/2023.
//

import Foundation
import RealmSwift

class BaseObject: Object {
  @Persisted(primaryKey: true) var id: String
  @Persisted var name: String
  
//  func isDownloaded() -> Bool {
//    return filename != nil
//  }
}
