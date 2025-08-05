//
//  QuestionType.swift
//  Flashcards of Knowledge
//
//  Created by Geraldy on 05/08/25.
//
import Foundation

struct QuestionsResponse: Codable {
    let results: [Question]
}

struct Question: Codable, Identifiable {
    var id: UUID { UUID() }
    let category: String
    let difficulty: String
    let question: String
    let correct_answer: String
}
