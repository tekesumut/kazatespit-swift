import SwiftUI
import CoreLocation



struct messagescreen: View {
    @State private var displayedText: String = "Buraya bir mesaj yazabilirsiniz."
    @State private var currentScreen: Screen = .main
    @State private var showSafetyAlert: Bool = false
    @State private var timerValue: Int = 60
    @State private var timer: Timer? = nil
    @State private var circleScale: CGFloat = 1.0
    
    @State private var opacityValue: Double = 1.0
    @State private var checkBox1IsChecked: Bool = UserDefaults.standard.bool(forKey: "checkBox1IsChecked")
    @State private var checkBox2IsChecked: Bool = UserDefaults.standard.bool(forKey: "checkBox2IsChecked")
    @State private var currentSpeed: Float = UserDefaults.standard.float(forKey: "currentSpeed")
    @StateObject var locationManager = LocationManager2()
    @State var intUserID: Int = UserDefaults.standard.integer(forKey: "userID")
    enum Screen {
        case main, home, message2
    }

    var body: some View {
        
        
       
        GeometryReader { geometry in
            ZStack {
                if currentScreen == .main {
                    ZStack {
                        Image("messageback")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .edgesIgnoringSafeArea(.all)
                        
                        VStack(spacing: 20) {
                            Button(action: {
                                self.timer?.invalidate()
                                self.timer = nil
                                currentScreen = .message2
                                if checkBox1IsChecked {
                                    sendToServer2(intUserID: intUserID, locationManager: locationManager, tespit: "Kaza Tespiti")
                                   
                                    showSafetyAlert = false
                                } else if checkBox2IsChecked {
                                    sendToServer2(intUserID: intUserID, locationManager: locationManager, tespit: "Düşme Tespiti")
                                    
                                    showSafetyAlert = false
                                }
                            }) {
                                Text("Kaza Oldu")
                                    .foregroundColor(.white)
                                    .padding()
                                    .font(.system(size: 35, weight: .bold, design: .serif))
                                    .frame(width: 350, height: 80)
                                    .background(Color.red)
                                    .cornerRadius(40)
                            }
                            .padding(.top, 280)
                            
                            Button(action: {
                              
                                showSafetyAlert = true
                            }) {
                                Text("Güvendeyiz")
                                    .foregroundColor(.white)
                                    .padding()
                                    .font(.system(size: 35, weight: .bold, design: .serif))
                                    .frame(width: 350, height: 80)
                                    .background(Color.green)
                                    .cornerRadius(40)
                            }
                            ZStack {
                                Circle()
                                    .strokeBorder(Color.red, lineWidth: 6)
                                    .frame(width: 135, height: 135)
                                    .scaleEffect(circleScale)
                                    .onAppear {
                                        withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                                            circleScale = 1.05
                                        }
                                    }

                                Text("\(timerValue)")
                                    .font(.system(size: 80, weight: .bold, design: .serif))
                                    .foregroundColor(Color.black)
                                    .opacity(opacityValue)
                                    .onAppear {
                                        withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                                            opacityValue = 0.5
                                        }
                                    }
                            }
                        }
                        .padding()
                        .frame(maxWidth: 300)
                        
                        // alt kısma beyaz bir görünüm ekleyin
                        VStack {
                            Spacer()
                            Color.white.frame(height: 20)
                        }
                        .edgesIgnoringSafeArea(.all)
                    }
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.all)
                    .alert(isPresented: $showSafetyAlert) {
                        Alert(
                            title: Text("Emin misiniz?"),
                            message: Text("Bu işlemi gerçekten yapmak istiyor musunuz?"),
                            primaryButton: .default(Text("Evet"), action: {
                                
                                
                                if checkBox1IsChecked {
                                    sendToServer3(intUserID: intUserID, locationManager: locationManager, tespit: "Kaza Tespiti")
                                    currentScreen = .home
                                    showSafetyAlert = false
                                } else if checkBox2IsChecked {
                                    sendToServer3(intUserID: intUserID, locationManager: locationManager, tespit: "Düşme Tespiti")
                                    currentScreen = .home
                                    showSafetyAlert = false
                                }

                                
                            }),
                            secondaryButton: .cancel(Text("Hayır"), action: {
                                        self.showSafetyAlert = false
                                    })
                        
                        )
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // 10 saniye sonra
                            if checkBox1IsChecked {
                                sendToServer4(intUserID: intUserID, locationManager: locationManager, tespit: "Kaza Tespiti", currentSpeed: currentSpeed)
                                
                            } else if checkBox2IsChecked {
                                sendToServer4(intUserID: intUserID, locationManager: locationManager, tespit: "Düşme Tespiti", currentSpeed: currentSpeed)
                                
                            }
                            }
                            startTimer()
                    }
                    .onDisappear {
                        timer?.invalidate()
                        timer = nil
                    }
                } else if currentScreen == .home {
                    homescreen() // Eğer bu bir view ise burada doğrudan gösterilir.
                } else if currentScreen == .message2 {
                    message2screen() // Eğer bu bir view ise burada doğrudan gösterilir.
                }
            }
        }
    
    }
    func startTimer() {
        timer?.invalidate()
        timerValue = 60
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timerValue > 0 {
                timerValue -= 1
            } else {
                timer?.invalidate()
                timer = nil
                currentScreen = .message2
                if checkBox1IsChecked {
                    sendToServer5(intUserID: intUserID, locationManager: locationManager, tespit: "Kaza Tespiti")
                    currentScreen = .home
                    showSafetyAlert = false
                } else if checkBox2IsChecked {
                    sendToServer5(intUserID: intUserID, locationManager: locationManager, tespit: "Düşme Tespiti")
                    currentScreen = .home
                    showSafetyAlert = false
                }
                
            }
        }
    }
}
func sendToServer2(intUserID: Int, locationManager: LocationManager2, tespit: String) {
    guard let latitude = locationManager.lastLocation?.coordinate.latitude,
          let longitude = locationManager.lastLocation?.coordinate.longitude else { return }
    guard let currentSpeed2 = locationManager.currentSpeed2 else { return }

    
    let url = URL(string: "https://www.aiheartech.online/bildirimlerios.php")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let currentDate = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    let tarih = formatter.string(from: currentDate)
    formatter.dateFormat = "HH:mm:ss"
    let saat = formatter.string(from: currentDate)
    let durum = 1
    // Tespit değerini de postString'e ekleyin
    let postString = "id=\(intUserID)&Tarih=\(tarih)&Saat=\(saat)&Koordinat=\(latitude),\(longitude)&Durum=\(durum)&Tespit=\(tespit)&Hiz=\(currentSpeed2)"
    request.httpBody = postString.data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let data = data else { return }
        let responseString = String(data: data, encoding: .utf8)
        print("response: \(responseString)")
    }
    
    task.resume()
}


