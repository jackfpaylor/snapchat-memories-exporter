//
//  FailedFilesView.swift
//  snap_memory_saver
//
//  Created by Jack Paylor on 10/17/25.
//


import SwiftUI

struct FailedFilesView: View {
    let failedFiles: [String]
    let failedCount: Int
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                    .font(.title2)
                Text("Failed Downloads")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("\(failedCount) files failed to download")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.top)
                
                if failedFiles.isEmpty {
                    Text("No failed files to display.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(failedFiles, id: \.self) { fileName in
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                    Text(fileName)
                                        .font(.system(.body, design: .monospaced))
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            
            Divider()
            
            HStack {
                Spacer()
                Button("Close") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.defaultAction)
            }
            .padding()
        }
        .frame(width: 500, height: 400)
    }
}

#Preview {
    FailedFilesView(failedFiles: [
        "2025-10-05_05-01-04.jpg",
        "2025-10-04_23-08-19.jpg",
        "2025-10-03_00-34-53.jpg"
    ], failedCount: 3)
}