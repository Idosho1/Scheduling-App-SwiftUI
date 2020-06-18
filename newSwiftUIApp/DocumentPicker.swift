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
    
    @State private var wrongDocument = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        
        let i = UIButton()
        i.setImage(UIImage(named: "cat"), for: .normal)
        i.frame = CGRect(x: UIScreen.screenWidth/2 - 50, y: UIScreen.screenHeight/3 - 150, width: 100, height: 100)
        view.addSubview(i)
        
        let t = UILabel()
        t.adjustsFontSizeToFitWidth = true
        t.text = "NSHS Schedule App"
        t.frame = CGRect(x: UIScreen.screenWidth/2 - 150, y: UIScreen.screenHeight/3, width: 300, height: 50)
        t.textAlignment = .center
        t.font = UIFont(name: "Avenir", size: 28)!
        view.addSubview(t)
        
        
        let s = UIButton()
        s.setTitle("Import Schedule", for: .normal)
        s.frame = CGRect(x: UIScreen.screenWidth/2 - 150, y: UIScreen.screenHeight/2 - 25, width: 300, height: 50)
        s.addTarget(self, action: #selector(pick), for: .touchDown)
        s.titleLabel!.font = UIFont(name: "Avenir", size: 20)!
        view.addSubview(s)

            let center = UNUserNotificationCenter.current()

            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if granted {
                    print("Notifications Approved")
                } else {
                    print("Notifications Not Approved")
                }
            }
    }
    
    @objc func pick(sender: UIButton) {
        rwt.writeFile(writeString: "1", fileName: "semester");
        rwt.writeFile(writeString: "19", fileName: "hour")
        rwt.writeFile(writeString: "0", fileName: "min")
        pdfStruct.semester = 1
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
        
        let pdfAsText = (pdfD.string)!
        let textArray = splitStringIntoLines(pdfAsText)
        
        
        print(textArray[0].trimmingCharacters(in: .whitespaces))
        if textArray[0].trimmingCharacters(in: .whitespaces) == "Student Name:" {
        

        let v = ViewRouter()
        v.currentPage = "page2"
        let vc = UIHostingController(rootView: MotherView(viewRouter: v))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        pdfStruct = PDF(pdfD)
        pdfStruct.makeSchedule()
        self.view.isHidden = true
        
        } else {
            let alert = UIAlertController(title: "Wrong Document", message: "You selected the wrong file. Make sure to select the schedule file!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Try Again", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
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
