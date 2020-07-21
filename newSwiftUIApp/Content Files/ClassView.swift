//
//  ClassView.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 6/18/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//

import SwiftUI

struct ClassView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext

    
    @State var c: Class
    @State var showingDetail = false
    var body: some View {
        
        VStack {
            if c.block == "adv" {
                Spacer()
                Text(c.courseName + " - " + c.block).bold().padding()
                Spacer()
            }
                
            else if c.block[0].lowercased() == "j" {
                Spacer()
                Text(c.courseName + " - " + c.block).bold().padding()
                Text(c.timeStart + " - " + c.timeEnd).bold().padding();
                Text(c.roomNumber).bold().padding().frame(width: 400);
                if pdfStruct.currentBlock() == self.c.block {
                Image(systemName: "star").padding(.bottom).padding(.leading, 325)
                }
                Spacer()
            }
            
            else {
            
                Spacer()
                
                Text(c.courseName + " - " + c.block).bold().padding();
                Text(c.timeStart + " - " + c.timeEnd).bold().padding();
                Text(c.roomNumber).bold().padding().frame(width: 400);
                
                Spacer()
                
                if pdfStruct.currentBlock() == self.c.block {
                Image(systemName: "star").padding(.bottom).padding(.leading, 325)
                }
                
                Button(action: {self.showingDetail.toggle()}) {
                    Image(systemName: "plus.circle").resizable()
                    .foregroundColor(.white).frame(width: 22, height: 22)
                    }.padding(.bottom, 45).padding(.leading, 325).sheet(isPresented: $showingDetail) {
                        AddHomeworkView(courseName: self.c.courseName).environment(\.managedObjectContext, self.managedObjectContext)

                    }
                
                
                
            }
            
            
        }.frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: CGFloat(7 * c.getLength()))
        .background(Color.init(pdfStruct.classColors[c.courseName]!))//.edgesIgnoringSafeArea(.all)
        //.padding(.vertical, 2.5)
        //.padding(.horizontal, 2)
        .cornerRadius(15)
        
        
    }
    
}
