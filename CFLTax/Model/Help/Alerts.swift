//
//  Alerts.swift
//  CFLTax
//
//  Created by Steven Williams on 10/9/24.
//

import Foundation

//Asset
public let alertName: String = "A valid equipment name must be a string no longer than 25 characters in length including spaces.  The string must be comprised of only letters, numbers or spaces. Any special characters are not allowed!"
public let alertLessorCost: String = "A valid Lessor Cost is a decimal that is greater than 999.99 but less than 10,000,000.00!"
public let alertResidualValue: String = "The maximum Residual Value cannot exceed the Lessor Cost!"
public let alertLesseeGty: String = "The maximum Lessee Guaranty cannot exceed the Residual Value!"
public let alertPaymentAmount: String = "The maximum payment amount cannot exceed the Lessor Cost. To enter such an amount first return to the Asset screen and enter a temporary amount for the Lessor Cost that is greater than the payment amount that was rejected.  Then return the Payment Group screen and enter the desired payment amount."
public let alertBonusDepreciation: String = "The maximum bonus depreciation cannot exceed 1.0 or 100% of Lessor Cost!"
public let alertMaxTaxRate: String = "The maximum tax rate must be loss than 100%!"
public let alertMaxFeeAmount: String = "The maximum fee amount cannot exceed the Lessor Cost!"
public let alertInterimGroup: String = "To delete an interim payment group go to the Lease Term screen and reset the Base Term Commencement Date to the Funding Date!!"
public let alertFirstPaymentGroup: String = "The first payment group following a interim payment group cannot be deleted. If an interim payment group does not exist then the Rent must include one payment group in which the number of payments is greater than 1!!"
public let alertMaxTargetYield: String = "The maximum target yield cannot exceed 20%!"
public let alertMaxDiscountRate: String = "The maximum discount rate cannot exceed 20%!"
public let alertYieldCalculationError = "There is one or more issues with the input parameters that will cause the yield calculation to produce either a negative value or a value greater than the maximum allowable yield. The current calculation has been terminated."
