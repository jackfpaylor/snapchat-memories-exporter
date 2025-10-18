import Foundation

struct SnapchatMemory: Codable, Identifiable {
    let date: String
    let mediaType: String
    let location: String?
    let downloadLink: String
    
    var id: String { downloadLink }
    
    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case mediaType = "Media Type"
        case location = "Location"
        case downloadLink = "Download Link"
    }
    
    var parsedDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        return dateFormatter.date(from: date)
    }
    
    var fileName: String {
        if let parsedDate = parsedDate {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
            let dateString = outputFormatter.string(from: parsedDate)
            let ext = mediaType.lowercased() == "video" ? "mp4" : "jpg"
            return "\(dateString).\(ext)"
        }
        
        let ext = mediaType.lowercased() == "video" ? "mp4" : "jpg"
        return "memory_\(UUID().uuidString).\(ext)"
    }
    
    var folderName: String {
        if let parsedDate = parsedDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM"
            return formatter.string(from: parsedDate)
        }
        return "Unknown_Date"
    }
    
    var coordinates: (latitude: Double, longitude: Double)? {
        guard let location = location else { return nil }
        
        let components = location.replacingOccurrences(of: "Latitude, Longitude: ", with: "")
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
        
        guard components.count == 2,
              let lat = Double(components[0]),
              let lon = Double(components[1]) else {
            return nil
        }
        
        return (lat, lon)
    }
}

struct SnapchatData: Codable {
    let savedMedia: [SnapchatMemory]
    
    enum CodingKeys: String, CodingKey {
        case savedMedia = "Saved Media"
    }
}
