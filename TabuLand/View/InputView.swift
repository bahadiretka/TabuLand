//
//  InputView.swift
//  TabuLand
//
//  Created by Bahadır Kılınç on 7.07.2022.
//

import SwiftUI
struct InputView: View {
    @State private var team1 = ""
    @State private var team2 = ""
    @Binding var isShowing: Bool
    @State var gameViewAppear = false
    @State private var isButtonDisabled = false
    
    var body: some View {
        
        VStack {
            VStack(spacing: 16) {
            TextField("", text: $team1)
               .placeholder(when: team1.isEmpty) {
                    Text("Birinci Takım").foregroundColor(Color("navyBlue"))
               }
              .foregroundColor(Color("shinyPink"))
              .font(.system(size: 24, weight: .bold, design: .rounded))
              .padding()
              .background(Color("shinyYellow"))
              .cornerRadius(10)
                TextField("", text: $team2)
                .placeholder(when: team2.isEmpty) {
                    Text("İkinci Takım").foregroundColor(Color("navyBlue"))
                }
                .foregroundColor(Color("shinyPink"))
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .padding()
                .background(Color("shinyYellow"))
                .cornerRadius(10)
            Button(action: {
                Taboo.startGame(team1: team1.isEmpty ? "A" : team1,
                                team2: team2.isEmpty ? "B" : team2)
                gameViewAppear.toggle()
                
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            }){
              Spacer()
              Text("Tamam")
                .font(.system(size: 24, weight: .bold, design: .rounded))
              Spacer()
            }.fullScreenCover(isPresented: $gameViewAppear, onDismiss: {
                isShowing.toggle()
            }){
                GameView(isShowing: $gameViewAppear)
            }
            .disabled(isButtonDisabled)
            .padding()
            .foregroundColor(Color("shinyYellow"))
            .background(isButtonDisabled ? Color.blue : Color.pink)
            .cornerRadius(10)
          } //: VSTACK
          .padding(.horizontal)
          .padding(.vertical, 20)
          .background(Color("navyBlue"))
          .cornerRadius(16)
          .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 24)
          .frame(maxWidth: 640)
        } //: VSTACK
        .padding()
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(isShowing: .constant(true))
        .background(Color.gray.edgesIgnoringSafeArea(.all))
    }
}
