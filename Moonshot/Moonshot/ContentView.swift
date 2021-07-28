//
//  ContentView.swift
//  Moonshot
//
//  Created by Tim Musil on 20.05.21.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    @State private var showingCrewNames = false
    
    var body: some View {
        NavigationView {
            VStack {
                List(missions) { mission in
                    NavigationLink(destination: MissionView(mission: mission, astronauts: astronauts)) {
                        Image(mission.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 44, height: 44)
                        
                        VStack(alignment: .leading) {
                            Text(mission.displayName)
                                .font(.headline)
                            if showingCrewNames {
                                Text(mission.crewNames)
                                
                            } else {
                                Text(mission.formattedLaunchDate)
                            }
                            
                        }
                    }
                }
                .navigationBarTitle("Moonshot")
                .navigationBarItems(leading: Button(showingCrewNames ? "Dates" : "Crew") {
                    showingCrewNames.toggle()
                })
                
            }
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("kodegut")
                            .frame(width: 100)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Capsule())
                            .padding()
                            .padding(.trailing, 10)
                            .accessibility(hidden: true)
                    }
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
