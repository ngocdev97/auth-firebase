//
//  MessengerApp.swift
//  Messenger
//
//  Created by Ngọc Lê on 30/04/2023.
//

import SwiftUI
import Firebase

@main
struct MessengerApp: App {
    @StateObject var viewModel = AuthViewModel()
    init()
    {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewModel)
        }
    }
}
