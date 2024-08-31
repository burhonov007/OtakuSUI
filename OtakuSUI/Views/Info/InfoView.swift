//
//  InfoView.swift
//  OtakuSUI
//
//  Created by itserviceimac on 30/08/24.
//

import SwiftUI

struct InfoView: View {

    @State var animeUrl: String
    @State var posterUrl: String
    @State var animeName: String
    @State private var isLoading = false
    @ObservedObject var vm = InfoViewModel()
    
    var body: some View {
        LoadingView(isLoading: $isLoading) {
            ScrollView(.vertical) {
                VStack {
                    ImageLoaderView(urlString: posterUrl)
                        .frame(width: 200, height: 200, alignment: .center)
                        .cornerRadius(15)
                    
                    Spacer()
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(alignment: .bottom) {
                            Text("Название:")
                                .padding(.leading, 10)
                            Text(vm.info["title"].stringValue)
                                .font(.title2)
                        }
                        
                        Spacer()
                        HStack(alignment: .firstTextBaseline) {
                            Text("Жанры:")
                                .padding(.leading, 10)
                            Text(vm.info["genres"].stringValue)
                                .font(.subheadline)
                                .lineLimit(2)
                        }
                        
                        Spacer()
                        HStack(alignment: .firstTextBaseline) {
                            Text("Рейтинг:")
                                .padding(.leading, 10)
                            Text(vm.info["rating"].stringValue)
                                .font(.subheadline)
                                .lineLimit(2)
                        }
                        
                        Spacer()
                        HStack(alignment: .firstTextBaseline) {
                            Text("Возрастной рейтинг:")
                                .padding(.leading, 10)
                            Text(vm.info["ageLimit"].stringValue)
                                .font(.subheadline)
                                .lineLimit(2)
                        }
                        
                        Spacer()
                        HStack(alignment: .firstTextBaseline) {
                            Text("Годы выпуска:")
                                .padding(.leading, 10)
                            Text(vm.info["releaseYears"].stringValue)
                                .font(.subheadline)
                                .lineLimit(2)
                        }
                        
                        Spacer()
                        
                        Button("В избранное") {
                            
                        }
                        .foregroundColor(.primary)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.yellow, lineWidth: 2)
                        }
                        
                        Spacer()
                        
                        NavigationLink {
                            SeriesView(htmlString: vm.htmlString, animeName: animeName)
                        } label: {
                            Text("Смотреть")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.green)
                            .cornerRadius(5)
                        }

                        
                        
                    }
                    .padding()
                }
                .padding()
            }
            .onAppear {
                vm.fetchInfo(from: animeUrl) {
                    self.isLoading = false
                }
            }
            .alert(isPresented: $vm.isCatchError, content: {
                Alert(title: Text("Ошибка соедения с интернетом"), message: Text("Нажмите на кнопку чтобы повторить запрос"), dismissButton: .cancel(Text("Повторить"), action: {
                    
                    self.isLoading = true
                    vm.fetchInfo(from: animeUrl) {
                        self.isLoading = false
                    }
                }))
            })
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(animeName)
    }
}

#Preview {
    InfoView(animeUrl: "asd", posterUrl: "https://dummyjson.com/image/150", animeName: "asd")
}
