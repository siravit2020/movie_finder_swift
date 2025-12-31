# Watchlist Feature - Use Cases Implementation

## สรุปการ Implement

เพิ่ม **Use Cases layer** สำหรับ Watchlist feature ตามแบบของ Home และ MovieDetail features เพื่อแยก business logic ออกจาก ViewModel และทำให้ code มี testability สูงขึ้น

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│                                                               │
│  ┌──────────────┐         ┌────────────────────────┐        │
│  │ WatchlistView│────────▶│ WatchlistViewModel     │        │
│  └──────────────┘         └────────────────────────┘        │
└────────────────────────────────┬──────────────────────────────┘
                                 │
                                 │ uses (ไม่เรียก repository ตรงๆ)
                                 ▼
┌─────────────────────────────────────────────────────────────┐
│                     Domain Layer                             │
│                                                               │
│  ┌────────────────────────────────────────────────────────┐ │
│  │              Use Cases (Business Logic)                 │ │
│  ├────────────────────────────────────────────────────────┤ │
│  │  • AddToWatchlistUseCase                               │ │
│  │  • RemoveFromWatchlistUseCase                          │ │
│  │  • GetAllWatchlistUseCase                              │ │
│  │  • CheckWatchlistStatusUseCase                         │ │
│  │  • ToggleWatchlistUseCase                              │ │
│  │  • GetWatchlistCountUseCase                            │ │
│  └────────────────────────────────────────────────────────┘ │
│                          │                                    │
│                          │ uses                               │
│                          ▼                                    │
│         ┌────────────────────────────────┐                   │
│         │ WatchlistRepositoryProtocol    │                   │
│         └────────────────────────────────┘                   │
└────────────────────────────────┬────────────────────────────┘
                                 │
                                 │ implements
                                 ▼
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                              │
│                                                               │
│  ┌──────────────────────┐    ┌──────────────────────┐       │
│  │ WatchlistRepository  │───▶│ WatchlistDataSource  │       │
│  └──────────────────────┘    └──────────────────────┘       │
│                                         │                     │
│                                         ▼                     │
│                          ┌──────────────────────────┐        │
│                          │ WatchlistLocalDataSource │        │
│                          └──────────────────────────┘        │
│                                         │                     │
│                                         ▼                     │
│                          ┌──────────────────────────┐        │
│                          │      ModelContext        │        │
│                          │      (SwiftData)         │        │
│                          └──────────────────────────┘        │
└─────────────────────────────────────────────────────────────┘
```

---

## ไฟล์ที่สร้าง/แก้ไข

### ✅ สร้างใหม่ (6 Use Cases):

1. **`AddToWatchlistUseCase.swift`**
   - เพิ่มหนังเข้า watchlist
   - Validate data ผ่าน repository

2. **`RemoveFromWatchlistUseCase.swift`**
   - ลบหนังออกจาก watchlist
   - Throw error ถ้าไม่เจอ

3. **`GetAllWatchlistUseCase.swift`**
   - ดึงรายการหนังทั้งหมดจาก watchlist
   - Support sorting options

4. **`CheckWatchlistStatusUseCase.swift`**
   - ตรวจสอบว่าหนังอยู่ใน watchlist หรือไม่
   - Return boolean

5. **`ToggleWatchlistUseCase.swift`**
   - Toggle หนังใน watchlist (เพิ่ม/ลบ)
   - Return true ถ้าเพิ่ม, false ถ้าลบ

6. **`GetWatchlistCountUseCase.swift`**
   - นับจำนวนหนังใน watchlist
   - Return Int

### ✅ แก้ไข:

1. **`Watchlist+Injection.swift`**
   - เพิ่ม registration สำหรับ Use Cases ทั้ง 6 ตัว
   - อัปเดต `watchlistViewModel` ให้ inject Use Cases แทน repository

2. **`WatchlistViewModel.swift`**
   - เปลี่ยนจากใช้ `repository` เป็นใช้ `Use Cases`
   - Inject Use Cases ทั้ง 6 ตัวผ่าน initializer
   - เพิ่ม `@MainActor` annotation

3. **`WatchlistView.swift`**
   - อัปเดต initializer ให้ใช้ `Container.shared.watchlistViewModel(modelContext)`

---

## Use Cases Details

### 1. AddToWatchlistUseCase
```swift
class AddToWatchlistUseCase {
    private let repository: WatchlistRepositoryProtocol
    
    func execute(_ movie: Movie) async throws {
        try await repository.addToWatchlist(movie)
    }
}
```

**ใช้งาน:**
```swift
await viewModel.addMovie(movie) // ViewModel เรียก use case
```

### 2. RemoveFromWatchlistUseCase
```swift
class RemoveFromWatchlistUseCase {
    private let repository: WatchlistRepositoryProtocol
    
    func execute(id: Int) async throws {
        try await repository.removeFromWatchlist(id: id)
    }
}
```

**ใช้งาน:**
```swift
await viewModel.removeMovie(id: movieId)
```

### 3. GetAllWatchlistUseCase
```swift
class GetAllWatchlistUseCase {
    private let repository: WatchlistRepositoryProtocol
    
