# Watchlist Feature - @InjectedObject Implementation

## สรุปการแก้ไข

แก้ไข Watchlist DI pattern จาก `ParameterFactory` (ต้องส่ง `modelContext`) เป็น `Factory` แบบปกติ เพื่อใช้ `@InjectedObject` เหมือนกับ Home และ MovieDetail features

---

## ปัญหาเดิม

### ❌ Before: ใช้ ParameterFactory
```swift
// Watchlist+Injection.swift (เดิม)
var watchlistDataSource: ParameterFactory<ModelContext, WatchlistDataSource> {
    self { modelContext in  // ต้องส่ง modelContext
        WatchlistLocalDataSource(modelContext: modelContext)
    }
}

// WatchlistView.swift (เดิม)
struct WatchlistView: View {
    @StateObject private var viewModel: WatchlistViewModel
    
    init(modelContext: ModelContext) {  // ต้องรับ parameter
        _viewModel = StateObject(wrappedValue: Container.shared.watchlistViewModel(modelContext))
    }
}
```

**ปัญหา:**
- ไม่สามารถใช้ `@InjectedObject` ได้
- ต้อง inject `modelContext` ผ่าน `init`
- ไม่ consistent กับ Home feature

---

## วิธีแก้ไข

### ✅ After: ใช้ Factory แบบปกติ

#### 1. เพิ่ม `shared` ใน MovieFinderApp
```swift
// MovieFinderApp.swift
@main
struct MovieFinderApp: App {
    static var shared: MovieFinderApp!  // ✅ เพิ่ม shared instance
    let modelContainer: ModelContainer

    init() {
        KingfisherConfig.setup()
        
        do {
            modelContainer = try ModelContainer(for: WatchlistMovie.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
        
        MovieFinderApp.shared = self  // ✅ Set shared
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)  // ✅ เพิ่ม
        }
    }
}
```

#### 2. แก้ไข Watchlist+Injection.swift
```swift
// Watchlist+Injection.swift
extension Container {
    // ✅ Helper property เพื่อเข้าถึง modelContext
    private var modelContext: ModelContext {
        MovieFinderApp.shared.modelContainer.mainContext
    }
    
    // ✅ เปลี่ยนจาก ParameterFactory เป็น Factory
    var watchlistDataSource: Factory<WatchlistDataSource> {
        self {
            WatchlistLocalDataSource(modelContext: self.modelContext)
        }.singleton
    }
    
    var watchlistRepository: Factory<WatchlistRepositoryProtocol> {
        self {
            WatchlistRepository(dataSource: self.watchlistDataSource())
        }.singleton
    }
    
    // Use Cases (ไม่เปลี่ยน)
    var addToWatchlistUseCase: Factory<AddToWatchlistUseCase> { ... }
    var removeFromWatchlistUseCase: Factory<RemoveFromWatchlistUseCase> { ... }
    // ... ฯลฯ
    
    // ✅ ViewModel ไม่ต้องรับ parameter
    var watchlistViewModel: Factory<WatchlistViewModel> {
        self {
            @MainActor in
            WatchlistViewModel(
                getAllWatchlistUseCase: self.getAllWatchlistUseCase(),
                addToWatchlistUseCase: self.addToWatchlistUseCase(),
                // ... ฯลฯ
            )
        }
    }
}
```

#### 3. แก้ไข WatchlistView.swift
```swift
// WatchlistView.swift
import SwiftUI
import SwiftData
import FactoryKit

struct WatchlistView: View {
    // ✅ ใช้ @InjectedObject เหมือน Home feature
    @InjectedObject(\.watchlistViewModel) private var viewModel
    
    var body: some View {
        NavigationStack {
            // ... UI code ...
        }
    }
}

#Preview {
    WatchlistView()  // ✅ ไม่ต้องส่ง parameter
}
```

---

## เปรียบเทียบ Before/After

| Feature | Before (ParameterFactory) | After (Factory) |
|---------|---------------------------|-----------------|
| **Factory Type** | `ParameterFactory<ModelContext, T>` | `Factory<T>` |
| **Registration** | `self { modelContext in ... }` | `self { ... }` |
| **ModelContext** | ส่งผ่าน parameter | เข้าถึงผ่าน shared |
| **View Injection** | `init(modelContext:)` | `@InjectedObject` |
| **Consistent กับ Home** | ❌ | ✅ |
| **Code ง่าย** | ❌ | ✅ |

---

## ข้อดีของแนวทางนี้

