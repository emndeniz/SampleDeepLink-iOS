//
//  ContentView.swift
//  SampleDeeplink
//
//  Created by Mehmet Emin Deniz on 16.11.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var counter = 0
    @State private var lastUrl = "N/A"
    @State private var screenName = "Home"
    @State private var userType = "Default User"

    var body: some View {
        VStack (spacing: 16, content: {
            Text("Counter: \(counter)")
                .accessibilityIdentifier(AccessibilityIdentifiers.ContentView.counter.rawValue)
            Text("Last URL:")
            Text(lastUrl)
                .accessibilityIdentifier(AccessibilityIdentifiers.ContentView.lastUrl.rawValue)
            Divider()

            Text("Screen: \(screenName)")
                .accessibilityIdentifier(AccessibilityIdentifiers.ContentView.screenName.rawValue)
            Text("User Type: \(userType)")
                .accessibilityIdentifier(AccessibilityIdentifiers.ContentView.userType.rawValue)
        })
        .padding()
        .onOpenURL(perform: { url in
            parseUrl(url: url)
        })
    }
}

extension ContentView {
    func parseUrl(url: URL){
        counter += 1
        lastUrl = url.absoluteString

        let scheme = url.scheme
        let host = url.host
        let querry = url.query
        print("Scheme: \(scheme), host: \(host), querryParams: \(querry)")

        setRouting(host: host, querry: querry)

    }

    private func setRouting(host: String?, querry: String?){

        switch host {
        case "list":
            screenName = "List Screen"
        case "detail":
            screenName = "Detail Screen"
        default :
            screenName = "Home Screen"
        }

        guard let querry = querry else {
            userType = "Default User"
            return
        }

        switch querry {
        case "paid":
            userType = "Paid User 💰"
        case "premium":
            userType = "Premium User 🤑"
        default :
            userType = "Default User"
        }

    }
}

#Preview {
    ContentView()
}
