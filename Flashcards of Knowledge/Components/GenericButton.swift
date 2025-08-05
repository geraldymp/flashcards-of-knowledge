//
//  GenericButton.swift
//  Flashcards of Knowledge
//
//  Created by Geraldy on 05/08/25.
//
import SwiftUI

struct GenericButton: View {
    var buttonAction: () -> Void
    var label: String

    var body: some View {
        Button(action: buttonAction) {
            Text(label)
                .bold()
                .font(.system(size: 32))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 24)
        .background(Color.green)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}
