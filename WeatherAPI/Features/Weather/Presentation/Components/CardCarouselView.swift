//
//  CardCarouselView.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 30/01/25.
//

import SwiftUI

struct CardCarouselView<T: Hashable, Content: View>: View {
    @State private var snappedItem = 0.0
    @State private var draggingItem = 0.0
    @State var activeIndex: Int = 0
    let items: [T]
    let content: (T) -> Content
    
    init(items: [T], content: @escaping (T) -> Content) {
        self.items = items
        self.content = content
    }
    
    var body: some View {
        ZStack {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                ZStack {
                    content(item)
                }
                .padding()
                .scaleEffect(1.0 - abs(distance(index)) * 0.2)
                .opacity(1.0 - abs(distance(index)) * 0.3)
                .offset(x: myXOffset(index), y: 0)
                .zIndex(1.0 - abs(distance(index)) * 0.1)
            }
        }
        .gesture(getDragGesture())
    }
    
    private func getDragGesture() -> some Gesture {
        DragGesture()
            .onChanged { value in
                draggingItem = snappedItem - value.translation.width / 100
            }
            .onEnded { value in
                withAnimation {
                    draggingItem = snappedItem - value.predictedEndTranslation.width / 100
                    draggingItem = round(draggingItem).remainder(dividingBy: Double(items.count))
                    snappedItem = draggingItem
                    
                    self.activeIndex = items.count + Int(draggingItem)
                    if self.activeIndex > items.count || Int(draggingItem) >= 0 {
                        self.activeIndex = Int(draggingItem)
                    }
                }
            }
    }
    
    private func distance(_ item: Int) -> Double {
        return (draggingItem - Double(item)).remainder(dividingBy: Double(items.count))
    }
    
    private func myXOffset(_ item: Int) -> Double {
        let angle = Double.pi * 2 / Double(items.count) * distance(item)
        return -sin(angle) * 200
    }
}
