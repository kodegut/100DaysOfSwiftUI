//
//  DetailView.swift
//  SocialNetworkChallenge
//
//  Created by Tim Musil on 17.06.21.
//

import SwiftUI

struct DetailView: View {
    
    let user: CDUser
    
    var userDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        if let registered = user.registered {
            return formatter.string(from: registered)
        } else {
            return "no date available"
        }
        
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("\(String(user.age)) years old")
                .padding()
            VStack(alignment: .leading, spacing: 4) {
                Text("Detail Information")
                    .font(.title)
                Text("Company: \(user.wrappedCompany)")
                Text("Mail: \(user.wrappedEmail)")
                Text("Registered: \(userDate)")
            }
            
            .padding(.horizontal)
            
            Spacer(minLength: 20)
            
            FriendList(friendsIds: user.wrappedFriends, sortDescriptors: []) { (user: CDUser) in
                NavigationLink(
                    destination: DetailView(user: user),
                    label: {
                        Text("\(user.wrappedName), \(user.wrappedAge)")
                    })
                
            }
        }
        .navigationBarTitle(user.wrappedName)
    }
    
    
}

struct DetailView_Preview_Wrapper: View {
    @FetchRequest(entity: CDUser.entity(), sortDescriptors: []) var users: FetchedResults<CDUser>
    
    var body: some View {
        DetailView(user: users.first!)
    }
    
}



struct DetailView_Previews: PreviewProvider {
    let user = User(id: UUID(), isActive: true, name: "Tom Bombadil", age: 4000, company: "Earth", email: "lotr.com", address: "that weird house", about: "He likes Rose if I remember correctly", registered: Date(), tags: ["blue","good","swords","woods"], friends: [Friend(id: UUID(), name: "Frodo Baggins")])
    
    
    static var previews: some View {
        DetailView_Preview_Wrapper().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
