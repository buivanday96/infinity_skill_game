# Chapter 35 - Game State & Scene Management System - Xây dựng hệ thống quản lý Game State và Scene chuyên nghiệp

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- Game State Machine
- Scene Management
- Scene Lifecycle
- Scene Transition
- Loading Screen
- Bootstrap Scene
- Persistent Systems
- Async Scene Loading
- Pause System
- Scene Event Pipeline

Đây là chương giúp toàn bộ game được tổ chức đúng cách.

Nếu Scene được thiết kế sai.

Game sẽ rất nhanh trở nên khó bảo trì.

---

# Scene là gì?

Rất nhiều người nghĩ.

Scene chỉ là.

```
Map
```

Hoặc.

```
Level
```

Thực tế.

Scene là.

```
Một tập hợp Gameplay

+

UI

+

Entities

+

Logic
```

Ví dụ.

```
Main Menu
```

Cũng là.

Một Scene.

---

# Scene Management

Scene.

Không tự.

Load.

Scene.

Được quản lý.

Bởi.

```
SceneManager
```

---

# Scene Flow

```text
Current Scene

↓

Unload

↓

Load

↓

Initialize

↓

Ready
```

Scene.

Không gọi nhau.

Trực tiếp.

---

# Bootstrap Scene

Game.

Nên bắt đầu.

Từ.

```
Bootstrap
```

Không phải.

Main Menu.

Bootstrap.

Khởi tạo.

```
Audio

Save

Localization

Config

Analytics

EventBus
```

Sau đó.

Mới.

Load.

Main Menu.

---

# Game State

Game.

Có nhiều.

State.

Ví dụ.

```
Boot
```

```
Loading
```

```
Main Menu
```

```
Playing
```

```
Paused
```

```
Game Over
```

---

# Game State Machine

```text
Boot

↓

Loading

↓

Main Menu

↓

Playing

↓

Paused

↓

Playing

↓

Game Over
```

Đây là.

State Machine.

---

# Scene Lifecycle

Một Scene.

Có vòng đời.

```text
Create

↓

Load

↓

Initialize

↓

Active

↓

Pause

↓

Resume

↓

Dispose
```

Không nên.

Chỉ có.

```
onLoad()
```

---

# Create

Scene.

Được tạo.

Nhưng.

Chưa Load.

Asset.

---

# Load

Scene.

Load.

```
Sprite
```

```
Audio
```

```
Map
```

```
Prefab
```

---

# Initialize

Sau khi.

Load xong.

Scene.

Kết nối.

Các System.

---

# Active

Gameplay.

Đang chạy.

Update.

Render.

Input.

---

# Pause

Scene.

Tạm dừng.

Gameplay.

Nhưng.

Không bị Dispose.

---

# Resume

Quay lại.

Gameplay.

Không cần.

Load lại.

---

# Dispose

Thoát Scene.

↓

Giải phóng.

Memory.

---

# Persistent System

Một số System.

Không bị.

Destroy.

Ví dụ.

```
Audio
```

```
Save
```

```
Analytics
```

```
Localization
```

```
EventBus
```

Chúng tồn tại.

Suốt Game.

---

# Local System

Ví dụ.

```
EnemySpawner
```

```
DungeonSystem
```

```
PuzzleSystem
```

Chỉ tồn tại.

Trong Scene.

---

# Scene Transition

Không nên.

```
Load

↓

Hiện ngay
```

Nên.

```
Fade Out

↓

Loading

↓

Fade In
```

---

# Transition Effect

Ví dụ.

```
Black Fade
```

```
White Flash
```

```
Blur
```

```
Portal
```

Transition.

Là.

Một System.

---

# Loading Screen

Nếu.

Map.

Lớn.

↓

Hiển thị.

```
Loading...
```

↓

Progress.

↓

Scene Ready.

---

# Async Loading

Không Block.

Main Thread.

Ví dụ.

```
Load Texture
```

↓

Background.

---

# Preload

Ví dụ.

Sau.

Level 1.

↓

Load trước.

Level 2.

Gameplay.

Mượt hơn.

---

# Asset Ownership

Scene.

Chỉ sở hữu.

Asset.

Của Scene.

Persistent Asset.

Do.

AssetManager.

Quản lý.

---

# Scene Event

Ví dụ.

```
SceneLoadedEvent
```

↓

UI.

↓

Analytics.

↓

Music.

---

# Scene Changed

Ví dụ.

```
Dungeon

↓

Village
```

↓

```
SceneChangedEvent
```

Audio.

Đổi.

BGM.

---

# Camera

Camera.

Không nên.

Thuộc.

Scene.

Camera.

Có thể.

Persistent.

Hoặc.

Scene Local.

Tùy Game.

---

# UI Layer

Gameplay.

Không nên.

Tự tạo.

UI.

Scene.

Chỉ phát.

```
OpenInventoryEvent
```

↓

UI.

---

# Pause System

Pause.

Không có nghĩa.

Dừng.

Toàn bộ Game.

Ví dụ.

Gameplay.

↓

Pause.

Nhưng.

```
UI

Audio

Animation
```

