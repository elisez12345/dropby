import SwiftUI

struct Welcome: View {
    @EnvironmentObject var dataStore: DataStore
    @StateObject var dataLoader = DataLoader()
//    @AppStorage("email") var email: String = ""
//    @AppStorage("firstName") var firstName: String = ""
//    @AppStorage("lastName") var lastName: String = ""
//    @AppStorage("userId") var userId: String = ""
//    @AppStorage("university") var university: String = ""
    @Binding var data: User.FormData
    @State private var searchTerm: String = ""
    
    
    var filteredUnis: [String] {
        dataLoader.universityNames.filter {
                searchTerm.isEmpty ? true : $0.lowercased().contains(searchTerm.lowercased())
            }
        }
    var body: some View {
        VStack{
            NavigationView{
                VStack{
                    Text("Welcome to DropBy!")
                        .fontWeight(.bold)
                        .font(.largeTitle)
                        .padding()
                    Image(systemName: "mappin")
                        .resizable()
                        .frame(width: 20, height: 50)
                        .foregroundColor(.purple)
                        
                    Spacer()
                    Form {
                        TextFieldWithLabel(label: "Email", text: $data.email, prompt: "email")
                            .autocapitalization(.none)
                        TextFieldWithLabel(label: "First Name", text: $data.firstName, prompt: "First Name")
                        TextFieldWithLabel(label: "Last Name", text: $data.lastName, prompt: "Last Name")
                        TextFieldWithLabel(label: "Username", text: $data.userId, prompt: "Username")
                            .autocapitalization(.none)
                        Picker(selection: $data.university, label: Text("University")) {
                            SearchBar(text: $searchTerm, placeholder: "Search Universities")
                                        ForEach(filteredUnis, id: \.self){ uni in
                                            Text(uni)
                                        }
                                    }
                        .pickerStyle(.navigationLink)
                        .accentColor(.purple)
                        .foregroundColor(.purple)
                    }
                    Spacer()
//                    Button("Submit") {
//                        let newUser = User.create(from: data)
//                        dataStore.createUser(newUser)
////                        isPresentingBookForm = false
//                        data = User.FormData()
//                    }
                }
            }
        }

    }
}
struct SearchBar: UIViewRepresentable {

    @Binding var text: String
    var placeholder: String

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator

        searchBar.placeholder = placeholder
        searchBar.autocapitalizationType = .none
        searchBar.searchBarStyle = .minimal
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
}
struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        Welcome(data: Binding.constant(User.previewData[0].dataForForm))
    }
}



//List(data.uniJson) {uni in
//  VStack{
//      Text(uni.institution)
//}}
