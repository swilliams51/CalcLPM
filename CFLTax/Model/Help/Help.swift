//
//  Help.swift
//  CFLTax
//
//  Created by Steven Williams on 8/9/24.
//

import Foundation


struct Help {
    let title: String
    let instruction: String
}


let baseTermHelp =
    Help(title: "Base Term Start Date", instruction: "The date when the periodic payments commence.  If the base term start date occurs after the funding date then an interim term will be created and one non-periodic payment will added to the payment schedule. To remove an interim payment set the base start date equal to the funding date. For a monthly payment frequency the base start date cannot occur more than 90 days after the funding date. For all other payment frequencies the interim term cannot exceed the number of days in the payment frequency.")

let basisHelp: Help =
Help(title: "Basis for Depreciation", instruction: "This is a non-input field and is always equal to the Lessor Cost of the Asset.  Under certain situations, such as assets that qualify for Investment Tax Credits (ITC), the basis will be reduced by 50% of the amount of ITC taken. ITC related transaction are currently beyond the scope of this program. It is anticipated that future versions of the program will allow the user to input the basis accordingly.")

let bonusHelp: Help =   Help(title: "Bonus Depreciation", instruction: "Bonus depreciation is the additional amount of first year depreciation that is available to the user. The bonus depreciation for 2024 is 60% and will be reduced by 20% per year until it will be phased out in 2027.")

let salvageValueHelp: Help =    Help(title: "Salvage Value", instruction: "Is used in connection with the straight-line depreciation method. The salvage value is the value of the asset at the end of its useful life. Straightline depreciation in leasing os often used in depreciating assets than do not qualify as MARCS property such as ssome types of utility assets and foreign use property.")

let dayOfMonthHelp: Help =  Help(title: "Day of Month", instruction: "This is the day of the month that lessor pays it quarterly and year end taxes. Conventionally, the 15th day of the month is used but the user may input any day of the month.")

let cutOffHelp: Help =
    Help(title: "Cut-Off Date", instruction: "A new Lease/Loan will be created from the payment groups of the existing Lease/Loan that occur on and after the cut-off date as selected by the user. If an EBO exists in the current Lease it will also be included in the new Lease if the cut-off date occurs before the EBO exercise date. The ideal application for the Cut-Off method is the purchase of a seasoned lease out of portfolio.")

let defaultNewHelp =
    Help(title: "Default New", instruction: "The default new lease/loan parameters can be set by the user. First, create the preferred lease/loan structure.  Then return to Preferences and switch on \"use saved\"  and switch on \"save current\". Thereafter, when New is selected from the Side Menu the user's saved lease/loan parameters will be loaded.  The default new parameters can be reset to the original parameters by turning off those same switches.")

let decimalPadHelp = Help(title: "Keypad Buttons", instruction: "From left to right the buttons are Cancel, Copy to Clipboard, Paste from Clipboard, Clear All, and Enter.")

let eboHelp =
    Help(title: "Early Buyout", instruction: "The EBO exercise date must occur on or before one year prior to the Lease maturity date but no earlier than the first anniversary date of the Lease.  An EBO Amount that is less than the par value on the applicable exercise date will result in an EBO yield that is less than the full term yield and potentially a book loss.")

let eboHelp2 =
    Help(title: "Early Buyout", instruction: "The EBO Amount can not be entered manually, but instead is expressed as a spread in basis points over the full term MISF After-Yield. The slider is accurate to ~ +/- 1 basis point.   To adjust the EBO amount move the slider to the appropriate spread and then press the calculate button. It is important to remember than any subsequent change in the investment parameters will result in the EBO being removed from the investment.  The EBO can be added back after all changes to the investment are completed.")

let eboHomeHelp =
    Help(title: "Add/Remove EBO", instruction: "An EBO can be added to or removed from the Investment using the Add/Remove EBO buttons below.  Setting the EBO Amount to 0.0 will also remove an EBO. Note, an EBO will be automatically removed from the Investment when any investment parameter changes.")

let feeHomeHelp =
    Help(title: "Add/Remove Fee", instruction: "A Fee maybe added to or removed from the Investment using the Add/Remove Fee buttons below. A Fee can also be added by selecting it as a solveFor option in the economics screen. Setting the Fee Amount to 0.0 will also remove a Fee from the Investment.")

