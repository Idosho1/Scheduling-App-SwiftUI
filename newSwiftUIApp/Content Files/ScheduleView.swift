//
//  ScheduleViews.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 1/8/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//

import SwiftUI
import UIKit


struct ScheduleView: View {
    
var body: some View {
    
    Group {
    if pdfStruct.getCurrentDay() != .Sat && pdfStruct.getCurrentDay() != .Sun {
        
     schoolView()
        
    }
    
    else {
    noSchoolView()
    }
    
}
}
}
