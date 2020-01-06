//
//  MotherView.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 1/3/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//
import Foundation
import SwiftUI
import Combine
import UIKit

struct MotherView: View {
    
    @ObservedObject var viewRouter: ViewRouter
    
    func filePicked(_ url: URL) {
        print("Filename: \(url)")
    }
    
    var body: some View {
        VStack {
            if viewRouter.currentPage == "page1" {
                ContentViewA(viewRouter: viewRouter)
            } else if viewRouter.currentPage == "page2" {
                ContentViewB(viewRouter: viewRouter)
            } else if viewRouter.currentPage == "page3" {
                ContentViewC(viewRouter: viewRouter, Class: pdfStruct.uniqueClassList[classCount])
            } else if viewRouter.currentPage == "page4" {
                ContentViewD(viewRouter: viewRouter)
            }
        }
    }
}

struct MotherView_Previews : PreviewProvider {
    static var previews: some View {
        MotherView(viewRouter: ViewRouter())
    }
}
