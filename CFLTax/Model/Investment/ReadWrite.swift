//
//  ReadWrite.swift
//  CFLTax
//
//  Created by Steven Williams on 8/14/24.
//

import Foundation


public let sampleFile: String = """
Mack Trucks, 100000, 10/1/2024, 20000, 10000, 0*
01/15/25, Monthly, true*
4000.50, 01/15/25, False, 1, 10/01/24, Advance, Specified, True, True|
1925.60, 01/15/30, False, 60, 01/15/25, Arrears, Rent, False, False*
0.00, 0.00, Half-Year, 5, MACRS, 0.0, 0.0,0.0*
0.21, December, 15*
0.00, 01/15/29, True*
MISF B/T, 0.075, Yield, 0.08, 0.00
"""

extension Investment {
    public func writeInvestment() -> String {
        
        // 1. Asset [6]
        let strName: String = self.asset.name
        let strCost: String = self.asset.lessorCost
        let strFundingDate: String = self.asset.fundingDate.toStringDateShort(yrDigits: 4)
        let strResidualValue: String = self.asset.residualValue
        let strLesseeGuaranty: String = self.asset.lesseeGuarantyAmount
        let strThirdPartyGuaranty: String = self.asset.thirdPartyGuarantyAmount
        let assetProperties: Array = [strName, strCost, strFundingDate, strResidualValue, strLesseeGuaranty, strThirdPartyGuaranty]
        let strAsset = assetProperties.joined(separator: ",")
        
        // 2. Lease Term [3]
        let strBaseCommence = self.leaseTerm.baseCommenceDate.toStringDateShort(yrDigits: 4)
        let strPaymentFrequency: String = self.leaseTerm.paymentFrequency.toString()
        let strEOMRule: String = self.leaseTerm.endOfMonthRule.toString()
        let leaseTermProperties: Array = [strBaseCommence, strPaymentFrequency, strEOMRule]
        let strLeaseTerm = leaseTermProperties.joined(separator: ",")
        
        // 3. Rent [9]
        var strGroups: String = ""
        
        for x in 0..<self.rent.groups.count {
            let strAmount: String = self.rent.groups[x].amount
            let strEndDate: String = self.rent.groups[x].endDate.toStringDateShort(yrDigits: 4)
            let strLocked: String = self.rent.groups[x].locked.toString()
            let strNoOfPayments: String = self.rent.groups[x].noOfPayments.toString()
            let strStartDate: String = self.rent.groups[x].startDate.toStringDateShort(yrDigits: 4)
            let strTiming: String = self.rent.groups[x].timing.toString()
            let strType: String = self.rent.groups[x].paymentType.toString()
            let strIsInterim: String = self.rent.groups[x].isInterim.toString()
            let strUndeletable: String = self.rent.groups[x].unDeletable.toString()
            
            let groupProperties: Array = [strAmount, strEndDate, strLocked, strNoOfPayments, strStartDate, strTiming, strType, strUndeletable, strIsInterim]
            let strGroupProperties = groupProperties.joined(separator: ",")
            strGroups = strGroups + strGroupProperties + "|"
        }
        strGroups = String(strGroups.dropLast())
        
        // 4. Depreciation [8] - basisReduction, bonusDepreciation, convention, life, method, investTaxCredit, salvageValue, vestingPeriod
        let strBasisReduction: String = self.depreciation.basisReduction.toString(decPlaces: 4)
        let strBonusDepreciation: String = self.depreciation.bonusDeprecPercent.toString(decPlaces: 4)
        let strConvention: String = self.depreciation.convention.toString()
        let strLife: String = self.depreciation.life.toString()
        let strMethod: String = self.depreciation.method.toString()
        let strInvestTaxCredit: String = self.depreciation.investmentTaxCredit.toString(decPlaces: 4)
        let strSalvageValue: String = self.depreciation.salvageValue
        let strVestingPeriod: String = self.depreciation.vestingPeriod.toString()
        
        let depreciationProperties: Array = [strBasisReduction, strBonusDepreciation, strConvention, strLife, strMethod, strInvestTaxCredit, strSalvageValue, strVestingPeriod]
        let strDepreciationProperties = depreciationProperties.joined(separator: ",")
        
        // 5. TaxAssumptions [3] - federalTaxRate, fiscalMonthEnd, dayOfMonthTaxesPaid
        let strFederalTaxRate: String = self.taxAssumptions.federalTaxRate
        let strFiscalMonthEnd: String = self.taxAssumptions.fiscalMonthEnd.rawValue.toString()
        let strDayOfMonthTaxesPaid: String = self.taxAssumptions.dayOfMonPaid.toString()
        let taxAssumptionsProperties: Array = [strFederalTaxRate, strFiscalMonthEnd, strDayOfMonthTaxesPaid]
        let strTaxAssumptionsProperties = taxAssumptionsProperties.joined(separator: ",")
    
        
        // 6. EBO [3] - Amount, Exercise Date, RentDueIsPaid
        let strEboAmount: String = self.earlyBuyout.amount
        let strExerciseDate: String = self.earlyBuyout.exerciseDate.toStringDateShort(yrDigits: 4)
        let strRentDueIsPaid: String = self.earlyBuyout.rentDueIsPaid.toString()
        let eboProperties: Array = [strEboAmount, strExerciseDate, strRentDueIsPaid]
        let strEBOProperties = eboProperties.joined(separator: ",")
        
        // 7. Fee [3] - amount, datePaid, feeType
        let strAmount: String = self.fee.amount
        let strDatePaid: String = self.fee.datePaid.toStringDateShort(yrDigits: 4)
        let strFeeType: String = self.fee.feeType.toString()
        let feeProperties: Array = [strAmount, strDatePaid, strFeeType]
        let strFeeProperties = feeProperties.joined(separator: ",")
        
        //  8. Economics [6] - yieldMethod, yieldTarget, solveFor, dayCountMethod, discountRateForRent, sinkingFundRate
        let strYieldMethod: String = self.economics.yieldMethod.toString()
        let strYieldTarget: String = self.economics.yieldTarget
        let strSolveFor: String = self.economics.solveFor.toString()
        let strDayCountMethod: String = self.economics.dayCountMethod.toString()
        let strDiscountRateForRent: String = self.economics.discountRateForRent
        let strSinkingFundRate: String = self.economics.sinkingFundDate
        let economicsProperties: Array = [strYieldMethod, strYieldTarget, strSolveFor, strDayCountMethod, strDiscountRateForRent, strSinkingFundRate]
        let strEconomicsProperties = economicsProperties.joined(separator: ",")
        
        let investmentProperties: Array = [strAsset, strLeaseTerm, strGroups, strDepreciationProperties, strTaxAssumptionsProperties, strEBOProperties, strFeeProperties, strEconomicsProperties]
        
        return investmentProperties.joined(separator: "*")
    }

