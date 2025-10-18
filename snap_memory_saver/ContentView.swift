import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var downloadManager = DownloadManager()
    @State private var selectedJSONFile: URL?
    @State private var outputDirectory: URL?
    @State private var memories: [SnapchatMemory] = []
    @State private var showingFileImporter = false
    @State private var showingFolderPicker = false
    @State private var showingFailedFiles = false
    @State private var parseError: String?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "photo.stack.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.yellow)
                Text("Snapchat Memories Downloader")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .padding(.top, 30)
            .padding(.bottom, 20)
            
            Divider()
            
            VStack(spacing: 25) {
                VStack(alignment: .leading, spacing: 12) {
                    Label("Step 1: Select JSON File", systemImage: "doc.fill")
                        .font(.headline)
                    
                    HStack {
                        Text(selectedJSONFile?.lastPathComponent ?? "No file selected")
                            .foregroundColor(selectedJSONFile == nil ? .secondary : .primary)
                            .lineLimit(1)
                            .truncationMode(.middle)
                        
                        Spacer()
                        
                        Button(action: { showingFileImporter = true }) {
                            Label("Choose File", systemImage: "folder")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                    
                    if let error = parseError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Label("Step 2: Choose Output Folder", systemImage: "folder.fill")
                        .font(.headline)
                    
                    HStack {
                        Text(outputDirectory?.path ?? "No folder selected")
                            .foregroundColor(outputDirectory == nil ? .secondary : .primary)
                            .lineLimit(1)
                            .truncationMode(.middle)
                        
                        Spacer()
                        
                        Button(action: { showingFolderPicker = true }) {
                            Label("Choose Folder", systemImage: "folder.badge.plus")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                }
                
                if !memories.isEmpty {
                    HStack {
                        Image(systemName: "photo.on.rectangle.angled")
                            .foregroundColor(.blue)
                        Text("\(memories.count) memories found")
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
                
                if downloadManager.isDownloading {
                    VStack(spacing: 12) {
                        ProgressView(value: downloadManager.progress) {
                            HStack {
                                Text("Progress")
                                    .font(.subheadline)
                                Spacer()
                                Text("\(downloadManager.completedCount) succeeded, \(downloadManager.failedCount) failed / \(downloadManager.totalCount) total")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Text(downloadManager.currentFile)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                }
                
                if !downloadManager.isDownloading && !downloadManager.currentFile.isEmpty {
                    HStack {
                        Image(systemName: downloadManager.failedCount > 0 ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                            .foregroundColor(downloadManager.failedCount > 0 ? .orange : .green)
                        Text(downloadManager.currentFile)
                            .font(.subheadline)
                        Spacer()
                        
                        if downloadManager.failedCount > 0 {
                            Button("View Failed") {
                                showingFailedFiles = true
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        }
                    }
                    .padding()
                    .background(downloadManager.failedCount > 0 ? Color.orange.opacity(0.1) : Color.green.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    if downloadManager.isDownloading {
                        Button(action: {
                            downloadManager.cancelDownload()
                        }) {
                            Label("Cancel", systemImage: "xmark.circle.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    } else {
                        Button(action: startDownload) {
                            Label("Download All Memories", systemImage: "arrow.down.circle.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .disabled(selectedJSONFile == nil || outputDirectory == nil || memories.isEmpty)
                    }
                }
            }
            .padding(30)
        }
        .frame(width: 600, height: 550)
        .fileImporter(
            isPresented: $showingFileImporter,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            handleFileSelection(result)
        }
        .sheet(isPresented: $showingFolderPicker) {
            FolderPicker(selectedFolder: $outputDirectory)
        }
        .sheet(isPresented: $showingFailedFiles) {
            FailedFilesView(failedFiles: downloadManager.failedFiles, failedCount: downloadManager.failedCount)
        }
        .alert("Download Issues", isPresented: $downloadManager.showError) {
            if !downloadManager.failedFiles.isEmpty {
                Button("View Failed Files") {
                    showingFailedFiles = true
                }
            }
            Button("OK", role: .cancel) {
                downloadManager.showError = false
            }
        } message: {
            Text(downloadManager.errorMessage ?? "Some files failed to download.")
        }
    }
    
    private func handleFileSelection(_ result: Result<[URL], Error>) {
        do {
            let fileURL = try result.get().first
            selectedJSONFile = fileURL
            parseError = nil
            
            if let fileURL = fileURL {
                loadMemories(from: fileURL)
            }
        } catch {
            parseError = "Failed to select file: \(error.localizedDescription)"
        }
    }
    
    private func loadMemories(from url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
            parseError = "Failed to parse JSON: The file \"memories_history.json\" couldn't be opened because you don't have permission to view it."
            return
        }
        
        defer {
            url.stopAccessingSecurityScopedResource()
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let snapchatData = try decoder.decode(SnapchatData.self, from: data)
            memories = snapchatData.savedMedia
            parseError = nil
        } catch {
            parseError = "Failed to parse JSON: \(error.localizedDescription)"
            memories = []
        }
    }
    
    private func startDownload() {
        guard let outputDir = outputDirectory else { return }
        
        guard outputDir.startAccessingSecurityScopedResource() else {
            return
        }
        
        downloadManager.downloadMemories(memories: memories, to: outputDir)
    }
}

#Preview {
    ContentView()
}
