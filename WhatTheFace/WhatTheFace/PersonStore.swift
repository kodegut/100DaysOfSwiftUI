//
//  PersonStore.swift
//  WhatTheFace
//
//  Created by Tim Musil on 10.07.21.
//

import Foundation
import UIKit

class PersonStore: ObservableObject {
    
    init() {
        do {
            let fileURL = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("Persons.json")
            let data = try Data(contentsOf: fileURL)
            persons = try JSONDecoder().decode([Person].self, from: data)
            return
        } catch {
            print(error.localizedDescription)
        }
        persons = []
    }
    
    @Published var persons: [Person] {
        didSet {
            savePersons()
        }
    }
    
    func savePersons() {
        if let url = PersonStore.getApplicationSupportDirectory()?.appendingPathComponent("Persons.json") {
            do {
                try JSONEncoder().encode(persons).write(to: url)
            } catch {
                print(error)
            }
        }
    }
    
    func saveImage(image: UIImage, imageId: UUID) {
        
        if let url = PersonStore.getApplicationSupportDirectory()?.appendingPathComponent(imageId.uuidString + ".jpg") {
            if let jpegData = image.jpegData(compressionQuality: 0.8) {
                try? jpegData.write(to: url, options: [.atomicWrite, .completeFileProtection])
            }
        }
    }
    
    static func loadImage(imageId: UUID) -> UIImage? {
        
        if let url = getApplicationSupportDirectory()?.appendingPathComponent(imageId.uuidString + ".jpg") {
            if let data = FileManager.default.contents(atPath: url.path) {
                return UIImage(data: data)
            }
        }
        return nil
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
