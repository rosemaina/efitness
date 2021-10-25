//
//  EfitnessClient.swift
//  eFitness
//
//  Created by Rose Maina on 25/10/2021.
//

import Firebase

class EfitnessClient {
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
    static let databaseRef = Database.database().reference() // Gets a FIRDatabaseReference for the root of your Firebase Database
    
//    func fetchFeedback(completion: @escaping ([FeedbackModel]) -> Void) {
        
//        let feedbackRef = "feedback/"
//
//        EfitnessClient.databaseRef.child(feedbackRef).observe(.value) { (snapshot) in
//
//            guard let feedbackDict = snapshot.value as? [String: Any] else {
//                return
//            }
            
//            let list = feedbackDict.compactMap { (arg: (key: String, value: Any)) -> FeedbackModel? in
//
//                var schedules: [Schedule] = []
//
//                for v in arg.value as! [[String: String]] {
//                    schedules.append(Schedule(from: v))
//                }
//
//                let container = ScheduleContainer(title: arg.key, schedules: schedules)
//                return container
//            }
//
//            completion(sc)
//        }
//    }
}
