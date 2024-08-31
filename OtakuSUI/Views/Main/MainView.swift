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
                        if index == searchResults.count - 1 {
                            vm.currentPage += 1
                            sendRequest()
                        }
                    }
                }
            }
            .alert(isPresented: $vm.isCatchError, content: {
                Alert(title: Text("Ошибка соединения с интернетом"),
                      message: Text("Нажмите на кнопку, чтобы повторить запрос"),
                      dismissButton: .cancel(Text("Повторить"), action: {
                    sendRequest()
                }))
            })
            .listStyle(.plain)
            .navigationTitle("Главная")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: EmptyView()) {
                        Image(systemName: "star")
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    NavigationLink(destination: SortView(sortList: vm.sortList)) {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    .navigationTitle("Сортировка")
                    
                    NavigationLink(destination: FilterView(onFilterSelected: { genres, years in
                        vm.selectedGenres = genres
                        vm.selectedReleaseYears = years
                        
                        vm.animeList = []
                        vm.currentPage = 1
                        sendRequest()
                    }, releaseYearsList: vm.releaseYearsList, genresList: vm.genreList, typesList: vm.typeList, selectedGenres: $vm.selectedGenres, selectedReleaseYears:  $vm.selectedReleaseYears)) {
                        Image(systemName: "checklist")
                    }
                    .navigationTitle("Фильтр")
                }
            }
            .onAppear {
                sendRequest()
            }
        }
        .searchable(text: $searchText, prompt: "Введите текст для поиска")
    }
    
    private func sendRequest() {
        isLoading = true
        let genres = vm.selectedGenres.joined(separator: "-")
        let years = vm.selectedReleaseYears.joined(separator: "-and-")
        let str = [genres, years].filter { !$0.isEmpty }.joined(separator: "/")
        vm.fetchAnime(from: "anime/\(str)\(vm.selectedSort)/page-\(vm.currentPage)/") {
            self.isLoading = false
        }
    }
}

#Preview {
    NavigationView {
        MainView()
    }
}
