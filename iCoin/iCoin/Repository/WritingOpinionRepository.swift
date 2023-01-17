//
//  WritingOpinionRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2023/01/16.
//

import Foundation

protocol WritingOpinionRepository {
    func postOpinion(symbol: String, data: PostContent)
}

struct WritingOpinionRepositoryImp: WritingOpinionRepository {
    
    private let firebase: Firebaseable
    
    init(firebase: Firebaseable) {
        self.firebase = firebase
    }
    
    func postOpinion(symbol: String, data: PostContent) {
        self.firebase.postOpinion(symbol: symbol, data: data)
    }
}
