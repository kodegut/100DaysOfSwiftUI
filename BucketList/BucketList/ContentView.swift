//
//  ContentView.swift
//  BucketList
//
//  Created by Tim Musil on 23.06.21.
//
import LocalAuthentication
import MapKit
import SwiftUI

struct ContentView: View {
    
    @State private var isUnlocked = false
    
    var body: some View {
        ZStack {
            if isUnlocked {
                FullMapView()
            } else {
                UnlockButtonView(isUnlocked: $isUnlocked)
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
