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

    private func onRestart() {
        currentIndex = 0
        totalCorrectAnswers = 0
        offset = .zero
        gameState = .loading
        Task {
            await viewModel.fetchQuestions()
            gameState = .quiz
        }
    }

    private func onGoHome() {
        currentIndex = 0
        totalCorrectAnswers = 0
        offset = .zero
        gameState = .start
    }

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

    var body: some View {
        VStack {
            switch gameState {
            case .start:
                GenericButton(
                    buttonAction: {
                        gameState = .loading
                        Task {
                            await viewModel.fetchQuestions()
                            gameState = .quiz
                        }
                    },
                    label: "Start"
                )
            case .loading:
                ProgressView("Loading Questions...")
            case .quiz:
                let questions = viewModel.questions
                CardItem(
                    offset: $offset,
                    questions: questions,
                    currentIndex: currentIndex,
                    handleAnswer: handleAnswer,
                    totalCorrectAnswers: totalCorrectAnswers,
                    onRestart: onRestart,
                    onGoHome: onGoHome
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 150 / 255, green: 100 / 255, blue: 100 / 255))
    }
}

#Preview {
    ContentView()
}
