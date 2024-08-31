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
    
    var body: some View {
        List {
            Section("Сортировка") {
                ForEach(0..<sortList.count, id: \.self) { index in
                    Text(sortList[index]["title"].stringValue)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Сортировка")
    }
    
}

#Preview {
    SortView(sortList: [JSON]())
}
