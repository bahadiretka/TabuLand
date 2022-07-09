//
//  MainView.swift
//  TabuLand
//
//  Created by Bahadır Kılınç on 7.07.2022.
//

import SwiftUI

struct MainView: View {
    @State var inputViewAppear = false
    @State var scoreViewAppear = false
    var body: some View {
        ZStack{
            ZStack{
                Image("main-background")
                    .ignoresSafeArea()
                    .scaledToFill()
                HStack{
                    Button(action: {
                        inputViewAppear.toggle()
                    }){
                        Image("new-game-button")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding()
                }
            }
            .blur(radius: inputViewAppear ? 8.0 : 0, opaque: false)
            if inputViewAppear{
                HStack{
                    InputView(isShowing: $inputViewAppear)
                }.padding(.horizontal,40)
            }
        }
    }
}
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
