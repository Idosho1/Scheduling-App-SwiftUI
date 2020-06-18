//
//  ScheduleViews.swift
//  newSwiftUIApp
//
//  Created by Ido Shoshani on 1/8/20.
//  Copyright © 2020 Ido Shoshani. All rights reserved.
//

import SwiftUI
import UIKit

struct ScrollableView<Content: View>: UIViewControllerRepresentable {

    // MARK: - Type
    typealias UIViewControllerType = UIScrollViewController<Content>
    
    // MARK: - Properties
    var offset: Binding<CGPoint>
    var animationDuration: TimeInterval
    var content: () -> Content
    var showsScrollIndicator: Bool
    var axis: Axis
    
    // MARK: - Init
    init(_ offset: Binding<CGPoint>, animationDuration: TimeInterval, showsScrollIndicator: Bool = false, axis: Axis = .vertical, @ViewBuilder content: @escaping () -> Content) {
        self.offset               = offset
        self.animationDuration    = animationDuration
        self.content              = content
        self.showsScrollIndicator = showsScrollIndicator
        self.axis                 = axis
    }
    
    // MARK: - Updates
    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> UIViewControllerType {

        let scrollViewController                                       = UIScrollViewController(rootView: self.content(), offset: self.offset, axis: self.axis)
        scrollViewController.scrollView.showsVerticalScrollIndicator   = self.showsScrollIndicator
        scrollViewController.scrollView.showsHorizontalScrollIndicator = self.showsScrollIndicator

        return scrollViewController
    }
    
    func updateUIViewController(_ viewController: UIViewControllerType, context: UIViewControllerRepresentableContext<Self>) {
        viewController.updateContent(self.content)
                
        let duration: TimeInterval = self.duration(viewController)
        guard duration != .zero else {
            viewController.scrollView.contentOffset = self.offset.wrappedValue
            return
        }
    
        UIView.animate(withDuration: duration, delay: 0, options: .allowUserInteraction, animations: {
            viewController.scrollView.contentOffset = self.offset.wrappedValue
        }, completion: nil)
    }
    
    //Calculate animation speed
    private func duration(_ viewController: UIViewControllerType) -> TimeInterval {
        
        var diff: CGFloat = 0
        
        switch axis {
            case .horizontal:
                diff = abs(viewController.scrollView.contentOffset.x - self.offset.wrappedValue.x)
            default:
                diff = abs(viewController.scrollView.contentOffset.y - self.offset.wrappedValue.y)
        }
        
        if diff == 0 {
            return .zero
        }
        
        let percentageMoved = diff / UIScreen.main.bounds.height
        
        return self.animationDuration * min(max(TimeInterval(percentageMoved), 0.25), 1)
    }
}

final class UIScrollViewController<Content: View> : UIViewController, UIScrollViewDelegate, ObservableObject {

    // MARK: - Properties
    var offset: Binding<CGPoint>
    let hostingController: UIHostingController<Content>
    private let axis: Axis
    lazy var scrollView: UIScrollView = {
        
        let scrollView                                       = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate                                  = self
        scrollView.backgroundColor                           = .clear
        
        return scrollView
    }()

    // MARK: - Init
    init(rootView: Content, offset: Binding<CGPoint>, axis: Axis) {
        self.offset                                 = offset
        self.hostingController                      = UIHostingController<Content>(rootView: rootView)
        self.hostingController.view.backgroundColor = .clear
        self.axis                                   = axis
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Update
    func updateContent(_ content: () -> Content) {
        
        self.hostingController.rootView = content()
        self.scrollView.addSubview(self.hostingController.view)
        
        var contentSize: CGSize = self.hostingController.view.intrinsicContentSize
        
        switch axis {
            case .vertical:
                contentSize.width = self.scrollView.frame.width
            case .horizontal:
                contentSize.height = self.scrollView.frame.height
        }
        
        self.hostingController.view.frame.size = contentSize
        self.scrollView.contentSize            = contentSize
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.scrollView)
        self.createConstraints()
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.offset.wrappedValue = scrollView.contentOffset
    }
    
