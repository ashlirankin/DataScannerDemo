# DataScannerDemo

Hi there thanks for visiting this repo. If you like it I encourage you to please leave a like.


### Before
Before iOS 16 it was quite unintuitave and tedious. There was also the difficulty for figuring out how to work this into your flow. 
The code below will get you up and running prior to iOS 16. But you would quickly see how tedious it is because of the ever publishing delegate method. 

```swift /// Configures the AvCaptureDevice.
    func configureCaptureDevice() {
        startRunningSession()
    
        let metadataOutput = AVCaptureMetadataOutput()
        
        session.sessionPreset = AVCaptureSession.Preset.iFrame1280x720
        
        guard let captureDevice = AVCaptureDevice.default(for: .video), let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            return
        }
        
        session.addInput(deviceInput)
        session.addOutput(metadataOutput)
        
        configureOutput()
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        metadataOutput.rectOfInterest = aVCaptureVideoPreviewLayer?.metadataOutputRectConverted(fromLayerRect: CGRect(x: view.frame.width * 0.065, y: view.center.y - 48, width: view.frame.width * 0.85, height: view.frame.width * 0.5)) ?? .zero
    }
    
    private func configureOutput() {
        aVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        aVCaptureVideoPreviewLayer?.frame = view.frame
        aVCaptureVideoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        if let previewLayerUnwrap = aVCaptureVideoPreviewLayer {
            view.layer.addSublayer(previewLayerUnwrap)
        }
    }
}

extension VideoSessionController: AVCaptureMetadataOutputObjectsDelegate {
   
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first else {
            return
        }
        guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
            return
        }
        guard let stringValue = readableObject.stringValue else {
            return
        }
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        self.barcodeStringSubject.send(stringValue)
    }
}
```

### After 
After iOS 16 we are give an abstracted API to integrate data scanner without the hassles of working with AVFoundation. The code below wraps the new `DataScannerViewController` in `UIViewControllerRepresentable` to be able to use it in SwiftUI.
I also want to cal out a few thing when using this API.
1. Apple has nicely integrated Guidance into this controller so it displays on screen prompts to guide the user in a direction which would allows the camera to pickup the target barcode more easily.
2. Inorder to receive the value of the scanned barcode the user must tap the screen after the barcode is recognised. There is no on screen prompt to indicate that the scanning has been complete.
3. If you have enabled `isHighlightingEnabled` in the initializer of the `DataScannerViewController` an on screen rectangle will be presented to highlight the frame of the bardoe which was scanned, which I think is a nice touch.
4. Dont forget to set the `delegate` inorder to receive any changes you must set the delegate as an object and conformm to it.
5. This API is also in beta changes may come to it but not to worry, I will make updates as they arise.
```swift
/// A view that allows for the scanning of a barcode.
struct BarcodeScannerView: UIViewControllerRepresentable {
    
    /// Manages the logic related to scanning data.
    @ObservedObject var dataScannerManager: DataScannerManager
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let dataScannerViewController = DataScannerViewController(recognizedDataTypes: [.barcode(symbologies: [.upce,.ean8,.ean13])], qualityLevel: .fast, isHighlightingEnabled: true)
        dataScannerViewController.delegate = dataScannerManager
        try? dataScannerViewController.startScanning()
        return dataScannerViewController
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {}
}
```
```swift
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
```
## Demo


https://user-images.githubusercontent.com/42153710/173164689-17ced725-a357-4d7e-b6c1-d5ab5efcc1ec.mov


