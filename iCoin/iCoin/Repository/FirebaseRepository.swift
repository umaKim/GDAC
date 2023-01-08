//
//  FirebaseRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/08.
//
import FirebaseDatabase
import Combine
import Foundation

protocol FirebaseRepository {
    func fetchOpinions() -> AnyPublisher<PostContent, Never>
}

class FirebaseRepositoryImp: FirebaseRepository {
    
    private let firebase: Firebaseable
    
    init(firebase: Firebaseable) {
        self.firebase = firebase
    }
    
    func fetchOpinions() -> AnyPublisher<PostContent, Never> {
        self.firebase.fetchOpinions()
    }
}
