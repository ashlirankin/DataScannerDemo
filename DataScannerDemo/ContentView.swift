//
//  ContentView.swift
//  DataScannerDemo
//
//  Created by Ashli Rankin on 6/9/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var dataScannerManager: DataScannerManager = DataScannerManager()
    @State private var recognisedBarcodeString: String = ""
    
    var body: some View {
        BarcodeScannerView(dataScannerManager: dataScannerManager)
            .onTapGesture(perform: {
                if !dataScannerManager.recognisedBarcodeString.isEmpty {
                    dataScannerManager.recognisedBarcodeString = ""
                }
            })
            .overlay(alignment: .bottom, content: {
                if !recognisedBarcodeString.isEmpty {
                    ZStack {
                        HStack {
                            Text("Barcode Number:")
                            Text(recognisedBarcodeString)
                        }
                        Color.white
                    }
                    .frame(height: 300)
                }
            })
        
            .onChange(of: dataScannerManager.recognisedBarcodeString, perform: { newValue in
                recognisedBarcodeString = newValue
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
