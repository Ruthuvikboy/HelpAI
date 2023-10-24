import SwiftUI

// EmergencyContact model to store contact information
struct EmergencyContact: Identifiable {
    var id = UUID()
    var name: String
    var phoneNumber: String
}

// ViewModel to manage the emergency contacts
class EmergencyContactsViewModel: ObservableObject {
    @Published var emergencyContacts: [EmergencyContact] = []
}

struct EmergencyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @StateObject var viewModel = EmergencyContactsViewModel()

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: EmergencyView(viewModel: viewModel)) {
                    Text("Emergency")
                }
                NavigationLink(destination: HealthView()) {
                    Text("Health")
                }
            }
            .navigationBarTitle("Main Menu")
        }
    }
}

struct EmergencyView: View {
    @ObservedObject var viewModel: EmergencyContactsViewModel
    @State private var isContactSheetPresented = false

    var body: some View {
        List {
            NavigationLink(destination: FAQView()) {
                Text("FAQ for Survival")
            }
            Button(action: {
                isContactSheetPresented.toggle()
            }) {
                Text("Emergency Contacts")
            }
        }
        .navigationBarTitle("Emergency")
        .sheet(isPresented: $isContactSheetPresented) {
            EmergencyContactsSheet(viewModel: viewModel)
        }
    }
}

struct FAQView: View {
    var body: some View {
        Text("FAQ View")
            .navigationBarTitle("FAQ for Survival")
    }
}

struct EmergencyContactsSheet: View {
    @ObservedObject var viewModel: EmergencyContactsViewModel
    @State private var contactName = ""
    @State private var phoneNumber = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Add Emergency Contact")) {
                    TextField("Name", text: $contactName)
                    TextField("Phone Number", text: $phoneNumber)
                    Button("Add Contact") {
                        viewModel.emergencyContacts.append(EmergencyContact(name: contactName, phoneNumber: phoneNumber))
                        contactName = ""
                        phoneNumber = ""
                    }
                }

                Section(header: Text("Emergency Contacts")) {
                    ForEach(viewModel.emergencyContacts) { contact in
                        EmergencyContactRow(contact: contact)
                    }
                    .onDelete { indexSet in
                        viewModel.emergencyContacts.remove(atOffsets: indexSet)
                    }
                }
            }
            .navigationBarTitle("Emergency Contacts")
            .navigationBarItems(trailing: Button("Done") {
                // Close the sheet
            })
        }
    }
}

struct EmergencyContactRow: View {
    var contact: EmergencyContact

    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 40, height: 40)
            VStack(alignment: .leading) {
                Text(contact.name)
                    .font(.headline)
                Text(contact.phoneNumber)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct HealthView: View {
    var body: some View {
        List {
            NavigationLink(destination: PedometerView()) {
                Text("Pedometer")
            }
            NavigationLink(destination: MeditationView()) {
                Text("Meditation Music")
            }
            NavigationLink(destination: VibrateView()) {
                Text("Vibrate")
            }
        }
        .navigationBarTitle("Health")
    }
}

struct PedometerView: View {
    var body: some View {
        Text("Pedometer View")
            .navigationBarTitle("Pedometer")
    }
}

struct MeditationView: View {
    var body: some View {
        Text("Meditation Music View")
            .navigationBarTitle("Meditation Music")
    }
}

struct VibrateView: View {
    var body: some View {
        Text("Vibrate View")
            .navigationBarTitle("Vibrate")
    }
}

struct EmergencyApp_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
