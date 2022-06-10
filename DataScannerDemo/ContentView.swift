//
//  ContentView.swift
//  DataScannerDemo
//
//  Created by Ashli Rankin on 6/9/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var dataScannerManager: DataScannerManager = DataScannerManager()
    
    var body: some View {
        BarcodeScannerView(dataScannerManager: dataScannerManager)
            .onTapGesture(perform: {
                if !dataScannerManager.recognisedBarcodeString.isEmpty {
                    dataScannerManager.recognisedBarcodeString = ""
                }
            })
            .overlay(alignment: .bottomLeading, content: {
                if !dataScannerManager.recognisedBarcodeString.isEmpty {
                    ZStack {
                        HStack {
                            Text("Barcode Number:")
                            Text(dataScannerManager.recognisedBarcodeString)
                        }
                        .padding(.leading, 16)
                    }
                    .frame(height: 300)
                }
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
