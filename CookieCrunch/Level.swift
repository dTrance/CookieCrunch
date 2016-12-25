//
//  Level.swift
//  CookieCrunch
//
//  Created by Doug Trance on 12/25/16.
//  Copyright © 2016 Trance Apps. All rights reserved.
//

import Foundation

let NumColumns = 9
let NumRows = 9

class Level {
    fileprivate var cookies = Array2d<Cookie>(columns: NumColumns, rows: NumRows)
    fileprivate var tiles = Array2d<Tile>(columns: NumColumns, rows: NumRows)
    
    
    init(filename: String) {
        // 1
        guard let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: filename) else { return }
        // 2
        guard let tilesArray = dictionary["tiles"] as? [[Int]] else { return }
        // 3
        for (row, rowArray) in tilesArray.enumerated() {
            // 4
            let tileRow = NumRows - row - 1
            // 5
            for (column, value) in rowArray.enumerated() {
                if value == 1 {
                    tiles[column, tileRow] = Tile()
                }
            }
        }
        print(filename)
    }

    
    func cookieAt(column: Int, row: Int) -> Cookie? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return cookies[column, row]
    }
    
    func shuffle() -> Set<Cookie> {
        return createIntialCookies()
    }
    
    private func createIntialCookies() -> Set<Cookie> {
        var set = Set<Cookie>()
        
        //1 
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                
                //2 
                if tiles[column, row] != nil {
                let cookieType = CookieType.random()
                
                //3
                let cookie = Cookie(column: column, row: row, cookieType: cookieType)
                cookies[column, row] = cookie
                
                //4 
                set.insert(cookie)
                }
            }
        }
        return set
    }
    
    func tileAt(column: Int, row: Int) -> Tile? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return tiles[column, row]
    }
    
}
