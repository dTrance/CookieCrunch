//
//  Swap.swift
//  CookieCrunch
//
//  Created by Doug Trance on 12/25/16.
//  Copyright © 2016 Trance Apps. All rights reserved.
//

struct Swap: CustomStringConvertible, Hashable {
    var hashValue: Int {
        return cookieA.hashValue ^ cookieB.hashValue
    }
    let cookieA: Cookie
    let cookieB: Cookie
    
    init(cookieA: Cookie, cookieB: Cookie) {
        self.cookieA = cookieA
        self.cookieB = cookieB
        
    }
    
    var description: String {
        return "swap \(cookieA) with \(cookieB)"
    }
    
    
    
}

func ==(lhs: Swap, rhs: Swap) -> Bool {
    return (lhs.cookieA == rhs.cookieA && lhs.cookieB == rhs.cookieB) ||
           (lhs.cookieB == rhs.cookieA && lhs.cookieA == rhs.cookieB)
}
