//
//  ColorPickerView.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 6/18/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//

import Foundation
import SwiftUI
import PDFKit
import Combine
import MobileCoreServices
import ColorPicker

struct ContentViewC: View {
    
    @ObservedObject var viewRouter: ViewRouter
    @State var color = UIColor.red
    
    let classList = pdfStruct.uniqueClassList
    let Class: Class
    
    var body: some View {

        ZStack {
            Color.init(color).edgesIgnoringSafeArea(.all).opacity(0.7)
        VStack {
            
            Text(Class.courseName).fontWeight(.heavy)
            Text("\(Class.block)  \(Class.semester)").fontWeight(.heavy)

            
            ColorPicker(color: $color, strokeWidth: 30)
                .frame(width: 200, height: 200, alignment: .center)
                .padding()
            
            Button(action: {classCount+=1;pdfStruct.classColors[self.Class.courseName] = self.color; self.color = UIColor.red; if classCount == self.classList.count {self.viewRouter.currentPage = "page4"; print(pdfStruct.classColors); pdfStruct.saveColors()} else { self.viewRouter.currentPage = "page3"}}) {
                Text("Next...").fontWeight(.heavy).padding()
            }
        }
    }
    }
}



