//
//  WelcomeView.swift
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

struct ContentViewB: View {

@ObservedObject var viewRouter: ViewRouter

var body: some View {
    VStack {
    Text("Welcome \(pdfStruct.returnName())!").fontWeight(.heavy)
        Button(action: {self.viewRouter.currentPage = "page3"; print(pdfStruct.classList)}) {
            Text("Continue").fontWeight(.heavy).frame(width: 300, height: 20, alignment: .center).padding()
        }
    }
    }
}
