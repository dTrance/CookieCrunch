//
//  Array2d.swift
//  CookieCrunch
//
//  Created by Doug Trance on 12/24/16.
//  Copyright © 2016 Trance Apps. All rights reserved.


struct Array2d<T> {
    let columns: Int
    let rows: Int
    fileprivate var array: Array<T?>
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(repeating: nil, count: rows*columns)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get {
            return array[row*columns + column]
        }
        set {
            array[row*columns + column] = newValue
        }
    }
}



//struct Array2d<T> {
//    
//    let columns: Int
//    let rows: Int
//    fileprivate var array: Array<T?>
//    
//    init(columns: Int, rows: Int) {
//        self.columns = columns
//        self.rows = rows
//        array = Array<T?>(repeating: nil, count: rows*columns)
//    }
//    
//    subscript(column: Int, row: Int) -> T? {
//        get {
//            return array[row*columns + column]
//        }
//        set {
//            array[row*columns + column] = newValue
//        }
//    }
//    
//}
