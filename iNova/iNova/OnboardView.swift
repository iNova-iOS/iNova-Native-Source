//
//  OnboardView.swift
//  iNova
//
//  Created by Mason Scherbarth on 5/14/22.
//
//  I passed a BOOl quite a lot here, sorry aha

import SwiftUI
import WhatsNewKit

struct OnboardView: View {
    
    @Binding var showModal: Bool
    
    var body: some View {
        NavigationView {
            WelcomeView(showModal: $showModal)
                .navigationBarHidden(true)
        }.navigationViewStyle(.stack)
    }
}

struct WelcomeView: View {
    
    @Binding var showModal: Bool
    
    var body: some View {
        
        VStack {
            Text("Welcome to iNova")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding([.leading, .trailing], 45)
                .padding([.top, .bottom], 35)
            
            HStack {
                Image(systemName: "star.fill")
                    .font(.largeTitle)
                    .foregroundColor(Color.orange)
                
                Spacer()
                    .frame(width: 15)
                
                VStack {
                    Text("The Return")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                        .frame(height: 3)
                    Text("After a nearly 3 year break, iNova is back and better than before.")
                        .foregroundColor(Color.primary.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }.padding([.leading, .trailing], 25)
            
            Spacer()
                .frame(height: 35)
            
            HStack {
                Image(systemName: "pencil.and.outline")
                    .font(.largeTitle)
                    .foregroundColor(Color(UIColor.systemTeal))
                
                Spacer()
                    .frame(width: 15)
                
                VStack {
                    Text("Advanced App Signing")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                        .frame(height: 3)
                    Text("We securely sign apps directly to your device straight from our server.")
                        .foregroundColor(Color.primary.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }.padding([.leading, .trailing], 25)
            
            Spacer()
                .frame(height: 35)
            
            HStack {
                Image(systemName: "app.badge")
                    .font(.largeTitle)
                    .foregroundColor(Color(UIColor.systemIndigo))
                
                Spacer()
                    .frame(width: 15)
                
                VStack {
                    Text("Large Library")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                        .frame(height: 3)
                    Text("Providing a wide variety of apps that the community loves.")
                        .foregroundColor(Color.primary.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }.padding([.leading, .trailing], 25)
            
            Spacer()
            
            NavigationLink(destination: UdidView(showModal: $showModal)) {
                Text("Continue")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.buttonText)
                    ).padding([.leading, .trailing, .bottom], 25)
            }
        }
        
    }
}

struct UdidView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var showModal: Bool
    @State private var shouldNavigate = false
    // self.presentationMode.wrappedValue.dismiss()
    
    var body: some View {
        
        VStack {
            Text("Verify your UDID")
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing], 45)
                .padding([.top, .bottom], 35)
            
            HStack {
                Image(systemName: "touchid")
                    .font(.largeTitle)
                    .foregroundColor(Color(hexStringToUIColor(hex: "7960E4")))
                
                Spacer()
                    .frame(width: 15)
                
                VStack {
                    Text("What is a UDID?")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                        .frame(height: 3)
                    Text("Your UDID is specific to your iOS device. It can be linked with a developer program in order to sign apps directly to your device.")
                        .foregroundColor(Color.primary.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }.padding([.leading, .trailing], 25)
            
            Spacer()
                .frame(height: 35)
            
            HStack {
                Image(systemName: "globe")
                    .font(.largeTitle)
                    .foregroundColor(Color(hexStringToUIColor(hex: "E97A71")))
                
                Spacer()
                    .frame(width: 15)
                
                VStack {
                    Text("Security and Privacy")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                        .frame(height: 3)
                    Text("Your UDID serves the purpose of signing apps to your device. We it to register your device to Apple in order to sign apps for you, and verify your purchase.")
                        .foregroundColor(Color.primary.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }.padding([.leading, .trailing], 25)
            
            Spacer()
            
            Button(action: {
                if let url = URL(string: "https://multision.dev/udid") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }) {
                Text("Verify UDID")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.buttonText)
                    )
            }.padding([.leading, .trailing, .bottom], 25)
            
        }.onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            if UserDefaults.standard.object(forKey: "udid") != nil {
                self.shouldNavigate.toggle()
            }
        }.background(
            NavigationLink(destination: VerifiedView(showModal: $showModal),
                              isActive: $shouldNavigate) { EmptyView() }
        )
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(.stack)
        .navigationBarTitle("")
        
    }
}

struct VerifiedView: View {
    
    @Binding var showModal: Bool
    
    var body: some View {
        
        VStack {
            Text("UDID Verified")
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing], 45)
                .padding(.top, 35)
            CheckmarkView()
                .offset(x: -5, y: 9)
            Spacer()
            
            Button(action: {
                showModal.toggle()
            }) {
                Text("Continue to iNova")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.buttonText)
                    )
            }.padding([.leading, .trailing, .bottom], 25)
        }
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(.stack)
        .navigationBarTitle("")
        .navigationBarHidden(true)
        
    }
}

struct CheckmarkView: View {
    @State private var checkViewAppear = false
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width: CGFloat = min(geometry.size.width, geometry.size.height)
                let height = geometry.size.height
                
                path.addLines([
                    .init(x: width/2 - 10, y: height/2 - 10),
                    .init(x: width/2, y: height/2),
                    .init(x: width/2 + 20, y: height/2 - 20)
                ])
            }
            .trim(from: 0, to: checkViewAppear ? 1 : 0)
            .stroke(style: StrokeStyle(lineWidth: 2.0, lineCap: .round))
            .foregroundColor(Color.green)
            .animation(Animation.easeIn(duration: 0.4))
            .frame(width: 50, height: 50)
            .aspectRatio(1, contentMode: .fit)
            .onAppear() {
                self.checkViewAppear.toggle()
            }
        }.frame(width: 50, height: 50)
    }
}
