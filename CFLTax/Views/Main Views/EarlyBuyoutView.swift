//
//  EarlyBuyoutView.swift
//  CFLTax
//
//  Created by Steven Williams on 9/26/24.
//

import SwiftUI

struct EarlyBuyoutView: View {
    @Bindable var myInvestment: Investment
    @Binding var path: [Int]
    @Binding var isDark: Bool
    @Binding var currentFile: String
    @Binding var minimumEBOAmount: Decimal
    @Binding var maximumEBOAmount: Decimal
    
    @State private var myEBO: EarlyBuyout = EarlyBuyout()
    
    @State private var alertTitle: String = ""
    @State private var amountColor: Int = 1
    @State private var parValuePremium: Decimal = 0.0
    @State private var basisPoints: Double = 0.00
    @State private var baseYield: Decimal = 0.05
    @State private var sliderMoved: Bool = false
    @State private var eboTerm: Int = 0
    @State private var editAmountStarted: Bool = false
    
    @State private var parValue: String = "0.00"
    @State private var premiumIsSpecified = false
    @State private var rentDueIsPaid = true
  
    @State private var stepBps: Double = 1.0
    @State private var stepValue: Int = 1
    
    //Alerts and Popovers
    @State private var myEBOHelp = eboHelp
    @State private var myEBOHelp2 = eboHelp2
    @State private var showAlert1: Bool = false
    @State private var showPop1: Bool = false
    @State private var showPop2: Bool = false
    
   
    @FocusState private var amountIsFocused: Bool
    private let pasteBoard = UIPasteboard.general
    
    var defaultInactive: Color = Color.theme.inActive
    var defaultCalculated: Color = Color.theme.calculated
    var activeButton: Color = Color.theme.accent
    var standard: Color = Color.theme.active
    
    var body: some View {
        VStack {
            MenuHeaderView(name: "Early Buyout", path: $path, isDark: $isDark)
            Form {
                Section (header: Text("Exercise Date").font(.footnote), footer: Text("Full Term MISF A/T Yield: \(percentFormatter(percent: baseYield.toString(decPlaces: 5), locale: myLocale, places: 2))")) {
                    eboTermInMonsRow
                    exerciseDateRow
                }
                
                Section (header: Text("EBO Amount").font(.footnote), footer: Text("Par Value on Date: \(amountFormatter(amount: parValue, locale: myLocale, places: 2))")) {
                    //eboAmountRow
                    interestRateAdderRow
                    basisPointsStepperRow2
                    calculatedButtonItemRow
                }
                
                Section(header: Text("Submit Form")) {
                    SubmitFormButtonsView(cancelName: "Cancel", doneName: "Done", cancel: myCancel, done: myDone, isFocused: sliderMoved, isDark: $isDark)
                }
            }
        }
        .environment(\.colorScheme, isDark ? .dark : .light)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.myInvestment.economics.solveFor = .yield
            self.myInvestment.calculate()
            self.baseYield = myInvestment.getMISF_AT_Yield()
            self.myEBO = self.myInvestment.earlyBuyout
            self.eboTerm = myEBO.getEBOTermInMonths(aInvestment: myInvestment)
            self.parValue = myInvestment.getParValue(askDate: myEBO.exerciseDate).toString(decPlaces: 4)
            self.basisPoints = myInvestment.getEBOPremium_bps(aEBO: myEBO, aBaseYield: self.baseYield)
        }
        .popover(isPresented: $showPop1) {
            PopoverView(myHelp: $myEBOHelp, isDark: $isDark)
        }
        .popover(isPresented: $showPop2) {
            PopoverView(myHelp: $myEBOHelp2, isDark: $isDark)
        }
    }
    
    private func myCancel() {
        path.removeLast()
    }
    
    private func myDone() {
        submitForm()
        path.removeLast()
    }
}

#Preview {
    EarlyBuyoutView(myInvestment: Investment(), path: .constant([Int]()), isDark: .constant(false), currentFile: .constant("File is New"), minimumEBOAmount: .constant(0.0), maximumEBOAmount: .constant(0.0))
}

