//
//  LibraryView.swift
//  iNova
//
//  Created by Mason Scherbarth on 5/17/22.
//
//  NOTE: This isn't going to work the way I'm doing it.
//        I want to get access to a bunch of the app information,
//        then sign it inside the app using an AdHoc Cert.
//        Debian might know how to do this.

import SwiftUI
import UniformTypeIdentifiers

struct SignerView: View {
    
    @State private var presentImporter = false
    var ipaExtension = UTType("dev.multision.ipa")!
    
    @State var appNames: [String] = []
    
    var body: some View {
        NavigationView {
            
            List(appNames, id: \.self) { app in
                HStack {
                    Image("placeholder")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 45, height: 45)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1.5))
                        .cornerRadius(10)
                    VStack {
                        Text(app.description) // Default value: {{ app_name }}
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(1)
                        Text("{{ app_bundleid (app_version) }}")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.primary.opacity(0.6))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(Color.blue)
                            .font(.title)
                    }.buttonStyle(PlainButtonStyle())
                }
            }.onAppear() {
                do {
                    appNames = try FileManager.default.contentsOfDirectory(at: getDocumentsDirectory(),
                                                                           includingPropertiesForKeys: nil, options: .skipsHiddenFiles).map {$0.lastPathComponent}

                } catch let error {
                    print(error.localizedDescription)
                }
            }
            
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Signer")
            .navigationBarItems(trailing:
                                    Button(action: {
                // Perform add IPA
                self.presentImporter.toggle()
            }) {
                Image(systemName: "plus.app")
            }).fileImporter(isPresented: $presentImporter, allowedContentTypes: [ipaExtension], allowsMultipleSelection: false) { result in
                
                do {
                    
                    let fileUrl = try result.get()
                    
                    //print(fileUrl)
                    
                    if fileUrl.first!.startAccessingSecurityScopedResource() {
                        //importFile(strPath: fileUrl.first!.path)
                        
                        importFileUrl(strPath: fileUrl.first!)
                        
                        fileUrl.first!.stopAccessingSecurityScopedResource()
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            
        }.navigationViewStyle(.stack)
    }
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func importFile(strPath: String) {
    let filemgr = FileManager.default
    
    if !filemgr.fileExists(atPath: strPath) {
        let documentPath = getDocumentsDirectory().path
        
        do {
            try filemgr.copyItem(atPath: strPath, toPath: documentPath)
        }catch (let error){
            print("Error for file write")
            print(error.localizedDescription)
        }
    }
}

func importFileUrl(strPath: URL) {
    let filemgr = FileManager.default
    
    let documentPath = getDocumentsDirectory().appendingPathComponent(strPath.lastPathComponent)
    
    do {
        try filemgr.copyItem(at: strPath, to: documentPath)
    }catch (let error){
        print(error.localizedDescription)
    }
}
