//
//  Arrow.swift
//  Drawing
//
//  Created by Tim Musil on 25.05.21.
//

import SwiftUI

struct Arrow: Shape {
    var headHeight: CGFloat = 100
    var stemWidth: CGFloat = 70
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(CGRect(x: rect.midX - stemWidth/2, y: rect.maxY, width: stemWidth, height: headHeight - rect.height))
        path.addLine(to: CGPoint(x: 0, y: headHeight))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: headHeight))
        path.addLine(to: CGPoint(x: rect.midX + stemWidth/2, y: headHeight))
        return path
    }
}

struct Arrow_Preview_Wrapper: View {
    
    @State private var strokeWidth: CGFloat = 1
    
    var body: some View {
        VStack {
            Arrow()
                .rotation(.degrees(45))
                .frame(width:200)
            
            Arrow()
                .stroke(lineWidth: strokeWidth)
                .animation(.linear(duration: 5))
                .frame(width:200)
                
        }
        .onAppear(
            perform: {
                withAnimation {
                    strokeWidth = 6
                }
            })
        
    }
    

}


struct Arrow_Previews: PreviewProvider {
    static var previews: some View {
        
        Arrow_Preview_Wrapper()
        
    }
}
