//
//  ContentView.swift
//  Crypto
//
//  Created by Waris Ruzi on 2022/11/07.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
