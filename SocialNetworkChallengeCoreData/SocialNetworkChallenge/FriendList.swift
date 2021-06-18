//
//  FriendList.swift
//  SocialNetworkChallenge
//
//  Created by Tim Musil on 18.06.21.
//

import CoreData
import SwiftUI

struct FriendList<T: NSManagedObject, Content: View>: View {
    
    var fetchRequest: FetchRequest<T>
    var friends: FetchedResults<T> { fetchRequest.wrappedValue }
    
    // this is our content closure; we'll call this once for each item in the list
    let content: (T) -> Content
    
    var body: some View {
        List(friends, id: \.self) { friend in
            self.content(friend)
        }
    }
    
    init(friendsIds: [UUID], sortDescriptors: [NSSortDescriptor], @ViewBuilder content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors, predicate: NSPredicate(format: "id IN %@", friendsIds))
        self.content = content
    }
}
