//
//  ImportView.swift
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

var rwt = ReadWriteText()
var pdfD = PDFDocument()
var pdfStruct = PDF()
var classCount = 0

struct ContentViewA: View {
    
    @ObservedObject var viewRouter: ViewRouter

    var body: some View {
        if rwt.readFile(fileName: "Save15") != "" {
            print(rwt.readFile(fileName: "Save15"))
            self.viewRouter.currentPage = "page4"
        } else {return ViewControllerWrapper()}
        return ViewControllerWrapper()
    }
}
