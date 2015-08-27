//
//  StringExtension.swift
//  HupunErp
//
//  Created by 何文新 on 15/4/20.
//  Copyright (c) 2015年 wesin. All rights reserved.
//

import Foundation

extension String {
    
    // MARK: - sub String
    func substringToIndex(index:Int) -> String {
        return self.substringToIndex(self.startIndex.advancedBy(index))
    }
    func substringFromIndex(index:Int) -> String {
        return self.substringFromIndex(self.startIndex.advancedBy(index))
    }
    func substringWithRange(range:Range<Int>) -> String {
        let start = self.startIndex.advancedBy(range.startIndex)
        let end = self.startIndex.advancedBy(range.endIndex)
        return self.substringWithRange(start..<end)
    }
    
    subscript(index:Int) -> Character{
        return self[self.startIndex.advancedBy(index)]
    }
    subscript(range:Range<Int>) -> String {
        let start = self.startIndex.advancedBy(range.startIndex)
        let end = self.startIndex.advancedBy(range.endIndex)
        return self[start..<end]
    }
    
    
    // MARK: - replace
    func replaceCharactersInRange(range:Range<Int>, withString: String!) -> String {
        let result:NSMutableString = NSMutableString(string: self)
        result.replaceCharactersInRange(NSRange(range), withString: withString)
        return result as String
    }
}