//
//  Task.swift
//  RxSwiftToDoExample
//
//  Created by gru on 2017. 4. 25..
//  Copyright © 2017년 com.myungGiSon. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources

class Task: Object
{
    dynamic var uid: Int = 0
    dynamic var title: String = ""
    dynamic var added: Date = Date()
    dynamic var checked: Date? = nil
    
    override class func primaryKey() -> String? { return "uid" }
}

extension Task: IdentifiableType
{
    var identity: Int { return self.isInvalidated ? 0 : uid }
}
