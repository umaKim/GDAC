//
//  FirebaseManager.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/08.
//
import FirebaseDatabase
import Combine
import Foundation

protocol Firebaseable {
    func fetchOpinions(completion: @escaping (PostContent) -> Void)
    func postOpinion(symbol: String, data: PostContent)
}

class FirebaseManager: Firebaseable {
    private let database = Database.database().reference().child("specificTalk")
    
    func fetchOpinions(completion: @escaping (PostContent) -> Void) {
        self.database.child("generalTalk").observe(.childAdded) { snapShot in
            guard let dictionary = snapShot.value as? [String: Any] else { return }
            
            guard
                let idString = dictionary["id"] as? String,
                let titleString = dictionary["title"] as? String,
                let date = dictionary["date"] as? Double,
                let bodyString = dictionary["body"] as? String
            else { return }
            
            let postContent = PostContent(
                id: idString,
                title: titleString,
                date: Date(timeIntervalSince1970: date),
                body: bodyString
            )
            completion(postContent)
        }
    }
    
    func postOpinion(symbol: String, data: PostContent) {
        let value = [
            "id": data.id,
            "title": data.title,
            "date": Int(NSDate().timeIntervalSince1970),
            "body": data.body
        ] as [String : Any]
        database.child(symbol).childByAutoId().updateChildValues(value)
    }
}