    func execute(sortBy: WatchlistSortOption = .dateAdded(ascending: false)) async throws -> [WatchlistMovie] {
        try await repository.getAllWatchlist(sortBy: sortBy)
    }
}
```

**ใช้งาน:**
```swift
await viewModel.loadWatchlist(sortBy: .rating(ascending: false))
```

### 4. CheckWatchlistStatusUseCase
```swift
class CheckWatchlistStatusUseCase {
    private let repository: WatchlistRepositoryProtocol
    
    func execute(id: Int) async -> Bool {
        await repository.isInWatchlist(id: id)
    }
}
```

**ใช้งาน:**
```swift
let isInWatchlist = await viewModel.isInWatchlist(id: movieId)
```

### 5. ToggleWatchlistUseCase
```swift
class ToggleWatchlistUseCase {
    private let repository: WatchlistRepositoryProtocol
    
    func execute(_ movie: Movie) async throws -> Bool {
        try await repository.toggleWatchlist(movie)
    }
}
```

**ใช้งาน:**
```swift
await viewModel.toggleMovie(movie) // เพิ่มหรือลบ auto
```

### 6. GetWatchlistCountUseCase
```swift
class GetWatchlistCountUseCase {
    private let repository: WatchlistRepositoryProtocol
    
    func execute() async throws -> Int {
        try await repository.getWatchlistCount()
    }
}
```

**ใช้งาน:**
```swift
let count = await viewModel.getWatchlistCount()
```

---

## Dependency Injection Flow

```swift
// Watchlist+Injection.swift

extension Container {
    // 1. Data Source
    var watchlistDataSource: ParameterFactory<ModelContext, WatchlistDataSource>
    
    // 2. Repository
    var watchlistRepository: ParameterFactory<ModelContext, WatchlistRepositoryProtocol>
    
    // 3. Use Cases (New!)
    var addToWatchlistUseCase: ParameterFactory<ModelContext, AddToWatchlistUseCase>
    var removeFromWatchlistUseCase: ParameterFactory<ModelContext, RemoveFromWatchlistUseCase>
    var getAllWatchlistUseCase: ParameterFactory<ModelContext, GetAllWatchlistUseCase>
    var checkWatchlistStatusUseCase: ParameterFactory<ModelContext, CheckWatchlistStatusUseCase>
    var toggleWatchlistUseCase: ParameterFactory<ModelContext, ToggleWatchlistUseCase>
    var getWatchlistCountUseCase: ParameterFactory<ModelContext, GetWatchlistCountUseCase>
    
    // 4. ViewModel (inject all use cases)
    var watchlistViewModel: ParameterFactory<ModelContext, WatchlistViewModel>
}
```

---

## ViewModel Structure

```swift
@MainActor
class WatchlistViewModel: ObservableObject {
    @Published var movies: [WatchlistMovie] = []
    @Published var errorMessage: String?
    @Published var isLoading = false

    // ✅ Use Cases (ไม่ใช่ repository)
    private let getAllWatchlistUseCase: GetAllWatchlistUseCase
    private let addToWatchlistUseCase: AddToWatchlistUseCase
    private let removeFromWatchlistUseCase: RemoveFromWatchlistUseCase
    private let checkWatchlistStatusUseCase: CheckWatchlistStatusUseCase
    private let toggleWatchlistUseCase: ToggleWatchlistUseCase
    private let getWatchlistCountUseCase: GetWatchlistCountUseCase

    // Inject all use cases
    init(
        getAllWatchlistUseCase: GetAllWatchlistUseCase,
        addToWatchlistUseCase: AddToWatchlistUseCase,
        removeFromWatchlistUseCase: RemoveFromWatchlistUseCase,
        checkWatchlistStatusUseCase: CheckWatchlistStatusUseCase,
        toggleWatchlistUseCase: ToggleWatchlistUseCase,
        getWatchlistCountUseCase: GetWatchlistCountUseCase
    ) { ... }
}
```

---

## ข้อดีของการใช้ Use Cases

### 1. ✅ **Single Responsibility Principle**
- แต่ละ Use Case ทำหน้าที่เดียว
- ViewModel ไม่ต้องรู้ว่า repository ทำงานยังไง

### 2. ✅ **Testability**
```swift
// Mock Use Case ง่ายกว่า mock repository
class MockAddToWatchlistUseCase: AddToWatchlistUseCase {
    var executeCallCount = 0
    var shouldThrowError = false
    
    override func execute(_ movie: Movie) async throws {
        executeCallCount += 1
        if shouldThrowError {
            throw WatchlistError.invalidData
        }
    }
}

// Test ViewModel
let mockUseCase = MockAddToWatchlistUseCase()
let viewModel = WatchlistViewModel(
    getAllWatchlistUseCase: ...,
    addToWatchlistUseCase: mockUseCase,
    ...
)

