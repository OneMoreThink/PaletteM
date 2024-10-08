//
//  AddButton.swift
//  PaletteM
//
//  Created by 이종선 on 9/16/24.
//

import SwiftUI

/// CustomButton
struct FloatingButton<Label: View>: View {
    var buttonSize: CGFloat
    /// Actions
    var actions: [FloatingAction]
    var label: (Bool) -> Label
    
    init(buttonSize: CGFloat = 60, @FloationActionBuilder actions: @escaping () -> [FloatingAction], @ViewBuilder label: @escaping (Bool) -> Label) {
        self.buttonSize = buttonSize
        self.actions = actions()
        self.label = label
    }
    
    @State private var isExpanded: Bool = false
    @State private var dragLocation: CGPoint = .zero
    @State private var selectedAction: FloatingAction?
    @GestureState private var isDragging: Bool = false
    
    var body: some View {
        Button{
            isExpanded.toggle()
        }label: {
            label(isExpanded)
                .frame(width: buttonSize, height: buttonSize)
                .contentShape(.rect)
        }
        .buttonStyle(NoAnimationButtonStyle())
        .gesture(LongPressGesture(minimumDuration: 0.3)
            .onEnded{ _ in
                isExpanded = true
            }.sequenced(before: DragGesture().updating($isDragging, body: { _, out, _ in
                    out = true
                }).onChanged{ value in
                    guard isExpanded else { return }
                    dragLocation = value.location
                }).onEnded({ _ in
                    Task{
                        if let selectedAction {
                            isExpanded = false
                            selectedAction.action()
                        }
                        selectedAction = nil
                        dragLocation = .zero
                    }
                })
        )
        .background{
            ZStack{
                ForEach(actions) { action in
                    
                    ActionView(action)
                }
            }
            .frame(width: buttonSize, height: buttonSize)
        }
        .coordinateSpace(name: "FLOATING VIEW")
        .animation(.snappy(duration: 0.4, extraBounce: 0), value: isExpanded )
    }
    
    @ViewBuilder
    func ActionView(_ action: FloatingAction) -> some View {
        
        Button(action: {
            action.action()
            isExpanded = false
            
        }, label: {
            Image(systemName: action.symbol)
                .font(action.font)
                .foregroundColor(action.tint)
                .frame(width: buttonSize, height: buttonSize)
                .background(action.background, in: .circle)
                .padding()
                .contentShape(.circle)
                .shadow(color: .white.opacity(0.6), radius: 1)
                .shadow(color: .white.opacity(0.8), radius: 20)
               
        })
        .buttonStyle(PressableButtonStyle())
        .disabled(!isExpanded)
        .animation(.snappy(duration: 0.3, extraBounce: 0)) { content in
            content
                .scaleEffect(selectedAction?.id == action.id ? 1.15 :1 )
            
        }
        .background {
            GeometryReader{
                let rect = $0.frame(in: .named("FLOATING VIEW"))
                Color.clear
                    .onChange(of: dragLocation) { oldValue, newValue in
                        if isExpanded && isDragging {
                            /// Checking if the drag location is inside any action's rect
                            if rect.contains(newValue){
                                /// User is Pressing on this Action
                                selectedAction = action
                            } else {
                                /// Checking if it's gone out of the rect
                                if selectedAction?.id == action.id && !rect.contains(newValue){
                                    selectedAction = nil
                                }
                            }
                        }
                    }
            }
        }
        .rotationEffect(.init(degrees: progress(action) * -180))
        .offset(x: isExpanded ? -offset / 2 : 0 )
        .rotationEffect(.init(degrees: progress(action) * 180))
        
            
    }
    
    private var offset: CGFloat {
        let buttonSize = buttonSize - 10
        return Double(actions.count) * (actions.count == 1 ? buttonSize * 2 : (actions.count == 2 ? buttonSize * 1.25 : buttonSize))
    }
    
    private func progress(_ action: FloatingAction) -> CGFloat {
        let index = CGFloat(actions.firstIndex(where: {$0.id == action.id}) ?? 0)
        return actions.count == 1 ? 1 : (index / CGFloat(actions.count - 1))
    }
}

fileprivate struct NoAnimationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

fileprivate struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.snappy(duration: 0.3), value: configuration.isPressed)
    }
}

struct FloatingAction: Identifiable {
    private(set) var id: UUID = .init()
    var symbol: String
    var font: Font = .title
    var tint: Color = .softBeige
    var background: Color = .black
    var action: () -> ()
}

/// Swift's result builders allow you to construct a result using 'build blocks' lined up after each other, This is a very basic example of the usage of result builders, Check out about result builders for more complex usages
/// SwiftUI View like Builder to get array of actions using ResultBuilder
@resultBuilder
struct FloationActionBuilder {
    static func buildBlock( _ components: FloatingAction...) -> [FloatingAction] {
        components.compactMap({$0})
    }
}

#Preview {
    ContentView()
}
