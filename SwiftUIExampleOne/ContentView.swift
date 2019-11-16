//
//  ContentView.swift
//  SwiftUIExampleOne
//
//  Created by Dave Troupe on 11/15/19.
//  Copyright © 2019 High Tree Development. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    // In SwiftUI, when a @State variable changes,
    // the view invalidates its appearance and recomputes the body.
    @State var randomRed = Double.random(in: 0..<1)
    @State var randomGreen = Double.random(in: 0..<1)
    @State var randomBlue = Double.random(in: 0..<1)

    @State var redGuess: Double
    @State var greenGuess: Double
    @State var blueGuess: Double

    @State var showAlert: Bool = false

    func calculateScore() -> String {
        // The diff value is just the distance between two points in three-dimensional space.
        // You subtract it from 1, then scale it to a value out of 100.
        // Smaller diff yields a higher score.
        let redDiff = redGuess - randomRed
        let greenDiff = greenGuess - randomGreen
        let blueDiff = blueGuess - randomBlue
        let diff = sqrt(redDiff * redDiff + greenDiff * greenDiff + blueDiff * blueDiff)

        return "\(Int((1.0 - diff) * 100.0 + 0.5))"
    }

     func resetGame() {
        randomRed = Double.random(in: 0..<1)
        randomGreen = Double.random(in: 0..<1)
        randomBlue = Double.random(in: 0..<1)

        redGuess = 0.5
        greenGuess = 0.5
        blueGuess = 0.5
    }

    var body: some View {
        VStack {
            HStack {
                VStack {
                    Color(red: randomRed, green: randomGreen, blue: randomBlue)
                    Text("Match this color")
                }
                VStack {
                    Color(red: redGuess, green: greenGuess, blue: blueGuess)
                    Text("R: \(Int(redGuess * 255))  G: \(Int(greenGuess * 255))  B: \(Int(blueGuess * 255))")
                }
            }

            Button(action: {self.showAlert = true} ) {
                Text("Hit me")
            }.alert(isPresented: $showAlert, content: {
                Alert(title: Text("Your Score"), message: Text(self.calculateScore()),
                      dismissButton: Alert.Button.default(Text("OK"), action: { self.resetGame()
                }))
            }).padding()

            ColorSlider(value: $redGuess, textColor: .red)
            ColorSlider(value: $greenGuess, textColor: .green)
            ColorSlider(value: $blueGuess, textColor: .blue)
        }
    }
}

struct ColorSlider: View {
    // Use @Binding instead of @State, because the ColorSlider view
    // doesn't own this data—it receives an initial value from its parent view and mutates it.
    @Binding var value: Double
    var textColor: Color

    var body: some View {
        HStack {
            Text("0").foregroundColor(textColor)
            Slider(value: $value)
            Text("255").foregroundColor(textColor)
        }.padding(.horizontal)  // Add some space before & after the text
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(redGuess: 0.5, greenGuess: 0.5, blueGuess: 0.5).previewLayout(.fixed(width: 568, height: 320))
    }
}