    public func readInvestment(file: String) -> Investment{
        let arrayInvestment: [String] = file.components(separatedBy: "*")
        let arrayAsset: [String] = arrayInvestment[0].components(separatedBy: ",")
        let arrayLeaseTerm: [String] = arrayInvestment[1].components(separatedBy: ",")
        let arrayGroups: [String] = arrayInvestment[2].components(separatedBy: ",")
        let arrayDepreciation: [String] = arrayInvestment[3].components(separatedBy: ",")
        let arrayTaxAssumptions: [String] = arrayInvestment[4].components(separatedBy: ",")
        let arrayEBO: [String] = arrayInvestment[5].components(separatedBy: ",")
        let arrayFee: [String] = arrayInvestment[6].components(separatedBy: ",")
        let arrayEconomics: [String] = arrayInvestment[7].components(separatedBy: ",")
        
        let name = arrayAsset[0]
        let lessorCost = arrayAsset[1]
        let fundingDate = arrayAsset[2].toDate()
        let residualValue = arrayAsset[3]
        let lesseeGuarantee = arrayAsset[4]
        let thirdPartyGuarantee = arrayAsset[5]
        
        //Asset
        let myAsset = Asset(name: name, fundingDate: fundingDate, lessorCost: lessorCost, residualValue: residualValue, lesseeGuarantyAmount: lesseeGuarantee, thirdPartyGuarantyAmount: thirdPartyGuarantee)
        
        //Lease Term
        let baseCommence = arrayLeaseTerm[0].toDate()
        let payPeriod = arrayLeaseTerm[1].toFrequency
        let eom = arrayLeaseTerm[2].toBool()
        
        let myLeaseTerm = LeaseTerm(baseCommenceDate: baseCommence, paymentFrequency: payPeriod(), eomRule: eom)
        
        //Groups
        var myRent: Rent = Rent()
        for x in 0..<arrayGroups.count {
            let myGroup = arrayGroups[x].components(separatedBy: ",")
            let myAmount:String = myGroup[0]
            let myEndDate: Date = myGroup[1].toDate()
            let myLocked: Bool = myGroup[2].toBool()
            let myNoOfPayments: Int = myGroup[3].toInteger()
            let myStartDate: Date = myGroup[4].toDate()
            let myTiming: TimingType = myGroup[5].toTimingType()
            let myType: PaymentType = myGroup[6].toPaymentType()
            let myIsInterim: Bool = myGroup[7].toBool()
            let myUndeletable: Bool = myGroup[8].toBool()
            
            let newGroup: Group = Group(amount: myAmount, endDate: myEndDate, locked: myLocked, noOfPayments: myNoOfPayments, startDate: myStartDate, timing: myTiming, paymentType: myType, isInterim: myIsInterim, unDeletable: myUndeletable)

            myRent.groups.append(newGroup)
        }
        
        //Depreciation [8] - basisReduction (DEc, bonusDepreciation, convention, life, method, investTaxCredit, salvageValue, vestingPeriod
        let basisReduction: Decimal = arrayDepreciation[0].toDecimal()
        let bonusDepreciation: Decimal = arrayDepreciation[1].toDecimal()
        let convention: ConventionType = arrayDepreciation[2].toConventionType()!
        let life: Int = arrayDepreciation[3].toInteger()
        let method: DepreciationType = arrayDepreciation[4].toDepreciationType()
        let investTaxCredit: Decimal = arrayDepreciation[5].toDecimal()
        let salvageValue: String = arrayDepreciation[6]
        let vestingPeriod: Int = arrayDepreciation[7].toInteger()
        
        let myDepreciation: Depreciation = Depreciation(basisReduction: basisReduction, bonusDeprecPercent: bonusDepreciation, convention: convention, life: life, method: method, investmentTaxCredit: investTaxCredit, salvageValue: salvageValue, vestingPeriod: vestingPeriod)
        
        // TaxAssumptions [3] - federalTaxRate, fiscalMonthEnd, dayOfMonthTaxesPaid
        let myTaxRate = arrayTaxAssumptions[0]
        let myFiscalMonthEnd: TaxYearEnd = arrayTaxAssumptions[1].toTaxYearEnd()!
        let myDayOfMonthTaxesPaid = arrayTaxAssumptions[2].toInteger()
        let myTaxAssumptions = TaxAssumptions(federalTaxRate: myTaxRate, fiscalMonthEnd: myFiscalMonthEnd, dayOfMonPaid: myDayOfMonthTaxesPaid)
        
        //EBO [3] - Amount, Exercise Date, RentDueIsPaid
        let myEBOAmount = arrayEBO[0]
        let myOptionsDate = arrayEBO[1].toDate()
        let myRentDueIsPaid: Bool = arrayEBO[2].toBool()
        let myEBO = EarlyBuyout(amount: myEBOAmount, exerciseDate: myOptionsDate, rentDueIsPaid: myRentDueIsPaid)
        
        let myFeeAmount = arrayFee[0]
        let myFeeDatePaid: Date = arrayFee[2].toDate()
        let myFeeType: FeeType = arrayFee[1].toFeeType()!
        
        let myFee = Fee(amount: myFeeAmount, feeType: myFeeType, datePaid: myFeeDatePaid)
        
        
        //Economics [6] - yieldMethod, yieldTarget, solveFor, dayCountMethod, discountRateForRent, sinkingFundRate
        let myYieldMethod = arrayEconomics[0].toYieldMethod()!
        let myYieldTarget: String = arrayEconomics[1]
        let mySolveFor: SolveForOption = arrayEconomics[2].toSolveFor()
        let myDayCountMethod: DayCountMethod = arrayEconomics[3].toDayCountMethod()!
        let myDiscountRate: String = arrayEconomics[4]
        let mySinkingFundRate: String = arrayEconomics[5]
        let myEconomics: Economics = Economics(yieldMethod: myYieldMethod, yieldTarget: myYieldTarget, solveFor: mySolveFor, dayCountMethod: myDayCountMethod, discountRateForRent: myDiscountRate)
        
        
        let myInvestment: Investment = Investment(aAsset: myAsset, aLeaseTerm: myLeaseTerm, aRent: myRent, aDepreciation: myDepreciation, aTaxAssumptions: myTaxAssumptions, aEconomics: myEconomics, aFee: myFee, aEarlyBuyout: myEBO)
        
        return myInvestment
        
    }
    
}

