//
//  SchoolView.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 6/18/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//

import SwiftUI

struct schoolView: View {
    
    @State private var contentOffset: CGPoint = .zero
    @State private var name: String = "chevron.down"
    @State private var isSemester2 = false
    
    var body: some View {
        
        
        
        ZStack {
        
            
            
        VStack {
        ScrollableView(self.$contentOffset, animationDuration: 0.5) {
            
            if !self.isSemester2 {
            
            VStack {
                
                
                ForEach(pdfStruct.schedule[pdfStruct.getCurrentDay()]!, id: \.self) { item in
                    ClassView(c: item).padding(.bottom, 5).padding(.horizontal,4)
                } // SEMESTER 1 / SEMESTER 2
                
    
            }
            
            } else {
                
                VStack {
                            
                            
                            ForEach(pdfStruct.schedule2[pdfStruct.getCurrentDay()]!, id: \.self) { item in
                                ClassView(c: item).padding(.bottom, 5).padding(.horizontal,4)
                            } // SEMESTER 1 / SEMESTER 2
                            
                
                        }
                
                
            }
            
        }.onAppear{self.contentOffset = CGPoint(x: 0, y: pdfStruct.getScrollValue());
            
            if pdfStruct.semester == 1 {self.isSemester2 = false}
            else {self.isSemester2 = true}
            
            
            }
            /*Button(action: {rwt.writeFile(writeString: "", fileName: "Save7")}) {
            Text("Restart")
            }.padding()*/
        }
            if self.contentOffset != CGPoint(x: 0, y: pdfStruct.getScrollValue()) {
            Button(action: {self.contentOffset = CGPoint(x: 0, y: pdfStruct.getScrollValue()); print("***")}) {

                Image(systemName: (Int(self.contentOffset.y) > pdfStruct.getScrollValue()) ? "chevron.up" : "chevron.down").resizable().frame(width: 40,height: 20).opacity(0.7).padding()
                
                }.offset(x: UIScreen.main.bounds.width/(-2.7), y: UIScreen.main.bounds.height/(2.7))
            }

            /*HStack {
                
            Toggle(isOn: $isSemester2){
                Text("")
            }
                if isSemester2 { Text("S2") }
                else { Text("S1")}
            }.offset(x: UIScreen.main.bounds.width/(-1.28), y: UIScreen.main.bounds.height/(-2.7))*/
            
            //Text("test")
            }.font(Font(UIFont(name: "Avenir", size: 18)!))
    }
    
}


struct noSchoolView: View {
    var body: some View {
        Text("No School Today!").bold()
    }
}
