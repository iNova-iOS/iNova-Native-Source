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

struct AppValue: Codable {
    let name: String
}

struct IdentifiableAppValue : Identifiable {
    let id: String
    let appValue: AppValue
}

struct AppsList: Codable, Identifiable {
    let id: String
    let name: String
}

struct CategoriesView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchText = ""
    @State var alreadyRan = false
    
    @State var appsNew: [AppsList] = []
    
    @State var apps : [String:AppValue] = [:]
    var listApps: [IdentifiableAppValue] {
        apps.map { IdentifiableAppValue(id: $0.key, appValue: $0.value) }
    }
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                
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
                .padding(.bottom, 17.5)
                
                /*if #available(iOS 15.0, *) {
                    LazyVStack {
                        /*
                         AppSectionView(image: "tweakedapps", category: "Tweaked apps", description: "Apps with modifications")
                         Divider()
                         .padding(.leading, 55)
                         AppSectionView(image: "hackedgames", category: "Hacked Games", description: "Games with modifications")
                         Divider()
                         .padding(.leading, 55)
                         AppSectionView(image: "paidapps", category: "Paid Apps", description: "Paid apps for free")
                         Divider()
                         .padding(.leading, 55)
                         AppSectionView(image: "paidgames", category: "Paid Games", description: "Paid games for free")*/
                        ForEach(listApps.filter({ (listApps) -> Bool in
                            return listApps.appValue.name.localizedCaseInsensitiveContains(searchText) || searchText == ""
                        })) { item in
                            AppView(id: item.id, name: item.appValue.name, description: "N/A")
                            Divider()
                                .padding(.leading, 55)
                        }
                    }.searchable(text: $searchText)
                } else {
                    LazyVStack {
                        ForEach(listApps) { item in
                            AppView(id: item.id, name: item.appValue.name, description: "N/A")
                            Divider()
                                .padding(.leading, 55)
                        }
                    }
                }*/
                
                if #available(iOS 15.0, *) {
                    LazyVStack {
                        ForEach(appsNew.filter({ (appsNew) -> Bool in
                            return appsNew.name.localizedCaseInsensitiveContains(searchText) || searchText == ""
                        }).sorted(by: { $0.name < $1.name}), id: \.id) { item in
                            AppView(id: item.id, name: item.name, description: "N/A")
                            Divider()
                            .padding(.leading, 55)
                        }
                    }.searchable(text: $searchText)
                } else {
                    LazyVStack {
                        ForEach(appsNew, id: \.id) { item in
                            AppView(id: item.id, name: item.name, description: "N/A")
                            Divider()
                            .padding(.leading, 55)
                        }
                    }
                }
                
            }.padding([.leading, .trailing], 17.5).padding(.top, 10)
            
                .navigationTitle("App Library")
                .navigationBarTitleDisplayMode(.large)
        }.navigationViewStyle(.stack)
            .onAppear() {
                if !alreadyRan {
                    /*guard let url = URL(string: "https://api.starfiles.co/2.0/files?public&extension=ipa") else { return }
                    URLSession.shared.dataTask(with: url) { (data, _, error) in
                        
                        do {
                            apps = try JSONDecoder().decode([String:AppValue].self, from: data!)
                            self.alreadyRan.toggle()
                        } catch {
                            print(error)
                            //self.showError.toggle()
                        }
                        
                    }.resume()*/
                    
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

struct AppView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var id: String
    var name: String
    var description: String
    
    var body: some View {
        
        HStack {
            WebImage(url: URL(string: "https://api.starfiles.co/file/icon/" + id))
                .resizable()
                .placeholder(Image("placeholder"))
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
                Text(description)
                    .foregroundColor(Color.primary.opacity(0.6))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            Button(action: {
                
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(colorScheme == .dark ? Color.buttonText : Color.buttonColor)
                        .frame(width: 65, height: 32)
                    Text("GET")
                        .fontWeight(.semibold)
                        .foregroundColor(colorScheme == .dark ? Color.buttonColor : Color.buttonText)
                }
            }
        }
    }
}