    // MARK: - Constraints
    fileprivate func createConstraints() {
        
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}



struct ContentViewD: View {
@ObservedObject var viewRouter: ViewRouter
@State private var selection = 1
    
var body: some View {
    
    TabView(selection:$selection) {
        
        TestView()
        
            .tabItem {
                VStack {
                    Image(systemName: "doc.on.doc")
                    Text("Tests")
                }
        }.tag(2)
        
        
        ScheduleView()
        
        .tabItem {
            VStack {
                Image(systemName: "clock")
                Text("Schedule")
                }
        }.tag(1)
        
        HomeworkView()
        
        .tabItem {
            VStack {
                Image(systemName: "pencil")
                Text("Homework")
                }
        }.tag(3)
            
        Experimental(viewRouter: viewRouter)
        
            .tabItem {
                VStack {
                Image(systemName: "gear")
                Text("Settings")
                }
        }.tag(4)
        
    }.onAppear {pdfStruct.restore(); print("done"); pdfStruct.updateNotifications()
        //REALLY IMPORTANT!!!!!!!
        
        print("\n\n\nS1 Schedule:")
        print(pdfStruct.schedule)
        print("\n\n\nS2 Schedule:")
        print(pdfStruct.schedule2)
        
    }
    }
}


struct CreditsView: View {

    
var body: some View {
    VStack {
        Spacer()
        Image("cat").resizable().frame(width: 150, height: 150).padding()
        Spacer()
            Text("Created by Ido Shoshani").padding().font(Font(UIFont(name: "Avenir", size: 24)!))
            Spacer()
        
            Text("Logo by Zhitong Liu").padding().font(Font(UIFont(name: "Avenir", size: 12)!))
            Text("Copyright © 2019 Raffi Kian - Date Picker").padding().font(Font(UIFont(name: "Avenir", size: 12)!))
            Text("Hendrik Ulbrich © 2020 - Color Wheel").padding().padding(.bottom,40).font(Font(UIFont(name: "Avenir", size: 12)!))
        
    }
    }
    
}

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
                            Text("Notification Time")
                        }
                    
                    // NOTIFICATIONS END
                }
                
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Software Version")
                        Spacer()
                        Text("1.0.0")
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




extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}



struct AddTestView: View {
    
    @State var singleIsPresented = false
    var rkManager1 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    var courseName: String
    
    init(courseName: String = "") {
        self.courseName = courseName
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    @State private var showingAlert = false

    @State private var name: String = ""
    @State private var selectedClass = 0
    @State private var missingInfo = false
    @State private var dueDate = Date()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        
        VStack {
            Text("Add Test").padding()
            
            TextField("Title", text: $name).padding().multilineTextAlignment(.center)
            

                /*VStack {
                HStack{
                Spacer()
                    DatePicker.init(selection: $dueDate, in: Date().addingTimeInterval(-86400*5)..., displayedComponents: .date, label: {
                    EmptyView()
                    })
                    .labelsHidden().datePickerStyle(WheelDatePickerStyle())
                Spacer()
                }
                    Text(PDF.intToDay(i: Int(Calendar.current.component(.weekday, from: self.dueDate))))
                }*/
            Button(action: { self.singleIsPresented.toggle() }) {
                Text("Select a due date").foregroundColor(.blue).padding()
            }
            .sheet(isPresented: self.$singleIsPresented, content: {
                RKViewController(isPresented: self.$singleIsPresented, rkManager: self.rkManager1)})
            Text(self.getTextFromDate(date: self.rkManager1.selectedDate))
            

            
            if pdfStruct.semester == 1 {
            Picker(selection: $selectedClass, label: Text("Please choose a color")) {
                ForEach(0 ..< pdfStruct.uniqueClassList1.count) {
                    Text(pdfStruct.uniqueClassList1[$0].courseName)
               }
                } .labelsHidden().padding()
            } else {
                Picker(selection: $selectedClass, label: Text("Please choose a color")) {
                 ForEach(0 ..< pdfStruct.uniqueClassList2.count) {
                     Text(pdfStruct.uniqueClassList2[$0].courseName)
                }
                 } .labelsHidden().padding()
            }
            
            
            Button(action: {
                if self.rkManager1.selectedDate != nil && self.name != "" {
                pdfStruct.addHW(name: self.name, cls: pdfStruct.uniqueClassList[self.selectedClass], dueDate: self.rkManager1.selectedDate, test: true)
                
                self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.missingInfo = true
                }}) {
                Text("Done").padding()
            }.alert(isPresented: $missingInfo) {
                Alert(title: Text("Missing Information"), message: Text("Missing title or due date"), dismissButton: .default(Text("Done")))
            }
            if self.missingInfo {
                //Text("Missing Title or Date").bold().foregroundColor(.red).padding()
                //Alert(title: Text("Important message"), message: Text("Wear sunscreen"), dismissButton: .default(Text("Got it!")))
            }
        } .font(Font(UIFont(name: "Avenir", size: 18)!)).padding().navigationViewStyle(StackNavigationViewStyle()).onAppear {
            if self.courseName != "" {
                for n in 0..<pdfStruct.uniqueClassList.count {
                    if pdfStruct.uniqueClassList[n].courseName == self.courseName {
                        self.selectedClass = n
                        break
                    }
                }
            }
        }.onDisappear() {
            pdfStruct.updateNotifications()
        }
    }
    func datesView(dates: [Date]) -> some View {
        ScrollView (.horizontal) {
            HStack {
                ForEach(dates, id: \.self) { date in
                    Text(self.getTextFromDate(date: date))
                }
            }
        }.padding(.horizontal, 15)
    }
    
