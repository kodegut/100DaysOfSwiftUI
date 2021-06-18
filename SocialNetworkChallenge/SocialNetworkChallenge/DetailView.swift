//
//  DetailView.swift
//  SocialNetworkChallenge
//
//  Created by Tim Musil on 17.06.21.
//

import SwiftUI

struct DetailView: View {
    let users: [User]
    let user: User
    
    var userDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        return formatter.string(from: user.registered)
        
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("\(String(user.age)) years old")
                .padding()
            Group {
                Text("Detail Information")
                    .font(.title)
                Text(user.email)
                Text(userDate)
            }
            .padding(.horizontal)
            
            Spacer(minLength: 20)
            List {
                ForEach(user.friends) { friend in
                    NavigationLink(
                        destination: getFriendById(id: friend.id)){
                        Text(friend.name)
                    }
                    
                }
            }
        }
        .navigationBarTitle(user.name)
    }
    
    func getFriendById (id: UUID) -> some View {
        guard let user = users.first(where: { $0.id == id }) else {
            return AnyView(Text("No Entry for this User"))
        }
        return AnyView(DetailView(users: users, user: user))
    }
    
    //let user = User(id: UUID(), isActive: true, name: "Tom Bombadil", age: 4000, company: "Earth", email: "lotr.com", address: "that weird house", about: "He likes Rose if I remember correctly", registered: Date(), tags: ["blue","good","swords","woods"], friends: [Friend(id: UUID(), name: "Frodo Baggins")])
    
}

struct DetailView_Previews: PreviewProvider {
    let user = User(id: UUID(), isActive: true, name: "Tom Bombadil", age: 4000, company: "Earth", email: "lotr.com", address: "that weird house", about: "He likes Rose if I remember correctly", registered: Date(), tags: ["blue","good","swords","woods"], friends: [Friend(id: UUID(), name: "Frodo Baggins")])
    
    static var previews: some View {
        DetailView(users: [], user: User(id: UUID(), isActive: true, name: "Tom Bombadil", age: 4000, company: "Earth", email: "lotr.com", address: "that weird house", about: "He likes Rose if I remember correctly", registered: Date(), tags: ["blue","good","swords","woods"], friends: [Friend(id: UUID(), name: "Frodo Baggins")]))
    }
}
