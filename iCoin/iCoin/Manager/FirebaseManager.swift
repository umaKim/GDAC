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
    func fetchOpinions() -> AnyPublisher<PostContent, Never>
}

class FirebaseManager: Firebaseable {
    private let database = Database.database().reference().child("specificTalk")
    
    func fetchOpinions() -> AnyPublisher<PostContent, Never> {
        Future<PostContent, Never> {[weak self] promise in
            guard let self = self else { return }
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
                promise(.success(postContent))
            }
        }
        .eraseToAnyPublisher()
    }
}
