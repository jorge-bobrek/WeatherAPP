//
//  Tabs.swift
//  UIUtils
//
//  Created by Jorge Bobrek on 31/03/23.
//

import SwiftUI

struct TabsView<Content: View>: View {
    @Binding var selectedTab: Int
    var tabs: [TabItem]
    @ViewBuilder var content: (Int) -> Content

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                ForEach(tabs.indices, id: \.self) { index in
                    content(index)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .opacity(selectedTab == index ? 1 : 0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack {
                Divider()
                HStack(spacing: 0) {
                    ForEach(tabs.indices, id: \.self) { index in
                        Button {
                            withAnimation(.bouncy(duration: 0.3, extraBounce: 0.2)) {
                                selectedTab = index
                            }
                        } label: {
                            VStack(spacing: 4) {
                                Image(systemName: tabs[index].icon)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(selectedTab == index ? .blue : .gray)
                                Text(tabs[index].title)
                                    .font(.caption)
                                    .foregroundColor(selectedTab == index ? .blue : .gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .background(Color(.secondarySystemBackground).edgesIgnoringSafeArea(.bottom))
            .ignoresSafeArea(.container)
        }
    }
}

struct TabItem {
    var title: String
    var icon: String
}

struct TabsView_Previews: PreviewProvider {
    @State static var selectedTab = 0

    static var previews: some View {
        TabsView(selectedTab: $selectedTab, tabs: [
            TabItem(title: "Locations", icon: "magnifyingglass"),
            TabItem(title: "Favorites", icon: "star.fill")
        ]) { index in
            switch index {
            case 0:
                Text("Locations Content")
                    .font(.largeTitle)
                    .padding()
            case 1:
                Text("Favorites Content")
                    .font(.largeTitle)
                    .padding()
            default:
                EmptyView()
            }
        }
    }
}
