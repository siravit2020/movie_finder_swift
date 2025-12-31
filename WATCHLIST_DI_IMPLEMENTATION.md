# Watchlist Feature - Dependency Injection Implementation

## สรุปการ Implement

เพิ่ม Dependency Injection สำหรับ Watchlist feature โดยใช้ **FactoryKit** pattern เหมือนกับ Home และ MovieDetail features

---

## ไฟล์ที่สร้าง/แก้ไข

### 1. ✅ สร้างใหม่: `DI/Watchlist+Injection.swift`
- Register `watchlistDataSource` - สร้าง `WatchlistLocalDataSource` พร้อม `ModelContext`
- Register `watchlistRepository` - สร้าง `WatchlistRepository` พร้อม data source
- Register `watchlistViewModel` - สร้าง `WatchlistViewModel` พร้อม repository

### 2. ✅ แก้ไข: `MovieFinderApp.swift`
- แก้ไข duplicate `import SwiftData`
- เพิ่ม `.modelContainer(modelContainer)` เพื่อให้ `ModelContext` accessible ผ่าน `@Environment`

### 3. ✅ แก้ไข: `WatchList/Presentation/Views/WatchlistView.swift`
- อัปเดต initializer ให้รับ `ModelContext` เป็น parameter
- เพิ่ม UI สมบูรณ์:
  - Loading state
  - Empty state
  - Movie list with delete functionality
- สร้าง `MovieRowView` สำหรับแสดงรายการหนัง
- เพิ่ม Preview

---

## วิธีใช้งาน

### 1. ใน ContentView หรือ TabView

```swift
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            WatchlistView(modelContext: modelContext)
                .tabItem {
                    Label("Watchlist", systemImage: "bookmark")
                }
        }
    }
}
```

### 2. ใน MovieDetailView - เพิ่มปุ่ม Toggle Watchlist

```swift
import SwiftUI
import SwiftData
import FactoryKit

struct MovieDetailView: View {
    let movie: Movie
    @Environment(\.modelContext) private var modelContext
    @State private var isInWatchlist = false
    
    private var repository: WatchlistRepositoryProtocol {
        Container.shared.watchlistRepository(modelContext)
    }
    
    var body: some View {
        ScrollView {
            // ... movie details ...
            
            Button {
                Task {
                    await toggleWatchlist()
                }
            } label: {
                Label(
                    isInWatchlist ? "Remove from Watchlist" : "Add to Watchlist",
                    systemImage: isInWatchlist ? "bookmark.fill" : "bookmark"
                )
                .frame(maxWidth: .infinity)
                .padding()
                .background(isInWatchlist ? Color.red : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .task {
            await checkWatchlistStatus()
        }
    }
    
    private func checkWatchlistStatus() async {
        isInWatchlist = await repository.isInWatchlist(id: movie.id)
    }
    
    private func toggleWatchlist() async {
        do {
            let added = try await repository.toggleWatchlist(movie)
            isInWatchlist = added
        } catch {
            print("Error toggling watchlist: \(error)")
        }
    }
}
```

### 3. แบบใช้ ViewModel (ถ้าต้องการ manage state ที่ซับซ้อน)

```swift
struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            // ... list of movies ...
            
            ForEach(movies) { movie in
                MovieCard(movie: movie, modelContext: modelContext)
            }
        }
    }
}

struct MovieCard: View {
    let movie: Movie
    let modelContext: ModelContext
    @State private var isInWatchlist = false
    
    private var repository: WatchlistRepositoryProtocol {
        Container.shared.watchlistRepository(modelContext)
    }
    
    var body: some View {
        HStack {
            // Movie info...
            
            Button {
                Task {
                    try? await repository.toggleWatchlist(movie)
                    isInWatchlist = await repository.isInWatchlist(id: movie.id)
                }
            } label: {
                Image(systemName: isInWatchlist ? "bookmark.fill" : "bookmark")
            }
        }
        .task {
            isInWatchlist = await repository.isInWatchlist(id: movie.id)
        }
    }
}
```

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│  ┌──────────────┐         ┌────────────────────────┐   │
│  │ WatchlistView│────────▶│ WatchlistViewModel     │   │
│  └──────────────┘         └────────────────────────┘   │
└────────────────────────────────┬────────────────────────┘
                                 │
                                 │ uses
                                 ▼
