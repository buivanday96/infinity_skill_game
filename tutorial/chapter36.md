# Chapter 36 - Asset & Resource Management System - Xây dựng hệ thống quản lý tài nguyên chuyên nghiệp

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- Asset Manager
- Resource Manager
- Resource Cache
- Asset Bundle
- Lazy Loading
- Preloading
- Reference Counting
- Texture Atlas
- Memory Management
- Asset Pipeline

Đây là chương quyết định hiệu năng của game.

Một game nhỏ.

Có thể.

```
Flame.images.load()
```

Là đủ.

Nhưng.

Một game lớn.

Không thể.

---

# Asset là gì?

Asset.

Không chỉ là.

```
Image
```

Asset có thể là.

```
Sprite
```

```
Audio
```

```
Font
```

```
Animation
```

```
Tile Map
```

```
Localization
```

```
JSON
```

```
Dialogue
```

```
Skill Definition
```

Mọi dữ liệu.

Đều là.

Asset.

---

# Asset Manager

Toàn bộ.

Asset.

Được quản lý.

Bởi.

```
AssetManager
```

Gameplay.

Không tự.

Load Asset.

---

# Asset Flow

```text
Gameplay

↓

Request Asset

↓

AssetManager

↓

Cache

↓

Load

↓

Return Asset
```

Gameplay.

Không biết.

File nằm đâu.

---

# Asset ID

Không dùng.

```
assets/images/player.png
```

Khắp Project.

Nên dùng.

```
hero_idle
```

```
boss_fire
```

```
bgm_village
```

↓

AssetManager.

Tự ánh xạ.

---

# Asset Definition

Ví dụ.

```
hero_idle

↓

assets/images/hero_idle.png
```

Nếu đổi.

Đường dẫn.

Gameplay.

Không cần sửa.

---

# Resource Cache

Nếu.

Asset.

Đã Load.

↓

Trả về.

Cache.

Không Load lại.

---

# Lazy Loading

Không Load.

Toàn bộ.

Game.

Khi khởi động.

Chỉ Load.

Khi cần.

Ví dụ.

```
Boss Texture
```

↓

Đến Boss Map.

Mới Load.

---

# Preloading

Ngược lại.

Một số Asset.

Nên Load.

Trước.

Ví dụ.

```
Main Menu
```

↓

Preload.

```
UI
```

```
Logo
```

```
Button
```

---

# Background Loading

Load Asset.

Trong nền.

↓

Gameplay.

Không bị.

Đứng.

---

# Asset Bundle

Thay vì.

Load.

Từng File.

Có thể.

Load.

Một Bundle.

Ví dụ.

```
Forest Bundle

↓

Tree

Grass

Monster

Music

VFX
```

---

# Scene Bundle

Mỗi Scene.

Có.

Bundle riêng.

Ví dụ.

```
Village Bundle
```

```
Dungeon Bundle
```

```
Boss Bundle
```

Khi đổi Scene.

↓

Unload.

Bundle cũ.

---

# Shared Bundle

Một số Asset.

Được dùng.

Ở mọi nơi.

Ví dụ.

```
Common UI
```

```
Default Font
```

```
Click Sound
```

Không nên.

Unload.

---

# Texture Atlas

Thay vì.

```
100 Image
```

↓

```
1 Atlas
```

Giảm.

Draw Call.

Tăng.

FPS.

---

# Sprite Sheet

Animation.

Không nên.

Load.

50 PNG.

Nên dùng.

```
Sprite Sheet
```

Hoặc.

```
Atlas
```

---

# Font Management

Font.

Cũng là.

Asset.

Không nên.

Load.

Nhiều lần.

---

# Audio Management

Âm thanh.

Không tự.

Load.

↓

AudioManager.

Yêu cầu.

AssetManager.

---

# JSON Resource

Ví dụ.

```
Skill Definition
```

↓

JSON.

↓

AssetManager.

↓

Cache.

---

# Localization

Localization.

Không đọc.

File.

Mỗi lần.

Đổi ngôn ngữ.

↓

Cache.

---

# Resource Lifetime

Asset.

Có vòng đời.

```text
Load

↓

Use

↓

Unused

↓

Release
```

---

# Reference Counting

Ví dụ.

```
Player Texture
```

Được dùng.

Bởi.

```
Hero
```

+

```
Preview
```

↓

Reference.

=2

Khi.

Hero.

Dispose.

↓

Reference.

=1

↓

Không Unload.

---

# Release

Reference.

↓

0

↓

Unload.

↓

Free Memory.

---

# Memory Leak

Nếu.

Không Release.

↓

Texture.

Không bao giờ.

Được giải phóng.

---

# Memory Budget

Ví dụ.

Game.

Cho phép.

```
500 MB
```

Texture.

↓

400 MB.

Audio.

↓

50 MB.

Font.

↓

20 MB.

Luôn.

Có giới hạn.

---

# Asset Priority

Ví dụ.

```
UI
```

↓

Priority.

Cao.

```
Boss Intro
```

↓

Có thể.

Load sau.

---

# Async Asset

Không Block.

Main Thread.

Ví dụ.

```
Load Atlas
```

↓

Background.

---

# Asset Dependency

Ví dụ.

Animation.

Cần.

```
Atlas
```

```
JSON
```

↓

AssetManager.

Tự.

Load.

Dependency.

---

# Resource Group

Ví dụ.

```
Character
```

↓

```
Animation
```

```
Texture
```

```
Audio
```

