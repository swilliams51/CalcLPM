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
    Help(title: "Base Term Start Date", instruction: "The date when the periodic payments commence.  If the Base Term Start Date occurs after the Funding Date then an interim term will be created and one non-periodic payment will added to the payment schedule. To remove an interim payment set the Base Term Start Date equal to the Funding Date. For a monthly payment frequency the Base Term Start Date cannot occur more than 90 days after the Funding Date. For all other payment frequencies the interim term cannot exceed the number of days in the Payment Frequency.")

let basisHelp: Help =
    Help(title: "Basis for Depreciation", instruction: "This is an informational only field and is always equal to the Lessor Cost of the Asset.  Under certain situations, such as assets that qualify for Investment Tax Credits (ITC), the basis will be reduced by 50% of the amount of ITC taken. ITC related transactions are currently beyond the scope of this program. It is anticipated that future versions of the program will allow the user to input the basis directly.")

let bonusHelp: Help =   Help(title: "Bonus Depreciation", instruction: "The additional amount of first year depreciation that is available to the owner. The bonus depreciation for 2024 is 60% and will be reduced by 20% per year thereafter until it is phased out in 2027.")

let salvageValueHelp: Help =    Help(title: "Salvage Value", instruction: "Is used in connection with the straight-line depreciation method. The salvage value is the value of the asset at the end of its useful life. Straightline depreciation in leasing os often used in depreciating assets than do not qualify as MARCS property such as ssome types of utility assets and foreign use property.")

let dayOfMonthHelp: Help =  Help(title: "Day of Month", instruction: "This is the day of the month that the lessor pays its quarterly or year end taxes. Conventionally, the 15th day of the month is used but the user may input any recurring day of the month.")

let defaultNewHelp =
    Help(title: "Default New", instruction: "The default new lease/loan parameters can be set by the user. First, create the preferred lease/loan structure.  Then return to Preferences and switch on \"use saved\" and switch on \"save current\". Thereafter, when New is selected from the Side Menu the user's saved lease/loan parameters will be loaded.  The default new parameters can be reset to the original parameters by turning off those same switches.")

let decimalPadHelp = Help(title: "Keypad Buttons", instruction: "From left to right the buttons are Cancel, Copy to Clipboard, Paste from Clipboard, Clear All, and Enter.")

let eboHelp =
    Help(title: "Early Buyout", instruction: "The EBO exercise date must occur on or before one year prior to the Lease maturity date but no earlier than the first anniversary date of the Lease.  An EBO Amount that is less than the par value on the applicable exercise date will result in an EBO yield that is less than the full term yield and potentially result in a book loss.")

let eboHelp2 =
    Help(title: "Early Buyout", instruction: "The EBO Amount can not be entered manually, but instead is expressed as a spread in basis points over the full term MISF After-Yield. The slider is accurate to ~ +/- 1 basis point.   To adjust the EBO amount move the slider to the appropriate spread and then press the calculate button to derive the EBO Amount. It is important to remember than any subsequent change to the Investment parameters will result in the EBO being removed from the Investment.  The EBO can be added back after all changes to the Investment are completed.")

let eboHomeHelp =
    Help(title: "Add or Remove EBO", instruction: "An EBO can be added to or removed from the Investment using the Add/Remove EBO buttons below.  Setting the EBO Amount to 0.0 will also remove an EBO. Note, an EBO will be automatically removed from the Investment when any investment parameter changes.")

let feeHomeHelp =
    Help(title: "Add/Remove Fee", instruction: "A Fee may be added to or removed from the Investment using the Add/Remove Fee buttons below. A Fee can also be added by selecting it as a solveFor option in the economics screen. Setting the Fee Amount to 0.0 will also remove a Fee from the Investment.")

let leaseTermEOMRuleHelp =
    Help(title: "End of Month Rule", instruction: "If the Base Term Commencement Date starts on last day of a month having 30 days and the EOM Rule is on, then the subsequent Rental payment due dates for the months with 31 days will occur on the 31st of the applicable month.  If the EOM Rule is off then payment due dates for the months with 31 days will occur on the 30th.")

let escalationRateHelp =
    Help(title: "Escalation Rate", instruction: "The total number of payments for the starting group must be evenly divisible by 12. The resulting escalated payment structure will be a series of consecutive annual payment groups in which the payment amount for each payment group is greater than the previous group by the amount of the escalation rate.")

let exportFileHelp =
    Help(title: "Export File Help", instruction: "When the export action is turned on, the above selected file can be exported to iCloud or to another location on the user's phone.  Once a file is located on the iCloud drive it may be shared with other users of CFLease.")

let FirstAndLastHelp =
    Help(title: "First And Last", instruction: "The last payment will be added to the first payment and the last payment will be set to 0.00.")


let implicitRateHelp =
    Help(title: "Implicit Rate", instruction: "Is the discount rate that equates the present value of the Minimum Lease Payments and the unguaranteed Residual Value to the the Lessor's Cost as of the Funding Date. The Implicit Rate is then used to discount the Lessee's Minimum Payment Obligations to determine if the Lease passes or fails the 90% test in connection classifying the Lease as an operating or finance lease." )


let numberOfPaymentsHelp =
    Help(title: "Number of Payments", instruction: "The total number of Base Term Payments for all non-interim Payment Groups must not exceed 180 months when adjusting for the Payment Frequency. For example, if the Payment Frequency is monthly, then the total number of payments must not exceed 180.  If the payment frequency is semiannually, then the total number of Base Term Payments must not exceed 90.")


