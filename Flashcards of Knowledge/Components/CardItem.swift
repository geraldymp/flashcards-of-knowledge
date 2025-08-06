//
//  CardItem.swift
//  Flashcards of Knowledge
//
//  Created by Geraldy on 06/08/25.
//
import SwiftUI

struct CardItem: View {
    @Binding var offset: CGSize
    
    var questions: [Question]
    var currentIndex: Int
    var handleAnswer: (_ userAnswer: Bool, _ correctAnswer: String) -> Void
    var totalCorrectAnswers: Int
    var onRestart: () -> Void
    var onGoHome: () -> Void
    
    
    private func htmlDecode(_ string: String) -> String {
        guard let data = string.data(using: .utf8) else { return string }

        if let attributedString = try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue,
            ],
            documentAttributes: nil
        ) {
            return attributedString.string
        } else {
            return string
        }
    }
    
    var body: some View {
        ZStack {
            if currentIndex < questions.count {
                let question = questions[currentIndex].question
                let answer = questions[currentIndex].correct_answer
                VStack {
                    Text("Question Type: \(questions[currentIndex].category)")
                        .font(.system(size: 14))
                        .padding(.bottom, 12)
                    Text("Difficulty: \(questions[currentIndex].difficulty)")
                        .font(.system(size: 14))
                        .padding(.bottom, 12)
                    Spacer()
                    Text(htmlDecode(question))
                    Spacer()
                }
                
                    .font(.title)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .offset(x: offset.width)
                    .rotationEffect(.degrees(Double(offset.width / 20)))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                self.offset = gesture.translation
                            }
                            .onEnded { _ in
                                if offset.width > 200 {
                                    // Swiped right = YES
                                    handleAnswer(true,answer)
                                } else if offset.width < -200 {
                                    // Swiped left = NO
                                    handleAnswer(false,answer)
                                } else {
                                    offset = .zero
                                }
                            }
                    )
                    .animation(.spring(), value: offset)
            } else {
                VStack {
                    Text("Quiz Completed!")
                        .font(.largeTitle)
                        .padding()
                    Text(
                        "You answered correctly to \(totalCorrectAnswers) out of \(questions.count) questions."
                    )
                    .padding()
                    
                    GenericButton(buttonAction: onRestart, label: "Restart")
                        .padding()

                    GenericButton(buttonAction: onGoHome, label: "Go to Home")
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 64)
        .background(Color.gray)
    }
}
