//
//  Chore.swift
//  SwiftChore
//
//  Created by AndrewJRangel on 1/21/16.
//  Copyright © 2016 Antifragile Development. All rights reserved.
//

import Foundation


public struct Chore:Hashable {
    var id:String
    var name:String
    var pointValue:Int
    var type:ChoreType
    
    public var hashValue:Int {
        return id.hashValue
    }
}

public func ==(lhs:Chore, rhs:Chore) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

public enum ChoreType:String {
    case Homework = "homework"
    case Cleaning = "cleaning"
    case HelpingOut = "helpingout"
}
