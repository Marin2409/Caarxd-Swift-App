//
//  CreateWorkCardView.swift
//  Caarxd
//
//  Created by Jose Marin on 11/28/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct CreateWorkCardView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var cardName = ""
    @State private var company = ""
    @State private var employeeName = ""
    @State private var employeeID = ""
    @State private var cardType: WorkCardType = .employeeID
    @State private var selectedImageItem: PhotosPickerItem?
    @State private var cardImageData: Data?

    var body: some View {
        NavigationStack {
            Form {
                Section("Card Information") {
                    TextField("Card Name", text: $cardName)
                    Picker("Card Type", selection: $cardType) {
                        Text("Employee ID").tag(WorkCardType.employeeID)
                        Text("Building Access").tag(WorkCardType.buildingAccess)
                        Text("Membership").tag(WorkCardType.membership)
                        Text("Other").tag(WorkCardType.other)
                    }
                    TextField("Company", text: $company)
                }

                Section("Employee Details") {
                    TextField("Employee Name", text: $employeeName)
                    TextField("Employee ID", text: $employeeID)
                }

                Section("Card Image") {
                    PhotosPicker(selection: $selectedImageItem, matching: .images) {
                        HStack {
                            Text("Card Photo")
                            Spacer()
                            if let cardImageData, let uiImage = UIImage(data: cardImageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 40)
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            } else {
                                Image(systemName: "photo")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("New Work Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCard()
                    }
                    .disabled(cardName.isEmpty || company.isEmpty)
                }
            }
            .onChange(of: selectedImageItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        cardImageData = data
                    }
                }
            }
        }
    }

    private func saveCard() {
        let card = WorkCard(
            cardName: cardName,
            cardType: cardType,
            company: company,
            employeeName: employeeName,
            employeeID: employeeID
        )
        card.cardImageData = cardImageData

        modelContext.insert(card)
        dismiss()
    }
}

#Preview {
    CreateWorkCardView()
}
