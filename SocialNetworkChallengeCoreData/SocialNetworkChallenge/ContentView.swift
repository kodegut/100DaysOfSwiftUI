//
//  ContentView.swift
//  SocialNetworkChallenge
//
//  Created by Tim Musil on 17.06.21.
//
import CoreData
import SwiftUI

struct ContentView: View {
    @State private var results = [User]()
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: CDUser.entity(), sortDescriptors: []) var users: FetchedResults<CDUser>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(users) { user in
                    NavigationLink(
                        destination: DetailView(user: user),
                        label: {
                            Text(user.wrappedName)
                        })
                    
                }
                
            }.overlay(
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("kodegut")
                            .frame(width: 100)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.7))
                            .clipShape(Capsule())
                            .padding()
                            .padding(.trailing, 40)
                    }
                })
            .navigationBarTitle("Users")
            .navigationBarItems(leading: Button(users.isEmpty ? "Load Data" : "Delete from CoreData") {
                
                if users.isEmpty {
                    loadData()
                } else {
                    deleteAllItems()
                }
                
            })
            
        }
        .onAppear(perform: loadData)
        
    }
    
    func loadData() {
        
        if users.count == 0 {
            
            
            guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
                print("Invalid URL")
                return
            }
            
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard let data = data else {
                    print("No data in response: \(error?.localizedDescription ?? "Unknown Error")")
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                do {
                    results = try decoder.decode([User].self, from: data)
                    
                } catch {
                    print("Decoding Failed: \(error)")
                }
                
                // load data into core data
                
                for user in results {
                    let newUser = CDUser(context: self.moc)
                    newUser.id = user.id
                    newUser.isActive = user.isActive
                    newUser.name = user.name
                    newUser.age = Int16(user.age)
                    newUser.company = user.company
                    newUser.email = user.email
                    newUser.address = user.address
                    newUser.about = user.about
                    newUser.registered = user.registered
                    newUser.tags = user.tags
                    newUser.friends = user.friendsIds
                }
                
                if self.moc.hasChanges {
                    try? self.moc.save()
                }
                
                return
                
            }.resume()
            
        }
        
    }
    
    func deleteAllItems() {
        
        
        for user in users {
            moc.delete(user)
        }
        
        try? self.moc.save()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
