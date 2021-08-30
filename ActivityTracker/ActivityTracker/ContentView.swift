//
//  ContentView.swift
//  ActivityTracker
//
//  Created by Tim Musil on 28.05.21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var activities = Activities()
    @State private var showingAddView = false
    var body: some View {
        NavigationView {
            List {
                ForEach(activities.activities) { activity in
                    NavigationLink(
                        destination: DetailView(activity: activity),
                        label: {
                            Label(activity.name, systemImage: activity.image)
                        })
                    HStack {
                        Text("Count: \(activity.count)")
                        Spacer()
                        Button("+") {
                            if let index = activities.activities.firstIndex(where: {$0.id == activity.id}) {
                                activities.activities[index].countUp()
                            }
                        }
                        
                        Divider()
                        Button("-") {
                            if let index = activities.activities.firstIndex(where: {$0.id == activity.id}) {
                                activities.activities[index].countDown()
                            }
                            
                        }
                        .padding(.horizontal)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                    
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("ActivityTracker")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    showingAddView = true
                }, label: {
                    Image(systemName: "plus")
                }))
            .sheet(isPresented: $showingAddView, content: {
                AddView(activities: activities)
            })
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
    func removeItems(at offsets: IndexSet) {
        activities.activities.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
