//
//  MHUtils.swift
//  Bucket Game
//
//  Created by Michael Hulet on 3/30/16.
//  Copyright © 2016 Michael Hulet. All rights reserved.
//

import Foundation
//This'll end up in an MHCommons Swift framework sometime soon
extension NSDate: Comparable{}
@warn_unused_result public func >(lhs: NSDate, rhs: NSDate) -> Bool{
    return lhs.compare(rhs) == .OrderedDescending
}
@warn_unused_result public func <(lhs: NSDate, rhs: NSDate) -> Bool{
    return lhs.compare(rhs) == .OrderedAscending
}
@warn_unused_result public func ==(lhs: NSDate, rhs: NSDate) -> Bool{
    return lhs === rhs || lhs.isEqualToDate(rhs)
}
@warn_unused_result public func >=(lhs: NSDate, rhs: NSDate) -> Bool{
    return lhs > rhs || lhs == rhs
}
@warn_unused_result public func <=(lhs: NSDate, rhs: NSDate) -> Bool{
    return lhs < rhs || lhs == rhs
}