let leaseTermEOMRuleHelp =
    Help(title: "End of Month Rule", instruction: "If the base term commencement date starts on last day of a month havong 30 days and the rule is on, then the subsequent payment due dates for the months with 31 days will occur on the 31st of the applicable month.  If the rule is off then payment due dates for the months with 31 days will occur on the 30th.")

let escalationRateHelp =
    Help(title: "Escalation Rate", instruction: "The total number of payments for the starting group must be evenly divisible by 12. The resulting escalated payment structure will be a series of consecutive annual payment groups in which the payment amount for each payment group is greater than the previous group by the amount of the escalation rate.")

let exportFileHelp =
    Help(title: "Export File Help", instruction: "When the export action is turned on, the above selected file can be exported to iCloud or to another location on the user's phone.  Once a file is located on the iCloud drive it may be shared with other users of CFLease.")

let FirstAndLastHelp =
    Help(title: "1stAndLast", instruction: "The last payment will be added to the first payment and the last payment will be set to 0.00.")

let graduationPaymentsHelp = Help(title: "Graduated Payments Help", instruction: "This structure primarily applies to fixed mortgages that have low initial monthly payment that gradually increase each year over a specified number of years. The rate of increase is set by the escalation rate and the number of years in which the monthly payments will increase is set by the number of annual steps.")

let interestRateHelp =
    Help(title: "Interest Rate", instruction: "A valid interest must be a decimal that is equal to or greater than 0.00 and less than 0.39")


let implicitRateHelp =
    Help(title: "Implicit Rate Help", instruction: "The implicit rate is the discount rate that equates the present value of the Minimum Lease Payments and the unguaranteed residual value to the Lease Amount as of the funding date. Any fee that the Lessee is required to make in connection with the Lease is considered part of the Minimum Lease Payments. To remove a Customer Paid Fee from reports set the fee amount equal to 0.00.")

let importExportHelp =
    Help(title: "Import Export Help", instruction: "The importing and exporting of CFLease data files provide users with additional storage space and the ability to share data files with other CFLease users. Both capabilities are best achieved by using iCloud.")

let importFileHelp =
    Help(title: "Import File Help", instruction: "When the import action is activated, a valid CFLease data file can be imported from iCloud or from another location on the user's phone.  After importing, save the file locally by selecting File Save As from the Side Menu.")

let leaseAmountHelp =
Help(title: "Lease Amount", instruction: "A valid lease or loan amount must be a decimal greater than 999.99 and less than or equal 50000000.00.")


let leaseBalanceHelp =
    Help(title: "Outstanding Balance Help", instruction: "The effective date can be any date occurring after the funding date and before the maturity date of the Lease/Loan. Upon clicking the done button, an amortization report is available for the Lease/Loan Balance through the effective date. Any subsequent recalculation of the Lease/Loan will remove the Balance calculation from reports. To manually remove a Balance calculation from reports set the effective date equal to the funding date.")

let numberOfPaymentsHelp =
Help(title: "Number of Payments", instruction: "The total number of Base Term payments for all non-interim payment groups must not exceed 180 months when adjusting for the payment frequency. For example, if the payment frequency is monthly, then the total number of payments must not exceed 180.  If the payment frequency is semiannually, then the total number of payments must not exceed 90.")

let operatingModeHelp =
    Help(title: "Operating Mode", instruction: "The app has two modes, leasing and lending. In the lending mode, the payment types are limited to interest only, payment, principal, and balloon and the timing of such payments is limited to in arrears. In the leasing mode payments can be made in advance or in arrears and there are 3 additional payment types - daily equivalent all (deAll), daily equivalent next (deNext), and residual.")

let myNewHelp =
    Help(title: "New Help", instruction: "This is a test.")

let paymentAmountHelp: Help =
    Help(title: "Payment Amount", instruction: "A valid payment amount must be a decimal that is equal to or greater than 0.00 but less than 2x the Lessor's Cost of the Asset. Any decimal amount entered that is less than 1.00 will be interpreted as being a percent of Lessor Cost. For example, if the Lessor Cost of the Asset is 1,000,000.00, then an entry of 0.15 will be converted into an entry of 150,000.00.")