    func getTextFromDate(date: Date!) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return date == nil ? "" : formatter.string(from: date)
    }
}


struct TestView: View {
    @State var showingDetail = false
    
    var body: some View {
        
        VStack {
            NavigationView {
                List {
                    ForEach(pdfStruct.homework.reversed(), id: \.self) { hw in
                        Group {
                            if !hw.complete && hw.test {
                                AssignmentView(homework: hw)
                            }
                        }
                    }
                } .navigationBarTitle(Text("Tests"))
            }
            Button(action: {
                self.showingDetail.toggle()
            }) {
                Image(systemName: "plus")
            }.sheet(isPresented: $showingDetail) {
                AddTestView()
            } .padding(.bottom, 25)
        }.onAppear{pdfStruct.updateHW()
            for hw in pdfStruct.homework {
                print(hw)
            }
        }.onDisappear{pdfStruct.updateHW()}
        
        
    }
}


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

struct schoolView: View {
    
    @State private var contentOffset: CGPoint = .zero
    @State private var name: String = "chevron.down"
    @State private var isSemester2 = false
    
    var body: some View {
        
        
        
        ZStack {
        
            
            
        VStack {
        ScrollableView(self.$contentOffset, animationDuration: 0.5) {
            
            if !self.isSemester2 {
            
            VStack {
                
                
                ForEach(pdfStruct.schedule[pdfStruct.getCurrentDay()]!, id: \.self) { item in
                    ClassView(c: item).padding(.bottom, 5).padding(.horizontal,4)
                } // SEMESTER 1 / SEMESTER 2
                
    
            }
            
            } else {
                
                VStack {
                            
                            
                            ForEach(pdfStruct.schedule2[pdfStruct.getCurrentDay()]!, id: \.self) { item in
                                ClassView(c: item).padding(.bottom, 5).padding(.horizontal,4)
                            } // SEMESTER 1 / SEMESTER 2
                            
                
                        }
                
                
            }
            
        }.onAppear{self.contentOffset = CGPoint(x: 0, y: pdfStruct.getScrollValue());
            
            if pdfStruct.semester == 1 {self.isSemester2 = false}
            else {self.isSemester2 = true}
            
            
            }
            /*Button(action: {rwt.writeFile(writeString: "", fileName: "Save7")}) {
            Text("Restart")
            }.padding()*/
        }
            if self.contentOffset != CGPoint(x: 0, y: pdfStruct.getScrollValue()) {
            Button(action: {self.contentOffset = CGPoint(x: 0, y: pdfStruct.getScrollValue()); print("***")}) {

                Image(systemName: (Int(self.contentOffset.y) > pdfStruct.getScrollValue()) ? "chevron.up" : "chevron.down").resizable().frame(width: 40,height: 20).opacity(0.7).padding()
                
                }.offset(x: UIScreen.main.bounds.width/(-2.7), y: UIScreen.main.bounds.height/(2.7))
            }

            /*HStack {
                
            Toggle(isOn: $isSemester2){
                Text("")
            }
                if isSemester2 { Text("S2") }
                else { Text("S1")}
            }.offset(x: UIScreen.main.bounds.width/(-1.28), y: UIScreen.main.bounds.height/(-2.7))*/
            
            //Text("test")
            }.font(Font(UIFont(name: "Avenir", size: 18)!))
    }
    
}



