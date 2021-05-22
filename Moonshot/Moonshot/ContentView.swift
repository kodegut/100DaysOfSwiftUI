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
            ZStack {
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
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
                    
                    HStack {
                        Spacer()
                        Text("@kodegut")
                            .padding(.horizontal)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
