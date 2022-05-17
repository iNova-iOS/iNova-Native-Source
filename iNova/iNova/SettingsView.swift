//
//  SettingsView.swift
//  iNova
//
//  Created by Mason Scherbarth on 5/14/22.
//

import SwiftUI
import DeviceKit

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    // self.presentationMode.wrappedValue.dismiss()
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Device")) {
                    HStack {
                        Spacer()
                        VStack {
                            Image("\(settingsDevice)")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 60)
                                .padding([.top, .bottom], 35)
                            Text(Device.current.safeDescription)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                
                            Text("iOS " + Device.current.systemVersion!)
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .opacity(0.6)
                                .padding(.bottom, 5)
                                .foregroundColor(.primary)
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Text("UDID")
                            .foregroundColor(.primary)
                        Text(UserDefaults.standard.string(forKey: "udid") ?? "{{ udid }}")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .minimumScaleFactor(0.2)
                            .lineLimit(1)
                            .foregroundColor(.primary)
                            .opacity(0.6)
                    }
                    
                    HStack {
                        Text("Model")
                            .foregroundColor(.primary)
                        Text(Device.identifier)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .minimumScaleFactor(0.2)
                            .lineLimit(1)
                            .foregroundColor(.primary)
                            .opacity(0.6)
                    }
                }
                
                // Cache info
                Section(header: Text("Cache")) {
                    HStack {
                        Text("Cache")
                        Spacer()
                        Text(ByteCountFormatter().string(fromByteCount: Int64(FileManager.default.directorySize(FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!) ?? 0)))
                            .foregroundColor(Color.primary.opacity(0.6))
                    }
                    
                    Button(action: {
                        clearCache()
                    }) {
                        Text("Clear Cache")
                    }
                }
                
                Section(header: Text("Credits")) {
                    Button(action: {
                        if let url = URL(string: "https://twitter.com/iNovaApp") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }) {
                        HStack {
                            Text("Support")
                                .foregroundColor(Color.primary)
                            Spacer()
                            Text("iNovaApp")
                                .foregroundColor(Color.primary.opacity(0.6))
                            Image(systemName: "chevron.forward")
                                .font(Font.system(.caption).weight(.bold))
                                .foregroundColor(Color(UIColor.tertiaryLabel))
                        }
                    }
                    
                    Button(action: {
                        if let url = URL(string: "https://twitter.com/DevCasp") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }) {
                        HStack {
                            Text("Developer")
                                .foregroundColor(Color.primary)
                            Spacer()
                            Text("DevCasp")
                                .foregroundColor(Color.primary.opacity(0.6))
                            Image(systemName: "chevron.forward")
                                .font(Font.system(.caption).weight(.bold))
                                .foregroundColor(Color(UIColor.tertiaryLabel))
                        }
                    }
                    
                    Button(action: {
                        if let url = URL(string: "https://twitter.com/multision") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }) {
                        HStack {
                            Text("Developer")
                                .foregroundColor(Color.primary)
                            Spacer()
                            Text("multision")
                                .foregroundColor(Color.primary.opacity(0.6))
                            Image(systemName: "chevron.forward")
                                .font(Font.system(.caption).weight(.bold))
                                .foregroundColor(Color(UIColor.tertiaryLabel))
                        }
                    }
                    
                    Button(action: {
                        if let url = URL(string: "https://twitter.com/StarfilesHelp") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }) {
                        HStack {
                            Text("App Library")
                                .foregroundColor(Color.primary)
                            Spacer()
                            Text("Starfiles")
                                .foregroundColor(Color.primary.opacity(0.6))
                            Image(systemName: "chevron.forward")
                                .font(Font.system(.caption).weight(.bold))
                                .foregroundColor(Color(UIColor.tertiaryLabel))
                        }
                    }
                }
            }
            
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(.stack)
            .navigationBarItems(trailing:
                                    
                                    Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Close")
            }
                                
            )
            
        }
    }
}

