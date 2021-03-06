//
//  ArrayExtension.swift
//  SwiftEasyStock
//
//  Created by 何文新 on 15/2/20.
//  Copyright (c) 2015年 wesin. All rights reserved.
//

import Foundation

extension Array {
    
    func find(fn: (Element) -> Bool) -> Int {
        for (index,x) in self.enumerate() {
            if fn(x) {
                return index
            }
        }
        return -1
    }
}