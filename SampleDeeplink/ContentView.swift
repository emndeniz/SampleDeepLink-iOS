//
//  ContentView.swift
//  SampleDeeplink
//
//  Created by Mehmet Emin Deniz on 16.11.2023.
//

import SwiftUI

struct ContentView: View {
    @State var counter = 0
    @State var lastUrl = "N/A"
    @State var screenName = "Home"
    @State var userType = "Default"

    var body: some View {
        VStack (spacing: 16, content: {
            Text("Counter: \(counter)")
            Text("Last URL:")
            Text(lastUrl)
            Divider()

            Text("Screen : \(screenName)")
            Text("User Type : \(userType)")
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
            screenName = "Home Scren"
        }

        guard let querry = querry else {
            userType = "Default"
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
