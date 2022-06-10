//
//  BarcodeScannerView.swift
//  DataScannerDemo
//
//  Created by Ashli Rankin on 6/9/22.
//

import SwiftUI
import VisionKit

struct BarcodeScannerView: UIViewControllerRepresentable {
    
    final class Coordinator: NSObject, DataScannerViewControllerDelegate {
        
        @Published var error: DataScannerViewController.ScanningUnavailable?
        
        var parent: BarcodeScannerView
        
        init(parent: BarcodeScannerView) {
            self.parent = parent
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item {
            case .text: break
            case let .barcode(barcode):
                print(barcode.payloadStringValue)
            @unknown default: break
            }
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
            // self.error = error
        }
    }
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let dataScannerViewController = DataScannerViewController(recognizedDataTypes: [.barcode(symbologies: [.upce,.ean8,.ean13])], qualityLevel: .fast, isHighlightingEnabled: true)
        dataScannerViewController.delegate = context.coordinator
        try? dataScannerViewController.startScanning()
        return dataScannerViewController
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
}

