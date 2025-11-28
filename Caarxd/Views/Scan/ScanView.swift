//
//  ScanView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI
import SwiftData
import AVFoundation
import VisionKit

enum ScanMode: String, CaseIterable {
    case qrCode = "QR Code"
    case businessCard = "Business Card"
    case barcode = "Barcode"

    var icon: String {
        switch self {
        case .qrCode: return "qrcode"
        case .businessCard: return "doc.text.viewfinder"
        case .barcode: return "barcode"
        }
    }
}

struct ScanView: View {
    @State private var scanMode: ScanMode = .qrCode
    @State private var showingCamera = false
    @State private var showingDocumentScanner = false
    @State private var showingScannedResult = false
    @State private var scannedData: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                // Mode Selector
                Picker("Scan Mode", selection: $scanMode) {
                    ForEach(ScanMode.allCases, id: \.self) { mode in
                        Label(mode.rawValue, systemImage: mode.icon)
                            .tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                // Scan Mode Info
                VStack(spacing: 16) {
                    Image(systemName: scanMode.icon)
                        .font(.system(size: 80))
                        .foregroundStyle(.blue)

                    Text(scanMode.rawValue)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(modeDescription)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()

                // Scan Button
                Button(action: { startScanning() }) {
                    Label("Start Scanning", systemImage: "camera.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(16)
                }
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("Scan")
            .sheet(isPresented: $showingCamera) {
                CameraView(scanMode: scanMode, scannedData: $scannedData, showingScannedResult: $showingScannedResult)
            }
            .sheet(isPresented: $showingDocumentScanner) {
                DocumentScannerView(scannedData: $scannedData, showingScannedResult: $showingScannedResult)
            }
            .sheet(isPresented: $showingScannedResult) {
                if let data = scannedData {
                    ScannedResultView(data: data, scanMode: scanMode)
                }
            }
        }
    }

    private var modeDescription: String {
        switch scanMode {
        case .qrCode:
            return "Scan QR codes to instantly connect with others and save their business cards"
        case .businessCard:
            return "Capture business cards with your camera and automatically extract contact information"
        case .barcode:
            return "Scan barcodes from employee IDs, access cards, and membership cards"
        }
    }

    private func startScanning() {
        if scanMode == .businessCard {
            showingDocumentScanner = true
        } else {
            showingCamera = true
        }
    }
}

// MARK: - Camera View
struct CameraView: UIViewControllerRepresentable {
    let scanMode: ScanMode
    @Binding var scannedData: String?
    @Binding var showingScannedResult: Bool
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.scanMode = scanMode
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, CameraViewControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func didScanCode(_ code: String) {
            parent.scannedData = code
            parent.dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                parent.showingScannedResult = true
            }
        }
    }
}

// MARK: - Camera View Controller
protocol CameraViewControllerDelegate: AnyObject {
    func didScanCode(_ code: String)
}

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var scanMode: ScanMode = .qrCode
    weak var delegate: CameraViewControllerDelegate?

    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let captureSession = captureSession, !captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                captureSession.startRunning()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let captureSession = captureSession, captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                captureSession.stopRunning()
            }
        }
    }

    private func setupCamera() {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else { return }

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

            switch scanMode {
            case .qrCode:
                metadataOutput.metadataObjectTypes = [.qr]
            case .barcode:
                metadataOutput.metadataObjectTypes = [.ean8, .ean13, .code128, .code39]
            default:
                metadataOutput.metadataObjectTypes = [.qr]
            }
        } else {
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = view.layer.bounds
        previewLayer?.videoGravity = .resizeAspectFill
        if let previewLayer = previewLayer {
            view.layer.addSublayer(previewLayer)
        }

        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            delegate?.didScanCode(stringValue)
        }
    }
}

// MARK: - Document Scanner View
struct DocumentScannerView: UIViewControllerRepresentable {
    @Binding var scannedData: String?
    @Binding var showingScannedResult: Bool
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let controller = VNDocumentCameraViewController()
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let parent: DocumentScannerView

        init(_ parent: DocumentScannerView) {
            self.parent = parent
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            // For now, just indicate success. OCR processing would happen here
            parent.scannedData = "Business card scanned successfully"
            parent.dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                parent.showingScannedResult = true
            }
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.dismiss()
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            parent.dismiss()
        }
    }
}

// MARK: - Scanned Result View
struct ScannedResultView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let data: String
    let scanMode: ScanMode

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var title = ""
    @State private var company = ""
    @State private var email = ""
    @State private var phone = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Scanned Information") {
                    Text(data)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Contact Details") {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Job Title", text: $title)
                    TextField("Company", text: $company)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                }
            }
            .navigationTitle("Review & Save")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveContact()
                    }
                    .disabled(firstName.isEmpty && lastName.isEmpty)
                }
            }
            .onAppear {
                parseScannedData()
            }
        }
    }

    private func parseScannedData() {
        // Basic parsing logic - this would be enhanced with actual OCR/QR parsing
        if data.contains("@") {
            email = data
        }
    }

    private func saveContact() {
        let contact = Contact(
            firstName: firstName,
            lastName: lastName,
            title: title,
            company: company,
            email: email,
            phone: phone,
            scannedFromQR: scanMode == .qrCode,
            scannedFromCard: scanMode == .businessCard
        )
        modelContext.insert(contact)
        dismiss()
    }
}

#Preview {
    ScanView()
}
