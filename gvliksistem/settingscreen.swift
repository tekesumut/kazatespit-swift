import SwiftUI

// Bu bir ToggleStyle tanımıdır. Checkbox görünümünü sağlamak için kullanılır.
struct CheckboxToggleStyle2: ToggleStyle {
    // Toggle için bir View oluşturur. Bu View kullanıcıya gösterilir.
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(configuration.isOn ? .blue : .gray)
            .onTapGesture { // Toggle'a tıklama olayını kontrol eder
                configuration.isOn.toggle() // Toggle durumunu değiştirir
            }
    }
}

// Ayarlar ekranı için bir View oluşturur
struct SettingsScreen: View {
    
    // UserDefaults'tan alınan değerleri durum değişkenlerine atar
    @State private var checkBox1IsChecked: Bool = UserDefaults.standard.bool(forKey: "checkBox1IsChecked")
    @State private var checkBox2IsChecked: Bool = UserDefaults.standard.bool(forKey: "checkBox2IsChecked")
    // Bazı durumları kontrol eden değişkenleri tanımlar
    @State private var showHomeScreen: Bool = false
    @State private var showAlertForTrafficAccidents: Bool = false // Trafik kazaları için uyarı durumu
    @State private var showAlertForAllFalls: Bool = false // Tüm düşmeler için uyarı durumu

    var body: some View {
        NavigationView {
            ZStack {
                // Arka plan resmini ayarlar
                Image("settingback")
                    .resizable()
                    .scaledToFit()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Çıkış butonunu tanımlar
                    Button(action: {}) {
                        Image("exitblack")
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    .padding(.top, 15)
                    .padding(.leading, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack {
                        // Trafik kazalarını algılama toggle'ını oluşturur
                        HStack {
                            Text("Trafik kazalarını algıla")
                                .font(.system(size: 25))
                                .bold()
                                .frame(width: 250, alignment: .leading)
                                .foregroundColor(Color.black)
                            Spacer()
                            Toggle("", isOn: $checkBox1IsChecked)
                                .toggleStyle(CheckboxToggleStyle2())
                                .onChange(of: checkBox1IsChecked, perform: { value in
                                    UserDefaults.standard.set(value, forKey: "checkBox1IsChecked")
                                    showHomeScreen = true
                                })
                        }
                        .padding([.leading, .trailing])

                        // Tüm düşmeleri algılama toggle'ını oluşturur
                        HStack {
                            Text("Tüm düşmeleri algıla")
                                .font(.system(size: 25))
                                .bold()
                                .foregroundColor(Color.black)
                                .frame(width: 250, alignment: .leading)
                            
                            Spacer()
                            Toggle("", isOn: $checkBox2IsChecked)
                                .toggleStyle(CheckboxToggleStyle2())
                                .onChange(of: checkBox2IsChecked, perform: { value in
                                    UserDefaults.standard.set(value, forKey: "checkBox2IsChecked")
                                    showHomeScreen = true
                                })
                        }
                        .padding([.leading, .trailing])
                    }
                    .padding(.bottom,150)
                    .background(Color.white)
                }
                
                VStack {
                    Spacer()
                    Color.white.frame(height:160)
                }
                .edgesIgnoringSafeArea(.all)
            }
            .background(Color.white)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
        .background(Color.white)
        .onAppear {
            // Bu kod bloğu Settings ekranı her görüntülendiğinde çalışacak
            // Geri tuşunun etkisini sıfırlamak için showHomeScreen değerini false yapıyoruz.
            showHomeScreen = false
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $showHomeScreen) {
            homescreen()
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