var settingsDevice: String {
    if Device.current.safeDescription.contains("iPhone X") ||
        Device.current.safeDescription.contains("iPhone 11") ||
        Device.current.safeDescription.contains("iPhone 12") ||
        Device.current.safeDescription.contains("iPhone 13") {
        return "iphonenotch"
    } else if Device.current.safeDescription.contains("iPhone 6") ||
                Device.current.safeDescription.contains("iPhone 7") ||
                Device.current.safeDescription.contains("iPhone 8") ||
                Device.current.safeDescription.contains("iPhone SE") {
        return "iphonebutton"
    } else if Device.current.safeDescription.contains("iPad Air 5") ||
                Device.current.safeDescription.contains("iPad Mini 6") ||
                Device.current.safeDescription.contains("iPad Pro (12.9-inch) (3rd generation)") ||
                Device.current.safeDescription.contains("iPad Pro (12.9-inch) (4th generation)") ||
                Device.current.safeDescription.contains("iPad Pro (11-inch) (3rd generation)") ||
                Device.current.safeDescription.contains("iPad Pro (12.9-inch) (5th generation)") ||
                Device.current.safeDescription.contains("iPad Air 4") {
        return "ipadnotch"
    } else if Device.current.safeDescription.contains("iPad Air 2") ||
                Device.current.safeDescription.contains("iPad Mini 4") ||
                Device.current.safeDescription.contains("iPad Pro (9.7-inch)") ||
                Device.current.safeDescription.contains("iPad Pro (12.9-inch)") ||
                Device.current.safeDescription.contains("iPad Pro (12.9-inch) (2nd generation)") ||
                Device.current.safeDescription.contains("iPad Pro (10.5-inch)") ||
                Device.current.safeDescription.contains("iPad Pro (11-inch)") ||
                Device.current.safeDescription.contains("iPad Pro (11-inch) (2nd generation)") ||
                Device.current.safeDescription.contains("iPad (5th generation)") ||
                Device.current.safeDescription.contains("iPad (6th generation)") ||
                Device.current.safeDescription.contains("iPad Air (3rd generation)") ||
                Device.current.safeDescription.contains("iPad Mini (5th generation)") ||
                Device.current.safeDescription.contains("iPad (7th generation)") ||
                Device.current.safeDescription.contains("iPad (8th generation)") ||
                Device.current.safeDescription.contains("iPad (9th generation)") {
        return "ipadbutton"
    } else {
        return "ipod"
    }
}

func clearCache() {
    let cacheURL =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    let fileManager = FileManager.default
    do {
        // Get the directory contents urls (including subfolders urls)
        let directoryContents = try FileManager.default.contentsOfDirectory( at: cacheURL, includingPropertiesForKeys: nil, options: [])
        for file in directoryContents {
            do {
                try fileManager.removeItem(at: file)
            }
            catch let error as NSError {
                debugPrint("Ooops! Something went wrong: \(error)")
            }
            
        }
        
        exit(0)
    } catch let error as NSError {
        print(error.localizedDescription)
    }
    
    //URLCache.shared.removeAllCachedResponses()
}

extension URL {
    var fileSize: Int? { // in bytes
        do {
            let val = try self.resourceValues(forKeys: [.totalFileAllocatedSizeKey, .fileAllocatedSizeKey])
            return val.totalFileAllocatedSize ?? val.fileAllocatedSize
        } catch {
            print(error)
            return nil
        }
    }
}

extension FileManager {
    func directorySize(_ dir: URL) -> Int? { // in bytes
        if let enumerator = self.enumerator(at: dir, includingPropertiesForKeys: [.totalFileAllocatedSizeKey, .fileAllocatedSizeKey], options: [], errorHandler: { (_, error) -> Bool in
            print(error)
            return false
        }) {
            var bytes = 0
            for case let url as URL in enumerator {
                bytes += url.fileSize ?? 0
            }
            return bytes
        } else {
            return nil
        }
    }
    
    func documentsDir() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
    
    func getDownloads() -> Int? {
        let filemgr = FileManager.default
        
        do {
            var filelist = try filemgr.contentsOfDirectory(atPath: documentsDir())
            filelist.removeAll(where: { $0 == ".Trash" })
            //print(filelist)
            return filelist.count
        } catch {
            return 0
        }
    }
}
