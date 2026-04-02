//
//  LibraryView.swift
//  MediaFlow
//
//  Created by Arpana Rani on 01/04/26.
//

import SwiftUI

struct LibraryView: View {

    let columns = Array(repeating: GridItem(.flexible()), count: 3)

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {

                    ForEach(0..<12) { _ in
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 100)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle("Library")
            .background(Color(.systemGray6))
        }
    }
}
