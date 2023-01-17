//
//  OpinionRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/16.
//

import Foundation

protocol OpinionRepository {
    func fetchOpinions(completion: @escaping (PostContent) -> Void)
}

struct OpinionRepositoryImp: OpinionRepository {
    
    private let firebase: Firebaseable
    
    init(firebase: Firebaseable) {
        self.firebase = firebase
    }
    
    func fetchOpinions(completion: @escaping (PostContent) -> Void) {
        self.firebase.fetchOpinions(completion: completion)
    }
}
