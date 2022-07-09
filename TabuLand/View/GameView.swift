//
//  GameView.swift
//  TabuLand
//
//  Created by Bahadır Kılınç on 7.07.2022.
//

import SwiftUI

struct GameView: View {
  // MARK: - PROPERTIES
    @Binding var isShowing: Bool
    @State var showScore: Bool = false
    @State var isReady = false
    @State var isQuitTapped = false
    @State var lastCardIndex: Int = 1
    @State var cardRemovalTransition = AnyTransition.trailingBottom
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timeRemaining = Taboo.remainingTime
    @State var currentColor = Color("softGreen")
    let haptics = UINotificationFeedbackGenerator()
    var game = Taboo.game
    @State var tour = Taboo.tour
    @State var passRight = Taboo.passRight
    @GestureState var dragState = DragState.inactive
    var dragAreaThreshold: CGFloat = 65.0
    
    
  // MARK: - CARD VIEWS
  
  @State var cardViews: [CardView] = {
    var views = [CardView]()
      (0..<2).forEach {
          views.append(CardView(words: tabulandData[$0]))
    }
    return views
  }()
  
  // MARK: - MOVE THE CARD
  
    func moveCards() {
    cardViews.removeFirst()
    
    self.lastCardIndex += 1
    
    let honeymoon = tabulandData[lastCardIndex % tabulandData.count]
    
      let newCardView = CardView(words: honeymoon)
    
    cardViews.append(newCardView)
  }
  
  // MARK: TOP CARD
  
    func isTopCard(cardView: CardView) -> Bool {
    guard let index = cardViews.firstIndex(where: { $0.id == cardView.id }) else {
      return false
    }
    return index == 0
  }
  
  // MARK: - DRAG STATES
  
  enum DragState {
    case inactive
    case pressing
    case dragging(translation: CGSize)
    
    var translation: CGSize {
      switch self {
      case .inactive, .pressing:
        return .zero
      case .dragging(let translation):
        return translation
      }
    }
    
    var isDragging: Bool {
      switch self {
      case .dragging:
        return true
      case .pressing, .inactive:
        return false
      }
    }
    
    var isPressing: Bool {
      switch self {
      case .pressing, .dragging:
        return true
      case .inactive:
        return false
      }
    }
  }
  
