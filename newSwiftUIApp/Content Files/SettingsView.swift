//
//  SettingsView.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 6/18/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//

import SwiftUI


struct Experimental: View {
    //@ObservedObject var viewRouter: ViewRouter
    @State var isSemester2 = false
    @State var notifications = false
    @State var date = Date()
    
    @ObservedObject var viewRouter: ViewRouter
    
    @State private var isDisplayed = false

    @State private var showingAlertColors = false
    @State private var showingAlertReset = false
    
    let dateFormatterHour = DateFormatter()
    let dateFormatterMinute = DateFormatter()
    
    let dateFormatter = DateFormatter()
    
    
    private var dateProxy:Binding<Date> {
        Binding<Date>(get: {self.date }, set: {
            self.date = $0
            self.updateDate()
        })
    }
    
    init(viewRouter: ViewRouter) {
        self.viewRouter = viewRouter
        dateFormatterHour.dateFormat = "HH"
        dateFormatterMinute.dateFormat = "mm"
        dateFormatter.dateFormat = "HH:mm"
        //UISwitch.appearance().onTintColor = UIColor.cyan
    }
    
    var body: some View {
        NavigationView {
            Form {
                
                
                Section(header: Text("Classes").padding(.top, 20)) {
                // CLASSES START
                HStack {
                    Text(isSemester2 ? "Semester 2" : "Semester 1")
                    Spacer()
                    Toggle("", isOn: $isSemester2)
                        .onReceive([self.isSemester2].publisher.first()) { (value) in
                            self.updateSemester()
                    }.labelsHidden()
                }
                // CLASSES END
                }
                
                Section(header: Text("Notifications")) {
                    // NOTIFICATIONS START
                    HStack {
                        Text("Notifications")
                        Spacer()
                        Toggle("", isOn: $notifications)
                            .onReceive([self.notifications].publisher.first()) { (value) in
                            self.updateNotifications()
                        }.labelsHidden().onTapGesture {
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                            
                            
                            
                            // 1
                            var dateComponents = DateComponents()
                            dateComponents.hour = pdfStruct.hour // Hour
                            dateComponents.minute = pdfStruct.minute // Minute
                            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

                            // 2
                            let content = UNMutableNotificationContent()
                            content.title = "Homework Reminder"
                            
                            if pdfStruct.numberHWDueTomorrow() == 0 {
                                content.body = "You are done with all your homework for tomorrow!"
                            } else if pdfStruct.numberHWDueTomorrow() == 1 {
                                content.body = "You have 1 homework assignment due tomorrow!"
                            } else {
                            content.body = "You have " + String(pdfStruct.numberHWDueTomorrow()) + " homework assignments due tomorrow!"
                            }
                            let randomIdentifier = UUID().uuidString
                            let request = UNNotificationRequest(identifier: randomIdentifier, content: content, trigger: trigger)

                            if pdfStruct.numberTestsDueTomorrow() != 0 {
                                let content2 = UNMutableNotificationContent()
                                content2.title = "Tests Reminder"
                                
                                if pdfStruct.numberTestsDueTomorrow() == 1 {
                                    content2.body = "You have 1 test tomorrow!"
                                } else {
                                    content2.body = "You have " + String(pdfStruct.numberTestsDueTomorrow()) + " tests tomorrow!"
                                }
                                
                                let randomIdentifier2 = UUID().uuidString
                                let request2 = UNNotificationRequest(identifier: randomIdentifier2, content: content2, trigger: trigger)
                                UNUserNotificationCenter.current().add(request2) { error in
                                  if error != nil {
                                    print("something went wrong")
                                  }
                                }
                            }
                            
                            
                            
                            // 3
                            UNUserNotificationCenter.current().add(request) { error in
                              if error != nil {
                                print("something went wrong")
                              }
                            }
                            print("updateNotification")
                        }
                    }
                    
                        
                        DatePicker(selection: dateProxy, displayedComponents: .hourAndMinute) {
                            if notifications {
                            Text("Notification Time")
                            } else {
                                Text("Notification Time").foregroundColor(.gray)
                            }
                            
                            
                            
                        }.disabled(!notifications)
                    
                    // NOTIFICATIONS END
                }
                
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Software Version")
                        Spacer()
                        Text("1.0.0").foregroundColor(.gray)
                    }
                    /*Button(action: {}) {
                        Text("Credits")
                    }*/
                    NavigationLink(destination: CreditsView()) {
                        Text("Credits")
                    }
                }
                
                
                
                /*Section {
                // RESET START
                
                    Button(action: {self.showingAlertColors = true}) {
                        Text("Reset Colors")
                    }.alert(isPresented:$showingAlertColors) {
                        Alert(title: Text("Are you sure you want to reset the colors?"), message: Text("You cannot undo this"), primaryButton: .destructive(Text("Reset")) {
                            
                            self.viewRouter.currentPage = "page3"
                            
                        }, secondaryButton: .cancel())
                    }
                }*/ // RESET COLORS: NOT CURRENTLY WORKING
                
                Section {
                    Button(action: {self.showingAlertReset = true}) {
                        Text("Reset Schedule")
                    }.alert(isPresented:$showingAlertReset) {
                        Alert(title: Text("Are you sure you want to reset the schedule?"), message: Text("You cannot undo this"), primaryButton: .destructive(Text("Reset")) {
                            pdfStruct.semester = 1
                            rwt.writeFile(writeString: "", fileName: "Save15"); rwt.writeFile(writeString: "", fileName: "SaveColors13"); rwt.writeFile(writeString: "", fileName: "saveHW15"); rwt.writeFile(writeString: "1", fileName: "semester"); rwt.writeFile(writeString: "", fileName: "notification"); rwt.writeFile(writeString: "19", fileName: "hour"); rwt.writeFile(writeString: "0", fileName: "min"); self.viewRouter.currentPage = "page1"; pdfStruct.semester = 1; rwt.writeFile(writeString: "1", fileName: "semester");
                        }, secondaryButton: .cancel())
                    }
                }
                
                // RESET END
                
                
                
                
            }.navigationBarTitle("Settings")
            
            
        }.onAppear {
            if pdfStruct.semester == 1 { self.isSemester2 = false }
            else { self.isSemester2 = true }
            
            self.notifications = pdfStruct.notifications
            
            let hourString = rwt.readFile(fileName: "hour")
            let minString = rwt.readFile(fileName: "min")
            
            let str = hourString + ":" + minString
            
            let date = self.dateFormatter.date(from: str)!
            
            self.dateProxy.wrappedValue = date
        }
}
    
    func updateSemester() {
        if !self.isSemester2 { rwt.writeFile(writeString: "1", fileName: "semester") }
        else { rwt.writeFile(writeString: "2", fileName: "semester") }
        pdfStruct.restoreSemester()
    }
    
    
    func updateNotifications() {
        rwt.writeFile(writeString: String(self.notifications), fileName: "notification")
        pdfStruct.restoreNotifications()
    }
    
    func updateDate() {
        let hour = dateFormatterHour.string(from: dateProxy.wrappedValue)
        let min = dateFormatterMinute.string(from: dateProxy.wrappedValue)
        
        rwt.writeFile(writeString: hour, fileName: "hour")
        rwt.writeFile(writeString: min, fileName: "min")
        
        pdfStruct.restoreDate()

        pdfStruct.updateNotifications()
        print("update notification")
        
        
    }
    
}
