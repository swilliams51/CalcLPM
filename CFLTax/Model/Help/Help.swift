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


let assetLesseeGuarantyHelp =
        Help(title: "Lessee Guaranty Amount", instruction: "Is the amount of the Residual Value that is guaranteed by the Lessee.  It is commonly used in TRAC Leases. The amount of the Lessee Guaranty can not exceed the Residual Value of the Asset.")

let assetFundingDateHelp =
        Help(title: "Funding Date", instruction: "The date that the Asset is funded by the Lessor.  This date can occur on the Base Commencement Date or it can occur at an earlier date.")

let assetResidualValueHelp =
        Help(title: "Residual Value", instruction: "Is the amount of the Lessor's Cost that the Lessor expects to realize by sale or release of the Asset at the end of the Base Lease Term.  The Residual Value can not be less than 0.00 or greater than the Lessor’s Cost.")

//b
let baseTermHelp =
    Help(title: "Base Term Start Date", instruction: "The date when the periodic rental payments commence.  If the Base Term Start Date occurs after the Funding Date then an interim term will be created and one non-periodic payment will added to the Rent Payment Schedule. To remove an interim rent payment set the Base Term Start Date equal to the Funding Date. For a monthly payment frequency, the Base Term Start Date cannot occur more than 90 days after the Funding Date. For all other payment frequencies the interim term cannot exceed the number of days in the Payment Frequency.")
         
let basisHelp: Help =
    Help(title: "Basis for Depreciation", instruction: "This field is for informational purposes only and will always be equal to the Lessor Cost of the Asset.  Under certain situations, such as assets that qualify for Investment Tax Credits (ITC), the depreciation basis will be reduced by 50% of the amount of ITC taken. ITC related transactions are currently beyond the scope of this program. It is anticipated that future versions of the program will allow the user to enter the Basis amount.")

let bonusHelp: Help =
    Help(title: "Bonus Depreciation", instruction: "The additional amount of first year depreciation that is available to the owner of depreciable property. Under current law the bonus depreciation for 2024 is 60% and will be reduced by 20% per year thereafter until it is phased out in 2027.")


let calculateHomeHelp =
    Help(title: "Calculate", instruction: "The Calculate button is used with the Solve For parameters as provided on the Economics form.  The Calculate button will execute a targeting algorithm based on the specific Yield Method, Target Yield, and Solve For option that is selected by the user.")


let dayCountMethodHelp =
        Help(title: "Day Count Method", instruction: "The method used to calculate the number of days between two dates.  The conventional day count method used in the Leasing industry is the 30/360 Day Count method, but the user has three additional options.")

let dayOfMonthHelp: Help =
    Help(title: "Day of Month", instruction: "This is the day of the month that the Lessor pays its quarterly or year end taxes. Conventionally, the 15th day of the month is used but the user may input any recurring day of the month.")

let decimalPadHelp =
    Help(title: "Keypad Buttons", instruction: "From left to right the buttons are Cancel, Copy to Clipboard, Paste from Clipboard, Clear All, and Enter.")

let discountRateHelp =
        Help(title: "Discount Rate", instruction: "The rate used to calculate two present value amounts, 1- PV1, which the present value of the Rental payments and 2- PV2, which is the present value of the Rentals payments plus the amount of the Lessee's Residual Guaranty. PV1 and PV2 are shown in the Rentals results screen.")

let defaultNewLeaseHelp =
    Help(title: "Default New Lease", instruction: "When creating a new Lease, the user has the option of using the parameters provided by the program or those defined by the user.  However, this toggle button will remain disabled until the parameters of a current Lease have been saved using the option directly below and after submitting the form.  Upon returning to this form, this option will be enabled and the user can elect to use the program's default Lease parameters or those that have been saved by the user.  Subsequently, the user can save a new Lease as the default Lease, but the program's default Lease cannot be changed. ")

let defaultSaveCurrentHelp =
    Help(title: "Save Current", instruction: "This option allows the user to save the current Lease as the default parameters for a new Lease when the \"File/New\" option on the File Menu Screen is selected. Note, that the file saving procedure will remove any interim term, any Fee, or any Early Buyout from the saved file. This option will not take effect until the option directly above has been toggled to \"Use Saved\".")


let eboHelp =
    Help(title: "Early Buyout", instruction: "The EBO exercise date must occur on or before one year prior to the Lease maturity date but no earlier than the first anniversary date of the Lease.  An EBO Amount that is less than the par value on the applicable exercise date will result in an EBO yield that is less than the full term after-tax yield and potentially will result in a book loss.")

let eboHelp2 =
    Help(title: "Early Buyout", instruction: "The EBO Amount can not be entered manually, but instead is expressed as a spread in basis points over the full term MISF After-Tax Yield. The basis point slider is accurate to ~ +/- 1 bps.   To adjust the EBO amount move the slider to the appropriate bps spread and then press the calculate button to derive the EBO Amount. It is important to remember than any subsequent change to the Investment parameters will result in the EBO being removed from the Investment.  The EBO can be added back after all changes to the Investment are completed.")

let eboHomeHelp =
    Help(title: "Add or Remove EBO", instruction: "An EBO can be added to or removed from the Investment using the Add/Remove EBO buttons below. Note, an EBO will be automatically removed from the Investment when any investment parameter changes.")

let feeHomeHelp =
    Help(title: "Add/Remove Fee", instruction: "A Fee may be added to or removed from the Investment using the Add/Remove Fee buttons below. A Fee can also be added by selecting it as a solveFor option in the economics screen. Setting the Fee Amount to 0.0 will also remove a Fee from the Investment.")

