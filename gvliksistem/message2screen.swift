import SwiftUI
import CoreLocation

// Ekran yapısını temsil eden View
struct message2screen: View {
    // Kullanıcı arayüz durumunu izlemek ve depolamak için @State özelliği
    @State private var showAlert: Bool = false
    @State private var navigateToHome: Bool = false
    @State private var checkBox1IsChecked: Bool = UserDefaults.standard.bool(forKey: "checkBox1IsChecked")
    @State private var checkBox2IsChecked: Bool = UserDefaults.standard.bool(forKey: "checkBox2IsChecked")

    // Kullanıcı konumunu izlemek için kullanılan LocationManager
    @StateObject var locationManager = LocationManager()
    @State var intUserID: Int = UserDefaults.standard.integer(forKey: "userID") // kullanıcının ID'si
    
    var body: some View {
        ZStack {
            // Arka planın beyaz olmasını sağlar
            Color.white.edgesIgnoringSafeArea(.all)
                        
            VStack {
                // Beyaz renkte boşluk oluşturur
                Spacer()
                Color.white.frame(height: 450)
            }
            .edgesIgnoringSafeArea(.all)
            
            // Arkaplan için görüntü ekler
            Image("message2back")
                .resizable()
                .scaledToFit()
                .edgesIgnoringSafeArea(.all)
            
            // Buttonların bulunduğu yer
            VStack(spacing: 20) {
                // "Tamam" butonu
                Button(action: {
                    // Butona basıldığında anasayfaya yönlendirir
                    self.navigateToHome = true
                    navigateToHome = true
                }) {
                    // Butonun tasarımı
                    Text("Tamam")
                        .foregroundColor(.white)
                        .padding()
                        .font(.system(size: 35, weight: .bold))
                        .frame(width: 350, height: 80)
                        .background(Color.green)
                        .cornerRadius(40)
                }.fullScreenCover(isPresented: $navigateToHome, content: homescreen.init)
      
                // "İptal Et" butonu
                Button(action: {
                    // Butona basıldığında uyarı gösterir
                    showAlert = true
                }) {
                    // Butonun tasarımı
                    Text("İptal Et")
                        .foregroundColor(.white)
                        .padding()
                        .font(.system(size: 35, weight: .bold))
                        .frame(width: 350, height: 80)
                        .background(Color.red)
                        .cornerRadius(40)
                }
            }
            .padding(.top, 300)
            .frame(maxWidth: 300)
            
            VStack {
                Spacer()
                Color.white.frame(height: 40)
            }
            .edgesIgnoringSafeArea(.all)
            
            // Anasayfaya yönlendirme durumu
            if navigateToHome {
                homescreen()
            }
        }
        // Uyarı penceresi
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Emin misiniz?"),
                message: Text("Bu işlemi gerçekten yapmak istiyor musunuz?"),
                // "Evet" seçeneği tıklandığında servera veri gönderir ve anasayfaya yönlendirir
                primaryButton: .default(Text("Evet"), action: {
                    if checkBox1IsChecked {
                        sendToServer(intUserID: intUserID, locationManager: locationManager, tespit: "Kaza Tespiti")
                        
                    } else if checkBox2IsChecked {
                        sendToServer(intUserID: intUserID, locationManager: locationManager, tespit: "Düşme Tespiti")
                        
                    }
                    navigateToHome = true
                    showAlert = false
                }),
                // "Hayır" seçeneği tıklandığında hiçbir şey yapmaz
                secondaryButton: .cancel(Text("Hayır"))
            )
        }
    }
}

// Önizleme sağlar
struct message2screen_Previews: PreviewProvider {
    static var previews: some View {
        message2screen()
    }
}

// Servera veri gönderme fonksiyonu
func sendToServer(intUserID: Int, locationManager: LocationManager, tespit: String) {
    guard let latitude = locationManager.lastLocation?.coordinate.latitude,
          let longitude = locationManager.lastLocation?.coordinate.longitude else { return }
    guard let currentSpeed3 = locationManager.currentSpeed3 else { return }
    
    
    let url = URL(string: "https://www.aiheartech.online/bildirimlerios.php")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let currentDate = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    let tarih = formatter.string(from: currentDate)
    formatter.dateFormat = "HH:mm:ss"
    let saat = formatter.string(from: currentDate)
    let durum = 3
    // Tespit değerini de postString'e ekleyin
    let postString = "id=\(intUserID)&Tarih=\(tarih)&Saat=\(saat)&Koordinat=\(latitude),\(longitude)&Durum=\(durum)&Tespit=\(tespit)&Hiz=\(currentSpeed3)"
    request.httpBody = postString.data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let data = data else { return }
        let responseString = String(data: data, encoding: .utf8)
        print("response: \(responseString)")
    }
    
    task.resume()
}


// Konum yöneticisi sınıfı
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
   private let locationManager = CLLocationManager()
    @Published var currentSpeed3: CLLocationSpeed?
   @Published var lastLocation: CLLocation!
   
   // Konum yöneticisini başlatır
   override init() {
       super.init()
       
       self.locationManager.delegate = self
       self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
       self.locationManager.requestWhenInUseAuthorization()
       self.locationManager.startUpdatingLocation()
       self.locationManager.startUpdatingHeading()
   }
   
   // Konum güncellendiğinde son konumu kaydeder
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       lastLocation = locations.first
       if let newLocation = locations.last {
           // Kullanıcının anlık hızını alın 
           currentSpeed3 = newLocation.speed
       }
   }
}
