//
//  ColorCyclingRectangle.swift
//  Drawing
//
//  Created by Tim Musil on 25.05.21.
//

import SwiftUI



struct ColorCyclingRectangle: View {
    var amount = 0.0
    var steps = 100
    var start: UnitPoint
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Rectangle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                        self.color(for: value, brightness: 1),
                        self.color(for: value, brightness: 0.5)
                    ]), startPoint: start, endPoint: .bottom), lineWidth: 2)
                
            }
        }
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
    
    
    // should show all properties of unitPoint in case they are UnitPoints (doesn't work yet)
    static var unitPoints: [UnitPoint] {
        
        var unitPoints: [UnitPoint] = [UnitPoint]()
        let unitPointMirror = Mirror(reflecting: UnitPoint())
        for property in unitPointMirror.children {
            if let unitPoint = property.value as? UnitPoint {
                unitPoints.append(unitPoint)
            }
        }
        return unitPoints
    }
    
    
    
}


struct ColorCyclingRectangle_Preview_Wrapper: View {
    @State private var colorCycle = 0.0
    //private var unitPoints = ColorCyclingRectangle.unitPoints
    @State private var gradientPosition: UnitPoint = .leading
    
    
    var body: some View {
        VStack {
            ColorCyclingRectangle(amount: self.colorCycle, start: gradientPosition)
                .frame(width: 300, height: 300)
           
            
            Slider(value: $colorCycle)
                 
            
        }
    }
}

struct ColorCyclingRectangle_Previews: PreviewProvider {
    static var previews: some View {
        ColorCyclingRectangle_Preview_Wrapper()
            
    }
}