let feeAmountHelp =
        Help(title: "Fee Amount", instruction: "The amount paid by the Lessor to the seller in order to purchase the Lease. Alternatively, if the Fee Type is income then the Fee represents the amount paid by the seller to the Lessor for purchase of the Lease.  Do not use this field to input any Fee paid by the Lessee.  For Lessee paid fees enter an advance Rent in the Rent Screen.  Note, that if the Fee Amount is set to 0.00 then the Fee will be removed from the Investment.")

let feeDatePaidHelp =
        Help(title: "Fee Date Paid", instruction: "This field is for informational purpose only. The date that the Fee is paid will always occur on the Funding Date of the Lease.  In future versions of the program this field may become determined by the user.")


let FirstAndLastHelp =
    Help(title: "First And Last", instruction: "The last payment will be added to the first payment and the last payment will be set to 0.00.")

let FirstAndLastTwoHelp = Help(title: "First And Last Two", instruction: "The last two payments will be added to the first payment and the last two payments will be set to 0.00.")


let implicitRateHelp =
    Help(title: "Implicit Rate", instruction: "Is the discount rate that equates the present value of the Minimum Lease Payments and the unguaranteed Residual Value to the Lessor's Cost as of the Funding Date. The Implicit Rate is then used to discount the Lessee's Minimum Payment Obligations to determine if the Lease passes or fails the 90% test in connection with the classification of the Lease as either an operating or a finance lease." )

let leaseTermEOMRuleHelp =
    Help(title: "End of Month Rule", instruction: "If the Base Term Commencement Date starts on last day of a month having 30 days and the EOM Rule is on, then the subsequent Rental payment due dates for the months with 31 days will occur on the 31st of the applicable month.  If the EOM Rule is off then payment due dates for the months with 31 days will occur on the 30th. The payment dues date will occur on the last day of February in either case.")


let numberOfPaymentsHelp =
        Help(title: "Number of Payments", instruction: "The total number of Base Term Payments for all non-interim Payment Groups must not exceed 180 months when adjusting for the Payment Frequency. For example, if the Payment Frequency is monthly, then the total number of payments must not exceed 180.  If the payment frequency is semiannually, then the total number of Base Term Payments cannot exceed 90.")

let paymentAmountHelp: Help =
        Help(title: "Payment Amount", instruction: "A valid Payment Amount must be a decimal that is equal to or greater than 0.00 but less than the Lessor's Cost of the Asset. To enter a Payment Amount that is greater than the Lessor’s Cost first go to the Asset form and enter a temporary amount for Lessor’s Cost. The return to the Payment Group details form and enter the desired Payment Amount.  Any decimal amount entered that is less than 1.00 will be interpreted as being a percent of Lessor Cost. For example, if the Lessor Cost of the Asset is 1,000,000.00, then an entry of 0.15 will be converted to an entry of 150,000.00.")

let lockedPaymentHelp: Help =
        Help(title: "Locked Payment", instruction: "This option is used when solving for Unlocked Payments on the Economics form. A Payment Group that is locked will not be adjusted when solving for Unlocked Payments.  Use this option when the payment amounts are known for one or more Payment Groups. However, there must be at least one Payment Group that is unlocked in order to use the solve for Unlocked Payments option.")

//let renameHelp =
//        Help(title: "Rename Help", instruction: "In order to rename a file, the renaming section must be active, the current name of the file must exist in the collection, the new file name must not already exist in the collection, and it must be a valid file name.")

let pvOneHelp =
    Help(title: "PV1", instruction: "This amount is equal to the present value of the Rentals discounted at the Discount Rate as shown in the Economics screen.")

let pvTwoHelp =
    Help(title: "PV2", instruction: "This amount is equal the sum of (1) and (2), where (1) is the present value of the Rentals and (2) is the present value of the amount of Residual Value that is guaranteed by the Lessee.  Both amounts are discounted at the Discount Rate as shown in the Economics screen.")

let pvImplicitHelp =
    Help(title: "PV @ Implicit Rate", instruction: "This amount is equal to the sum of (1) and (2), where (1) is the present value of the Rentals and (2) is the present value of the amount of Residual Value that is guaranteed by the Lessee.  Both amounts are discounted at the Implicit Rate as shown above.")

let salvageValueHelp: Help =
    Help(title: "Salvage Value", instruction: "Is used in connection with the straight-line depreciation method. The salvage value is the value of the asset at the end of its useful life. Straight-line depreciation in leasing is often used in depreciating property than does not qualify as MARCS property such as some types of utility assets and foreign use property.")

let saveAsHelp =
        Help(title: "Save As", instruction: "A legal file name must not already exist, must not contain any illegal characters, and must be less than 30 characters in length.")

let solveForHelp =
        Help(title: "Solve For", instruction: "The Solve For option is used with the above two parameters to define a specific targeting algorithm. For example, if the Yield Method is MISF AT, the Target Yield is 5.00%, and the Solve For option is “Unlocked Rentals” then the targeting algorithm will solve for the unlocked payment amounts that will produce a 5.00% MISF AT Yield while holding all other Investment parameters constant. Note, that if the Solve For option is “yield” then the targeting algorithm will be suppressed and all three yields will simply be calculated.")

let targetYieldHelp =
    Help(title: "Target Yield", instruction: "Target Yield is the specific IRR (expressed as a nominal annual interest rate) of the applicable Investment cashflows that the goal seeking algorithm will target when solving for the selected Solve For option.")

let yieldMethodHelp =
        Help(title: "Yield Method", instruction: "Yield Method is either Multiple Investment Sinking Fund or Internal Rate of Return, and within the MISF method the options are either after-tax or its before-tax equivalent. The MISF method will use the Investment’s after-tax cashflows while the IRR method will use the before-tax cashflows.")













