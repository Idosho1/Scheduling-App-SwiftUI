//
//  DocumentPicker.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 1/7/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import Combine
import MobileCoreServices
import PDFKit



class ViewController: UIViewController, UIDocumentPickerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let s = UIButton()
        s.setTitle("Import Schedule", for: .normal)
        s.frame = CGRect(x: 100, y: 100, width: 300, height: 50)
        s.addTarget(self, action: #selector(pick), for: .touchDown)
        view.addSubview(s)
    }
    
    @objc func pick(sender: UIButton) {
        let importMenu = UIDocumentPickerViewController(documentTypes: [(kUTTypePDF as String)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.show(importMenu, sender: nil)
    }

    
   
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        for url in urls {
            let p = PDFDocument(url: url)!
            print(p.string!)
            pdfD = p
        }
        //WORK HERE

        let v = ViewRouter()
        v.currentPage = "page2"
        let vc = UIHostingController(rootView: MotherView(viewRouter: v))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        pdfStruct = PDF(pdfD)
        pdfStruct.makeSchedule()
        self.view.isHidden = true
        
        
    }
    
}

struct ViewControllerWrapper: UIViewControllerRepresentable {

    typealias UIViewControllerType = ViewController


    func makeUIViewController(context: UIViewControllerRepresentableContext<ViewControllerWrapper>) -> ViewControllerWrapper.UIViewControllerType {
        //print("making")
        return ViewController()
    }

    func updateUIViewController(_ uiViewController: ViewControllerWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<ViewControllerWrapper>) {
        //print("updating")
    }
}