let purchaseHelp =
    Help(title: "Buy/Sell", instruction: "Enter a buy rate and the program will solve for the amount fee to be paid by the purchaser of the Lease/Loan (the Buy Fee) or vice versa. A negative Buy Fee cannot be entered, however, a Buy Rate higher than the Lease/Loan interest rate can be entered and will result in a negative Buy Fee.  To remove a buy fee from reports set the fee paid equal to 0.00 or set the buy rate equal to the Lease/Loan interest rate.")

let renameHelp =
    Help(title: "Rename Help", instruction: "In order to rename a file, the renaming section must be active, the current name of the file must exist in the collection, the new file name must not already exist in the collection, and it must be a valid file name.")

let saveAsHelp =
    Help(title: "Save As", instruction: "A legal file name must not already exist, must not contain any illegal characters, and must be less than 30 characters in length.")

let saveAsTemplateHelp = Help(title: "Save As Template", instruction: "The requirements for legal template file name are the same as a regular file name.  When naming a template do not add the suffix \"_tmp\" to the end of the template name.  That will be done by the program.  A template file cannot have an interim term.")

let solveForTermHelp =
    Help(title: "Solve For Term", instruction: "In order to solve for the term, there must be only one unlocked payment group.  Additionally, the number of payments for that group must greater than the minimum and less then the maximum number allowed. Finally, the payment type for that group cannot be interest only.")

let termAmortHelp =
    Help(title: "Amortization Term", instruction: "The amortization term is the number of months required to fully amortize the loan amount given the interest rate and a level payment structure. The program will then use that calculated payment as the payment amount for the current loan and then will calculate the balloon payment that will balance the loan. A 60-month loan at a 120-month amortization given a 5.00% interest rate will result in 56.2048% balloon payment.")

let terminationHelp = Help(title: "Termination Values", instruction: "TVs are a schedule of values in excess of the applicable lease balances for each payment date. For a non-true lease, setting the discount rate for rent equal to the buy rate will protect any fees paid to the buyer in the event of an unscheduled termination of the lease.  To remove TVs from reports set the discount rates for rent and residual to the maximum values and the additional residual percentage to 0.00%.")

let assetFundingDateHelp = Help(title: "Funding Date", instruction: "The asset funding date is the date that the asset is funded by the lessor.  This date can be the same as the Base Commencement Date or it can occur at an earlier date.")

let assetResidualValueHelp = Help(title: "Residual Value", instruction: "The residual value is the amount of the lessor's cost that the lessor expects to realize by sale or release of the asset at the end expiration of the Base Lease Term.  The residual value can not be less than zero or gretaer than the Lessor Cost.")

let assetLesseeGuarantyHelp = Help(title: "Lessee Guaranty Amount", instruction: "The Lessee Guaranty Amount is the amount of the residual value that is guaranteed by the Lessee.  It is commonmly used in TRAC Leases. The amount of the Lessee Guaranty can not exceed the residual value of the asset.")


let yieldMethodHelp = Help(title: "Yield Method", instruction: "The yield method is the method used to calculate the yield of the Investment.  The two primary methods are the After-Tax Multiple Investment Sinking Fund (MISF-AT) method and the Internal Rate of Return of the Pre-Tax Cashflows (IRR of PTCF) method.  The sinking rate used in the MISF method is 0.00%.  The MISF-BT yield is cacluated indirectly by dividing the MISF-AT Yield by 1.0 minus the Federal Tax Rate.")

let solveForHelp = Help(title: "Solve For", instruction: "The program allows the user to solve for 1- the lessor cost, 2- the unlocked rentals, 3- the residual value, 4- the fee amount, or 5- any one of 3 possible yields. The first four options will solve for the amount of lessor cost, unlocked rentals, residual value, or fee amount that will produce the targeted yield while holding all other investment paranmeters constant. The yield solve for option will simply calculate all three yields based upon the input parameters.")

let discountRateHelp = Help(title: "Discount Rate", instruction: "The discount rate is the rate used to calculate two present value amounts, 1- PV1, which the present value of the lease payments and 2- PV2, which is the present value of the lease payments plus the amount of the lessee's residual guaranty. PV1 and PV2 are shown in the Rentals results screen.")

let dayCountMethodHelp = Help(title: "Day Count Method", instruction: "The day count method is the method used to calculate the number of days between two dates.  The conventional day count method the 30/360 day method, but the user has 3 additional options.")
