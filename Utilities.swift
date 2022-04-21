//
//  Utilities.swift
//  WheatherApp
//
//  Created by Samuel Noye on 20/04/2022.
//

import Foundation

class Utilities {
    func getStorage() -> UserDefaults {
        return UserDefaults.standard
    }
    func setSkinType (value: String) {
       
    }
    func getSkinType() -> String {
        let defualt = getStorage()
        if let result = defualt.string(forKey: defualtkeys.skinType){
            return result
        }
            return SkinType().type1
    }
}

struct SkinType {
    let type1 = "Type 1 - Pale / Light"
    let type2 = "Type 2 - White / Fair"
    let type3 = "Type 3 - Mdeium / Light"
    let type4 = "Type 4 - Olive Brown"
    let type5 = "Type 5 - Dark Brown"
    let type6 = "Type 6 - Very Dark / Black"
}

struct defualtkeys {
    static let skinType = "skinType"
}
