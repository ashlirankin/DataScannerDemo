//
//  BarcodeScannerView.swift
//  DataScannerDemo
//
//  Created by Ashli Rankin on 6/9/22.
//

import SwiftUI
import VisionKit

/// <#Description#>
struct BarcodeScannerView: UIViewControllerRepresentable {
    
    @ObservedObject var dataScannerManager: DataScannerManager
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let dataScannerViewController = DataScannerViewController(recognizedDataTypes: [.barcode(symbologies: [.upce,.ean8,.ean13])], qualityLevel: .fast, isHighlightingEnabled: true)
        dataScannerViewController.delegate = dataScannerManager
        try? dataScannerViewController.startScanning()
        return dataScannerViewController
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {}
}

