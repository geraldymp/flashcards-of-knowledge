//
//  ContentView.swift
//  Flashcards of Knowledge
//
//  Created by Geraldy on 05/08/25.
//

import SwiftUI

struct ContentView: View {

    enum GameState {
        case start, loading, quiz
    }

    @State private var gameState: GameState = .start

    @StateObject private var viewModel = FetchQuestions()

    @State private var currentIndex = 0
    @State private var offset = CGSize.zero
    @State private var totalCorrectAnswers: Int = 0

    private func handleAnswer(userAnswer: Bool, correctAnswer: String) {
        if userAnswer {
            if correctAnswer == "True" {
                totalCorrectAnswers += 1
                offset = .zero
                currentIndex += 1
            } else {
                offset = .zero
                currentIndex += 1
            }
        } else {
            if correctAnswer == "False" {
                totalCorrectAnswers += 1
                offset = .zero
                currentIndex += 1
            } else {
                offset = .zero
                currentIndex += 1
            }
        }
    }

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
        VStack {
            switch gameState {
            case .start:
                GenericButton(buttonAction: {
                        gameState = .loading
                        Task {
                            await viewModel.fetchQuestions()
                            gameState = .quiz
                        }
                }, label: "Start")
            case .loading:
                ProgressView("Loading Questions...")
            case .quiz:
                let questions = viewModel.questions
                ZStack {
                    if currentIndex < questions.count {
                        let question = questions[currentIndex].question
                        let answer = questions[currentIndex].correct_answer
                        Text(htmlDecode(question))
                            .font(.title)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 400)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 10)
                            .offset(x: offset.width)
                            .rotationEffect(.degrees(Double(offset.width / 20)))
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        offset = gesture.translation
                                    }
                                    .onEnded { _ in
                                        if offset.width > 200 {
                                            // Swiped right = YES
                                            handleAnswer(
                                                userAnswer: true,
                                                correctAnswer: answer
                                            )
                                        } else if offset.width < -200 {
                                            // Swiped left = NO
                                            handleAnswer(
                                                userAnswer: false,
                                                correctAnswer: answer
                                            )
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
                            Button("Restart") {
                                currentIndex = 0
                                totalCorrectAnswers = 0
                                offset = .zero
                                gameState = .loading
                                Task {
                                    await viewModel.fetchQuestions()
                                    gameState = .quiz
                                }
                            }
                            .padding()

                            Button("Go to Home") {
                                currentIndex = 0
                                totalCorrectAnswers = 0
                                offset = .zero
                                gameState = .start
                            }
                        }
                    }
                }
                .padding()
                .background(Color.gray)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 100/255, green: 100/255, blue: 100/255))
    }
}

#Preview {
    ContentView()
}
