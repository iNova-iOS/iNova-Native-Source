//
//  HomeView.swift
//  iNova
//
//  Created by Mason Scherbarth on 5/13/22.
//

import SwiftUI
import SDWebImageSwiftUI

// Getting the apps
struct TrendingApps: Codable, Identifiable {
    let id, name, version: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, version
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        self.id = id
        self.name = name
        
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

struct HomeView: View {
    
    @State var fetched = false
    
    @State var showSettings = false
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var trendingApps: [TrendingApps] = []
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                // Featured Apps start
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        Spacer()
                            .frame(width: 2.5)
                        FeaturedAppView(name: "unc0ver", image: UIImage(imageLiteralResourceName: "unc0ver"))
                        FeaturedAppView(name: "Spotify++", image: UIImage(imageLiteralResourceName: "spotify"))
                        FeaturedAppView(name: "Instagram++", image: UIImage(imageLiteralResourceName: "instagram"))
                        FeaturedAppView(name: "AV-Tinder++", image: UIImage(imageLiteralResourceName: "tinder"))
                        Spacer()
                            .frame(width: 2.5)
                    }
                }.padding(.top, 15)
                // Featured Apps end
                
                // Popular Apps start
                Text("Trending Apps")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .padding(.top, 15)
                    .padding(.leading, 17.5)
                
                VStack {
                    ForEach(trendingApps.sorted(by: { $0.name < $1.name}), id: \.id) { app in
                        HStack {
                            WebImage(url: URL(string: "https://api.starfiles.co/file/icon/" + app.id), options: [.lowPriority, .scaleDownLargeImages])
                                .resizable()
                                .placeholder(Image("placeholder"))
                                .purgeable(true)
                                .scaledToFill()
                                .frame(width: 45, height: 45)
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1.5))
                                .cornerRadius(10)
                            VStack {
                                Text(app.name)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(1)
                                Text("Version: " + app.version)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.primary.opacity(0.6))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(1)
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
                        
                        Divider()
                            .padding(.leading, 55)
                    }
                }.padding([.leading, .trailing], 17.5).padding(.top, 10)
                // Popular Apps end
            }
            
            .navigationTitle("Featured")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(trailing:
                                    
                                    Button(action: {
                self.showSettings.toggle()
            }) {
                Image(systemName: "gearshape.fill")
            }
                                
            )
            
        }.navigationViewStyle(.stack)
            .onAppear() {
                if !fetched {
                    guard let url = URL(string: "https://api.starfiles.co/2.0/files?public&extension=ipa&group=hash&collapse=true&limit=15&sort=trending") else { return }
                    URLSession.shared.dataTask(with: url) { (data, _, _) in
                        trendingApps = try! JSONDecoder().decode([TrendingApps].self, from: data!)
                        
                        self.fetched.toggle()
                    }
                    .resume()
                }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

struct FeaturedAppView: View {
    
    var name: String
    var image: UIImage
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.init(image.findAverageColor()!))
            .frame(width: 275, height: 150, alignment: .leading)
            .overlay (
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [.black.opacity(0), .black.opacity(0.2)]), startPoint: .top, endPoint: .bottom)
                        .cornerRadius(15)
                    
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 75, height: 75)
                        .cornerRadius(15)
                        .padding(.bottom, 40)
                    
                    VStack() {
                        Spacer()
                        HStack {
                            Spacer()
                                .frame(width: 15)
                            Text(name)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .lineLimit(1)
                                .padding(.bottom, 15)
                        }
                    }
                }
            )
    }
}
