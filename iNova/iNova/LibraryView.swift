//
//  CategoriesView.swift
//  iNova
//
//  Created by Mason Scherbarth on 5/14/22.
//
//  Starfiles App API
//  https://api.starfiles.co/2.0/files?public&extension=ipa
//  No Duplicate Apps API
//  https://api.starfiles.co/2.0/files?public&extension=ipa&group=hash&collapse=true
//

import SwiftUI
import SDWebImageSwiftUI

// Getting the apps
struct AppsList: Codable, Identifiable {
    let id, name, version: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, version
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        //let version = try? container.decode(String.self, forKey: .version)
        self.id = id
        self.name = name
        //self.version = version ?? "Unknown"
        
        if let double = try? container.decode(Double.self, forKey: .version) {
            self.version = "\(double)"
        } else if let string = try? container.decode(String.self, forKey: .version) {
            self.version = string
        } else if try container.decodeNil(forKey: .version) {
            self.version = "Unknown"
        } else {
            self.version = "Unknown"
        }
    }
}

struct LibraryView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchText = ""
    @State var alreadyRan = false
    @State var shouldNavigate = false
    
    @State var appsNew: [AppsList] = []
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                
                Spacer()
                    .frame(height: 10)
                
                VStack {
                    HStack {
                        Spacer()
                            .frame(width: 15)
                        
                        VStack {
                            Spacer()
                                .frame(height: 25)
                            Text("Suggest an app")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                                .frame(height: 7.5)
                            
                            Text("To help find what you")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.primary.opacity(0.6))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("may be looking for")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.primary.opacity(0.6))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                                .frame(height: 25)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if let url = URL(string: "twitter://post?message=%40iNovaApp") {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.buttonText)
                                    .frame(width: 35, height: 35)
                                Image(systemName: "chevron.right")
                                    .font(.subheadline)
                                    .foregroundColor(Color.buttonColor)
                            }
                        }
                        
                        Spacer()
                            .frame(width: 15)
                    }
                }
                .background(Color(UIColor.tertiarySystemGroupedBackground))
                .clipShape(
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                )
                .padding([.leading, .trailing], 17.5).padding(.bottom, 17.5)
                
                if #available(iOS 15.0, *) {
                    LazyVStack {
                        ForEach(appsNew.filter({ (appsNew) -> Bool in
                            return appsNew.name.localizedCaseInsensitiveContains(searchText) || searchText == ""
                        }).sorted(by: { $0.name < $1.name}), id: \.id) { item in
                            
                            AppView(id: item.id, name: item.name, description: item.version)
                            Divider()
                                .padding(.leading, 55)
                        }
                    }.searchable(text: $searchText)
                        .padding([.leading, .trailing], 17.5)
                } else {
                    LazyVStack {
                        ForEach(appsNew, id: \.id) { item in
                            AppView(id: item.id, name: item.name, description: item.version)
                            Divider()
                                .padding(.leading, 55)
                        }
                    }
                    .padding([.leading, .trailing], 17.5)
                }
                
            }
            
                .navigationTitle("App Library")
                .navigationBarTitleDisplayMode(.large)
        }.navigationViewStyle(.stack)
            .onAppear() {
                if !alreadyRan {
                    guard let url = URL(string: "https://api.starfiles.co/2.0/files?public&extension=ipa&group=hash&collapse=true") else { return }
                    URLSession.shared.dataTask(with: url) { (data, _, error) in
                        
                        do {
                            appsNew = try JSONDecoder().decode([AppsList].self, from: data!)
                            self.alreadyRan.toggle()
                        } catch {
                            print(error)
                        }
                        
                    }.resume()
                }
            }
    }
}

// This is used for App Categories, if there's a way to split them up.
struct AppSectionView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var image: String
    var category: String
    var description: String
    
    var body: some View {
        
        HStack {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: 45, height: 45)
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1.5))
                .cornerRadius(10)
            VStack {
                Text(category)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(description)
                    .foregroundColor(Color.primary.opacity(0.6))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            ZStack {
                Circle()
                    .fill(colorScheme == .dark ? Color.buttonText : Color.buttonColor)
                    .frame(width: 35, height: 35)
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundColor(colorScheme == .dark ? Color.buttonColor : Color.buttonText)
            }
        }
    }
}

// This is for apps themselves
struct AppView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var id: String
    var name: String
    var description: String
    
    @State var showModal = false
    
    var body: some View {
        
        HStack {
            WebImage(url: URL(string: "https://api.starfiles.co/file/icon/" + id), options: [.lowPriority, .scaleDownLargeImages])
                .resizable()
                .placeholder(Image("placeholder"))
                .purgeable(true)
                .scaledToFill()
                .frame(width: 45, height: 45)
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1.5))
                .cornerRadius(10)
            VStack {
                Text(name.replacingOccurrences(of: ".ipa", with: ""))
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Version: \(description)")
                    .foregroundColor(Color.primary.opacity(0.6))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            /*
            Button(action: {
                self.showModal.toggle()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(colorScheme == .dark ? Color.buttonText : Color.buttonColor)
                        .frame(width: 65, height: 32)
                    Text("GET")
                        .fontWeight(.semibold)
                        .foregroundColor(colorScheme == .dark ? Color.buttonColor : Color.buttonText)
                }
            }*/
            
            NavigationLink(destination: InspectView(id: id)) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(colorScheme == .dark ? Color.buttonText : Color.buttonColor)
                        .frame(width: 65, height: 32)
                    Text("VIEW")
                        .fontWeight(.semibold)
                        .foregroundColor(colorScheme == .dark ? Color.buttonColor : Color.buttonText)
                }
            }
        }
        
        .sheet(isPresented: $showModal) {
            InspectView(id: id)
        }
    }
}
