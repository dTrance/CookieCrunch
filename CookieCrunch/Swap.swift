//
//  Swap.swift
//  CookieCrunch
//
//  Created by Doug Trance on 12/25/16.
//  Copyright © 2016 Trance Apps. All rights reserved.
//

struct Swap: CustomStringConvertible {
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
