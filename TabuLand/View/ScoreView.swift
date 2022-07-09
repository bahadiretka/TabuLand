//
//  ScoreView.swift
//  TabuLand
//
//  Created by Bahadır Kılınç on 7.07.2022.
//

import SwiftUI
struct ScoreView: View {
    @Binding var isShowing: Bool
    @State private var isButtonDisabled = false
    let game = Taboo.game
    var body: some View {
        ZStack{
            Image("score-background")
                .scaledToFit()
            .ignoresSafeArea()
            VStack(alignment: .center, spacing: 12) {
                HStack{
                Text(game.isThereWinner ? "KAZANAN: \(game.winner.uppercased())"
                     : "BERABERE")
                        .foregroundColor(Color.white)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .shadow(radius: 1)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 4)
                        .overlay(
                          Rectangle()
                            .fill(Color.white)
                            .frame(height: 1),
                          alignment: .bottom
                        )
                }.padding()
                teamName(team: game.team1)
                teamDetail(team: game.team1)
                    
                teamName(team: game.team2)
                teamDetail(team: game.team2)

                    Button(action: {
                        isShowing.toggle()
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    }){
                      Spacer()
                      Text("Tamam")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                      Spacer()
                    }
                    .frame(maxWidth: 240,minHeight: 40)
                    .disabled(isButtonDisabled)
                    .foregroundColor(Color("boyDress"))
                    .background(isButtonDisabled ? Color.blue : Color("girlDress"))
                    .cornerRadius(10)
                    .shadow(color: .black, radius: 1, x: 3, y: 4)
                    .padding(.top,40)
                // VSTACK
            }

        }

    }
}
struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView(isShowing: .constant(true))
    }
}
@ViewBuilder private func teamDetail(team: Team) -> some View{
    HStack{
        VStack{
            Text("Doğru Sayısı: \(team.trueAnswer)")
                .foregroundColor(Color.black)
                .font(.footnote)
                .fontWeight(.bold)
                .frame(minWidth: 85)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                  Capsule().fill(Color.white)
                )
            Text("Yapılan Tabu Sayısı: \(team.taboo)")
                .foregroundColor(Color.black)
                .font(.footnote)
                .fontWeight(.bold)
                .frame(minWidth: 85)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                  Capsule().fill(Color.white)
                )
        }
    }.padding()
}
@ViewBuilder private func teamName(team: Team) -> some View{
    HStack{
        Text(team.name.uppercased())
            .foregroundColor(Color.white)
            .font(.largeTitle)
            .fontWeight(.bold)
            .shadow(radius: 1)
            .padding(.horizontal, 18)
            .padding(.vertical, 4)
            .overlay(
              Rectangle()
                .fill(Color.white)
                .frame(height: 1),
              alignment: .bottom
          )
    }
}
