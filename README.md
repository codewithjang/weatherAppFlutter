# 🌤️ Weather App (Flutter)

แอปสภาพอากาศที่พัฒนาโดยใช้ **Flutter & Dart**  
สามารถแสดงอุณหภูมิ ความชื้น และสภาพอากาศปัจจุบัน พร้อมแอนิเมชันจาก **Lottie**  
รองรับทั้ง **Web (GitHub Pages)** และ **Android (APK สำหรับ Android 12 ขึ้นไป)**  

**🌍 Live Demo:** [https://codewithjang.github.io/weatherAppFlutter/](https://codewithjang.github.io/weatherAppFlutter/)

---

## ✨ Features

- ค้นหาสภาพอากาศตามชื่อเมือง  
- แสดง **อุณหภูมิ / ความชื้น / สภาพท้องฟ้า** (พร้อมไอคอนแอนิเมชัน)  
- รองรับการเลือกหน่วยอุณหภูมิ: °C / °F / K  
- แสดงแอนิเมชันสภาพอากาศแบบเรียลไทม์ด้วย **Lottie**  
- รองรับทั้ง **Flutter Web** และ **Android APK (Android 12+)**

---

## 🧱 Tech Stack

- **Flutter** (ภาษา Dart)
- **http package** สำหรับเรียก API
- **Lottie** สำหรับ Animation
- **OpenWeatherMap API** สำหรับดึงข้อมูลสภาพอากาศ

---

## 🗂️ โครงสร้างโปรเจกต์
```bash
weather_app/
├─ lib/
│ ├─ main.dart
│ ├─ services/ (เรียก API)
│ ├─ widgets/ (UI component)
│ └─ ...
├─ assets/
│ └─ lottie/ (ไฟล์แอนิเมชัน)
├─ web/
│ └─ index.html <-- ใช้ตอนรัน dev
└─ build/
└─ web/ <-- ใช้สำหรับ deploy (หลัง build)
```


> 💡 สำหรับ GitHub Pages ให้ใช้เฉพาะไฟล์ใน `build/web` เพื่อ deploy  

---

## 🔑 การตั้งค่า API Key

สร้างบัญชีที่ [https://openweathermap.org/](https://openweathermap.org/)  
แล้วคัดลอก API Key มาใช้งาน

### วิธีใช้งาน (ปลอดภัยกว่าการฮาร์ดโค้ด)
```bash
# Run แบบ Web (Dev)
flutter run -d chrome --dart-define=OPENWEATHER_API_KEY=YOUR_KEY

# Build Web
flutter build web --release --dart-define=OPENWEATHER_API_KEY=YOUR_KEY

# Build Android
flutter build apk --release --dart-define=OPENWEATHER_API_KEY=YOUR_KEY

```
 ---

 ## ▶️ Run บนเครื่อง (Local Development)
 - flutter pub get
 - flutter run -d chrome --dart-define=OPENWEATHER_API_KEY=YOUR_KEY

 --- 
 📸 ตัวอย่าง
 
<img height="480" alt="Screenshot_20251023_213040" src="https://github.com/user-attachments/assets/d725c8af-73c7-42f5-9218-ee01df337e07" />
<img height="480" alt="Screenshot_20251023_213106" src="https://github.com/user-attachments/assets/d4d9e6ff-dad2-424a-9867-eac0ae3b644e" />
<img height="480" alt="Screenshot_20251023_213222" src="https://github.com/user-attachments/assets/e78c6fc2-96fe-4662-a9db-dc723a78ffe1" />
<img height="480" alt="Screenshot_20251023_213133" src="https://github.com/user-attachments/assets/cf8f0ef4-c47f-4b47-9e04-262ebd9e782c" />

---

## 🙌 Credits

- Flutter & Dart
- OpenWeatherMap API
- LottieFiles
- Icon8 Weather Set


---

พัฒนาโดย:
👩‍💻 Hafeezan Kutha (CodewithJang)
📅 Deploy สำเร็จ: 23 ตุลาคม 2025
🌐 Demo: https://codewithjang.github.io/weatherAppFlutter/