Vẫn chạy.

---

# Time Scale

Pause.

Có thể.

Đặt.

```
Time Scale

0
```

Gameplay.

Dừng.

---

# Overlay Scene

Ví dụ.

```
Inventory
```

Không cần.

Đổi Scene.

Có thể.

Hiện.

```
Overlay
```

---

# Popup

Ví dụ.

```
Settings
```

```
Shop
```

```
Pause Menu
```

Không phải.

Scene.

---

# Scene Stack

Ví dụ.

```text
Gameplay

↓

Inventory

↓

Settings
```

Đây là.

Stack.

Không phải.

Destroy.

Gameplay.

---

# Modal Layer

Ví dụ.

```
Dialogue
```

↓

Chặn.

Input.

Gameplay.

---

# Scene Context

Mỗi Scene.

Có.

```
Context
```

Ví dụ.

```
Current Map
```

```
Difficulty
```

```
Spawn Point
```

---

# Restart Scene

Ví dụ.

Player.

Chết.

↓

Reload.

Scene.

Không cần.

Restart.

Game.

---

# Game Restart

Khác với.

Restart Scene.

Game.

Quay lại.

```
Bootstrap
```

---

# Multiplayer

Một Client.

Có thể.

Load.

Scene.

Khác.

Client khác.

Server.

Quản lý.

Gameplay.

Không quản lý.

UI.

---

# Serialization

Scene.

Không lưu.

Toàn bộ.

Object.

Chỉ lưu.

Gameplay State.

---

# Memory

Khi.

Dispose.

↓

Release.

```
Texture
```

```
Audio
```

```
Particles
```

Không giữ.

Tham chiếu.

---

# Debug

Developer Mode.

Hiển thị.

```
Current Scene
```

```
Loading Time
```

```
Scene Stack
```

```
Active Systems
```

```
Memory
```

```
Persistent Systems
```

---

# Scene Event Pipeline

```text
Load Scene

↓

SceneLoadedEvent

↓

Audio

↓

UI

↓

Analytics

↓

Gameplay
```

---

# Kiến trúc hoàn chỉnh

```text
Bootstrap

↓

SceneManager

↓

Scene Lifecycle

↓

Game State Machine

↓

Gameplay

↓

EventBus

↓

UI
```

Scene.

Không biết.

Scene khác.

Gameplay.

Không biết.

Loading.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ SceneManager

✅ Game State Machine

✅ Bootstrap Scene

✅ Scene Lifecycle

✅ Async Loading

✅ Loading Screen

✅ Scene Transition

✅ Pause System

✅ Scene Stack

✅ Persistent Systems

---

# Sai lầm phổ biến

## Sai lầm 1

Scene.

Tự Load.

Scene khác.

Hãy để.

```
SceneManager
```

Điều phối.

---

## Sai lầm 2

Toàn bộ.

System.

Đều Persistent.

Chỉ giữ.

Những System.

Thực sự.

Toàn cục.

---

## Sai lầm 3

Dispose.

Không giải phóng.

Asset.

Sau vài Scene.

Game.

Sẽ rò rỉ.

Memory.

---

## Sai lầm 4

Popup.

Là.

Scene.

Popup.

Nên là.

Overlay.

---

## Sai lầm 5

Pause.

Bằng cách.

Dừng.

Toàn bộ.

Application.

Chỉ Gameplay.

Nên.

Pause.

---

# Tổng kết

Game State & Scene Management System là nền tảng điều phối toàn bộ vòng đời của game.

Sau chương này:

- **SceneManager** chịu trách nhiệm chuyển đổi giữa các Scene.
- **Game State Machine** quản lý trạng thái tổng thể của game.
- **Scene Lifecycle** giúp mỗi Scene có quy trình khởi tạo và hủy rõ ràng.
- **Bootstrap Scene** là nơi khởi tạo các System toàn cục.
- **Persistent Systems** tồn tại xuyên suốt game, còn Scene chỉ chứa những thành phần cục bộ.
- **Loading Screen**, **Async Loading** và **Scene Transition** giúp việc chuyển màn chơi mượt mà và chuyên nghiệp.
- **Scene Stack** và **Overlay** cho phép hiển thị Inventory, Settings hay Dialogue mà không cần tải lại Gameplay.

Kiến trúc này phù hợp cho cả game nhỏ lẫn game thế giới mở, đồng thời giúp mở rộng dễ dàng sang Multiplayer, DLC hoặc Streaming World.

---

# Chương tiếp theo

Ở **Chương 36**, chúng ta sẽ xây dựng **Asset & Resource Management System**.

Bạn sẽ học cách xây dựng:

- Asset Manager.
- Resource Cache.
- Asset Bundle.
- Lazy Loading.
- Preloading.
- Reference Counting.
- Memory Management.
- Texture Atlas.
- Resource Hot Reload.
- Asset Pipeline.

Sau chương này, game sẽ quản lý toàn bộ hình ảnh, âm thanh, font, animation và dữ liệu một cách hiệu quả, giảm thời gian tải và tối ưu bộ nhớ cho các dự án lớn.