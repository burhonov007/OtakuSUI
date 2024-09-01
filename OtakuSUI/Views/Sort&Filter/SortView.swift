//
//  SortView.swift
//  OtakuSUI
//
//  Created by itserviceimac on 31/08/24.
//

import SwiftUI
import SwiftyJSON


struct SortView: View {
    
    @State var sortList: [JSON]
    @Binding var selectedSort: String
    @Environment(\.presentationMode) var presentationMode
    var onSortSelected: (String) -> Void
    
    var body: some View {
        List {
            Section("Сортировка") {
                ForEach(0..<sortList.count, id: \.self) { index in
                    Button(action: {
                        onSortSelected(sortList[index]["link"].stringValue)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Text(sortList[index]["title"].stringValue)
                                .foregroundColor(selectedSort == sortList[index]["link"].stringValue ? .blue : .primary)
                            Spacer()
                            if selectedSort == sortList[index]["link"].stringValue {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Сортировка")
    }
    
}

//#Preview {
//    SortView(sortList: [JSON](), selectedSort: .constant(""))
//}
