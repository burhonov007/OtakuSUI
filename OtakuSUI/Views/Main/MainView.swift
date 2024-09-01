//
//  MainView.swift
//  OtakuSUI
//
//  Created by itserviceimac on 29/08/24.
//
import SwiftUI
import SwiftyJSON

struct MainView: View {
    
    init() {
        sendRequest()
    }
    
    @ObservedObject var vm = AnimeListViewModel()
    @State private var isLoading = false
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
                    NavigationLink(destination: SortView(sortList: vm.sortList, selectedSort: $vm.selectedSort, onSortSelected: { str in
                        vm.selectedSort = str
                        sendRequest(cleanList: true)
                    })) {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    .navigationTitle("Сортировка")
                    
                    NavigationLink(destination: FilterView(onFilterSelected: { genres, years in
                        vm.selectedGenres = genres
                        vm.selectedReleaseYears = years
                        
                        sendRequest(cleanList: true)
                    }, releaseYearsList: vm.releaseYearsList, genresList: vm.genreList, typesList: vm.typeList, selectedGenres: $vm.selectedGenres, selectedReleaseYears:  $vm.selectedReleaseYears)) {
                        Image(systemName: "checklist")
                    }
                    .navigationTitle("Фильтр")
                }
            }
        }
        .searchable(text: $searchText, prompt: "Введите текст для поиска")
    }
    
    private func sendRequest(cleanList: Bool = false) {
        if cleanList {
            vm.currentPage = 1
            vm.animeList = []
        }
        let genres = vm.selectedGenres.joined(separator: "-")
        let years = vm.selectedReleaseYears.joined(separator: "-and-")
        let str = [genres, years].filter { !$0.isEmpty }.joined(separator: "/")
        isLoading = true
        vm.fetchAnime(from: "anime/\(str)/\(vm.selectedSort)/page-\(vm.currentPage)/") {
            DispatchQueue.main.async {
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
