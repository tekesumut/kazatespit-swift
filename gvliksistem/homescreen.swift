import SwiftUI
import CoreLocation
import UserNotifications
import CoreMotion
import Combine


class BackgroundShakeDetector: NSObject, UNUserNotificationCenterDelegate {
    // Singleton instance
    private var isNotificationSent = false

    static let shared = BackgroundShakeDetector()
    var shakeDetectedSubject = PassthroughSubject<Void, Never>()
    
    private var motionManager: CMMotionManager?
    
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    override init() {
        super.init()
    
        UNUserNotificationCenter.current().delegate = self
    }
    
    func sendNotification() {
        guard !isNotificationSent else { return } // Bildirim daha önce gönderildiyse çıkış yap
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Sallama Algılandı!"
        content.body = "Uygulamanız sallama algıladı."
        content.sound = .default
        content.categoryIdentifier = "shakeNotificationCategory"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        // Bildirime tıklanınca messagescreen() açılacak
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
        
        isNotificationSent = true // Bildirim gönderildiğini işaretle
    }

    
    
    func startMonitoring() {
        motionManager = CMMotionManager()
        
        if motionManager!.isAccelerometerAvailable {
            motionManager!.accelerometerUpdateInterval = 0.1
            motionManager!.startAccelerometerUpdates(to: OperationQueue.current!) { [weak self] (data, error) in
                guard let strongSelf = self else { return }
                if let acceleration = data?.acceleration {
                    if abs(acceleration.x) > 2.5 || abs(acceleration.y) > 2.5 || abs(acceleration.z) > 2.5 {
                       
                            strongSelf.sendNotification()
                
                        
                    }
                }
            }
            
            backgroundTask = UIApplication.shared.beginBackgroundTask {
                UIApplication.shared.endBackgroundTask(self.backgroundTask)
                self.backgroundTask = .invalid
            }
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Bildirime tıklandı!")

        // Bildirime tıklanıldığında Messagescreen'i göstermek için bir bağlantı oluşturun.
        let messagescreenView = messagescreen()

        // Ana ekranı değiştirin ve Messagescreen'i gösterin.
        if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.rootViewController = UIHostingController(rootView: messagescreenView)
        }

        completionHandler()
    }

    
   
