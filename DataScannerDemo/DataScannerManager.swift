//
//  DataScannerManager.swift
//  DataScannerDemo
//
//  Created by Ashli Rankin on 6/9/22.
//

import SwiftUI
import VisionKit

final class DataScannerManager: NSObject, ObservableObject, DataScannerViewControllerDelegate {
    
    @Published private(set) var error: DataScannerViewController.ScanningUnavailable?
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
         self.error = error
    }
}