struct noSchoolView: View {
    var body: some View {
        Text("No School Today!").bold()
    }
}







struct ClassView: View {
    
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
                        AddHomeworkView(courseName: self.c.courseName)
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


@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
struct ScaledFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    var name: String
    var size: CGFloat

    func body(content: Content) -> some View {
       let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        return content.font(.custom(name, size: scaledSize))
    }
}

@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
extension View {
    func scaledFont(name: String, size: CGFloat) -> some View {
        return self.modifier(ScaledFont(name: name, size: size))
    }
}


struct HomeworkView: View {
    @State var showingDetail = false
    @State private var selectedTab = 1
    @State var period = "Today"
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Avenir", size: 30)!]
        UITableView.appearance().tableFooterView = UIView()
    }

var body: some View {
    
    
    
    func updatePeriod() {
        switch selectedTab {
        case 0: period = "Overdue"
        case 1: period = "Today"
        case 2: period = "Tomorrow"
        case 3: period = "This Week"
        case 4: period = "This Month"
        default: period = "Today"
        }
    }
    
    
    
    
    return ZStack {
        VStack {
        NavigationView {
            
            List {
                ForEach(pdfStruct.homework.reversed(), id: \.self) { hw in
                    // START
                    
                    
                        
                    
                    
                    Group {
                        
                        if !hw.complete && !hw.test {
                            if self.selectedTab == 0 && ((...Calendar.current.startOfDay(for: Date().addingTimeInterval(-86400))).contains(Calendar.current.startOfDay(for: hw.dueDate))) {
                                //NavigationLink(destination: DetailedAssignmentView(homework: hw)) {
                                AssignmentView(homework: hw) // Overdue
                                //}
                                
                            }
                            if self.selectedTab == 1 && (Calendar.current.isDateInToday(hw.dueDate)) {
                                //NavigationLink(destination: DetailedAssignmentView(homework: hw)) {
                                AssignmentView(homework: hw) // Today
                                //}
                                
                            }
                            if self.selectedTab == 2 && (Calendar.current.isDateInTomorrow(hw.dueDate)) {
                                //NavigationLink(destination: DetailedAssignmentView(homework: hw)) {
                                AssignmentView(homework: hw) // Tomorrow
                                //}
                                
                            }
                            if self.selectedTab == 3 && ((Calendar.current.startOfDay(for: Date().addingTimeInterval(86400*2))...Calendar.current.startOfDay(for: Date().addingTimeInterval(86400*7))).contains(Calendar.current.startOfDay(for: hw.dueDate))) {
                                
                                //NavigationLink(destination: DetailedAssignmentView(homework: hw)) {
                                AssignmentView(homework: hw) // This Week
                                //}
                                
                            }
                            if self.selectedTab == 4 && ((Calendar.current.startOfDay(for: Date().addingTimeInterval(86400*8))...).contains(Calendar.current.startOfDay(for: hw.dueDate))) {
                                
                                //NavigationLink(destination: DetailedAssignmentView(homework: hw)) {
                                AssignmentView(homework: hw) // This Month
                                //}
                                
                            }
                    }
                      
                    }
                   
                        
                        
                    // END
                }
                } .navigationBarTitle(Text("Homework - " + self.period))
            
            }
           
            
        HStack {
            
            Button(action: {self.selectedTab -= 1; updatePeriod(); pdfStruct.updateHW()}) {
            Image(systemName: "arrow.left")
                    }.padding(.horizontal, 70).disabled(!(selectedTab>=1))
            
        
        
        Button(action: {
            self.showingDetail.toggle()
        }) {
            Image(systemName: "plus")
        }.sheet(isPresented: $showingDetail) {
            AddHomeworkView()
            } //.padding()
        
            
                Button(action: {self.selectedTab += 1; updatePeriod(); pdfStruct.updateHW()}) {
            Image(systemName: "arrow.right")
                    }.padding(.horizontal, 70).disabled(!(selectedTab<=3))
            
        }.padding(.bottom, 25)
            
            
        
        }.onAppear{self.selectedTab = 1; updatePeriod(); pdfStruct.updateHW()}.onDisappear{pdfStruct.updateHW()}

    }
    
    }
    
    
}




