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
        
    }.onAppear {pdfStruct.restore(); print("done");}
    
    }
}

/*VStack {
    Text("Schedule View")
    Button(action: {rwt.writeFile(writeString: "", fileName: "Save7")}) {
    Text("Restart")
    }.padding()
}*/

struct AddTestView: View {
    
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
    @State private var dueDate = Date()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        
        VStack {
            Text("Add Test").padding()
            
            TextField("Title", text: $name).padding().multilineTextAlignment(.center)
            

                VStack {
                HStack{
                Spacer()
                    DatePicker.init(selection: $dueDate, in: Date().addingTimeInterval(-86400*5)..., displayedComponents: .date, label: {
                    EmptyView()
                    })
                    .labelsHidden().datePickerStyle(WheelDatePickerStyle())
                Spacer()
                }
                    Text(PDF.intToDay(i: Int(Calendar.current.component(.weekday, from: self.dueDate))))
                }
            

            
            Picker(selection: $selectedClass, label: Text("Please choose a color")) {
                ForEach(0 ..< pdfStruct.uniqueClassList.count) {
                    Text(pdfStruct.uniqueClassList[$0].courseName)
               }
                } .labelsHidden().padding()
            
            
            Button(action: {
                pdfStruct.addHW(name: self.name, cls: pdfStruct.uniqueClassList[self.selectedClass], dueDate: self.dueDate, test: true)
                
                self.presentationMode.wrappedValue.dismiss()
                }) {
                Text("Done").padding()
            }
        } .padding().onAppear {
            if self.courseName != "" {
                for n in 0..<pdfStruct.uniqueClassList.count {
                    if pdfStruct.uniqueClassList[n].courseName == self.courseName {
                        self.selectedClass = n
                        break
                    }
                }
            }
        }
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
            } .padding().padding(.bottom, 30)
        }.onAppear{pdfStruct.updateHW()}.onDisappear{pdfStruct.updateHW()}
        
        
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
    
    var body: some View {
        
        VStack {
        ScrollableView(self.$contentOffset, animationDuration: 0.5) {
            VStack {
                
                
                ForEach(pdfStruct.schedule[pdfStruct.getCurrentDay()]!, id: \.self) { item in
                    ClassView(c: item)
                }
                
    
            }
        }.onAppear{self.contentOffset = CGPoint(x: 0, y: pdfStruct.getScrollValue()); print(pdfStruct.schedule[.Thu])}
            /*Button(action: {rwt.writeFile(writeString: "", fileName: "Save7")}) {
            Text("Restart")
            }.padding()*/
        }
        /*ScrollView(Axis.Set.vertical, showsIndicators: false) {
            /*HStack {
                VStack {
                    ForEach(pdfStruct.schedule[pdfStruct.getCurrentDay()]!, id: \.self) { item in
                        ClassSideView(c: item).frame(width: 20)
                    }
                }*/
            VStack {
                ForEach(pdfStruct.schedule[pdfStruct.getCurrentDay()]!, id: \.self) { item in
                    ClassView(c: item)
                }
            }
        //}
            Button(action: {rwt.writeFile(writeString: "", fileName: "Save7")}) {
            Text("Restart")
            }.padding()
        }*/
        
        
        
        
    }
    
}



struct noSchoolView: View {
    var body: some View {
        Text("No School Today!").bold()
    }
}







struct ClassView: View {
    
    var c: Class
    @State var showingDetail = false
    
    var body: some View {
        
        VStack {
            if c.block == "adv" {
                Spacer()
                Text(c.courseName + " - " + c.block).bold().padding()
                Spacer()
            }
            
            else {
            
                Spacer()
                
                Text(c.courseName + " - " + c.block).bold().padding();
                Text(c.timeStart + " - " + c.timeEnd).bold().padding();
                Text(c.roomNumber).bold().padding().frame(width: 400);
                
                Spacer()
                
                Button(action: {self.showingDetail.toggle()}) {
                    Image(systemName: "plus.circle").resizable()
                    .foregroundColor(.white).frame(width: 22, height: 22)
                    }.padding(.bottom, 45).padding(.leading, 325).sheet(isPresented: $showingDetail) {
                        AddHomeworkView(courseName: self.c.courseName)
                    }
                
                
                
            }
            
            
        }.frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: CGFloat(7 * c.getLength()))
        .background(Color.init(pdfStruct.classColors[c.courseName]!).edgesIgnoringSafeArea(.all).opacity(0.7))
        .padding(.bottom, 8)
        
        
        
    }
    
}

