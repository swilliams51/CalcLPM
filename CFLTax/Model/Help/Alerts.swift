//
//  Alerts.swift
//  CFLTax
//
//  Created by Steven Williams on 10/9/24.
//

import Foundation


public let alertInterimGroup: String = "To delete an interim payment group go to the home screen and reset the base term commencement date to equal the funding date!!"
public let alertFirstPaymentGroup: String = "The last payment group in which the number of payments is greater than 1 cannot be deleted!!"
public let alertPaymentAmount: String = "The amount entered exceeds the maximum allowable amount which is constrained by the Lease/Loan amount. To enter such an amount first return to the Home screen and enter a temporary amount that is greater than the payment amount that was rejected.  Then return the Payment Group screen and enter the desired amount."
public let alertMaxTargetYield: String = "The calculated Lease/Loan amount exceeds the maximum allowable amount (50,000,000). As a result, the Lease/Loan will be reset to the default parameters.  It is likely that one or more of the Payment Groups has an incorrect payment amount!"
public let alertMaxGty: String = "The calculated Lease/Loan amount exceeds the maximum allowable amount (50,000,000). As a result, the Lease/Loan will be reset to the default parameters.  It is likely that one or more of the Payment Groups has an incorrect payment amount!"
public let alertName: String = "The calculated Lease/Loan amount exceeds the maximum allowable amount (50,000,000). As a result, the Lease/Loan will be reset to the default parameters.  It is likely that one or more of the Payment Groups has an incorrect payment amount!"
public let alertMaxAmount: String = "The calculated Lease/Loan amount exceeds the maximum allowable amount (50,000,000). As a result, the Lease/Loan will be reset to the default parameters.  It is likely that one or more of the Payment Groups has an incorrect payment amount!"
public let alertMaxResidual: String = "The maximum resiudal cannot exceed the Lessor Cost!"
public let alertYieldCalculationError = "There is one or more issues with the input parameters that will cause the yield calculation to produce a negative value or a value greater than the maximum allowable yield. The current calculation has been terminated."
public let alertDefaultLease = "A default lease cannot have an interim term."
