import Foundation
import SwiftUI
import Combine

class DownloadManager: ObservableObject {
    @Published var progress: Double = 0.0
    @Published var currentFile: String = ""
    @Published var isDownloading: Bool = false
    @Published var completedCount: Int = 0
    @Published var failedCount: Int = 0
    @Published var totalCount: Int = 0
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var failedFiles: [String] = []
    
    private var downloadTask: Task<Void, Never>?
    
    func downloadMemories(memories: [SnapchatMemory], to outputDirectory: URL) {
        downloadTask = Task { @MainActor in
            await performDownload(memories: memories, to: outputDirectory)
        }
    }
    
    func cancelDownload() {
        downloadTask?.cancel()
        Task { @MainActor in
            self.isDownloading = false
            self.currentFile = "Download cancelled"
        }
    }
    
    @MainActor
    private func performDownload(memories: [SnapchatMemory], to outputDirectory: URL) async {
        self.isDownloading = true
        self.completedCount = 0
        self.failedCount = 0
        self.totalCount = memories.count
        self.progress = 0.0
        self.errorMessage = nil
        self.showError = false
        self.failedFiles = []
        self.currentFile = "Preparing download..."
        
        print("Starting download of \(memories.count) memories")
        
        var folderStructure: [String: [SnapchatMemory]] = [:]
        for memory in memories {
            let folderName = memory.folderName
            if folderStructure[folderName] == nil {
                folderStructure[folderName] = []
            }
            folderStructure[folderName]?.append(memory)
        }
        
        for folderName in folderStructure.keys {
            let folderURL = outputDirectory.appendingPathComponent(folderName)
            try? FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
        }
        
        for (index, memory) in memories.enumerated() {
            if Task.isCancelled {
                print("Download cancelled at \(index)")
                break
            }
            
            self.currentFile = "Downloading \(memory.fileName)..."
            
            do {
                try await downloadFile(memory: memory, to: outputDirectory)
                self.completedCount += 1
                print("✅ Downloaded \(index + 1)/\(memories.count): \(memory.fileName)")
            } catch let error as URLError {
                self.failedCount += 1
                self.failedFiles.append(memory.fileName)
                
                switch error.code {
                case .badURL:
                    print("❌ Failed \(memory.fileName): Invalid URL")
                case .badServerResponse:
                    print("❌ Failed \(memory.fileName): Link expired or invalid")
                case .timedOut:
                    print("❌ Failed \(memory.fileName): Connection timed out")
                case .cannotConnectToHost, .notConnectedToInternet:
                    print("❌ Failed \(memory.fileName): No internet connection")
                default:
                    print("❌ Failed \(memory.fileName): \(error.localizedDescription)")
                }
            } catch {
                self.failedCount += 1
                self.failedFiles.append(memory.fileName)
                print("❌ Failed \(memory.fileName): \(error.localizedDescription)")
            }
            
            self.progress = Double(self.completedCount + self.failedCount) / Double(self.totalCount)
            
            try? await Task.sleep(nanoseconds: 100_000_000)
        }
        
        self.isDownloading = false
        
        if self.failedCount == 0 {
            self.currentFile = "Successfully downloaded all \(self.completedCount) files!"
        } else if self.completedCount == 0 {
            self.currentFile = "Failed to download any files. Links may have expired."
            self.errorMessage = "All download links appear to be expired or invalid. Please export fresh data from Snapchat."
            self.showError = true
        } else {
            self.currentFile = "Downloaded \(self.completedCount) files, \(self.failedCount) failed"
            self.errorMessage = "\(self.failedCount) files failed to download. Links may have expired."
            self.showError = true
        }
        
        print("Download complete: \(self.completedCount) succeeded, \(self.failedCount) failed")
    }
    
    private func downloadFile(memory: SnapchatMemory, to outputDirectory: URL) async throws {
        guard let url = URL(string: memory.downloadLink) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 403 || httpResponse.statusCode == 404 {
                throw URLError(.badServerResponse)
            }
            throw URLError(.badServerResponse)
        }
        
        let folderURL = outputDirectory.appendingPathComponent(memory.folderName)
        let fileURL = folderURL.appendingPathComponent(memory.fileName)
        try data.write(to: fileURL)
        
        try writeMetadata(for: memory, at: fileURL)
        
        if let creationDate = memory.parsedDate {
            try FileManager.default.setAttributes(
                [.creationDate: creationDate, .modificationDate: creationDate],
                ofItemAtPath: fileURL.path
            )
        }
    }
    
    private func writeMetadata(for memory: SnapchatMemory, at fileURL: URL) throws {
        var metadata: [String: Any] = [
            "Date": memory.date,
            "Media Type": memory.mediaType,
            "Download Link": memory.downloadLink
        ]
        
        if let location = memory.location {
            metadata["Location"] = location
        }
        
        if let coords = memory.coordinates {
            metadata["Latitude"] = coords.latitude
            metadata["Longitude"] = coords.longitude
        }
        
        let metadataURL = fileURL.deletingPathExtension().appendingPathExtension("json")
        let jsonData = try JSONSerialization.data(withJSONObject: metadata, options: [.prettyPrinted, .sortedKeys])
        try jsonData.write(to: metadataURL)
    }
}
