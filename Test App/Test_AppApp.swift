//
//  Test_AppApp.swift
//  Test App
//
//  Created by Cameron Coles on 22/06/2023.
//

import SwiftUI

@main
struct Test_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
