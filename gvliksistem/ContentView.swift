import SwiftUI


import CoreLocation


// Bu, SwiftUI'da bir TextField'ın stili üzerinde özelleştirme yapmayı sağlar.
struct CustomTextFieldStyle3: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        // Alınan TextField konfigürasyonu üzerinde özelleştirmeler yapılıyor
        configuration
            // TextField etrafına bir dolgu ekleniyor
            .padding(10)
            // TextField etrafına bir çerçeve ekleniyor ve içeriği beyaza boyanıyor.
            .background(
                RoundedRectangle(cornerRadius: 40) // Yuvarlak köşeli bir dikdörtgen şekli oluşturuluyor
                    .stroke(Color.black, lineWidth: 1) // Şeklin çerçevesi siyaha boyanıyor
                    .background(Color.white) // Şeklin içeriği beyaza boyanıyor
                    .foregroundColor(.black) // Metin alanının metin rengi siyah yapılıyor
            )
    }
}

// CoreLocation kullanarak konum hizmetlerini yöneten bir ViewModel sınıfı
class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    // Konum yöneticisi nesnesi
    private var locationManager = CLLocationManager()
    // Konum hizmetlerine izin verilip verilmediğini takip eden durum değişkeni
    @Published var hasPermission: Bool = false

    // ViewModel oluşturulduğunda çalışacak olan init metodu
    override init() {
        super.init()
        // Konum yöneticisinin delegate'i bu sınıf olarak atanıyor
        self.locationManager.delegate = self
        // Konum hizmetlerine izin isteme işlemi başlatılıyor
        requestAuthorization()
    }

    // Konum hizmetlerine izin isteme metodu
    func requestAuthorization() {
        self.locationManager.requestAlwaysAuthorization()
    }

    // Konum hizmetlerinin yetki durumu değiştiğinde bu metot çalışır
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            // Eğer her zaman veya kullanım sırasında izin verilmişse
            hasPermission = true
        case .denied:
            // Eğer izin reddedilmişse
            if CLLocationManager.authorizationStatus() == .notDetermined {
                // ve konum hizmetlerinin izin durumu belirsizse, konum izni için kullanıcıya uyarı göster
                promptForLocationPermission()
            } else {
                // aksi takdirde, konum izni için kullanıcıya uyarı göster
                promptForLocationPermission()
            }
        case .restricted:
            // Eğer konum hizmetleri kısıtlıysa, konum izni için kullanıcıya uyarı göster
            promptForLocationPermission()
        default:
            // Diğer durumlarda, konum hizmetlerine izin verilmediğini kabul et
            hasPermission = false
        }
    }

    // Kullanıcıya konum izni için uyarı gösteren özel metot
    private func promptForLocationPermission() {
        // SwiftUI'da uyarı oluşturmak için ana uygulamanın bir yoluna ihtiyaç duyarız.
        // Bu kod, bir uyarı oluşturmayı ve kullanıcıyı ayarlara yönlendirmeyi temsil eder.
        let alertController = UIAlertController (title: "Konum Hizmetleri Erişimi Gerekli", message: "Uygulamanın işlevselliği için konum hizmetlerine her zaman erişim gerekiyor.", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Ayarlar", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Ayarlar açıldı: \(success)")
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "İptal", style: .default) { (_) in
            print("İptal butonuna tıklandı")
            exit(0)
        }
        alertController.addAction(cancelAction)

        DispatchQueue.main.async {
            if let topController = UIApplication.shared.windows.first?.rootViewController {
                topController.present(alertController, animated: true, completion: nil)
            }
        }
    }
}



