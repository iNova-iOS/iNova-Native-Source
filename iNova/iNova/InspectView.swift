//
//  AppView.swift
//  iNova
//
//  Created by Mason Scherbarth on 5/20/22.
//
//  Starfiles & EonHub VIP Endpoint
//  https://premium.eonhubapp.com/1/backend/signvip.php?file= ID
//

import SwiftUI
import SDWebImageSwiftUI
import Alamofire

struct InspectedApp: Codable, Identifiable {
    var id = UUID()
    
    let name, version, tidy_size, minCompatibleVersion: String
    let download_count: Int
    
    enum CodingKeys : String, CodingKey {
        case name, version, tidy_size, download_count
        case minCompatibleVersion = "min_compatible_version"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let tidy_size = try container.decode(String.self, forKey: .tidy_size)
        let download_count = try container.decode(Int.self, forKey: .download_count)
        self.name = name
        self.tidy_size = tidy_size
        self.download_count = download_count
        
        if let double = try? container.decode(Double.self, forKey: .version) {
            self.version = "\(double)"
        } else if let string = try? container.decode(String.self, forKey: .version) {
            self.version = string
        } else if try container.decodeNil(forKey: .version) {
            self.version = "Unknown"
        } else {
            self.version = "Unknown"
        }
        
        if let doubleMin = try? container.decode(Double.self, forKey: .minCompatibleVersion) {
            self.minCompatibleVersion = "iOS \(doubleMin)+"
        } else if let intMin = try? container.decode(Int.self, forKey: .minCompatibleVersion) {
            self.minCompatibleVersion = "iOS \(intMin)+"
        } else if let stringMin = try? container.decode(String.self, forKey: .minCompatibleVersion) {
            if !stringMin.isEmpty {
                self.minCompatibleVersion = "iOS \(stringMin)+"
            } else {
                self.minCompatibleVersion = "Unknown"
            }
        } else if try container.decodeNil(forKey: .minCompatibleVersion) {
            self.minCompatibleVersion = "Unknown"
        } else {
            self.minCompatibleVersion = "Unknown"
        }
    }
}

struct InspectView: View {
    
    var id: String
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var appsNew: InspectedApp?
    
