# การใช้งาน Kingfisher ใน MovieFinder

## 📚 เกี่ยวกับ Kingfisher

Kingfisher เป็น library สำหรับ download และ cache รูปภาพใน Swift ที่ได้รับความนิยมมาก คล้ายกับ `CachedNetworkImage` ใน Flutter

### ✨ ฟีเจอร์หลัก
- ✅ Cache รูปภาพทั้ง Memory และ Disk
- ✅ Download รูปภาพแบบ Async
- ✅ รองรับ Placeholder และ Animation
- ✅ Retry และ Error handling
- ✅ Memory และ Performance optimization

## 🚀 การติดตั้ง

Kingfisher ได้ถูกติดตั้งผ่าน Swift Package Manager แล้ว:
- Repository: `https://github.com/onevcat/Kingfisher`
- Version: 8.1.3+

## 💻 การใช้งานในโปรเจค

### 1. การตั้งค่าเริ่มต้น

ตั้งค่าใน `MovieFinderApp.swift`:

```swift
import SwiftUI

@main
struct MovieFinderApp: App {
    init() {
        KingfisherConfig.setup() // ตั้งค่า cache
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 2. การใช้งานพื้นฐาน

```swift
import Kingfisher

KFImage(url)
    .placeholder {
        ProgressView()
    }
    .fade(duration: 0.5)
    .resizable()
    .frame(width: 200, height: 300)
    .cornerRadius(12)
```

### 3. ตัวอย่างการใช้งานในโปรเจค

#### MovieImage.swift
```swift
KFImage(url)
    .placeholder {
        SkeletonImageView()
    }
    .fade(duration: 0.5)
    .resizable()
    .frame(width: width, height: height)
    .cornerRadius(12)
```

#### Avatar.swift
```swift
KFImage(URL(string: imageURL))
    .placeholder {
        Image(systemName: "person.circle.fill")
            .resizable()
    }
    .fade(duration: 0.3)
    .resizable()
    .frame(width: 50, height: 50)
    .clipShape(Circle())
```

#### MovieDetailScreen.swift
```swift
KFImage(movie.backdropURL)
    .placeholder {
        SkeletonImageView()
    }
    .fade(duration: 0.5)
    .resizable()
    .aspectRatio(contentMode: .fill)
```

## ⚙️ การตั้งค่า Cache

### ตั้งค่าใน `KingfisherConfig.swift`:

```swift
// Memory Cache - 100MB
ImageCache.default.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024

// Disk Cache - 500MB
ImageCache.default.diskStorage.config.sizeLimit = 500 * 1024 * 1024

// Cache expiration - 7 วัน
ImageCache.default.diskStorage.config.expiration = .days(7)
```

### จัดการ Cache:

```swift
// ลบ cache ทั้งหมด
KingfisherConfig.clearCache()

// ลบ cache ที่หมดอายุ
KingfisherConfig.clearExpiredCache()

// คำนวณขนาด cache
KingfisherConfig.calculateCacheSize { size in
    print("Cache size: \(size) bytes")
}
```

## 🎨 Modifiers ที่ใช้บ่อย

### Animation
```swift
.fade(duration: 0.5)              // Fade in animation
.transition(.opacity)             // Custom transition
```

### Placeholder
```swift
.placeholder {
    ProgressView()                // Loading indicator
}
.placeholder {
    SkeletonImageView()           // Custom skeleton
}
```

### Error Handling
```swift
.onSuccess { result in
    print("✅ Loaded: \(result.source.url)")
}
.onFailure { error in
    print("❌ Error: \(error)")
}
```

### Retry
```swift
.retry(maxCount: 3, interval: .seconds(1))
```

### Cache Control
```swift
.cacheOriginalImage()             // Cache รูปต้นฉบับ
.cacheMemoryOnly()                // Cache ใน memory เท่านั้น
.forceRefresh()                   // Force download ใหม่
```

### Progress
```swift
.onProgress { receivedSize, totalSize in
    let progress = Double(receivedSize) / Double(totalSize)
    print("Progress: \(Int(progress * 100))%")
}
```

## 📊 เปรียบเทียบกับ Flutter

| Flutter | SwiftUI (Kingfisher) |
|---------|---------------------|
| `CachedNetworkImage` | `KFImage` |
| `placeholder` | `.placeholder { }` |
| `fadeInDuration` | `.fade(duration:)` |
| `errorWidget` | `.onFailure { }` |
| `fit` | `.resizable()` + `.aspectRatio()` |

### Flutter Example:
```dart
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
  fadeInDuration: Duration(milliseconds: 500),
  fit: BoxFit.cover,
)
```

### SwiftUI (Kingfisher) Example:
```swift
KFImage(URL(string: url))
    .placeholder {
        ProgressView()
    }
    .onFailure { error in
        Image(systemName: "exclamationmark.triangle")
    }
    .fade(duration: 0.5)
    .resizable()
    .aspectRatio(contentMode: .fill)
```

## 🔧 Advanced Features

### 1. Custom Image Processor
```swift
KFImage(url)
    .setProcessor(
        RoundCornerImageProcessor(cornerRadius: 20)
        |> BlurImageProcessor(blurRadius: 10)
    )
```

### 2. Priority
```swift
KFImage(url)
    .loadDiskFileSynchronously()
    .cacheMemoryOnly()
    .lowDataMode(.network(lowDataModeSource))
```

### 3. Cache Keys
```swift
KFImage
    .url(url)
    .cacheKey("custom-key-\(movieId)")
```

## 📱 Performance Tips

1. **ใช้ Memory Cache สำหรับรูปที่ใช้บ่อย**
2. **ตั้ง Disk Cache ขนาดเหมาะสม** (500MB แนะนำ)
3. **ใช้ `.cacheOriginalImage()`** สำหรับรูปที่ต้องการคุณภาพสูง
4. **ลบ expired cache เป็นระยะ** ด้วย `.clearExpiredCache()`
5. **ใช้ `.fade()`** แทน animation ซับซ้อน

## 🐛 Troubleshooting

### ปัญหา: รูปไม่แสดง
```swift
// เช็คว่า URL ถูกต้อง
print("Loading: \(url?.absoluteString ?? "nil")")

// ใช้ onFailure เพื่อดู error
.onFailure { error in
    print("Error: \(error)")
}
```

### ปัญหา: Cache เต็ม
```swift
// เพิ่มขนาด disk cache
ImageCache.default.diskStorage.config.sizeLimit = 1000 * 1024 * 1024 // 1GB
```

### ปัญหา: รูปโหลดช้า
```swift
// ลด timeout
ImageDownloader.default.downloadTimeout = 30.0

// เพิ่ม retry
.retry(maxCount: 5, interval: .seconds(2))
```

## 📚 Resources

- [Official Documentation](https://github.com/onevcat/Kingfisher)
- [Wiki](https://github.com/onevcat/Kingfisher/wiki)
- [Migration Guide](https://github.com/onevcat/Kingfisher/wiki/SwiftUI-Support)

## ✅ สรุป

Kingfisher ให้ประสบการณ์การใช้งานที่ดีเทียบเท่าหรือดีกว่า `CachedNetworkImage` ใน Flutter:

✅ Cache อัตโนมัติทั้ง memory และ disk  
✅ API ใช้งานง่าย เหมือน SwiftUI  
✅ Performance ดีเยี่ยม  
✅ รองรับ Animation และ Transition  
✅ Error handling และ Retry ครบถ้วน  

---
**Updated:** December 8, 2025