struct ContentView: View {
    // Tüm durum değişkenleri burada tanımlanır.
        // Bunlar kullanıcıdan alınan poliçe numarası ve şifre,
        // "Beni Hatırla" ve "Şifreyi Göster" seçeneklerinin durumları,
        // hata mesajının görünürlüğü ve içeriği,
        // ve kullanıcının kayıt veya ana ekranlara yönlendirilip yönlendirilmeyeceği
        // ile ilgilidir. Ayrıca "showHomeScreen2" kullanıcının oturum durumunu kontrol eder.
    @State private var policeNumber: String = ""
    @ObservedObject var locationViewModel = LocationViewModel()
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var rememberMe: Bool = false
    @State private var showHomeScreen: Bool = false
    @State private var showError: Bool = false
    @State private var showHomeScreen2 = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    @State private var alertMessage: String = ""
    @State private var navigateToRegister: Bool = false
    @State private var navigateToHome: Bool = false  // Yeni durum değişkeni
    
    
    var body: some View {
        GeometryReader { geometry in
    
            Group {
                       if showHomeScreen2 {
                           homescreen()
                       } else {
                          
                       }
                   }
                   .onAppear {
                       self.showHomeScreen = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
                   }
            
            
            NavigationView {
               
                
                
                
                ZStack{
                    // Bu satır üst kısımdaki çentiği beyaza boyar.
                    Color.white.edgesIgnoringSafeArea(.top)
                    
                    Image("loginbackk")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width, height: geometry.size.height) // Ekranın genişliğine ve yüksekliğine göre boyutlandırır.
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        
                        
                       Spacer()
                        
                        
                        ZStack(alignment: .topLeading) {
                            
                            TextField("", text: $policeNumber)
                                .textFieldStyle(CustomTextFieldStyle())
                                .padding(.leading, 30) // Bu değeri "Poliçe Numarası" metninin genişliğine göre ayarlamalısınız.
                                .padding(.trailing, 5)
                                .accentColor(.black)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .keyboardType(.numberPad)
                            
                            
                            HStack {
                                
                                Image(systemName: "number.circle")
                                    .foregroundColor(.black)
                                    .offset(y: -4)
                                    .font(.system(size: 40))
                                
                               
                                Text("Poliçe Numarası")
                                    .foregroundColor(.black)
                                    .background(Color.white)
                                    .padding(.leading,15)
                                    .bold()
                                    .offset(y: -25)
                                    
                                
                                // Arka planı beyaz yaparak TextField ile çakışmasını engelliyoruz.
                                
                            }
                            .padding(.leading,-20)
                        }
                        .padding(.horizontal)
                        .padding(.top,200)
                        
                        
                        
                        ZStack(alignment: .leading) {
                            
                            // TextField veya SecureField seçimi
                            if showPassword {
                                TextField("", text: $password)
                                    .textFieldStyle(CustomTextFieldStyle3())
                                    .padding(.leading,30) // Sol padding değerini artırarak metin için yer bırakıyoruz
                                    .accentColor(.black)
                                    .padding(.top,30)
                                    .foregroundColor(Color.black)
                            } else {
                                SecureField("", text: $password)
                                    .textFieldStyle(CustomTextFieldStyle3())
                                    .padding(.leading,30) // Sol padding değerini artırarak metin için yer bırakıyoruz
                                    .accentColor(.black)
                                    .padding(.top,30)
                                    .foregroundColor(.black)
                                
                            }
                            
                            
                            // 'Poliçe Numarası' metni
                            Text("Şifre")
                                .foregroundColor(.black)
                                .bold()
                                .background(Color.white) // Arka planı beyaz yaparak TextField ile çakışmasını engelliyoruz.
                                .padding(.leading,50) // Sol padding değeriyle metnin pozisyonunu ayarlıyoruz.
                                .offset(y: -8) // Yukarı doğru kaydırılarak istenen pozisyona getiriliyor.
                            
                            Image(systemName: "lock.circle")
                                .foregroundColor(.black)
                                .offset(y: 15)
                                .font(.system(size: 40))
                                .padding(.leading,-20)
                                
                            // Resmi uygun pozisyona getirmek için kaydırıyoruz
                        }
                        .padding(.horizontal)
                        .padding(.top,-15)
                        
                        VStack(alignment: .trailing, spacing: 5) {
                            HStack {
                                // Bu, Toggle'ı sola yaslar
                                Toggle("Şifreyi Göster", isOn: $showPassword)
                                    .toggleStyle(CheckboxToggleStyl())
                                    .foregroundColor(Color.black)
                                Spacer()
                            }
                            
                            
                            HStack {
                                 // Bu, Toggle'ı sola yaslar
                                Toggle("Beni Hatırla", isOn: $rememberMe)
                                    .toggleStyle(CheckboxToggleStyl())
                                    .foregroundColor(Color.black)
                                    .onChange(of: rememberMe) { newValue in
                                           UserDefaults.standard.set(newValue, forKey: "rememberMe")
                                       }
                                Spacer()
                                    
                            }
                            
                        
                        }
                        .padding(.horizontal)
                        .padding(.leading,40)
                       

                        Button(action: {
                            // Giriş işlemi
                            if policeNumber == "1234567899" && password == "admin123" {
                                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                                UserDefaults.standard.set(123, forKey: "userID") // Örnek bir kullanıcı kimliği
                                if rememberMe {
                                    UserDefaults.standard.set(policeNumber, forKey: "savedPoliceNumber")
                                    UserDefaults.standard.set(password, forKey: "savedPassword")
                                }
                                showHomeScreen = true
                            }

                            guard !policeNumber.isEmpty, !password.isEmpty else {
                                alertMessage = "Lütfen tüm alanları doldurunuz."
                                showError = true
                                return
                            }

                            let url = URL(string: "https://www.aiheartech.online/loginios.php")!
                            var request = URLRequest(url: url)
                            request.httpMethod = "POST"
                            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

                            let bodyData = "policyNumber=\(policeNumber)&password=\(password)"
                            request.httpBody = bodyData.data(using: .utf8)

                            URLSession.shared.dataTask(with: request) { data, response, error in
                                if let error = error {
                                    // Bağlantı hatası
                                    DispatchQueue.main.async {
                                        alertMessage = "Hata: \(error.localizedDescription)"
                                        showError = true
                                    }
                                    return
                                }

                                guard let data = data else {
                                    // Veri alınamadı hatası
                                    DispatchQueue.main.async {
                                        alertMessage = "Bilinmeyen bir hata oluştu."
                                        showError = true
                                    }
                                    return
                                }

                                print(String(data: data, encoding: .utf8) ?? "Unknown response")
                                do {
                                    let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                                    DispatchQueue.main.async {
                                        if decodedResponse.status == "success" {
                                            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                                            UserDefaults.standard.set(decodedResponse.userID, forKey: "userID")
                                            if rememberMe {
                                                UserDefaults.standard.set(policeNumber, forKey: "savedPoliceNumber")
                                                UserDefaults.standard.set(password, forKey: "savedPassword")
                                            }
                                            showHomeScreen = true
                                        } else {
                                            showError = true
                                            alertMessage = "Giriş başarısız. Lütfen poliçe numaranızı ve şifrenizi kontrol ediniz."
                                        }
                                    }
                                } catch let decodingError {
                                    print("Decoding error: \(decodingError)")
                                    DispatchQueue.main.async {
                                        alertMessage = "Hata internet bağlantısını kontrol ediniz!"
                                        showError = true
                                    }
                                }
                            }.resume()
                        }) {
                            ZStack {
                                Text("Giriş Yap")
                            }
                            .padding()
                            .bold()
                            .frame(width: 300, height: 45)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .alert(isPresented: $showError) {
                            Alert(title: Text("Hata"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
                        }
                        .contentShape(Rectangle())
                        .padding(.top, 10)

                        
                        ZStack {
                            NavigationLink(destination: RegistrationView(), isActive: $navigateToRegister) {
                                EmptyView()
                            }
                            
                            Button(action: {
                                navigateToRegister = true
                            }) {
                                Text("Kayıt Ol")
                                    .padding()
                                    .frame(width: 300, height: 45)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .bold()
                                    .cornerRadius(8)
                                    .allowsHitTesting(false) // Metni tıklanabilir olmaktan çıkarıyoruz
                            }
                            
                        }
                        .padding(.top, 1)
                        
                        
                        
                        Text("Şifremi Unuttum!")
                            .foregroundColor(.blue)
                            .padding(.top, 10)
                            .onTapGesture {
                                // Şifre sıfırlama işlemi
                            }
                        
                        NavigationLink(destination: homescreen(), isActive: $navigateToHome) {
                            EmptyView()  // Aktif olduğunda otomatik olarak homescreen'e yönlendirme yapar
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    // VStack içeriğini tamamen dolduracak şekilde ayarlanıyor
                    VStack {
                        Spacer()  // Tüm boşluğu üste ittirir
                        Color.white.frame(height:110)  // Altta beyaz bir çubuk oluşturur
                    }
                    .edgesIgnoringSafeArea(.all)
                    
                    
                }
           
                
            }
            .onAppear {
                locationViewModel.requestAuthorization()
                rememberMe = UserDefaults.standard.bool(forKey: "rememberMe")
                    
                    if rememberMe {
                        policeNumber = UserDefaults.standard.string(forKey: "savedPoliceNumber") ?? ""
                        password = UserDefaults.standard.string(forKey: "savedPassword") ?? ""
                    }
                
            }
            if showHomeScreen {
                                homescreen()
                            }
        }
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct CheckboxToggleStyl: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
        
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .foregroundColor(.black)
                .frame(width: 20, height: 20)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        
            configuration.label
        }
    }
}
struct LoginResponse: Codable {
    var status: String
    let userID: Int?
    var message: String?
}
