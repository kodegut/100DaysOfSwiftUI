//
//  Prospect.swift
//  HotProspects
//
//  Created by Tim Musil on 16.07.21.
//

import Foundation


class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
    var timestamp = Date()
}

enum Sorting {
    case name, added
}

class Prospects: ObservableObject {
    static let saveKey = "SavedData"
    @Published private(set) var people: [Prospect]
    
    // old version
    
    //    init() {
    //        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
    //            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
    //                self.people = decoded
    //                return
    //            }
    //        }
    //
    //        self.people = []
    //    }
    
    init() {
        do {
            let fileURL = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("Prospects.json")
            let data = try Data(contentsOf: fileURL)
            people = try JSONDecoder().decode([Prospect].self, from: data)
            return
        } catch {
            print(error.localizedDescription)
        }
        self.people = []
    }
    
    private func save() {
        
        // old version
        //        if let encoded = try? JSONEncoder().encode(people) {
        //            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        //        }
        
        if let url = Prospects.getApplicationSupportDirectory()?.appendingPathComponent("Prospects.json") {
            do {
                try JSONEncoder().encode(people).write(to: url)
            } catch {
                print(error)
            }
        }
        
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    static func getApplicationSupportDirectory() -> URL? {
        let directoryURL: URL
        
        do {
            directoryURL = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true)
        }
        catch {
            return nil
        }
        return directoryURL
    }
    
    
}
