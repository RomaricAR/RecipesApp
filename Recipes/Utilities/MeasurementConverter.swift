//
//  MeasurementConverter.swift
//  Recipes
//
//  Created by Romaric Allahramadji on 8/10/24.
//

import Foundation

func convertMeasurementToOunces(_ measurement: String) -> String {
    var converted = measurement
    
    // If both "g" and "oz" are present, extract and return only the "oz" part
    if converted.contains("g") && converted.contains("oz") {
        if let range = converted.range(of: "\\d+\\.?\\d*\\s?oz", options: .regularExpression) {
            let ouncePart = String(converted[range])
            return ouncePart.trimmingCharacters(in: .whitespaces)
        }
    }
    
    // Convert grams to ounces if only grams are present
    if converted.contains("g") {
        if let grams = extractNumericValue(from: measurement, unit: "g") {
            let ounces = grams * 0.035274 // Convert grams to ounces
            converted = String(format: "%.1f oz", ounces)
        }
    }
    // Convert milliliters to fluid ounces if only milliliters are present
    if converted.contains("ml") {
        if let ml = extractNumericValue(from: measurement, unit: "ml") {
            let flOz = ml * 0.033814 // Convert milliliters to fluid ounces
            converted = String(format: "%.1f fl oz", flOz)
        }
    }
    // Convert centimeters to inches if only centimeters are present
    if converted.contains("cm") {
        if let cm = extractNumericValue(from: measurement, unit: "cm") {
            let inches = cm * 0.393701 // Convert centimeters to inches
            converted = String(format: "%.1f in", inches)
        }
    }
    return converted
}

func standardizeUnitsInText(_ text: String) -> String {
    var convertedText = text
    let units = ["g", "ml", "cm", "oz"]

    // Regular expression pattern to match and convert temperatures from °C or C to °F
    let celsiusPattern = "\\d+\\.?\\d*\\s?°?C"
    let tempRegex = try? NSRegularExpression(pattern: celsiusPattern, options: [])
    
    // Replace Celsius temperatures with Fahrenheit
    if let matches = tempRegex?.matches(in: convertedText, options: [], range: NSRange(location: 0, length: convertedText.count)) {
        for match in matches.reversed() { // reversed() to handle multiple matches correctly
            if let range = Range(match.range, in: convertedText) {
                let celsiusText = String(convertedText[range])
                if let celsiusValue = Double(celsiusText.replacingOccurrences(of: "°C", with: "").replacingOccurrences(of: "C", with: "")) {
                    let fahrenheitValue = celsiusToFahrenheit(celsiusValue)
                    let fahrenheitText = String(format: "%.0f°F", fahrenheitValue)
                    convertedText.replaceSubrange(range, with: fahrenheitText)
                }
            }
        }
    }
    
    // Regular expression pattern to match cases like "18cm/7in" or similar
    let cmInPattern = "\\d+\\.?\\d*\\s?cm/\\d+\\.?\\d*\\s?in"
    
    // If both "cm" and "in" are present in the form of "18cm/7in", remove the "cm" part and "/"
    if let range = convertedText.range(of: cmInPattern, options: .regularExpression) {
        let match = String(convertedText[range])
        
        // Extract and keep only the "in" part
        if let inchRange = match.range(of: "\\d+\\.?\\d*\\s?in", options: .regularExpression) {
            let inchPart = String(match[inchRange])
            convertedText = convertedText.replacingOccurrences(of: match, with: inchPart)
        }
    }

    for unit in units {
        let regexPattern = "(\\d+\\.?\\d*)\\s?\(unit)"
        
        while let range = convertedText.range(of: regexPattern, options: .regularExpression) {
            let match = String(convertedText[range])
            let converted = convertMeasurementToOunces(match)
            
            // Avoid an infinite loop by breaking if no change is made
            if converted == match {
                break
            }
            convertedText = convertedText.replacingOccurrences(of: match, with: converted)
        }
    }
    
    // Add ° symbol before F only when preceded by a digit
    convertedText = convertedText.replacingOccurrences(of: "(\\d)F", with: "$1°F", options: .regularExpression)
    
    return convertedText
}

func celsiusToFahrenheit(_ celsius: Double) -> Double {
    return (celsius * 9/5) + 32
}


// Standardize ingredient names (capitalize each word)
func standardizeIngredientName(_ ingredient: String) -> String {
    return ingredient.capitalized
}

// Extract numeric value from a measurement string, given a specific unit
func extractNumericValue(from measurement: String, unit: String) -> Double? {
    let pattern = "\\d+\\.?\\d*\\s?\(unit)"  // Regex to match numeric value followed by unit
    
    if let range = measurement.range(of: pattern, options: .regularExpression) {
        let valueString = measurement[range]
            .replacingOccurrences(of: unit, with: "")  // Remove the unit
            .trimmingCharacters(in: .whitespaces)  // Trim any leading/trailing spaces
        return Double(valueString)
    }
    return nil
}

func processInstructions(_ instructions: String) -> String {
    
    // Convert measurements in the instructions to ounces
    let processedInstructions = standardizeUnitsInText(instructions)
    
    return processedInstructions
}


// Process each ingredient by converting and standardizing its measurement
func processIngredientAndMeasurement(_ ingredient: String, with measurement: String) -> String {
    let processedMeasurement = convertMeasurementToOunces(measurement)
    let standardizedIngredient = standardizeIngredientName(ingredient)
    return "\(standardizedIngredient): \(processedMeasurement)"
}