    var body: some View {
        ScrollView {
            Rectangle()
                .frame(maxWidth: .infinity, minHeight: 175, maxHeight: 175)
                .overlay(
                    ZStack {
                        GeometryReader { geo in
                            WebImage(url: URL(string: "https://api.starfiles.co/file/icon/" + id), options: [.lowPriority, .scaleDownLargeImages])
                                .resizable()
                                .placeholder(Image("placeholder"))
                                .purgeable(true)
                                .scaledToFill()
                                .frame(width: geo.size.width, height: geo.size.height)
                                .clipped()
                        }
                        VisualEffectBlur(blurStyle: .regular)
                        LinearGradient(gradient: Gradient(colors: [.black.opacity(0), .black.opacity(0.2)]), startPoint: .top, endPoint: .bottom)
                    }
                )
            
            VStack {
                HStack {
                    WebImage(url: URL(string: "https://api.starfiles.co/file/icon/" + id), options: [.lowPriority, .scaleDownLargeImages])
                        .resizable()
                        .placeholder(Image("placeholder"))
                        .purgeable(true)
                        .scaledToFill()
                        .frame(width: 75, height: 75)
                        .overlay(RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1.5))
                        .cornerRadius(15)
                    VStack {
                        Text(appsNew?.name.replacingOccurrences(of: ".ipa", with: "") ?? "")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(1)
                        Text("\(abbreviateNumber(num: Float(appsNew?.download_count ?? 0) as NSNumber)) Downloads")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.primary.opacity(0.6))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                            .frame(height: 2)
                        Text("\(appsNew?.tidy_size ?? "") · \(appsNew?.version ?? "")")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.primary.opacity(0.4))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button(action: {
                        
                        //https://multision.dev/inova/sign.php?file=\(id)
                        AF.request("https://multision.dev/inova/sign.php?file=\(id)", method: .post).responseJSON
                        { response in switch response.result {
                        case .success(let JSON):
                            print("Success with JSON: \(JSON)")
                            
                            let response = JSON as! NSDictionary
                            
                            //example if there is an id
                            let appInstall = response.object(forKey: "url")!
                            
                            if let url = URL(string: "itms-services://?action=download-manifest&url=\(appInstall)") {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                            
                        case .failure(let error):
                            print("Request failed with error: \(error)")
                        }
                        }
                        
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
            }.padding([.leading, .trailing], 15)
            
            VStack {
                Spacer()
                    .frame(height: 15)
                Text("Information")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // info shit
                Group {
                    Spacer()
                        .frame(height: 20)
                    HStack {
                        Text("Distributor")
                            .font(.callout)
                            .foregroundColor(Color.primary.opacity(0.6))
                        Spacer()
                        Text("Starfiles")
                            .font(.callout)
                    }
                    Spacer()
                        .frame(height: 15)
                    Divider()
                    
                    InfoView(title: "Size", description: appsNew?.tidy_size ?? "")
                    InfoView(title: "Compatibility", description: appsNew?.minCompatibleVersion ?? "")
                    InfoButtonView()
                }
            }.padding([.leading, .trailing], 15)
            
            //"https://premium.eonhubapp.com/1/backend/signvip.php?file=" + id
            //"https://app.eonhubapp.com/backend/signfree.php?file=2fcf42b52d46"
            /*WebView(request: URLRequest(url: URL(string: "https://premium.eonhubapp.com/1/backend/signvip.php?file=" + id)!))
             .frame(width: 10, height: 10)*/
            
        }.onAppear() {
            guard let url = URL(string: "https://api.starfiles.co/file/fileinfo?file=" + id) else { return }
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                do {
                    appsNew = try JSONDecoder().decode(InspectedApp.self, from: data!)
                } catch {
                    //self.showError.toggle()
                }
            }.resume()
        }
        
        //.navigationBarTitle(appsNew?.name.replacingOccurrences(of: ".ipa", with: "") ?? "")
        .navigationBarTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(.stack)
        .toolbar {
            ToolbarItem(placement: .principal) {
                WebImage(url: URL(string: "https://api.starfiles.co/file/icon/" + id), options: [.lowPriority, .scaleDownLargeImages])
                    .resizable()
                    .placeholder(Image("placeholder"))
                    .purgeable(true)
                    .scaledToFill()
                    .frame(width: 25, height: 25)
                    .cornerRadius(5)
            }
        }
    }
}

struct InfoView: View {
    
    var title, description: String
    
    var body: some View {
        Spacer()
            .frame(height: 15)
        HStack {
            Text(title)
                .font(.callout)
                .foregroundColor(Color.primary.opacity(0.6))
            Spacer()
            Text(description)
                .font(.callout)
        }
        Spacer()
            .frame(height: 15)
        Divider()
    }
}

struct InfoButtonView: View {
    
    var body: some View {
        Spacer()
            .frame(height: 15)
        Button(action: {
            if let url = URL(string: "https://starfiles.co") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }) {
            HStack {
                Text("Starfiles Website")
                    .font(.callout)
                Spacer()
                Image(systemName: "safari")
                    .font(.callout)
            }
        }
        Spacer()
            .frame(height: 15)
        Divider()
    }
}

func abbreviateNumber(num: NSNumber) -> NSString {
    var ret: NSString = ""
    let abbrve: [String] = ["K", "M", "B"]
    
    let floatNum = num.floatValue
    
    if floatNum > 1000 {
        
        for i in 0..<abbrve.count {
            let size = pow(10.0, (Float(i) + 1.0) * 3.0)
            if (size <= floatNum) {
                let num = floatNum / size
                let str = floatToString(val: num)
                ret = NSString(format: "%@%@", str, abbrve[i])
            }
        }
    } else {
        ret = NSString(format: "%d", Int(floatNum))
    }
    
    return ret
}

func floatToString(val: Float) -> NSString {
    var ret = NSString(format: "%.1f", val)
    var c = ret.character(at: ret.length - 1)
    
    while c == 48 {
        ret = ret.substring(to: ret.length - 1) as NSString
        c = ret.character(at: ret.length - 1)
        
        
        if (c == 46) {
            ret = ret.substring(to: ret.length - 1) as NSString
        }
    }
    return ret
}
