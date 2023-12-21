//
//  TutorialView.swift
//  ArcadeGameTemplate
//
//  Created by Jakub Mantelli on 17/12/23.
//

import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack {
            Image("Tutorial_Panel")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    TutorialView()
}