await viewModel.addMovie(movie)
XCTAssertEqual(mockUseCase.executeCallCount, 1)
```

### 3. ✅ **Reusability**
```swift
// Use case เดียวกันใช้ได้หลายที่
// - WatchlistViewModel
// - MovieDetailViewModel
// - HomeViewModel
let addUseCase = Container.shared.addToWatchlistUseCase(modelContext)
```

### 4. ✅ **Business Logic Isolation**
```swift
// ถ้าต้องการเพิ่ม logic (เช่น analytics)
class AddToWatchlistUseCase {
    func execute(_ movie: Movie) async throws {
        // Log analytics
        Analytics.log("add_to_watchlist", movieId: movie.id)
        
        // Add to watchlist
        try await repository.addToWatchlist(movie)
        
        // Notify other services
        NotificationCenter.default.post(...)
    }
}
```

### 5. ✅ **Clear Dependencies**
```swift
// เห็นชัดว่า ViewModel ต้องการ Use Cases อะไรบ้าง
init(
    getAllWatchlistUseCase: GetAllWatchlistUseCase,  // ดึงรายการ
    addToWatchlistUseCase: AddToWatchlistUseCase,    // เพิ่ม
    removeFromWatchlistUseCase: RemoveFromWatchlistUseCase,  // ลบ
    checkWatchlistStatusUseCase: CheckWatchlistStatusUseCase, // ตรวจสอบ
    toggleWatchlistUseCase: ToggleWatchlistUseCase,  // Toggle
    getWatchlistCountUseCase: GetWatchlistCountUseCase  // นับ
)
```

---

## เปรียบเทียบ Before/After

### ❌ Before (เรียก Repository โดยตรง)
```swift
class WatchlistViewModel {
    private let repository: WatchlistRepositoryProtocol
    
    func addMovie(_ movie: Movie) async {
        try await repository.addToWatchlist(movie)  // เรียกตรงๆ
    }
}
```

### ✅ After (ใช้ Use Cases)
```swift
class WatchlistViewModel {
    private let addToWatchlistUseCase: AddToWatchlistUseCase
    
    func addMovie(_ movie: Movie) async {
        try await addToWatchlistUseCase.execute(movie)  // เรียกผ่าน use case
    }
}
```

---

## การใช้งานใน View

```swift
struct MovieDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let movie: Movie
    
    // Get use case directly
    private var toggleUseCase: ToggleWatchlistUseCase {
        Container.shared.toggleWatchlistUseCase(modelContext)
    }
    
    var body: some View {
        Button {
            Task {
                try? await toggleUseCase.execute(movie)
            }
        } label: {
            Label("Toggle Watchlist", systemImage: "bookmark")
        }
    }
}
```

---

## File Structure

```
WatchList/
├── Data/
│   ├── DataSource/
│   │   └── WatchlistLocalDataSource.swift
│   ├── Models/
│   │   └── WatchlistMovie.swift
│   └── Repositories/
│       └── WatchlistRepository.swift
├── Domain/
│   ├── Errors/
│   │   └── WatchlistError.swift
│   └── UseCases/                              ✅ NEW
│       ├── AddToWatchlistUseCase.swift        ✅ NEW
│       ├── RemoveFromWatchlistUseCase.swift   ✅ NEW
│       ├── GetAllWatchlistUseCase.swift       ✅ NEW
│       ├── CheckWatchlistStatusUseCase.swift  ✅ NEW
│       ├── ToggleWatchlistUseCase.swift       ✅ NEW
│       └── GetWatchlistCountUseCase.swift     ✅ NEW
└── Presentation/
    ├── ViewModels/
    │   └── WatchlistViewModel.swift           ✅ UPDATED
    └── Views/
        └── WatchlistView.swift                ✅ UPDATED

DI/
└── Watchlist+Injection.swift                  ✅ UPDATED
```

---

## สรุป

### สิ่งที่ทำ:
1. ✅ สร้าง 6 Use Cases สำหรับ Watchlist operations
2. ✅ อัปเดต DI ให้ register Use Cases
3. ✅ แก้ ViewModel ให้ใช้ Use Cases แทน repository
4. ✅ เพิ่ม `@MainActor` ที่ ViewModel

### ข้อดี:
1. ✅ **Clean Architecture** - แยก layer ชัดเจน
2. ✅ **Testable** - mock ง่าย
3. ✅ **Maintainable** - แก้ไขง่าย
4. ✅ **Reusable** - ใช้ซ้ำได้
5. ✅ **Single Responsibility** - แต่ละ class ทำหน้าที่เดียว

### Pattern เดียวกับ:
- ✅ Home feature (FetchNowShowingMoviesUseCase, FetchPopularMoviesUseCase)
- ✅ MovieDetail feature (FetchMovieDetailUseCase, FetchMovieVideoUseCase)

---

**สร้างเมื่อ:** 10 ธันวาคม 2568  
**Pattern:** Clean Architecture + SOLID Principles  
**DI Framework:** FactoryKit
