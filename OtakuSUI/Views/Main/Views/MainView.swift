//
//  MainView.swift
//  OtakuSUI
//
//  Created by itserviceimac on 29/08/24.
//

import SwiftUI
import SwiftyJSON


struct MainView: View {
    
    @ObservedObject var vm = AnimeListViewModel()
    @State private var isLoading = true
    
    var body: some View {
        LoadingView(isLoading: $isLoading) {
            List {
                ForEach(vm.animeList.indices, id: \.self) { index in
                    AnimeListRow(
                        imageURL: vm.animeList[index]["imageUrl"].stringValue,
                        name: vm.animeList[index]["name"].stringValue,
                        seriesCount: vm.animeList[index]["series"].stringValue
                    )
                    .onAppear {
                        if index == vm.animeList.count - 1 {
                            self.isLoading = true
                            vm.currentPage += 1
                            vm.fetchAnime(from: "/page-\(vm.currentPage)") {
                                self.isLoading = false
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Главная")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink {
                        EmptyView()
                    } label: {
                        Image(systemName: "star")
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    NavigationLink {
                        EmptyView()
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    
                    NavigationLink {
                        EmptyView()
                    } label: {
                        Image(systemName: "checklist")
                    }
                }
            }
        }
        .onAppear {
            vm.fetchAnime(from: "/page-\(vm.currentPage)") {
                self.isLoading = false
            }
        }
    }
}


#Preview {
    NavigationView {
        MainView()
    }
    
}
