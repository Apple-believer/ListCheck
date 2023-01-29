
import SwiftUI

class UserData: ObservableObject {
    @Published var items = [String]()
}

struct ContentView: View {
    @ObservedObject var data = UserData()
    @State private var newItem = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("こちらに文字を入力してください", text: $newItem)
                    Button(action: {
                        self.showingConfirmation = true
                    }) {
                        Text("追加")
                    }
                }
                .alert(isPresented: $showingConfirmation) {
                    Alert(title: Text("Confirmation"), message: Text("こちらの文字を登録してもよろしいですか？\(newItem)"), primaryButton: .default(Text("Yes"), action: {
                        self.data.items.append(self.newItem)
                        self.newItem = ""
                        UserDefaults.standard.set(self.data.items, forKey: "items")
                    }), secondaryButton: .cancel())
                }
                List {
                    ForEach(data.items, id: \.self) { item in
                        Text(item)
                    }
                }
            }
            .navigationBarTitle("ListCheck")
            .onAppear {
                if let items = UserDefaults.standard.array(forKey: "items") as? [String] {
                    self.data.items = items
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