/*struct CheckView: View {
@State var isChecked:Bool = false
var title:String
func toggle(){isChecked = !isChecked}
var body: some View {
Button(action: toggle){
HStack{
Image(systemName: isChecked ? "checkmark.square": "square")
Text(title)
}

}

}

}*/

struct AddHomeworkView: View {
    
    @State var singleIsPresented = false
    var rkManager1 = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), mode: 0)
    
    var courseName: String
    
    init(courseName: String = "") {
        self.courseName = courseName
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    @State private var name: String = ""
    @State private var selectedClass = 0
    @State var isChecked: Bool = true
    @State private var dueDate = Date()
    @State private var missingInfo = false
    func toggle(){isChecked = !isChecked}
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        
        VStack {
            Text("Add Homework").padding()
            
            TextField("Title", text: $name).padding().multilineTextAlignment(.center)
            
            Button(action: {self.toggle();}){
            HStack{
            Image(systemName: isChecked ? "checkmark.square": "square")
            Text("Due Next Class?")
            }
            }
            
            if !isChecked {
                /*VStack {
                HStack{
                Spacer()
                    DatePicker.init(selection: $dueDate, in: Date().addingTimeInterval(-86400*5)..., displayedComponents: .date, label: {
                    EmptyView()
                    })
                    .labelsHidden().datePickerStyle(WheelDatePickerStyle())
                Spacer()
                }
                    Text(PDF.intToDay(i: Int(Calendar.current.component(.weekday, from: self.dueDate))))
                }*/
                Button(action: { self.singleIsPresented.toggle() }) {
                    Text("Select a due date").foregroundColor(.blue).padding()
                }
                .sheet(isPresented: self.$singleIsPresented, content: {
                    RKViewController(isPresented: self.$singleIsPresented, rkManager: self.rkManager1)})
                Text(self.getTextFromDate(date: self.rkManager1.selectedDate))
            }

            if pdfStruct.semester == 1 {
            Picker(selection: $selectedClass, label: Text("Please choose a color")) {
                ForEach(0 ..< pdfStruct.uniqueClassList1.count) {
                    Text(pdfStruct.uniqueClassList1[$0].courseName)
               }
                } .labelsHidden().padding()
            } else {
                Picker(selection: $selectedClass, label: Text("Please choose a color")) {
                 ForEach(0 ..< pdfStruct.uniqueClassList2.count) {
                     Text(pdfStruct.uniqueClassList2[$0].courseName)
                }
                 } .labelsHidden().padding()
            }
            
            Button(action: {
                if (self.isChecked || self.rkManager1.selectedDate != nil) && self.name != "" {
                if self.isChecked {
                    pdfStruct.addHW(name: self.name, cls: pdfStruct.uniqueClassList[self.selectedClass], dueDate: pdfStruct.getNextClassDate(pdfStruct.uniqueClassList[self.selectedClass]))
                    self.presentationMode.wrappedValue.dismiss()
                }
                else {
                    pdfStruct.addHW(name: self.name, cls: pdfStruct.uniqueClassList[self.selectedClass], dueDate: self.rkManager1.selectedDate)
                }
                
                self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.missingInfo = true
                }}) {
                Text("Done").padding()
            } .alert(isPresented: $missingInfo) {
                Alert(title: Text("Missing Information"), message: Text("Missing title or due date"), dismissButton: .default(Text("Done")))
            }
            /*if self.missingInfo {
                Text("Missing Title or Date").bold().foregroundColor(.red).padding()
            }*/
        }.font(Font(UIFont(name: "Avenir", size: 18)!)) .padding().navigationViewStyle(StackNavigationViewStyle()).onAppear {
            if self.courseName != "" {
                for n in 0..<pdfStruct.uniqueClassList.count {
                    if pdfStruct.uniqueClassList[n].courseName == self.courseName {
                        self.selectedClass = n
                        break
                    }
                }
            }
        }.onDisappear() {
            pdfStruct.updateNotifications()
        }
        
        

    }
    func datesView(dates: [Date]) -> some View {
        ScrollView (.horizontal) {
            HStack {
                ForEach(dates, id: \.self) { date in
                    Text(self.getTextFromDate(date: date))
                }
            }
        }.padding(.horizontal, 15)
    }
    
    func getTextFromDate(date: Date!) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return date == nil ? "" : formatter.string(from: date)
    }
}