┌─────────────────────────────────────────────────────────┐
│                     Domain Layer                         │
│         ┌────────────────────────────────┐              │
│         │ WatchlistRepositoryProtocol    │              │
│         └────────────────────────────────┘              │
└────────────────────────────────┬────────────────────────┘
                                 │
                                 │ implements
                                 ▼
┌─────────────────────────────────────────────────────────┐
│                      Data Layer                          │
│  ┌──────────────────────┐    ┌──────────────────────┐  │
│  │ WatchlistRepository  │───▶│ WatchlistDataSource  │  │
│  └──────────────────────┘    └──────────────────────┘  │
│                                         │                │
│                                         │ uses           │
│                                         ▼                │
│                          ┌──────────────────────────┐   │
│                          │ WatchlistLocalDataSource │   │
│                          └──────────────────────────┘   │
│                                         │                │
│                                         │ uses           │
│                                         ▼                │
│                          ┌──────────────────────────┐   │
│                          │      ModelContext        │   │
│                          │      (SwiftData)         │   │
│                          └──────────────────────────┘   │
└─────────────────────────────────────────────────────────┘

                    Dependency Injection (FactoryKit)
┌─────────────────────────────────────────────────────────┐
│              DI/Watchlist+Injection.swift                │
│                                                           │
│  Container.watchlistDataSource(modelContext)             │
│       ↓                                                   │
│  Container.watchlistRepository(modelContext)             │
│       ↓                                                   │
│  Container.watchlistViewModel(modelContext)              │
└─────────────────────────────────────────────────────────┘
```

---

## ข้อดีของ Architecture นี้

1. ✅ **Separation of Concerns** - แยก layer ชัดเจน
2. ✅ **Testable** - mock ได้ง่าย (DataSource, Repository)
3. ✅ **Type-safe** - ใช้ protocol และ generic
4. ✅ **Async/Await** - รองรับ background operations
5. ✅ **Error Handling** - มี custom error types
6. ✅ **Reusable** - ใช้ repository ได้ทุกที่ในแอป
7. ✅ **Maintainable** - เพิ่ม/แก้ไข feature ง่าย

---

## การทดสอบ

### 1. Run app และเปิด WatchlistView
```swift
// ใน ContentView.swift
WatchlistView(modelContext: modelContext)
```

### 2. เพิ่มหนังเข้า Watchlist จาก MovieDetailView
```swift
try await repository.addToWatchlist(movie)
```

### 3. ตรวจสอบใน WatchlistView ว่ามีหนังแสดงหรือไม่

### 4. ลองลบหนัง (swipe to delete)

---

## Next Steps

1. ✅ **เพิ่ม Toggle Watchlist ใน MovieDetailView**
2. ✅ **เพิ่ม Watchlist indicator ใน MovieCard/MovieList**
3. ✅ **เพิ่ม Sort/Filter options**
4. ⬜ **เพิ่ม Search ใน WatchlistView**
5. ⬜ **เพิ่ม Unit Tests**
6. ⬜ **เพิ่ม UI Tests**

---

## Files Summary

```
MovieFinder/
├── DI/
│   └── Watchlist+Injection.swift           ✅ NEW
├── MovieFinderApp.swift                    ✅ UPDATED
└── Features/
    └── WatchList/
        ├── Data/
        │   ├── DataSource/
        │   │   └── WatchlistLocalDataSource.swift  ✅ EXISTS
        │   ├── Models/
        │   │   └── WatchlistMovie.swift            ✅ EXISTS
        │   └── Repositories/
        │       └── WatchlistRepository.swift       ✅ EXISTS
        ├── Domain/
        │   └── Errors/
        │       └── WatchlistError.swift            ✅ EXISTS
        └── Presentation/
            ├── ViewModels/
            │   └── WatchlistViewModel.swift        ✅ EXISTS
            └── Views/
                └── WatchlistView.swift             ✅ UPDATED
```

---

## คำแนะนำ

1. **ใช้ Repository แทนการเข้าถึง ModelContext โดยตรง** - เพื่อให้ testable
2. **ใช้ async/await** - เพื่อ smooth UX
3. **Handle errors properly** - แสดง error message ให้ user เห็น
4. **ใช้ @MainActor** - สำหรับ ViewModel methods ที่อัปเดต @Published properties

---

สร้างเมื่อ: 10 ธันวาคม 2568
