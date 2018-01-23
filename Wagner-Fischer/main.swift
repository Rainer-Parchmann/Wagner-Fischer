//
//  main.swift
//  Wagner-Fischer
//
//  Created by Rainer Parchmann on 11.08.16.
//  Copyright © 2016 Rainer Parchmann. All rights reserved.
//

import Foundation


// Wagner Fischer Verfahren zum Bestimmen des Abstands zweier Zeichenketten
// x und y sowie Ausgabe des Alignments


let x = "abcabba"
let y = "cbabac"
let nullChar: Character = "-"


let blabla = "nur zum Testen!"

// (a,b) ist die Ausrichtung

var ausrichtung = (xs: "",ys: "")


let xArray = [Character]()
let yArray = [Character]()

func convertStringToCharacterArray(_ s: String) -> [Character]
{
    var a: [Character] = ["$"]
    for i in s.characters.indices {
        a.append(s[i])
    }
    return a
}

let n = x.characters.count
let m = y.characters.count


var d = [[Int]](repeating: [Int] (repeating: 0, count: m+1),  count: n+1)

func w(_ x: Character, y: Character) -> Int
{
    // die Gewichtsfunktion, zunächste mal einfach
    return x == y ? 0 : 1
}

func min3(a: Int, b: Int, c: Int) -> Int
{
    let t = a < b ? a: b
    return  t < c ? t : c
}

var i = 1
var j = 1

let ax = convertStringToCharacterArray(x)
let ay = convertStringToCharacterArray(y)

while  i <= n {
    d[i][0] = d[i-1][0] + w(ax[i],y: nullChar)
    i += 1
}

while j <= m {
    d[0][j] = d[0][j-1] + w(nullChar, y: ay[j])
    j += 1
}

i = 1

while i <= n {
    j = 1
    while j <= m {
        d[i][j] = min3(a: d[i-1][j] + w(ax[i],y: nullChar),
                       b: d[i][j-1] + w(nullChar, y: ay[j]),
                       c: d[i-1][j-1] + w(ax[i],y: ay[j]))
        j += 1
    }
    i += 1
}

print("x = \(x)\ny = \(y)\nDistanz = \(d[n][m])")




func printcp(char_x: Character, char_y: Character) {
    ausrichtung.xs.append(char_x)
    ausrichtung.ys.append(char_y)
}



func findAlignment(p: (i: Int, j:Int)) {
    
    switch p {
    case (0, 0):
        return
    
    case (0, let j):
        findAlignment(p:(0,j-1))
        printcp(char_x: nullChar, char_y: ay[j])
        
    case (let i, 0):
        findAlignment(p: (i-1,0))
        printcp(char_x: ax[i],char_y: nullChar)
        
    case (let i, let j):
        if d[i][j] == d[i-1][j-1] + w(ax[i],y: ay[j]) {
            findAlignment(p: (i-1,j-1))
            printcp(char_x: ax[i], char_y: ay[j])

        } else if d[i][j] == d[i-1][j] + w(ax[i],y: nullChar) {
            findAlignment(p: (i-1,j))
            printcp(char_x: ax[i], char_y: nullChar)
        } else {
            findAlignment(p: (i,j-1))
            printcp(char_x: nullChar, char_y: ay[j])
        }
    }
}



// alternative, nicht rekursive Version, liefert das Alignment reverse
//
//func findAlignment(n: Int, m: Int) {
//    var i = n
//    var j = m
//    while i != 0 && j != 0 {
//        if i == 0 {
//            printcp("-", cy: ay[j])
//            j -= 1
//        } else if j == 0 {
//            printcp(ax[i], cy: "-")
//            i -= 1
//        } else { // i != 0 && j != 0
//            if d[i][j] == d[i-1][j-1] + w(ax[i],y: ay[j]) {
//                printcp(ax[i], cy: ay[j])
//                i -= 1
//                j -= 1
//            } else if d[i][j] == d[i-1][j] + w(ax[i],y: "-") {
//                printcp(ax[i], cy: "-")
//                i -= 1
//            } else {
//                printcp("-", cy: ay[j])
//                j -= 1
//            }
//            
//        }
//    }
//}


findAlignment(p: (n, m))

print(ausrichtung.xs + "\n" + ausrichtung.ys + "\n")