let paymentAmountHelp: Help =
    Help(title: "Payment Amount", instruction: "A valid Payment Amount must be a decimal that is equal to or greater than 0.00 but less than the Lessor's Cost of the Asset. Any decimal amount entered that is less than 1.00 will be interpreted as being a percent of Lessor Cost. For example, if the Lessor Cost of the Asset is 1,000,000.00, then an entry of 0.15 will be converted into an entry of 150,000.00.")


let renameHelp =
    Help(title: "Rename Help", instruction: "In order to rename a file, the renaming section must be active, the current name of the file must exist in the collection, the new file name must not already exist in the collection, and it must be a valid file name.")

let saveAsHelp =
    Help(title: "Save As", instruction: "A legal file name must not already exist, must not contain any illegal characters, and must be less than 30 characters in length.")


let terminationHelp =
    Help(title: "Termination Values", instruction: "Are a schedule of values in excess of the applicable lease balances for each payment date. For a non-true lease, setting the discount rate for rent equal to the buy rate will protect any fees paid to the buyer in the event of an unscheduled termination of the lease.  To remove TVs from reports set the discount rates for rent and residual to the maximum values and the additional residual percentage to 0.00%.")

let assetFundingDateHelp =
    Help(title: "Funding Date", instruction: "The date that the asset is funded by the Lessor.  This date can occur on the Base Commencement Date or it can occur at an earlier date.")

let assetResidualValueHelp =
    Help(title: "Residual Value", instruction: "Is the amount of the Lessor's Cost that the Lessor expects to realize by sale or release of the Asset at the end of the Base Lease Term.  The Residual Value can not be less than zero or greater than the Lessor Cost.")

let assetLesseeGuarantyHelp =
    Help(title: "Lessee Guaranty Amount", instruction: "Is the amount of the Residual Value that is guaranteed by the Lessee.  It is commonly used in TRAC Leases. The amount of the Lessee Guaranty can not exceed the Residual Value of the Asset.")

let yieldMethodHelp =
    Help(title: "Yield Method", instruction: "The method that is used to calculate the yield of the Investment.  The two primary methods are the After-Tax Multiple Investment Sinking Fund (MISF-AT) method and the Internal Rate of Return of the Pre-Tax Cashflows (IRR of PTCF) method.  The Sinking Fund Rate used in the MISF method is 0.00%.  The MISF-BT yield is determined indirectly by dividing the MISF-AT Yield by 1.0 minus the Federal Tax Rate.")

let solveForHelp =
    Help(title: "Solve For", instruction: "The program allows the user to solve for 1- the Lessor Cost, 2- the unlocked Rentals, 3- the Residual value, 4- the Fee Amount, or 5- any one of 3 possible yields. Because of rounding constraints, the targeting procedure will only be precise to +/- 1 basis point of the Target Yield.")

let discountRateHelp =
    Help(title: "Discount Rate", instruction: "The rate used to calculate two present value amounts, 1- PV1, which the present value of the Rental payments and 2- PV2, which is the present value of the Rentals payments plus the amount of the Lessee's Residual Guaranty. PV1 and PV2 are shown in the Rentals results screen.")

let dayCountMethodHelp =
    Help(title: "Day Count Method", instruction: "The method used to calculate the number of days between two dates.  The conventional day count method used in the Leasing industry is the 30/360 Day Count method, but the user has 3 additional options.")

let feeAmountHelp =
    Help(title: "Fee Amount", instruction: "The amount paid by the Lessor to the seller in order to purchase the Lease. Alternatively, if the Fee Type is income then the Fee represents the additional amount the seller must pay in order for the Lessor to purchase the Lease.  Do not use this field to input any Fee paid by the Lessee.  For Lessee paid fees enter an advance Rent in the Rent Screen.  Note, that if the Fee Amount is set to 0.00 then the Fee object will be removed from the Investment.")

let feeDatePaidHelp =
    Help(title: "Fee Date Paid", instruction: "This field is for informational purpose only. The date that the Fee is paid will always occur on the Funding Date of the Lease.  In future versions of the program this field may become determined by the user.")

let defaultNewLeaseHelp = Help(title: "Default New Lease", instruction: "When creating a new Lease, the user has the option of using the parameters provided by the program or those defined by the user.  However, this toggle button will remain disabled until a current Lease has been saved to file using the option below.  Once a current Lease has been saved, this option will allow the user to use the program's default Lease parameters or those that have been saved by the user.  Subsequently, the user can save a new Lease as the default Lease, but the program's default Lease cannot be changed. ")

let defaultSaveCurrentHelp = Help(title: "Save Current", instruction: "This option allows the user to save the current Lease as the default parameters for a new Lease when the \"File/New\" option on the File Menu Screen is selected. Note, that the file saving procedure will remove any interim term, any Fee or any Early Buyout from the saved file. This option will not take effect until the option above has been toggled to \"Use Saved\".")

let pvOneHelp = Help(title: "PV1", instruction: "This amount is equal to the present value of the Rentals discounted at the Discount Rate as shown in the Economics screen.")

let pvTwoHelp = Help(title: "PV2", instruction: "This amount is equal the sum of (1) and (2), where (1) is the present value of the Rentals and (2) is the present value of the amount of Residual Value that is guaranteed by the Lessee.  Both amounts are discounted at the Discount Rate as shown in the Economics screen.")

let pvImplicitHelp = Help(title: "PV @ Implicit Rate", instruction: "This amount is equal to the sum of (1) and (2), where (1) is the present value of the Rentals and (2) is the present value of the amount of Residual Value that is guaranteed by the Lessee.  Both amounts are discounted at the Implicit Rate as shown above.")
