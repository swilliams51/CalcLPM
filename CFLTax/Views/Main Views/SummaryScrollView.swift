//
//  SummaryScrollView.swift
//  CFLTax
//
//  Created by Steven Williams on 9/26/24.
//

import SwiftUI

struct SummaryScrollView: View {
    
    let columns = [GridItem(.fixed(210)), GridItem(.fixed(210))]
    
    var body: some View {
        Form {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 90) {
                   Text("MISF Yield")
                   Text("4.78%")
                }
                    
                    
                    
                }
                
            }
        }

    }
   


#Preview {
    SummaryScrollView()
}


