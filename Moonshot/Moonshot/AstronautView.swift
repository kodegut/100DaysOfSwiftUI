//
//  AstronautView.swift
//  Moonshot
//
//  Created by Tim Musil on 22.05.21.
//

import SwiftUI

struct AstronautView: View {
    
    let astronaut: Astronaut
    var astronautMissions: [Mission] = [Mission]()
    
    var body: some View {
        GeometryReader { gr in
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Image(astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: gr.size.width)
                    VStack(alignment: .leading) {
                        Text(self.astronaut.description)
                        Spacer()
                        Text("Missions:")
                            .bold()
                        Spacer()
                        ForEach(astronautMissions) { mission in
                            HStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:30)
                                Text(mission.displayName)
                                    .padding(.leading)
                                Spacer()
                                Text("Date:  \(mission.formattedLaunchDate)")
                            }
                            
                        }
                    }
                    .padding()
                    
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name),displayMode: .inline)
    }
    
    init(astronaut: Astronaut) {
        self.astronaut = astronaut
        
        // missions could also be passed through MissionView but at this size I guess it is no problem to load it again from the original json
        let missions: [Mission] = Bundle.main.decode("missions.json")
        
        for mission in missions {
            if mission.crew.contains(where: {$0.name == astronaut.id}) {
                astronautMissions.append(mission)
            }
            
        }
    }
    
    
    
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        AstronautView(astronaut: astronauts[7])
    }
}