Có thể.

Release.

Theo nhóm.

---

# Hot Reload

Developer Mode.

Sửa.

```
hero.png
```

↓

Reload.

Không cần.

Restart.

Game.

---

# Asset Validation

Build.

Kiểm tra.

```
Missing File
```

```
Duplicate ID
```

```
Unused Asset
```

Giúp.

Giảm lỗi.

---

# Asset Pipeline

```text
PSD

↓

Export

↓

Atlas

↓

Compression

↓

Bundle

↓

Game
```

Asset.

Không nên.

Đưa thẳng.

PSD.

Vào Game.

---

# Compression

Texture.

Có thể.

Compress.

↓

Giảm.

Dung lượng.

---

# Streaming Asset

Ví dụ.

Open World.

Không Load.

Toàn bộ.

Map.

↓

Streaming.

Theo.

Camera.

---

# Resource Event

Ví dụ.

```
AssetLoadedEvent
```

↓

Gameplay.

Có thể.

Khởi tạo.

---

# Loading Progress

AssetManager.

Có thể.

Thông báo.

```
35%
```

↓

Loading Screen.

Hiển thị.

Progress.

---

# Fallback Asset

Nếu.

Texture.

Không tồn tại.

↓

Hiện.

```
Missing Texture
```

↓

Không Crash.

---

# Serialization

Asset.

Không lưu.

Trong Save.

Chỉ lưu.

```
Asset ID
```

---

# Debug

Developer Mode.

Hiển thị.

```
Loaded Assets
```

```
Memory Usage
```

```
Cache Size
```

```
Reference Count
```

```
Bundle
```

```
Loading Queue
```

---

# Performance

Không Load.

Asset.

Trong.

```
update()
```

Hoặc.

```
render()
```

Chỉ Load.

Trước.

Hoặc.

Background.

---

# Flame Asset Manager

Trong Flame.

Bạn sẽ thường dùng.

```
images
```

```
Flame.images
```

```
Sprite.load()
```

```
SpriteAnimation.load()
```

```
FlameAudio
```

Tuy nhiên.

Khi game lớn.

Không nên.

Để Gameplay.

Gọi trực tiếp.

Các API này.

Thay vào đó.

Tất cả.

Đi qua.

```
AssetManager
```

↓

AssetManager.

Là lớp duy nhất.

Làm việc.

Với.

Flame.

---

# Kiến trúc hoàn chỉnh

```text
Gameplay

↓

AssetManager

↓

Resource Cache

↓

Bundle

↓

Loader

↓

Flame Asset API

↓

GPU / Memory
```

Gameplay.

Không biết.

Asset.

Được Load.

Như thế nào.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ AssetManager

✅ Resource Cache

✅ Asset Bundle

✅ Lazy Loading

✅ Preloading

✅ Texture Atlas

✅ Reference Counting

✅ Memory Management

✅ Loading Progress

✅ Asset Pipeline

---

# Sai lầm phổ biến

## Sai lầm 1

Gameplay.

Tự gọi.

```
Flame.images.load()
```

Hãy để.

```
AssetManager
```

Là nơi duy nhất.

Load Asset.

---

## Sai lầm 2

Load.

Toàn bộ.

Asset.

Khi mở game.

Chỉ Preload.

Những gì.

Sắp dùng.

---

## Sai lầm 3

Không dùng.

Cache.

↓

Load.

Cùng một.

Texture.

Nhiều lần.

---

## Sai lầm 4

Không Release.

Asset.

Sau khi.

Đổi Scene.

↓

Memory.

Tăng mãi.

---

## Sai lầm 5

Hard Code.

Đường dẫn.

Khắp Project.

Luôn.

Sử dụng.

```
Asset ID
```

Để Gameplay.

Không phụ thuộc.

Cấu trúc thư mục.

---

# Tổng kết

Asset & Resource Management System là nền tảng giúp game tải nhanh, tiết kiệm bộ nhớ và dễ mở rộng.

Sau chương này:

- **AssetManager** trở thành cổng duy nhất để truy cập tài nguyên.
- **Resource Cache** tránh việc tải lặp lại cùng một Asset.
- **Lazy Loading** và **Preloading** cân bằng giữa tốc độ khởi động và trải nghiệm chơi.
- **Asset Bundle** giúp quản lý tài nguyên theo từng Scene hoặc tính năng.
- **Reference Counting** đảm bảo Asset chỉ được giải phóng khi không còn ai sử dụng.
- **Texture Atlas**, **Compression** và **Streaming** giúp tối ưu hiệu năng trên các thiết bị có tài nguyên hạn chế.

Kiến trúc này đủ mạnh để quản lý hàng chục nghìn Asset trong một dự án game lớn mà vẫn giữ được tốc độ tải và mức sử dụng bộ nhớ ổn định.

---

# Chương tiếp theo

Ở **Chương 37**, chúng ta sẽ xây dựng **Game Data Driven Architecture**.

Bạn sẽ học cách xây dựng:

- Data Driven Design.
- Definition vs Instance.
- Registry System.
- Config Database.
- JSON/YAML Asset.
- Factory Pattern.
- Runtime Configuration.
- Hot Reload Config.
- Data Validation.
- Mod Support.

Sau chương này, gần như toàn bộ game (Skill, Enemy, Item, Quest, NPC...) sẽ được điều khiển bằng dữ liệu thay vì Hard Code, giúp việc mở rộng và cân bằng game trở nên cực kỳ dễ dàng.