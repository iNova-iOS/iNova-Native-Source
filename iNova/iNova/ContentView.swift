//
//  ContentView.swift
//  iNova
//
//  Created by Mason Scherbarth on 5/13/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var showSetup = false
    
    var body: some View {
        TabView {
            
            HomeView()
                .tabItem {
                    Image("home")
                        .renderingMode(.template)
                }
            
            LibraryView()
                .tabItem {
                    Image("categories")
                        .renderingMode(.template)
                }
            
            /*
            SignerView()
                .tabItem {
                    Image("signer")
                        .renderingMode(.template)
                }
             */
            
        }.onAppear() {
            if !firstRun() {
                self.showSetup.toggle()
            }
        }
        .sheet(isPresented: $showSetup) {
            OnboardView(showModal: $showSetup)
                .allowAutoDismiss(false)
        }
    }
}

// Checks if UDID is validated within the app
func firstRun() -> Bool {
    var udidIsValid = false
    
    if UserDefaults.standard.value(forKey: "udid") != nil {
        udidIsValid = true
    }
    
    return udidIsValid
        
}
