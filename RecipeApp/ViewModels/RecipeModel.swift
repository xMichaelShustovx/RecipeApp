//
//  RecipeModel.swift
//  RecipeApp
//
//  Created by Michael Shustov on 08.08.2021.
//

import Foundation


class RecipeModel: ObservableObject {
    
    @Published var recipes = [Recipe]()
    
    init() {
        
        // Create an instance of data service and get the data
        self.recipes = DataService.getLocalData()
    }
    
    static func getPortion (ingredient: Ingredient, recipeServings: Int, targetServings: Int) -> String {
        
        var portion = ""
        var numerator = ingredient.num ?? 1
        var denumerator = ingredient.denom ?? 1
        var wholePortions = 0
        
        if ingredient.num != nil {
            
            denumerator *= recipeServings
            numerator *= targetServings
            
            let commonDivisor = Rational.greatestCommonDivisor(numerator, denumerator)
            
            denumerator  /= commonDivisor
            numerator /= commonDivisor
            
            if numerator >= denumerator {
                
                wholePortions = numerator / denumerator
                
                numerator = numerator % denumerator
                
                portion += String(wholePortions)
            }
            
            if numerator > 0 {
                
                portion += wholePortions > 0 ? " " : ""
                portion += "\(numerator)/\(denumerator)"
            }
        }
        
        if var unit = ingredient.unit {
            
            if wholePortions > 1{
                
                if unit.suffix(2) == "ch" {
                    unit += "es"
                }
                else if unit.suffix(1) == "f" {
                    
                    unit = String(unit.dropLast())
                    unit += "ves"
                }
                else {
                    unit += "s"
                }
            }
            
            portion += ingredient.num == nil && ingredient.denom == nil ? "" : " "
            
            return portion + unit
        }
            
        return portion
    }
}
