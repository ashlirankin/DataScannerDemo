//
//  DataScannerManager.swift
//  DataScannerDemo
//
//  Created by Ashli Rankin on 6/9/22.
//

import SwiftUI
import VisionKit


/// Manages the properties and methods related to data scanning.
final class DataScannerManager: NSObject, ObservableObject, DataScannerViewControllerDelegate {
    
    /// Value indicating that scanning has failed.
    @Published private(set) var dataScannerFailure: DataScannerViewController.ScanningUnavailable?
    
    /// The string of the recognized barcode.
    @Published var recognisedBarcodeString: String = ""
   
    // MARK: - DataScannerViewControllerDelegate
    
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        switch item {
        case .text: break
        case let .barcode(barcode):
            recognisedBarcodeString = barcode.payloadStringValue ?? ""
        @unknown default: break
        }
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
         self.dataScannerFailure = error
    }
}
