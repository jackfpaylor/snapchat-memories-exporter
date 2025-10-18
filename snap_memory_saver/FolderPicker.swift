//
//  FolderPicker.swift
//  snap_memory_saver
//
//  Created by Jack Paylor on 10/17/25.
//


import SwiftUI

struct FolderPicker: View {
    @Binding var selectedFolder: URL?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Choose Output Folder")
                .font(.headline)
            
            Text("Select where you want to save your Snapchat memories")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                
                Button("Choose Folder") {
                    selectFolder()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(30)
        .frame(width: 400)
    }
    
    private func selectFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = true
        
        if panel.runModal() == .OK {
            selectedFolder = panel.url
        }
        
        dismiss()
    }
}