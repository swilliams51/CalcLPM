//
//  InvestmentDocument.swift
//  CFLTax
//
//  Created by Steven Williams on 9/4/24.
//

import SwiftUI
import UniformTypeIdentifiers

public struct InvestmentDocument: FileDocument {
    public static var readableContentTypes: [UTType] { [.plainText] }
    
    var investmentData: String
    
    public init (investmentData: String) {
        self.investmentData = investmentData
    }
    
    public init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        investmentData  = string
    }
    
    public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: investmentData.data(using: .utf8)!)
    }
    
    
}
