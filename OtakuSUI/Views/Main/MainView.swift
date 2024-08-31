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
    
    @State private var searchText = ""
    var searchResults: [JSON] {
        if searchText.isEmpty {
            return vm.animeList
        } else {
            return vm.animeList.filter { $0["name"].stringValue.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        LoadingView(isLoading: $isLoading) {
            List {
                ForEach(searchResults.indices, id: \.self) { index in
                    NavigationLink(destination: {
                        InfoView(
                            animeUrl: searchResults[index]["link"].stringValue,
                            posterUrl: searchResults[index]["imageUrl"].stringValue, 
                            animeName: searchResults[index]["name"].stringValue
                        )
                    }, label: {
                        AnimeListRow(
                            imageURL: searchResults[index]["imageUrl"].stringValue,
                            name: searchResults[index]["name"].stringValue,
                            seriesCount: searchResults[index]["series"].stringValue
                        )
                    })
                    .onAppear {
                        if index == vm.animeList.count - 1 {
                            self.isLoading = true
                            vm.currentPage += 1
                            vm.fetchAnime(from: "anime/page-\(vm.currentPage)") {
                                self.isLoading = false
                            }
                        }
                    }
                }
            }
            .alert(isPresented: $vm.isCatchError, content: {
                Alert(title: Text("Ошибка соедения с интернетом"), message: Text("Нажмите на кнопку чтобы повторить запрос"), dismissButton: .cancel(Text("Повторить"), action: {
                    
                    self.isLoading = true
                    vm.fetchAnime(from: "anime/page-\(vm.currentPage)") {
                        self.isLoading = false
                    }
                }))
            })
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
                        SortView(sortList: vm.sortList)
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    .navigationTitle("Сортировка")
                    
                    NavigationLink {
                        FilterView(releaseYearsList: vm.releaseYearsList, genresList: vm.genreList, typesList: vm.typeList)
                    } label: {
                        Image(systemName: "checklist")
                    }
                    .navigationTitle("Фильтр")
                }
            }
        }
        .onAppear {
            vm.fetchAnime(from: "anime/page-\(vm.currentPage)") {
                self.isLoading = false
            }
        }
        .searchable(text: $searchText, prompt: "Введите текст для поиска")
    }
}


#Preview {
    NavigationView {
        MainView()
    }
    
}