struct HomeworkView: View {
    @State var showingDetail = false
    @State private var selectedTab = 1
    @State var period = "Today"
    

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
                    Group {
                        if !hw.complete && !hw.test {
                            if self.selectedTab == 0 && ((...Calendar.current.startOfDay(for: Date().addingTimeInterval(-86400))).contains(Calendar.current.startOfDay(for: hw.dueDate))) {AssignmentView(homework: hw)}
                            if self.selectedTab == 1 && (Calendar.current.isDateInToday(hw.dueDate)) {AssignmentView(homework: hw)}
                            if self.selectedTab == 2 && (Calendar.current.isDateInTomorrow(hw.dueDate)) {AssignmentView(homework: hw)}
                            if self.selectedTab == 3 && ((Calendar.current.startOfDay(for: Date().addingTimeInterval(86400*2))...Calendar.current.startOfDay(for: Date().addingTimeInterval(86400*7))).contains(Calendar.current.startOfDay(for: hw.dueDate))) {AssignmentView(homework: hw)}
                            if self.selectedTab == 4 && ((Calendar.current.startOfDay(for: Date().addingTimeInterval(86400*8))...).contains(Calendar.current.startOfDay(for: hw.dueDate))) {AssignmentView(homework: hw)}
                    }
                        
                    }
                }
            } .navigationBarTitle(Text("Homework - " + period))
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
            } .padding()
        
            
                Button(action: {self.selectedTab += 1; updatePeriod(); pdfStruct.updateHW()}) {
            Image(systemName: "arrow.right")
                    }.padding(.horizontal, 70).disabled(!(selectedTab<=3))
            
        }.padding(.bottom, 30)
        
        
        
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
                VStack {
                HStack{
                Spacer()
                    DatePicker.init(selection: $dueDate, in: Date().addingTimeInterval(-86400*5)..., displayedComponents: .date, label: {
                    EmptyView()
                    })
                    .labelsHidden().datePickerStyle(WheelDatePickerStyle())
                Spacer()
                }
                    Text(PDF.intToDay(i: Int(Calendar.current.component(.weekday, from: self.dueDate))))
                }
            }

            
            Picker(selection: $selectedClass, label: Text("Please choose a color")) {
                ForEach(0 ..< pdfStruct.uniqueClassList.count) {
                    Text(pdfStruct.uniqueClassList[$0].courseName)
               }
                } .labelsHidden().padding()
            
            
            Button(action: {
                if self.isChecked {
                    pdfStruct.addHW(name: self.name, cls: pdfStruct.uniqueClassList[self.selectedClass], dueDate: pdfStruct.getNextClassDate(pdfStruct.uniqueClassList[self.selectedClass]))
                    self.presentationMode.wrappedValue.dismiss()
                }
                else {
                    pdfStruct.addHW(name: self.name, cls: pdfStruct.uniqueClassList[self.selectedClass], dueDate: self.dueDate)
                }
                
                self.presentationMode.wrappedValue.dismiss()
                }) {
                Text("Done").padding()
            }
        } .padding().onAppear {
            if self.courseName != "" {
                for n in 0..<pdfStruct.uniqueClassList.count {
                    if pdfStruct.uniqueClassList[n].courseName == self.courseName {
                        self.selectedClass = n
                        break
                    }
                }
            }
        }
    }
}


struct AssignmentView: View {

    var picName: String = "circle"
    @ObservedObject var homework: Homework
    @State var complete = false
    
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
            }
            else {
                self.homework.complete = false
                self.complete = false
                pdfStruct.addHW(name: self.homework.name, cls: self.homework.cls, dueDate: self.homework.dueDate)
            }
        }
            
            //(homework.complete == false ? Image(systemName: "circle") : Image(systemName: "checkmark.circle")).resizable()
            /*if complete {
                Image(systemName: "pencil").resizable().onTapGesture {
                    <#code#>
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
                }
                
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
