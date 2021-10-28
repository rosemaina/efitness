//
//  Feedback.swift
//  eFitness
//
//  Created by Rose Maina on 25/10/2021.
//

import Firebase

struct Feedback {
    let ref: DatabaseReference?
    let key, name, dateTime: String
    let workouts: [Workout]
    
    // MARK: - Initialize with Raw Data
    init( key: String = "", name: String, dateTime: String, workouts: [Workout]) {
        self.ref = nil
        self.key = key
        self.name = name
        self.dateTime = dateTime
        self.workouts = workouts
    }
    
    // MARK: - Initialize with Firebase DataSnapshot
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let dateTime = value["dateTime"] as? String,
            let workouts = value["workouts"] as? [Workout]
        else {
            return nil
        }
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
        self.dateTime = dateTime
        self.workouts = workouts
    }
    
    // MARK: - Convert WorkOut Item to AnyObject
    func toAnyObject() -> Any {
        return [
            "name": name,
            "dateTime": dateTime,
            "workouts": workouts
        ]
    }
}

struct Workout: Codable {
    let name, feedback, dateTime: String
}
