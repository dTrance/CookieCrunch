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
    fileprivate var possibleSwaps = Set<Swap>()
    
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
        var set: Set<Cookie>
        repeat {
            set = createIntialCookies()
            detectPossibleSwaps()
            print("Possible swaps: \(possibleSwaps)")
        } while possibleSwaps.count == 0
        return set
    }
    
    private func createIntialCookies() -> Set<Cookie> {
        var set = Set<Cookie>()
        
        //1 
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                
                //2 
                if tiles[column, row] != nil {
                    var cookieType: CookieType
                    repeat {
                       cookieType = CookieType.random()
                    } while (column >= 2 &&
                             cookies[column - 1, row]?.cookieType == cookieType &&
                             cookies[column - 2, row]?.cookieType == cookieType)
                        ||  (row >= 2 &&
                             cookies[column, row - 1]?.cookieType == cookieType &&
                             cookies[column, row - 2]?.cookieType == cookieType)
                    
                
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
 
    func performSwap(swap: Swap) {
        let columnA = swap.cookieA.column
        let rowA = swap.cookieA.row
        let columnB = swap.cookieB.column
        let rowB = swap.cookieB.row
        
        cookies[columnA, rowA] = swap.cookieB
        swap.cookieB.column = columnA
        swap.cookieB.row = rowA
        
        cookies[columnB, rowB] = swap.cookieA
        swap.cookieA.column = columnB
        swap.cookieA.row = rowB
    }
    
    fileprivate func hasChainAt(column: Int, row: Int) -> Bool {
        // Here we do ! because we know there is a cookie here
        let cookieType = cookies[column, row]!.cookieType
        
        // Horizontal chain check
        var horzLength = 1
        
        // Left
        var i = column - 1
        // Here we do ? because there may be no cookie there; if there isn't then
        // the loop will terminate because it is != cookieType. (So there is no
        // need to check whether cookies[i, row] != nil.)
        while i >= 0 && cookies[i, row]?.cookieType == cookieType {
            i -= 1
            horzLength += 1
        }
        
        // Right
        i = column + 1
        while i < NumColumns && cookies[i, row]?.cookieType == cookieType {
            i += 1
            horzLength += 1
        }
        if horzLength >= 3 { return true }
        
        // Vertical chain check
        var vertLength = 1
        
        // Down
        i = row - 1
        while i >= 0 && cookies[column, i]?.cookieType == cookieType {
            i -= 1
            vertLength += 1
        }
        
        // Up
        i = row + 1
        while i < NumRows && cookies[column, i]?.cookieType == cookieType {
            i += 1
            vertLength += 1
        }
        return vertLength >= 3
    }

    

    
    
    
    func detectPossibleSwaps() {
        var set = Set<Swap>()
        
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if let cookie = cookies[column, row] {
                    
                    // TODO: detection logic here
                    // Is it possible to swap this cookie with the one to the right?
                    if column < NumColumns - 1 {
                        // Have a cookie in this spot? If there is no tile there is no cookie
                        if let other = cookies[column + 1, row] {
                            //swap them
                            cookies[column, row] = other
                            cookies[column + 1, row] = cookie
                            
                            // is either cookie now part of a chain?
                            if hasChainAt(column: column + 1, row: row) ||
                                hasChainAt(column: column, row: row) {
                                set.insert(Swap(cookieA: cookie, cookieB: other))
                            }
                            // swap them back
                            cookies[column, row] = cookie
                            cookies[column + 1, row] = other
                        }
                    }
                    if row < NumRows - 1 {
                        if let other = cookies[column, row + 1] {
                            cookies[column, row] = other
                            cookies[column, row + 1] = cookie
                            
                            // is either cookie a part of a chain
                            if hasChainAt(column: column, row: row + 1) ||
                                hasChainAt(column: column, row: row) {
                                set.insert(Swap(cookieA: cookie, cookieB: other))
                            }
                            // swap them back
                            cookies[column, row] = cookie
                            cookies[column, row + 1] = other
                        }
                    }
                }
            }
        }
        possibleSwaps = set
    }
    
    func isPossibleSwap(_ swap: Swap) -> Bool {
        return possibleSwaps.contains(swap)
    }
    
    private func detectHorizontalMatches() -> Set<Chain>{
        
        var set = Set<Chain>()
        
        for row in 0..<NumRows {
            var column = 0
            while column < NumColumns - 2 {
                if let cookie = cookies[column, row] {
                    let matchType = cookie.cookieType
                    
                    if cookies[column + 1, row]?.cookieType == matchType &&
                        cookies[column + 2, row]?.cookieType == matchType {
                        let chain = Chain(chainType: .horizontal)
                        repeat {
                            chain.add(cookie: cookies[column, row]!)
                            column += 1
                        } while column < NumColumns && cookies[column, row]?.cookieType == matchType
                        
                        set.insert(chain)
                        continue
                    }
                }
                column += 1
            }
        }
        return set
    }
    
    func detectVerticalMatches() -> Set<Chain> {
        var set = Set<Chain>()
        
        for column in 0..<NumColumns {
            var row = 0
            while row < NumRows - 2 {
                if let cookie = cookies[column, row] {
                    let matchType = cookie.cookieType
                    
                    if cookies[column, row + 1]?.cookieType == matchType &&
                        cookies[column, row + 2]?.cookieType == matchType {
                        let chain = Chain(chainType: .vertical)
                        repeat {
                            chain.add(cookie: cookies[column, row]!)
                            row += 1
                        } while row < NumRows && cookies[column, row]?.cookieType == matchType
                        set.insert(chain)
                        continue
                    }
                }
                row += 1
            }
        }
        return set
    }
    
    func removeMatches() -> Set<Chain> {
        let horizontalChains = detectHorizontalMatches()
        let verticalChains = detectVerticalMatches()
        
        print("Horizontal matches: \(horizontalChains)")
        print("Vertical matches: \(verticalChains)")
        
        return horizontalChains.union(verticalChains)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


