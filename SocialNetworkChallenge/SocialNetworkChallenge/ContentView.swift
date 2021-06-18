//
//  ContentView.swift
//  SocialNetworkChallenge
//
//  Created by Tim Musil on 17.06.21.
//

import SwiftUI

struct ContentView: View {
    @State private var results = [User]()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(results) { user in
                    NavigationLink(
                        destination: DetailView(users: results, user: user),
                        label: {
                            Text(user.name)
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
            
        }
        .onAppear(perform: loadData)
        
    }
    
    func loadData() {
        
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
                return
            } catch {
                print("Decoding Failed: \(error)")
            }
            
            
        }.resume()
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