  var body: some View {
          ZStack{
          ZStack{
        VStack {
          // MARK: - HEADER
            HStack(alignment: .center, spacing: 12){
                Button(action: {
                    isReady.toggle()
                    isQuitTapped.toggle()
                }){
                    Image(systemName: "house.circle")
                        .foregroundColor(Color("navyBlue"))
                        .font(.system(size: 42))
                }
                .padding()
                Spacer()
                Text(game.teamName.uppercased()) // make bigger team names
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .foregroundColor(Color("navyBlue"))
                    .background(
                        Capsule().stroke(Color("navyBlue"), lineWidth: 5)
                    )
                    .background(Capsule().fill(Color("shinyYellow")))
                Spacer()
                
                Text("\(timeRemaining)")
                    .frame(width: 30, height: 30, alignment: .center)
                    .padding()
                    .foregroundColor(Color("navyBlue"))
                    .background(
                        Arc(endAngle: Angle(degrees: Double((Double(timeRemaining) / Double(Taboo.remainingTime)) * 360)))
                            .strokeBorder(currentColor,lineWidth: 10)
                    )
                    .background(Circle())
                    .onReceive(timer) { _ in
                        if isReady{
                            if timeRemaining > 0 {
                                timeRemaining -= 1
                                if timeRemaining < 15{
                                    currentColor = Color("softRed")
                                    playSound(sound: "tic-toc", type: "mp3")
                                }
                            }
                            if timeRemaining == 0{
                                playSound(sound: "time-finished", type: "mp3")
                                if tour == 0{
                                    showScore.toggle()
                                    tour = -1
                                }else{
                                    isReady.toggle()
                                    currentColor = Color("softGreen")
                                    self.timeRemaining = Taboo.remainingTime
                                    game.changeTeam()
                                    Taboo.passRight = 3
                                    self.moveCards()
                                    self.tour -= 1
                                }
                            }
                        }
                    }
                    .padding()
            }
          
          Spacer()
          
          // MARK: - CARDS
          ZStack {
            ForEach(cardViews) { cardView in
              cardView
                .zIndex(self.isTopCard(cardView: cardView) ? 1 : 0)
                .overlay(
                  ZStack {
     
                    Text("PAS")
                      .modifier(SymbolModifier())
                      .opacity(self.dragState.translation.width < -self.dragAreaThreshold && self.isTopCard(cardView: cardView) ? 1.0 : 0.0)

                    Text("DOĞRU")
                      .modifier(SymbolModifier())
                      .opacity(self.dragState.translation.width > self.dragAreaThreshold && self.isTopCard(cardView: cardView) ? 1.0 : 0.0)
                  }
              )
                .offset(x: self.isTopCard(cardView: cardView) ?  self.dragState.translation.width : 0, y: self.isTopCard(cardView: cardView) ?  self.dragState.translation.height : 0)
                .scaleEffect(self.dragState.isDragging && self.isTopCard(cardView: cardView) ? 0.85 : 1.0)
                .rotationEffect(Angle(degrees: self.isTopCard(cardView: cardView) ? Double(self.dragState.translation.width / 12) : 0))
                .animation(.interpolatingSpring(stiffness: 120, damping: 120))
                .gesture(LongPressGesture(minimumDuration: 0.01)
                  .sequenced(before: DragGesture())
                  .updating(self.$dragState, body: { (value, state, transaction) in
                    switch value {
                    case .first(true):
                      state = .pressing
                    case .second(true, let drag):
                      state = .dragging(translation: drag?.translation ?? .zero)
                    default:
                      break
                    }
                  })
                  .onChanged({ (value) in
                    guard case .second(true, let drag?) = value else {
                      return
                    }
                    if drag.translation.width < -self.dragAreaThreshold {
                      self.cardRemovalTransition = .leadingBottom
                    }
                    
                    if drag.translation.width > self.dragAreaThreshold {
                      self.cardRemovalTransition = .trailingBottom
                    }
                  })
                  .onEnded({ (value) in
                    guard case .second(true, let drag?) = value else {
                      return
                    }
                    if drag.translation.width < -self.dragAreaThreshold{
      
                        if Taboo.passRight >= 0{
                           self.moveCards()
                            Taboo.passRight -= 1
                        }else{
                            playSound(sound: "pass-failed", type: "mp3")
                        }
                    }else if drag.translation.width > self.dragAreaThreshold {
                            game.incrementScore()
                            playSound(sound: "true-answer-sound", type: "mp3")
                            self.moveCards()
                        }
                  })
              ).transition(self.cardRemovalTransition)
            }
          }
          .padding(.horizontal)
          
          Spacer()
          

            HStack {
              Image(systemName: "forward.circle.fill")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(Color("navyBlue"))
              Spacer()
              
              Button(action: {
                self.haptics.notificationOccurred(.warning)
                playSound(sound: "taboo-sound", type: "mp3")
                  self.moveCards()
                game.taboo()
              }) {
                Text("TABU")
                  .font(.system(.subheadline, design: .rounded))
                  .fontWeight(.heavy)
                  .padding(.horizontal, 20)
                  .padding(.vertical, 12)
                  .accentColor(Color.red)
                  .background(
                    Capsule().stroke(Color.yellow, lineWidth: 2)
                  )
              }.buttonStyle(GrowingButton())
              
              Spacer()
              
              Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(Color("navyBlue"))
            }
            .padding()

        }
        .background(Color("softPink"))
        .sheet(isPresented: $showScore, onDismiss: {isShowing.toggle()}) {
            ScoreView(isShowing: $showScore)
        }
          }
        .blur(radius: !isReady || isQuitTapped ? 8.0 : 0, opaque: false)
              if !isReady{
                  VStack {
                      VStack(spacing: 16) {
                      Text("\(game.currentTeam.name) başlayacak, hazır mısın?")
                          .foregroundColor(Color("shinyPink"))
                          .font(.system(size: 24, weight: .bold, design: .rounded))
                          .padding()
                          .background(Color("shinyYellow"))
                          .cornerRadius(10)
                      Button(action: {
                          isReady.toggle()
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                      }){
                        Spacer()
                        Text("Hazır")
                          .font(.system(size: 24, weight: .bold, design: .rounded))
                        Spacer()
                      }
                      .padding()
                      .foregroundColor(Color("shinyYellow"))
                      .background(.pink)
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
              if isQuitTapped{
                  VStack {
                      VStack(spacing: 16) {
                      Text("Çıkmak istediğinden emin misin?")
                          .foregroundColor(Color("shinyPink"))
                          .font(.system(size: 24, weight: .bold, design: .rounded))
                          .padding()
                          .background(Color("shinyYellow"))
                          .cornerRadius(10)
                      Button(action: {
                          showScore.toggle()
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                      }){
                        Spacer()
                        Text("Evet, çıkıyorum")
                          .font(.system(size: 24, weight: .bold, design: .rounded))
                        Spacer()
                      }
                      .padding()
                      .foregroundColor(Color("shinyYellow"))
                      .background(.pink)
                      .cornerRadius(10)
                          Button(action: {
                              isReady.toggle()
                              isQuitTapped.toggle()
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                          }){
                            Spacer()
                            Text("Hayır, devam edeceğim")
                              .font(.system(size: 24, weight: .bold, design: .rounded))
                            Spacer()
                          }
                          .padding()
                          .foregroundColor(Color("shinyYellow"))
                          .background(.pink)
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
  }
}

struct GameView_Previews: PreviewProvider {
  static var previews: some View {
      GameView(isShowing: .constant(true))
  }
}



