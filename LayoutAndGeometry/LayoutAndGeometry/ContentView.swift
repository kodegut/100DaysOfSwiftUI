//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Tim Musil on 27.07.21.
//

import SwiftUI

extension VerticalAlignment {
    enum MidAccountAndName: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[.top]
        }
    }

    static let midAccountAndName = VerticalAlignment(MidAccountAndName.self)
}

struct ContentView: View {
    
    var body: some View {
        HStack(alignment: .midAccountAndName) {
            VStack {
                Text("@kodegut")
                  //  .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
                Image("wedding")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 64)
            }

            VStack {
                Text("Full name:")
                 //   .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
                Text("Tim")
                    
                    .font(.largeTitle)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
