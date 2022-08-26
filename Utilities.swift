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
        let defualts = getStorage()
        defualts.setValue(value, forKey: defualtkeys.skinType)
      //  defualts.synchronize()
    }
    func getSkinType() -> String {
        let defualt = getStorage()
        if let result = defualt.string(forKey: defualtkeys.skinType){
            return result
        }
            return SkinType().type1
    }
}

