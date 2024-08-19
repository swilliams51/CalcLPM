//
//  DepreciationTableView.swift
//  CFLTax
//
//  Created by Steven Williams on 8/19/24.
//

import SwiftUI

struct DepreciationTableView: View {
    @Bindable var myDepreciationTable: DepreciationIncomes
    @Binding var path: [Int]
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    DepreciationTableView(myDepreciationTable: DepreciationIncomes(), path: .constant([Int]()))
}
