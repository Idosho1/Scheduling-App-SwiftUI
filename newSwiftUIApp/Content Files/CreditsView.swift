//
//  CreditsView.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 6/18/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//

import SwiftUI

struct CreditsView: View {

    
var body: some View {
    VStack {
        Spacer()
        Image("cat").resizable().frame(width: 150, height: 150).padding()
        Spacer()
            Text("Created by Ido Shoshani").padding().font(Font(UIFont(name: "Avenir", size: 24)!))
            Spacer()
        
            Text("Logo by Zhitong Liu").padding().font(Font(UIFont(name: "Avenir", size: 12)!))
            Text("Hendrik Ulbrich © 2020 - Color Wheel").padding().padding(.bottom,40).font(Font(UIFont(name: "Avenir", size: 12)!))
        
    }
    }
    
}
