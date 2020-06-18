//
//  TestView.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 6/18/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//

import SwiftUI

struct TestView: View {
    @State var showingDetail = false
    
    var body: some View {
        
        VStack {
            NavigationView {
                List {
                    ForEach(pdfStruct.homework.reversed(), id: \.self) { hw in
                        Group {
                            if !hw.complete && hw.test {
                                AssignmentView(homework: hw)
                            }
                        }
                    }
                } .navigationBarTitle(Text("Tests"))
            }
            Button(action: {
                self.showingDetail.toggle()
            }) {
                Image(systemName: "plus")
            }.sheet(isPresented: $showingDetail) {
                AddTestView()
            } .padding(.bottom, 25)
        }.onAppear{pdfStruct.updateHW()
            for hw in pdfStruct.homework {
                print(hw)
            }
        }.onDisappear{pdfStruct.updateHW()}
        
        
    }
}

