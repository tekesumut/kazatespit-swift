
import SwiftUI
import Combine

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.black, lineWidth: 1)
                    .background(Color.white)
            )
    }
}
struct RegistrationView: View {
    @State private var name = ""
    @State private var surname = ""
    @State private var email = ""
    @State private var policeNumber = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var password2 = ""
    
    @State private var showAlert = false
    @State private var alertTitle = "Sunucu Yanıtı"
    @State private var alertMessage = ""

    @State private var address = ""
    @State private var birthDate = Date()
    @State private var selectedCompany: Int = 0
    @State private var selectedBlood: Int = 0
    @StateObject var viewModel = CityDistrictViewModel()
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 20) {
                Spacer()
                Group {
                    
                    
                    ZStack(alignment: .topLeading) {
                        
                        
                        TextField("", text: $name)
                            .textFieldStyle(CustomTextFieldStyle())
                            .foregroundColor(.black)
                            .padding(.trailing,20)
                            .padding(.leading,30)
                        
                        
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.black)
                                .offset(y: 10)
                                .padding(.leading,5)
                            
                            Text("Ad")
                                .foregroundColor(.black)
                                .background(Color.white)
                                .padding(.leading,20)
                                .offset(y: -10)
                                .bold()
                            
                            
                            // Arka planı beyaz yaparak TextField ile çakışmasını engelliyoruz.
                            
                        }
                    }
                    .background(.white)
                    
                    
                    
                    ZStack(alignment: .topLeading) {
                        
                        
                        TextField("", text: $surname)
                            .textFieldStyle(CustomTextFieldStyle())
                            .foregroundColor(.black)
                            .padding(.trailing,20)
                            .padding(.leading,30)
                            .background(Color.white)
                            .padding(.top,10)
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.black)
                                .offset(y: 20)
                                .padding(.leading,5)
                            
                            Text("Soyad")
                                .foregroundColor(.black)
                                .background(Color.white)
                                .padding(.leading,20)
                                .offset(y: -2)
                                .bold()
                            
                            // Arka planı beyaz yaparak TextField ile çakışmasını engelliyoruz.
                            
                        }
                        
                    }
                    .background(.white)
                    
                    
                    
                    HStack {
                        Image(systemName: "drop.fill")
                            .resizable()
                            .frame(width: 15, height: 20)
                            .foregroundColor(.black)
                            .padding(.leading,5)
                        
                        Picker("", selection: $selectedBlood) {
                            ForEach(0..<viewModel.bloods.count) {
                                Text(self.viewModel.bloods[$0])
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .background(.white)
                    
                    HStack {
                        Picker("", selection: $selectedCompany) {
                            ForEach(0..<viewModel.companies.count) {
                                Text(self.viewModel.companies[$0])
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .background(.white)
                }
                Group {
                    
                    
                    ZStack(alignment: .topLeading) {
                        TextField("", text: $email)
                            .textFieldStyle(CustomTextFieldStyle())
                            .foregroundColor(.black)
                            .padding(.trailing,20)
                            .padding(.leading,30)
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.black)
                                .offset(y: 10)
                                .padding(.leading,5)
                            
                            Text("Email")
                                .foregroundColor(.black)
                                .background(Color.white)
                                .padding(.leading,20)
                                .offset(y: -10)
                                .bold()
                            
                            
                            // Arka planı beyaz yaparak TextField ile çakışmasını engelliyoruz.
                            
                        }
                        
                    }
                    .background(.white)
                    
                    
                    ZStack(alignment: .topLeading){
                        
                        
                        TextField("", text: $policeNumber)
                            .textFieldStyle(CustomTextFieldStyle())
                            .keyboardType(.numberPad)
                            .foregroundColor(.black)
                            .padding(.trailing,20)
                            .padding(.leading,30)
                            .padding(.top,10)
                        HStack {
                            Image(systemName: "number")
                                .foregroundColor(.black)
                                .offset(y: 20)
                                .padding(.leading,5)
                            
                            Text("Poliçe Numarası")
                                .foregroundColor(.black)
                                .background(Color.white)
                                .padding(.leading,20)
                                .offset(y: -1)
                                .bold()
                            
                            
                            // Arka planı beyaz yaparak TextField ile çakışmasını engelliyoruz.
                            
                        }
                    }
                    .background(.white)
                    
                    
                    
                    ZStack(alignment: .topLeading) {
                        
                        
                        TextField("", text: $phone)
                            .textFieldStyle(CustomTextFieldStyle())
                            .keyboardType(.phonePad)
                            .foregroundColor(.black)
                            .padding(.trailing,20)
                            .padding(.leading,30)
                            .padding(.top,10)
                        
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.black)
                                .offset(y: 20)
                                .padding(.leading,5)
                            
                            Text("Telefon")
                                .foregroundColor(.black)
                                .background(Color.white)
                                .padding(.leading,20)
                                .offset(y: -1)
                                .bold()
                            
                            // Arka planı beyaz yaparak TextField ile çakışmasını engelliyoruz.
                            
                        }
                        
                    }
                    .background(.white)
                    
                    
                    
                    
                    
                    
                }
                Group {
                    ZStack(alignment: .topLeading) {
                        
                        
                        SecureField("", text: $password)
                            .textFieldStyle(CustomTextFieldStyle3())
                            .foregroundColor(.black)
                            .padding(.trailing,20)
                            .padding(.leading,30)
                            .padding(.top,10)
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.black)
                                .offset(y: 20)
                                .padding(.leading,5)
                            
                            Text("Şifre")
                                .foregroundColor(.black)
                                .background(Color.white)
                                .padding(.leading,20)
                                .offset(y: -1)
                                .bold()
                            // Arka planı beyaz yaparak TextField ile çakışmasını engelliyoruz.
                            
                        }
                        
                    }
                    .background(.white)
                    
                    ZStack(alignment: .topLeading) {
                        
                        
                        SecureField("", text: $password2)
                            .textFieldStyle(CustomTextFieldStyle3())
                            .foregroundColor(.black)
                            .padding(.trailing,20)
                            .padding(.leading,30)
                            .padding(.top,10)
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.black)
                                .offset(y: 20)
                                .padding(.leading,5)
                            
                            Text("Şifre Tekrar")
                                .foregroundColor(.black)
                                .background(Color.white)
                                .padding(.leading,20)
                                .offset(y: -1)
                                .bold()
                            
                            // Arka planı beyaz yaparak TextField ile çakışmasını engelliyoruz.
                            
                        }
                        
                    }
                    .background(.white)
                        HStack {
                            Picker("Select City", selection: $viewModel.selectedCityIndex) {
                                ForEach(0 ..< viewModel.cities.count, id: \.self) { index in
                                    Text(viewModel.cities[index].name).tag(index)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                    
                    Group {
                        HStack {
                            Picker("Select District", selection: $viewModel.selectedDistrictId) {
                                ForEach(viewModel.selectedCity?.districts ?? [], id: \.id) { district in
                                    Text(district.name).tag(district.id)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())

                        }
                        
                        
                        ZStack(alignment: .topLeading) {
                            
                            
                            TextField("", text: $address)
                                .textFieldStyle(CustomTextFieldStyle())
                                .foregroundColor(.black)
                                .padding(.trailing,20)
                                .padding(.leading,30)
                            
                            HStack {
                                Image(systemName: "house.fill")
                                    .foregroundColor(.black)
                                    .offset(y: 10)
                                    .padding(.leading,5)
                                
                                Text("Adres")
                                    .foregroundColor(.black)
                                    .background(Color.white)
                                    .padding(.leading,20)
                                    .offset(y: -10)
                                    .bold()
                                // Arka planı beyaz yaparak TextField ile çakışmasını engelliyoruz.
                            }
                            
                            
                        }
                        .background(.white)
                        
                        
                        
                        HStack {
                            Image(systemName: "calendar")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.black)
                                .padding(.leading,5)
                            DatePicker("Doğum Tarihi", selection: $birthDate, displayedComponents: .date)
                                .foregroundColor(.black)
                                .padding()
                                .bold()
                        }
                        .foregroundColor(.black)
                    }
                    .background(.white)
                    Button(action: {
                        
                        
                        if name.isEmpty || surname.isEmpty || email.isEmpty || policeNumber.isEmpty || phone.isEmpty || password.isEmpty || password2.isEmpty || address.isEmpty {
                               self.alertMessage = "Lütfen tüm alanları doldurunuz."
                               self.showAlert = true
                               return
                           }
                           
                           if phone.count != 11 {
                               self.alertMessage = "Telefon numarası 11 karakter olmalıdır."
                               self.showAlert = true
                               return
                           }
                           
                           if policeNumber.count != 10 {
                               self.alertMessage = "Poliçe numarası 10 karakter olmalıdır."
                               self.showAlert = true
                               return
                           }
                           
                           if password != password2 {
                               self.alertMessage = "Şifreler birbiriyle eşleşmiyor."
                               self.showAlert = true
                               return
                           }
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy" // YYYY-MM-DD formatı

                        let formattedBirthDate = dateFormatter.string(from: birthDate)


                           let ageComponents = Calendar.current.dateComponents([.year], from: birthDate, to: Date())
                           if let age = ageComponents.year, age < 18 {
                               self.alertMessage = "18 yaşından büyük olmalısınız."
                               self.showAlert = true
                               return
                           }
                        
                        // PHP script URL'sini buraya ekleyin
                        // ...

                        
                        
                        guard let url = URL(string: "https://www.aiheartech.online/registerios.php") else { return }
                        print("Selected District ID: \(viewModel.selectedDistrictId)")
                        print("District Name: \(viewModel.selectedDistrictName() ?? "Not Found")")
                        var request = URLRequest(url: url)
                        request.httpMethod = "POST"
                        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")  // Header'ı ekleyin.

                        // POST verisini hazırlayın
                        var components = URLComponents()
                        components.queryItems = [
                            URLQueryItem(name: "name", value: name),
                            URLQueryItem(name: "surname", value: surname),
                            URLQueryItem(name: "bloodType", value: viewModel.bloods[selectedBlood]),
                            URLQueryItem(name: "company", value: viewModel.companies[selectedCompany]),
                            URLQueryItem(name: "email", value: email),
                            URLQueryItem(name: "policyNumber", value: policeNumber),
                            URLQueryItem(name: "phone", value: phone),
                            URLQueryItem(name: "password", value: password),
                            URLQueryItem(name: "city", value: viewModel.cities[viewModel.selectedCityIndex].name),
                            URLQueryItem(name: "district", value: viewModel.selectedDistrictName()),
                            
                            URLQueryItem(name: "address", value: address),
                            URLQueryItem(name: "birthDate", value: formattedBirthDate)

                        ]

                        request.httpBody = Data(components.query!.utf8)

                        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                                print("Data alınamadı: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                                return
                            }

                            print("Response: \(responseString)")
                            
                            self.alertMessage = responseString
                            self.showAlert = true

                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                    DispatchQueue.main.async {
                                        if let success = json["success"] as? Bool {
                                            if success {
                                                self.alertMessage = "Veri başarıyla kaydedildi!"
                                            } else if let message = json["message"] as? String {
                                                self.alertMessage = "Hata: \(message)"
                                            }
                                        }
                                        self.showAlert = true
                                    }
                                }
                            } catch let error {
                                print("JSON okuma hatası: \(error.localizedDescription)")
                                DispatchQueue.main.async {
                                    
                                }
                            }
                        }

                        task.resume()


                    }) {
                        ZStack {
                            Text("Kayıt Ol")
                        }
                        .padding()
                        .frame(width: 350, height: 45)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Uyarı"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
                    }
                    .contentShape(Rectangle())
                    .padding()
                    .background(Color.white)
                    
                }
            }
            .background(Color.white)
        }
        
        struct RegistrationView_Previews: PreviewProvider {
            static var previews: some View {
                RegistrationView()
            }
        }
        struct City: Identifiable, Hashable {
            var id: Int
            var name: String
            var districts: [District]
        }

        struct District: Identifiable, Hashable {
            var id: Int
            var name: String
        }

        class CityDistrictViewModel: ObservableObject {
            @Published var companies = ["Axa Sigorta", "Anadolu Sigorta", "Allianz Sigorta"]
            @Published var bloods = ["A +", "A -", "B +", "B -", "AB +", "AB -", "0 +", "0 -"]
            @Published var cities: [City] = []
            

            
            @Published var selectedCity: City? = nil
            @Published var selectedCityIndex = 0 {
                didSet {
                    if cities.indices.contains(selectedCityIndex) {
                        self.selectedCity = cities[selectedCityIndex]
                        // Şehri değiştirdiğimizde, ilçeyi de ilk ilçeye ayarlayalım
                        if let firstDistrict = selectedCity?.districts.first {
                            self.selectedDistrictId = firstDistrict.id
                        }
                    }
                }
            }


            @Published var selectedDistrictId: Int = -1 // Başlangıç değeri olarak -1 atanıyor.

            init() {
                loadCitiesAndDistricts()
                if let firstCity = self.cities.first, let firstDistrict = firstCity.districts.first {
                    self.selectedDistrictId = firstDistrict.id
                }
            }
            func selectedDistrictName() -> String? {
                    return selectedCity?.districts.first(where: { $0.id == selectedDistrictId })?.name
                }
            
            func loadCitiesAndDistricts() {
                guard let path = Bundle.main.path(forResource: "il_ilceler", ofType: "xml") else {
                    print("Dosya yolu bulunamadı!")
                    return
                }
                
                guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return }
                
                let parser = CityDistrictXMLParser(withData: data)
                self.cities = parser.parse()
                self.selectedCity = self.cities.first
            }
        }

        class CityDistrictXMLParser: NSObject, XMLParserDelegate {
            var data: Data
            var cities: [City] = []
            var currentCity: City?
            var currentDistrict: District?
            var currentElement: String?
            var currentValue: String = ""

            init(withData data: Data) {
                self.data = data
            }
            
            
            func parse() -> [City] {
                let parser = XMLParser(data: self.data)
                parser.delegate = self
                parser.parse()
                return cities
            }
            
            func parserDidStartDocument(_ parser: XMLParser) {
                cities.removeAll()
                currentCity = nil
                currentDistrict = nil
            }
            
            func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
                currentElement = elementName
                if elementName == "CITY" {
                    if let cityIdStr = attributeDict["cityid"], let cityId = Int(cityIdStr), let cityName = attributeDict["cityname"] {
                        currentCity = City(id: cityId, name: cityName, districts: [])
                    }
                } else if elementName == "DISTRICT" {
                    currentDistrict = District(id: 0, name: "") // İlçe başlangıcında geçici bir District oluşturalım
                }
            }
            
            func parser(_ parser: XMLParser, foundCharacters string: String) {
                currentValue += string.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
                if currentElement == "DISTID", let districtId = Int(currentValue) {
                    currentDistrict?.id = districtId
                } else if currentElement == "DISTNAME" {
                    currentDistrict?.name = currentValue
                }
                
                if elementName == "CITY" {
                    if let city = currentCity {
                        cities.append(city)
                        currentCity = nil
                    }
                } else if elementName == "DISTRICT" {
                    if let district = currentDistrict, currentCity != nil {
                        currentCity?.districts.append(district)
                        currentDistrict = nil
                    }
                    currentDistrict = nil
                }
                
                currentElement = nil
                currentValue = "" // Reset the current value at the end of each element
            }
        }
        }

