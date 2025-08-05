//
//  FetchQuestion.swift
//  Flashcards of Knowledge
//
//  Created by Geraldy on 05/08/25.
//

import Foundation

@MainActor
class FetchQuestions: ObservableObject {
    @Published var questions: [Question] = []
    
    func fetchQuestions() async {
        guard let url = URL(string: "https://opentdb.com/api.php?amount=10&category=9&type=boolean") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(QuestionsResponse.self, from: data)
            questions = decoded.results
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    
}
