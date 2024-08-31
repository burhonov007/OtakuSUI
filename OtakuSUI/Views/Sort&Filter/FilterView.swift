//
//  FilterView.swift
//  OtakuSUI
//
//  Created by itserviceimac on 31/08/24.
//

import SwiftUI
import SwiftyJSON


struct FilterView: View {
    
    var onFilterSelected: (Set<String>, Set<String>) -> Void
    
    @State var releaseYearsList: [JSON]
    @State var genresList: [JSON]
    @State var typesList: [JSON]
    
    @Binding var selectedGenres: Set<String>
    @Binding var selectedReleaseYears: Set<String>
    
    var body: some View {
        List {
            
            Section("Жанр") {
                ForEach(genresList.indices, id: \.self) { index in
                    Button(action: {
                        toggleSelection(for: genresList[index], in: &selectedGenres)
                    }) {
                        HStack {
                            Text(genresList[index]["title"].stringValue)
                                .foregroundColor(selectedGenres.contains(genresList[index]["link"].stringValue) ? .blue : .primary)
                            Spacer()
                            if selectedGenres.contains(genresList[index]["link"].stringValue) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            
            Section("Год выпуска") {
                ForEach(releaseYearsList.indices, id: \.self) { index in
                    Button(action: {
                        toggleSelection(for: releaseYearsList[index], in: &selectedReleaseYears)
                    }) {
                        HStack {
                            Text(releaseYearsList[index]["title"].stringValue)
                                .foregroundColor(selectedReleaseYears.contains(releaseYearsList[index]["link"].stringValue) ? .blue : .primary)
                            Spacer()
                            if selectedReleaseYears.contains(releaseYearsList[index]["link"].stringValue) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            
            Section("Тип") {
                ForEach(typesList.indices, id: \.self) { index in
                    Button(action: {
                        toggleSelection(for: typesList[index], in: &selectedGenres)
                    }) {
                        HStack {
                            Text(typesList[index]["title"].stringValue)
                                .foregroundColor(selectedGenres.contains(typesList[index]["link"].stringValue) ? .blue : .primary)
                            Spacer()
                            if selectedGenres.contains(typesList[index]["link"].stringValue) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Фильтр")
        .onDisappear {
            onFilterSelected(selectedGenres, selectedReleaseYears)
        }
        .onAppear {
            print(selectedGenres)
            print(selectedReleaseYears)
        }
        .toolbar {
            Button {
                selectedGenres = []
                selectedReleaseYears = []
            } label: {
                Image(systemName: "arrow.clockwise")
            }

        }
    }
    
    private func toggleSelection(for item: JSON, in set: inout Set<String>) {
        if set.contains(item["link"].stringValue) {
            set.remove(item["link"].stringValue)
        } else {
            set.insert(item["link"].stringValue)
        }
        print(set)
    }
}

//#Preview {
//    FilterView(onFilterSelected: { _,_  in }, releaseYearsList: [], genresList: [], typesList: [])
//}