    func stopMonitoring() {
        motionManager?.stopAccelerometerUpdates()
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            backgroundTask = .invalid
        }
    }
}



    
    // Bu class, kullanıcının konum erişim izni durumunu kontrol eder ve yönetir.
    class LocationViewModel2: NSObject, ObservableObject, CLLocationManagerDelegate {
        // CoreLocation kütüphanesini kullanarak kullanıcının konum bilgisine erişmeyi sağlar.
        private var locationManager = CLLocationManager()
        
        // Kullanıcının konum izni olup olmadığını belirten bir boolean değişken.
        @Published var hasPermission: Bool = false
        @Published var currentSpeed: CLLocationSpeed? = nil  // Kullanıcının şuanki hızı
        
        override init() {
            super.init()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            self.locationManager.distanceFilter = kCLDistanceFilterNone
            
            // İzin durumunu kontrol et
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                requestAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                self.locationManager.startUpdatingLocation()
            default:
                break
            }
        }
        
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let newLocation = locations.last else { return }
            print("Yeni konum güncellendi: \(newLocation)")
            currentSpeed = max(newLocation.speed, 0)
            
            UserDefaults.standard.set(currentSpeed, forKey: "currentSpeed")
        }
        
        
        func requestNotificationPermission() {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                if granted {
                    print("Bildirim izinleri alındı")
                } else {
                    print("Bildirim izinleri reddedildi")
                }
            }
        }
        
        // Kullanıcıdan konum izni istemek için bu fonksiyon kullanılır.
        func requestAuthorization() {
            self.locationManager.startUpdatingLocation()
            self.locationManager.requestAlwaysAuthorization()
        }
        
        
        // Kullanıcının konum izni durumunda değişiklik olması durumunda bu fonksiyon çağrılır.
        // Konum izni durumu kontrol edilir ve `hasPermission` değişkeni buna göre güncellenir.
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                hasPermission = true
            case .denied:
                if CLLocationManager.authorizationStatus() == .notDetermined {
                    promptForLocationPermission()
                } else {
                    promptForLocationPermission()
                }
            case .restricted:
                promptForLocationPermission()
            default:
                hasPermission = false
            }
        }
        
        
        
        // Kullanıcının konum izni olmaması durumunda bir uyarı oluşturulur ve kullanıcıyı ayarlar ekranına yönlendirmek için bu fonksiyon kullanılır.
        private func promptForLocationPermission() {
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
    
    
    
    
    
    
    // Ana ekranı temsil eden bir SwiftUI görünümü
    struct homescreen: View {
        let shakeDetector = BackgroundShakeDetector.shared
        @State private var cancellables = Set<AnyCancellable>()
        // Sallama durumunu takip eden durum değişkeni
        @State private var isShaken: Bool = false
        // Kullanıcının belirli bir seçeneği işaretleyip işaretlemediğini kontrol eden durum değişkenleri
        @State private var checkBox1IsChecked: Bool = UserDefaults.standard.bool(forKey: "checkBox1IsChecked")
        @State private var checkBox2IsChecked: Bool = UserDefaults.standard.bool(forKey: "checkBox2IsChecked")
        // Sallama algılamayı yöneten bir UIViewController nesnesi
        @State private var shakeDetectorVC: ShakeDetectingViewController = ShakeDetectingViewController()
        // Konum verilerini yönetmek için kullanılan bir ViewModel nesnesi
        @ObservedObject var locationViewModel = LocationViewModel2()
        
     
        // Görünümün ana gövdesi
        var body: some View {
            
            
            // Üst üste bindirilmiş (ZStack) görünümler
            ZStack {
                // Eğer cihaz sallanırsa, MessageScreen'i göster
                if isShaken {
                    if checkBox2IsChecked && checkBox1IsChecked {
                        if let speed = locationViewModel.currentSpeed, speed > 20.0 {
                            // Hız 10 m/s üzerinde ise bu bloğu çalıştır
                            
                            messagescreen()
                        } else {
                            MainContentView()
                        }
                        
                        
                    }
                    else if checkBox1IsChecked {
                        
                        if let speed = locationViewModel.currentSpeed, speed > 20.0 {
                            // Hız 10 m/s üzerinde ise bu bloğu çalıştır
                            
                            messagescreen()
                        } else {
                            MainContentView()
                        }
                        
                    }
                    else if checkBox2IsChecked {
                        
                        messagescreen()
                        
                    }
                    
                } else {
                    // Eğer cihaz sallanmıyorsa, MainContentView'i göster
                    MainContentView()
                }
                
                // Sallama dedektörünün kontrolünü sağlayan UIKit kontrolcüsünü entegre ediyoruz
                ShakeDetectorController(isShaken: $isShaken, controller: shakeDetectorVC)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .allowsHitTesting(false)
                // Görünüm göründüğünde, sallama hassasiyetini kontrol et
                    .onAppear {
                        if checkBox1IsChecked && !checkBox2IsChecked {
                            shakeDetectorVC.sensitivity = 1.0
                        } else if checkBox2IsChecked && !checkBox1IsChecked {
                            shakeDetectorVC.sensitivity = 1.0
                        } else if !checkBox1IsChecked && !checkBox2IsChecked {
                            shakeDetectorVC.sensitivity = 0.0
                        } else {
                            shakeDetectorVC.sensitivity = 0.75
                        }
                    }
                    }
            }
                  
                    

        }
    
    
    // Sistem durumunu gösteren bir görüntü
    struct SystemStateImage: View {
        var checkBox1IsChecked: Bool
        var checkBox2IsChecked: Bool
        
        var body: some View {
            // Eğer her iki kutu da işaretli değilse, sistem kapalı görüntüsünü göster
            if !checkBox1IsChecked && !checkBox2IsChecked {
                Image("sistemkapali")
                    .resizable()
                    .scaledToFit()
                    .edgesIgnoringSafeArea(.all)
            } else {
                // Eğer herhangi bir kutu işaretliyse, sistem açık görüntüsünü göster
                Image("sistemacik")
                    .resizable()
                    .scaledToFit()
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    // Ana içerik görünümü
    struct MainContentView: View {
        private let shakeDetector = BackgroundShakeDetector()
        
        // Ayarlar ekranını göstermek için kullanılan durum değişkeni
        @State private var showSettingsScreen = false
        // Ana içerik görünümüne yönlendirme durumunu kontrol eden durum değişkeni
        @State private var navigateToContentView: Bool = false
        // Kullanıcının belirli bir seçeneği işaretleyip işaretlemediğini kontrol eden durum değişkenleri
        @State private var checkBox1IsChecked: Bool = UserDefaults.standard.bool(forKey: "checkBox1IsChecked")
        @State private var checkBox2IsChecked: Bool = UserDefaults.standard.bool(forKey: "checkBox2IsChecked")
        // Oturum açma durumunu kontrol etmek için kullanılan durum değişkeni
        @State private var showHomeScreen = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        // Çıkış onayını kontrol etmek için kullanılan durum değişkeni
        @State private var showLogoutConfirmation = false
        // Konum verilerini yönetmek için kullanılan bir ViewModel nesnesi
        @ObservedObject var locationViewModel = LocationViewModel2()
        
        // Görünümün ana gövdesi
        var body: some View {
            
            NavigationView {
                ZStack {
                    SystemStateImage(checkBox1IsChecked: checkBox1IsChecked, checkBox2IsChecked: checkBox2IsChecked)
                    
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                showLogoutConfirmation = true
                            }) {
                                Image("logouticon")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                            .alert(isPresented: $showLogoutConfirmation) {
                                Alert(
                                    title: Text("Çıkış Yap"),
                                    message: Text("Çıkış yapmak istediğinize emin misiniz?"),
                                    primaryButton: .default(Text("Evet")) {
                                        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
                                        showHomeScreen = false
                                        navigateToContentView = true
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                            Spacer().frame(width: 20)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Spacer()
                            HStack {
                                HizGostergesi(speed: locationViewModel.currentSpeed)
                                    .padding(.leading)
                                    .padding(.bottom,70)
                                Spacer()
                            }
                            .padding(.top)
                        }
                        .padding(.top)
                        
                        Spacer()
                        
                        NavigationLink(
                            destination: ContentView().navigationBarBackButtonHidden(true),
                            isActive: $navigateToContentView
                        ) {
                            EmptyView()
                        }
                        .hidden()
                    }
                    
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            NavigationLink(
                                destination: SettingsScreen(),
                                isActive: $showSettingsScreen
                            ) {
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(Color.black)
                                    .padding(.bottom, 90)
                            }
                            .padding(.trailing)
                        }
                    }
                    
                }
                .background(Color.white)
            }
            .onAppear {
                locationViewModel.requestAuthorization()
                locationViewModel.requestNotificationPermission()
                shakeDetector.startMonitoring()
                
            }
        }
    }
    
    struct HizGostergesi: View {
        var speed: CLLocationSpeed?
        
        var body: some View {
            let displayText: String
            if let currentSpeed = speed, currentSpeed * 3.6 >= 15 {
                displayText = String(Int(currentSpeed * 3.6))
            } else {
                displayText = "-"
            }
            
            return ZStack {
                Circle()
                    .stroke(lineWidth: 4)
                    .foregroundColor(Color.red)
                    .frame(width: 130, height: 130)
                
                Text(displayText)
                    .font(.largeTitle)
                    .foregroundColor(Color.black)
            }
            .padding(.top)
        }
    }
    
    
    
    // Bir UIViewControllerRepresentable yapısı. Bu, SwiftUI ile UIKit'ı birleştirmeyi sağlar.
    struct ShakeDetectorController: UIViewControllerRepresentable {
        // Sallama durumunu kontrol eden durum değişkeni
        @Binding var isShaken: Bool
        // Sallama detektörü kontrolcüsü
        var controller: ShakeDetectingViewController
        
        // ShakeDetectingViewController örneği oluşturma
        func makeUIViewController(context: Context) -> ShakeDetectingViewController {
            // Sallama işlemi tetiklendiğinde çalıştırılacak işlemi belirler
            controller.shakeHandler = {
                isShaken = true
            }
            return controller
        }
        // SwiftUI, UIViewControllerRepresentable nesnesini güncellerken bu yöntem çağrılır
        func updateUIViewController(_ uiViewController: ShakeDetectingViewController, context: Context) {}
    }
    
    // Sallamayı algılayan bir UIKit kontrolcüsü
    class ShakeDetectingViewController: UIViewController {
        // Sallama işlemi tetiklendiğinde çalıştırılacak işlem
        var shakeHandler: (() -> Void)?
        // Sallamanın hassasiyetini kontrol eden değişken
        var sensitivity: Double = 1.0
        
        // Eğer hareket sallama hareketiyse ve hassasiyet > 0.5 ise, shakeHandler'ı tetikle
        override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            if motion == .motionShake && sensitivity > 0.5 {
                shakeHandler?()
            }
          
            }
        
        
        // ViewController'ın first responder olmasını sağlar
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            self.becomeFirstResponder()
        }
        
        // Bu view controller'ın first responder olabileceğini belirtir.
        override var canBecomeFirstResponder: Bool {
            return true
        }
    }
    
    // Önizleme amaçlı bir struct
    struct homescreen_Previews: PreviewProvider {
        static var previews: some View {
            homescreen()
        }
    }
    
    // İkinci bir önizleme struct'ı
    struct ContentView_Previews2: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

struct MessagescreenLink: View {
    var body: some View {
        NavigationLink("", destination: messagescreen())
            .hidden()
    }
}


