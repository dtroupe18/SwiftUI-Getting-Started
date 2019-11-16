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

  // Subscribe to the TimeCounter publisher.
  @ObservedObject var timer = TimeCounter()

  private func calculateScore() -> String {
    // The diff value is just the distance between two points in three-dimensional space.
    // You subtract it from 1, then scale it to a value out of 100.
    // Smaller diff yields a higher score.
    let redDiff = redGuess - randomRed
    let greenDiff = greenGuess - randomGreen
    let blueDiff = blueGuess - randomBlue
    let diff = sqrt(redDiff * redDiff + greenDiff * greenDiff + blueDiff * blueDiff)

    return "\(Int((1.0 - diff) * 100.0 + 0.5))"
  }

  /// Returns opacity 1 when the guess and the randomValue are the same
  /// otherwise the opacity is decreased by the difference.
  /// TLDR: Full opacity means you're close - Light opacity means you're far away.
  private func calculateScoreForColor(rgbColor: RGBColor) -> Double {
    switch rgbColor {
    case .red:
      return 1.0 - abs(self.redGuess - self.randomRed)
    case .green:
      return 1.0 - abs(self.greenGuess - self.randomGreen)
    case .blue:
      return 1.0 - abs(self.blueGuess - self.randomBlue)
    }
  }

  private func resetGame() {
    randomRed = Double.random(in: 0..<1)
    randomGreen = Double.random(in: 0..<1)
    randomBlue = Double.random(in: 0..<1)

    redGuess = 0.5
    greenGuess = 0.5
    blueGuess = 0.5
  }

  var body: some View {
    // Add a NavigationView so dark mode preview will work.
    NavigationView {
      VStack {
        HStack {
          VStack {
            Color(red: randomRed, green: randomGreen, blue: randomBlue)
            // Display the rgb value when the user ends their game.
            self.showAlert ? Text("R: \(Int(randomRed * 255.0))" + " G: \(Int(randomGreen * 255.0))"
              + " B: \(Int(randomBlue * 255.0))")
              : Text("Match this color")
          }
          VStack {
            // ZStack is like a z index the lower in the stack the "higher" the
            // view appears on the screen. So text appears on top of color.
            ZStack(alignment: .center) {
              Color(red: redGuess, green: greenGuess, blue: blueGuess)
              Text(String(timer.counter))
                .foregroundColor(.black)
                .padding(.all, 5)
                .background(Color.white)
                .mask(Circle())
            }
            Text("R: \(Int(redGuess * 255))  G: \(Int(greenGuess * 255))  B: \(Int(blueGuess * 255))")
          }
        }

        Button(action: {
          self.showAlert = true
          self.timer.killTimer()
        } ) {
          Text("Hit me")
        }.alert(isPresented: $showAlert, content: {
          Alert(title: Text("Your Score"), message: Text(self.calculateScore()),
                dismissButton: Alert.Button.default(Text("OK"), action: { self.resetGame()
                }))
        }).padding()

        VStack {
          SwiftUISlider(thumbColor: .red, minTrackColor: .red, maxTrackColor: .lightGray, value: $redGuess)
            .opacity(self.calculateScoreForColor(rgbColor: .red))

          SwiftUISlider(thumbColor: .green, minTrackColor: .green, maxTrackColor: .lightGray, value: $greenGuess)
            .opacity(self.calculateScoreForColor(rgbColor: .green))

          SwiftUISlider(thumbColor: .blue, minTrackColor: .blue, maxTrackColor: .lightGray, value: $blueGuess)

          // ColorSlider(value: $redGuess, textColor: .red).opacity(self.calculateScoreForColor(rgbColor: .red))
          // ColorSlider(value: $greenGuess, textColor: .green).opacity(self.calculateScoreForColor(rgbColor: .green))
          // ColorSlider(value: $blueGuess, textColor: .blue).opacity(self.calculateScoreForColor(rgbColor: .blue))
        }.padding(.horizontal) // Add some space before & after the sliderViews.
      }
      .navigationBarTitle("", displayMode: .inline)
      .navigationBarHidden(true)

      // You can also apply a colorScheme here
      // which will impact how the view looks when the app
      // is launched on device. Regardless of the users theme settings.
    }   // .environment(\.colorScheme, .dark)
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
        .background(textColor)
        .cornerRadius(10)
        .accentColor(.white)
      Text("255").foregroundColor(textColor)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(redGuess: 0.5, greenGuess: 0.5, blueGuess: 0.5).previewLayout(.fixed(width: 568, height: 320))
    // .environment(\.colorScheme, .dark)
  }
}