class LocationManager2: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var currentSpeed2: CLLocationSpeed?
    @Published var lastLocation: CLLocation!

    override init() {
        super.init()

        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
        self.manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
        self.manager.startUpdatingHeading()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.first
        if let newLocation = locations.last {
            // Kullanıcının anlık hızını alın
            currentSpeed2 = newLocation.speed
        }
    }
}
//-----------------------Güvendeyiz
func sendToServer3(intUserID: Int, locationManager: LocationManager2, tespit: String) {
    guard let latitude = locationManager.lastLocation?.coordinate.latitude,
          let longitude = locationManager.lastLocation?.coordinate.longitude else { return }
    guard let currentSpeed2 = locationManager.currentSpeed2 else { return }

    
    let url = URL(string: "https://www.aiheartech.online/bildirimlerios.php")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let currentDate = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    let tarih = formatter.string(from: currentDate)
    formatter.dateFormat = "HH:mm:ss"
    let saat = formatter.string(from: currentDate)
    let durum = 2
    // Tespit değerini de postString'e ekleyin
    let postString = "id=\(intUserID)&Tarih=\(tarih)&Saat=\(saat)&Koordinat=\(latitude),\(longitude)&Durum=\(durum)&Tespit=\(tespit)&Hiz=\(currentSpeed2)"
    request.httpBody = postString.data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let data = data else { return }
        let responseString = String(data: data, encoding: .utf8)
        print("response: \(responseString)")
    }
    
    task.resume()
}

//------------------------ilk algılama
func sendToServer4(intUserID: Int, locationManager: LocationManager2, tespit: String, currentSpeed: Float) {
    guard let latitude = locationManager.lastLocation?.coordinate.latitude,
          let longitude = locationManager.lastLocation?.coordinate.longitude else { return }
    
    let url = URL(string: "https://www.aiheartech.online/bildirimlerios.php")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let currentDate = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    let tarih = formatter.string(from: currentDate)
    formatter.dateFormat = "HH:mm:ss"
    let saat = formatter.string(from: currentDate)
    let durum = 0
    // Tespit değerini de postString'e ekleyin
    let postString = "id=\(intUserID)&Tarih=\(tarih)&Saat=\(saat)&Koordinat=\(latitude),\(longitude)&Durum=\(durum)&Tespit=\(tespit)&Hiz=\(currentSpeed)"
    request.httpBody = postString.data(using: .utf8)
    print("Tespit değeri: \(tespit)")

    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        // Eğer başarılı bir cevap alırsak, bu cevabı yazdıralım
        guard let data = data else {
            print("Data alınamadı!")
            return
        }
        let responseString = String(data: data, encoding: .utf8)
        print("response: \(responseString)")
        if let error = error {
            print("Hata oluştu: \(error.localizedDescription)")
            return
        }
    }
    
    task.resume()
}



func sendToServer5(intUserID: Int, locationManager: LocationManager2, tespit: String) {
    guard let latitude = locationManager.lastLocation?.coordinate.latitude,
          let longitude = locationManager.lastLocation?.coordinate.longitude else { return }
    guard let currentSpeed2 = locationManager.currentSpeed2 else { return }

    
    let url = URL(string: "https://www.aiheartech.online/bildirimlerios.php")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let currentDate = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    let tarih = formatter.string(from: currentDate)
    formatter.dateFormat = "HH:mm:ss"
    let saat = formatter.string(from: currentDate)
    let durum = 4
    // Tespit değerini de postString'e ekleyin
    let postString = "id=\(intUserID)&Tarih=\(tarih)&Saat=\(saat)&Koordinat=\(latitude),\(longitude)&Durum=\(durum)&Tespit=\(tespit)&Hiz=\(currentSpeed2)"
    request.httpBody = postString.data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let data = data else { return }
        let responseString = String(data: data, encoding: .utf8)
        print("response: \(responseString)")
    }
    
    task.resume()
}