//Section Exercise Date
extension EarlyBuyoutView {
    var eboTermInMonsRow: some View {
        HStack {
            Text("Term in Mons: \(eboTerm)")
                .font(myFont)
            Stepper(value: $eboTerm, in: rangeBaseTermMonths, step: getStep()) {
    
            }.onChange(of: eboTerm) { oldTerm, newTerm in
                let noOfPeriods: Int = newTerm  * 12 / self.myInvestment.leaseTerm.paymentFrequency.rawValue
                self.myEBO.exerciseDate = self.myInvestment.getExerciseDate(eboTermInMonths: noOfPeriods)
                self.parValue = self.myInvestment.getParValue(askDate: self.myEBO.exerciseDate).toString()
                self.myEBO.amount = self.parValue
                self.basisPoints = 0.0
            }
        }
        .font(myFont)
    }
    
    var exerciseDateRow: some View {
        HStack {
            Text("Exercise Date:")
                .font(myFont)
            Image(systemName: "questionmark.circle")
                .foregroundColor(Color.blue)
                .onTapGesture {
                    self.showPop1 = true
                }
            Spacer()
            Text(myEBO.exerciseDate.toStringDateShort(yrDigits: 4))
                .font(myFont)
                .onChange(of: myEBO.exerciseDate) { oldDate, newDate in
                    self.parValue = self.myInvestment.getParValue(askDate: newDate).toString()
                    self.myEBO.amount = self.parValue
                }
        }
    }
    
    var parValueOnDateRow: some View {
        HStack {
            Text("Par Value on Date:")
                .font(myFont)
            Spacer()
            Text(amountFormatter(amount: parValue, locale: myLocale))
                .font(myFont)
        }
    }
    
}

extension EarlyBuyoutView {
    //Row 2
    var interestRateAdderRow: some View {
        VStack {
            HStack {
                Text("MISF A/T Yield Adder:")
                    .font(myFont)
                    .foregroundColor(premiumIsSpecified ? defaultInactive : defaultCalculated)
                Spacer()
                Text("\(basisPointsFormatter(basisPoints: basisPoints, locale: myLocale)) bps")
                    .font(myFont)
                    .foregroundColor(premiumIsSpecified ? defaultInactive : defaultCalculated)
            }
            
            Slider(value: $basisPoints, in: -50...maxEBOSpread.toDouble(), step: stepBps) { editing in
                self.amountColor = 1
                self.sliderMoved = true
            }
            .accentColor(basisPoints < 0 ? .red : .green)
        }
    }
    
    
    var basisPointsStepperRow2: some View {
        HStack {
            Spacer()
            Stepper("", value: $basisPoints, in: 0...maxEBOSpread.toDouble(), step: 1, onEditingChanged: { _ in
                self.sliderMoved = true
            }).labelsHidden()
            .transformEffect(.init(scaleX: 1.0, y: 0.9))
        }
    }
    
    //Row 3a
    var calculatedButtonItemRow: some View {
        HStack{
            Button(action: {
                self.myEBO.amount = self.myInvestment.solveForEBOAmount(aEBO: myEBO, aBaseYield: baseYield, bpsSpread: basisPoints).toString(decPlaces: 6)
                self.sliderMoved = false
                self.editAmountStarted = false
            }) {
                Text("Calculate")
                    .font(myFont)
                    .foregroundColor(sliderMoved ? .blue : .gray)
            }
            Image(systemName: "questionmark.circle")
                .foregroundColor(Color.blue)
                .onTapGesture {
                    self.showPop2 = true
                }
            Spacer()
            Text("\(eboFormatted(editStarted:editAmountStarted))")
                .font(myFont)
        }
    }
    
    func eboFormatted(editStarted: Bool) -> String {
        if editStarted == true {
            return self.myEBO.amount
        } else {
            return amountFormatter(amount: self.myEBO.amount, locale: myLocale)
        }
    }
    
    func getAlert() -> Alert{
        return Alert(title: Text(alertTitle))
    }
    
    func getStep() -> Int {
        switch self.myInvestment.leaseTerm.paymentFrequency {
        case .monthly:
            return 1
        case .quarterly:
            return 3
        case .semiannual:
            return 6
        default:
            return 12
        }
    }
    
    func submitForm (){
        if self.myInvestment.earlyBuyout.isEqual(to: self.myEBO) == false {
            self.myInvestment.earlyBuyout = self.myEBO
            self.myInvestment.earlyBuyout.hasChanged = true
        }
    }

    
    var rangeBaseTermMonths: ClosedRange<Int> {
        let starting: Int = 12
        let ending: Int = myInvestment.getBaseTermInMonths() - 12
        
        return starting...ending
    }
    
    
}
