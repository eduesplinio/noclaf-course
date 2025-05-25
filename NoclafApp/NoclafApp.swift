//  NoclafApp
//
//  aula_04App.swift
//  aula-04
//
//  Created by Eduardo Esplinio on 29/04/25.
//

import SwiftUI

@main
struct aula_04App: App {
    @AppStorage("login") var isLogin: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isLogin {
                TabNavView()
            } else {
                ContentView()
            }
        }
    }
}
