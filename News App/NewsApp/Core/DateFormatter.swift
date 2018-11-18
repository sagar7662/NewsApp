import Foundation

extension String {
    
    func utcToLocale(currentFormat: String, requiredFormat: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = currentFormat
        formatter.locale = Locale(identifier: "UTC")
        if let date = formatter.date(from: self) {
            formatter.dateFormat = requiredFormat
            return formatter.string(from: date)
        }
        
        return self
    }
    
    func getDateFormattedString() -> String {
        return utcToLocale(currentFormat: "yyyy-MM-dd'T'HH:mm:ssZ", requiredFormat: "MMM d, yyyy")
    }
}
