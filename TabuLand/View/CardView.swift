//
//  CardView.swift
//  TabuLand
//
//  Created by Bahadır Kılınç on 7.07.2022.
//

import SwiftUI

struct CardView: View, Identifiable {
  
  let id = UUID()
  var words: [String]
  
  var body: some View {
      ZStack{
          Image("card-background")
          .resizable()
          .cornerRadius(24)
          .scaledToFit()
          .frame(minWidth: 0, maxWidth: .infinity)
                Text(words[0])
                  .frame(maxHeight: .infinity, alignment: .top)
                  .font(.system(size: 36))
                  .font(.largeTitle)
                  .padding()
                  .foregroundColor(Color("shinyYellow"))
              VStack(alignment: .center,spacing: 30) {
                Text(words[1])
                Text(words[2])
                Text(words[3])
                Text(words[4])
                Text(words[5])
              }
              .padding(.top,90)
              .frame(alignment: .center)
              .foregroundColor(Color("navyBlue"))
              .font(.system(size: 24))
      }
  }
}
struct CardView_Previews: PreviewProvider {
  static var previews: some View {
      CardView(words: tabulandData.shuffled()[0])
      .previewLayout(.fixed(width: 375, height: 600))
  }
}