### 1. ✅ **Consistent Pattern**
```swift
// Home Feature
@InjectedObject(\.homeViewModel) private var viewModel

// MovieDetail Feature
@InjectedObject(\.movieDetailViewModel) private var viewModel

// Watchlist Feature (ตอนนี้เหมือนกันแล้ว!)
@InjectedObject(\.watchlistViewModel) private var viewModel
```

### 2. ✅ **ไม่ต้องส่ง Parameter**
```swift
// ❌ Before
WatchlistView(modelContext: modelContext)

// ✅ After
WatchlistView()
```

### 3. ✅ **Singleton DataSource & Repository**
```swift
var watchlistDataSource: Factory<WatchlistDataSource> {
    self { ... }.singleton  // ✅ Share instance
}

var watchlistRepository: Factory<WatchlistRepositoryProtocol> {
    self { ... }.singleton  // ✅ Share instance
}
```

### 4. ✅ **Clean View Code**
```swift
struct WatchlistView: View {
    @InjectedObject(\.watchlistViewModel) private var viewModel
    // ไม่ต้องมี init, ไม่ต้อง inject context
    
    var body: some View { ... }
}
```

### 5. ✅ **Easy Preview**
```swift
#Preview {
    WatchlistView()  // สั้น ง่าย ไม่ต้อง setup อะไร
}
```

---

## Architecture Flow

```
View (@InjectedObject)
    ↓
Container.watchlistViewModel (Factory)
    ↓
Use Cases (Factory)
    ↓
Repository (Factory.singleton)
    ↓
DataSource (Factory.singleton)
    ↓
ModelContext (from MovieFinderApp.shared)
    ↓
SwiftData
```

---

## ไฟล์ที่แก้ไข

### 1. ✅ **MovieFinderApp.swift**
- เพิ่ม `static var shared`
- แก้ duplicate `import SwiftData`
- เพิ่ม `.modelContainer(modelContainer)`

### 2. ✅ **Watchlist+Injection.swift**
- เปลี่ยน `ParameterFactory<ModelContext, T>` → `Factory<T>`
- เพิ่ม `private var modelContext` helper
- ลบ `modelContext` parameter จาก closures
- เพิ่ม `.singleton` สำหรับ DataSource และ Repository

### 3. ✅ **WatchlistView.swift**
- เปลี่ยน `@StateObject` + `init(modelContext:)` → `@InjectedObject`
- ลบ `init` method
- อัปเดต Preview ไม่ต้องส่ง parameter

### 4. ❌ **ลบ: InjectedObjectWithContext.swift**
- ไฟล์ helper ที่สร้างไว้แต่ไม่ได้ใช้

---

## การใช้งาน

### ใน TabView หรือ Navigation
```swift
struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
            
            WatchlistView()  // ✅ เรียกง่ายๆ
                .tabItem { Label("Watchlist", systemImage: "bookmark") }
        }
    }
}
```

### ใน MovieDetailView - Toggle Watchlist
```swift
struct MovieDetailView: View {
    let movie: Movie
    @InjectedObject(\.toggleWatchlistUseCase) private var toggleUseCase
    @State private var isInWatchlist = false
    
    var body: some View {
        Button {
            Task {
                try? await toggleUseCase.execute(movie)
                // Update state...
            }
        } label: {
            Label(
                isInWatchlist ? "Remove" : "Add",
                systemImage: isInWatchlist ? "bookmark.fill" : "bookmark"
            )
        }
    }
}
```

---

## Trade-offs

### ข้อดี:
1. ✅ Pattern consistent กับทั้งแอป
2. ✅ Code สั้นและง่าย
3. ✅ ใช้ `@InjectedObject` ได้
4. ✅ Singleton repository/datasource
5. ✅ Preview ง่าย

### ข้อเสีย:
1. ⚠️ ใช้ global shared instance (`MovieFinderApp.shared`)
2. ⚠️ Repository เป็น singleton (แต่ก็เหมาะสมสำหรับ local database)

---

## สรุป

✅ **เปลี่ยนจาก:**
```swift
@StateObject private var viewModel: WatchlistViewModel
init(modelContext: ModelContext) { ... }
```

✅ **เป็น:**
```swift
@InjectedObject(\.watchlistViewModel) private var viewModel
```

**Result:** Clean, consistent, และใช้งานง่ายเหมือนกับ Home และ MovieDetail features! 🎉

---

**สร้างเมื่อ:** 10 ธันวาคม 2568  
**Pattern:** Factory DI with Shared ModelContext  
**Framework:** FactoryKit + SwiftData