struct AssignmentView: View {

    var picName: String = "circle"
    @ObservedObject var homework: Homework
    @State var complete = false
    @State var showingDetail = false
    
    let df = DateFormatter()
    let dfDay = DateFormatter()
    
    
var body: some View {
    df.dateFormat = "MM-dd";
    
    dfDay.dateFormat = "EEE";
    
    return HStack {
        VStack {
            Color.init(pdfStruct.classColors[homework.cls.courseName]!)
        } .frame(width: 10, height: 85, alignment: .leading)
        VStack(alignment: .leading) {
        Text("\(homework.cls.courseName) - \(homework.cls.block)")
            Text(homework.name).padding(.bottom, 10)
            

            Text("\(dfDay.string(from: homework.dueDate)) - \(df.string(from: homework.dueDate))")
        }.padding(5)
        
        Spacer()
        
        VStack {
            
            if !complete && !self.homework.complete {
                Image(systemName: "circle").resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                    .opacity(0.6)
            }
            else {
                Image(systemName: "checkmark.circle.fill").resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                    .opacity(0.6)
            }
            
        }.onTapGesture {
            print(self.homework.dueDate)
            if !self.complete {
                self.homework.complete = true
                self.complete = true
                pdfStruct.updateHW()
                pdfStruct.updateNotifications()
            }
            else {
                self.homework.complete = false
                self.complete = false
                pdfStruct.updateHW()
                pdfStruct.addHW(name: self.homework.name, cls: self.homework.cls, dueDate: self.homework.dueDate, test: self.homework.test)
                pdfStruct.updateNotifications()
            }
        }
            
            //(homework.complete == false ? Image(systemName: "circle") : Image(systemName: "checkmark.circle")).resizable()
            /*if complete {
                Image(systemName: "pencil").resizable().onTapGesture {
                    
                }
                .frame(width: 30, height: 30, alignment: .center)
                .opacity(0.6)
            }
            else {
                Image(systemName: "circle").resizable()
                .frame(width: 30, height: 30, alignment: .center)
                .opacity(0.6)
            }
            
        }
        .onTapGesture {
            for n in 0..<pdfStruct.homework.count {
                if pdfStruct.homework[n].name == self.homework.name {
                    pdfStruct.homework[n].complete = true
                    complete = true
                    print(complete)
                    */
        
        
    }.cornerRadius(10)
                
            }
        }
        
   // }
    
    //}
//}


struct ContentView_PreviewsD: PreviewProvider {
    static var previews: some View {
        ContentViewD(viewRouter: ViewRouter())
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}

struct HomeworkView_Previews: PreviewProvider {
    static var previews: some View {
        HomeworkView()
    }
}

/*
struct AssignmentView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentView(homework: Homework(name: "Name", cls: Class(roomNumber: "1", courseName: "AP Calculus BC", semester: "FY", timeStart: "7:40", timeEnd: "8:40", block: "A")))
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
*/


/*
 VStack {
       Text("All Done!").fontWeight(.heavy)
     Button(action: {rwt.writeFile(writeString: "", fileName: "Save6"); self.viewRouter.currentPage = "page1"}) {
         Text("Reset").fontWeight(.heavy).padding()
     }
 } .onAppear {classCount = 0}
 */
