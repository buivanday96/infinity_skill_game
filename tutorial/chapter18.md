# Chapter 18 - Xây dựng Game Bootstrap & Core Engine

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- Game Bootstrap hoàn chỉnh
- HalpGame
- GameWorld
- CameraController
- GameSystemRegistry
- AssetManager
- EventBus
- Vòng lặp Update đầu tiên

Đây là chương đầu tiên chúng ta bắt đầu code thật.

Không còn chỉ là thiết kế.

Sau chương này game sẽ thật sự chạy được.

---

# Chúng ta sẽ xây cái gì?

Đây là kiến trúc cuối chương.

```text
Flutter

↓

GameWidget

↓

HalpGame

↓

Camera

↓

World

↓

GameSystemRegistry

↓

Systems

↓

Update()
```

Đây là nền tảng của toàn bộ game.

---

# Khởi động Game

Flutter không chạy trực tiếp Gameplay.

Nó chỉ tạo Game.

```text
main()

↓

Bootstrap

↓

HalpGame

↓

GameWidget
```

GameWidget sẽ bắt đầu Game Loop.

---

# Bootstrap

Bootstrap chịu trách nhiệm.

```text
Load Config

↓

Dependency Injection

↓

Logger

↓

AssetManager

↓

EventBus

↓

Create Game
```

Bootstrap không biết.

```
Hero

Monster

Skill
```

---

# HalpGame

HalpGame là trung tâm của Flame.

```text
HalpGame

↓

Load

↓

Update

↓

Render
```

Nhưng.

HalpGame không chứa Gameplay.

---

# HalpGame chỉ điều phối

Một sai lầm phổ biến.

```dart
update()

{

battle();

move();

skill();

}
```

Không.

HalpGame chỉ gọi.

```text
SystemRegistry

↓

Update
```

---

# Game Loop

Flame sẽ chạy.

```text
Load

↓

Update

↓

Render

↓

Update

↓

Render

...
```

Khoảng.

```
60 FPS
```

Chúng ta chỉ cần cắm Gameplay vào.

---

# World

World là nơi chứa mọi Entity.

```text
World

↓

Hero

↓

Monster

↓

Effect

↓

Projectile
```

Không thêm Component trực tiếp vào HalpGame.

---

# Camera

Camera được tạo một lần.

```text
Camera

↓

World
```

Sau này.

Camera sẽ hỗ trợ.

- Zoom
- Shake
- Follow
- Bounds

---

# Camera Controller

Thay vì.

```dart
camera.zoom=2;
```

Khắp project.

Chúng ta sẽ có.

```
CameraController
```

Ví dụ.

```text
Follow Hero
```

```
Shake
```

```
Move To
```

```
Zoom
```

Gameplay chỉ gọi.

```
CameraController
```

---

# GameSystemRegistry

Đây là trái tim Gameplay.

```text
Registry

↓

AISystem

↓

MovementSystem

↓

BattleSystem

↓

SkillSystem

↓

DungeonSystem
```

Registry biết.

- System nào tồn tại
- Thứ tự Update
- Lifecycle

---

# Vì sao cần Registry?

Nếu không.

HalpGame.

```dart
update()

{

ai();

battle();

skill();

inventory();

quest();

}
```

Sau vài tháng.

File sẽ rất lớn.

Registry giải quyết vấn đề này.

---

# Lifecycle của System

Mỗi System nên có.

```text
Initialize

↓

Load

↓

Update

↓

Dispose
```

Nhờ vậy.

Mọi System hoạt động giống nhau.

---

# BaseGameSystem

Toàn bộ System nên kế thừa.

```
GameSystem
```

Ví dụ.

```
BattleSystem
```

```
AISystem
```

```
QuestSystem
```

```
InventorySystem
```

Đều có cùng Interface.

---

# Thứ tự Update

Registry sẽ Update.

```text
Input

↓

AI

↓

Movement

↓

Battle

↓

Skill

↓

Dungeon

↓

Quest

↓

Event
```

Đây là thứ tự cố định.

---

# AssetManager

Ngay khi Game khởi động.

AssetManager được tạo.

```text
AssetManager

↓

Preload

↓

Ready
```

Chưa Load toàn bộ Asset.

Chỉ Load.

- UI
- Hero
- Common Effect

---

# EventBus

Ngay khi Game bắt đầu.

EventBus cũng được tạo.

```text
Battle

↓

MonsterDeadEvent

↓

GameEventBus
```

Mặc dù.

Chưa có Monster.

Kiến trúc đã sẵn sàng.

---

# Dependency Injection

Mọi System đều lấy Dependency.

Thông qua.

```
DI
```

Ví dụ.

```
BattleSystem

↓

EventBus

↓

AssetManager

↓

Logger
```

Không tự tạo.

---

# Game Context

Một số dữ liệu dùng chung.

```
Delta Time
```

```
Difficulty
```

```
Game Time
```

```
Seed
```

Có thể đặt trong.

```
GameContext
```

Các System cùng đọc.

---

# Delta Time

Registry truyền.

```
dt
```

Cho toàn bộ System.

```text
Registry

↓

Battle

↓

AI

↓

Movement
```

Nhờ vậy.

Gameplay đồng bộ.

---

# Không tạo Hero

Trong chương này.

World vẫn rỗng.

```text
World

↓

(No Entity)
```

Điều này hoàn toàn bình thường.

Chúng ta đang xây Engine.

---

# Load Flow

Khi mở Game.

```text
Flutter

↓

Bootstrap

↓

DI

↓

AssetManager

↓

EventBus

↓

Registry

↓

World

↓

Camera

↓

Ready
```

Sau đó.

Game Loop bắt đầu.

---

# Update Flow

Mỗi Frame.

```text
Flame

↓

HalpGame.update(dt)

↓

GameSystemRegistry

↓

AISystem

↓

MovementSystem

↓

BattleSystem

↓

DungeonSystem

↓

Event Queue

↓

Finish
```

Render xảy ra sau đó.

---

# Render Flow

```text
World

↓

Camera

↓

Visible Components

↓

Render Layer

↓

GPU
```

Gameplay không tham gia.

---

# Dispose Flow

Khi thoát Game.

```text
Save

↓

Dispose Systems

↓

Dispose World

↓

Release Assets

↓

Exit
```

Không nên.

```
kill app
```

Ngay lập tức.

---

# Logging

Ngay từ đầu.

Nên có.

```
GameLogger
```

Ví dụ.

```
Battle Started
```

```
Dungeon Generated
```

```
Skill Used
```

Sau này.

Debug sẽ rất dễ.

---

# Debug Overlay

Ngay từ đầu.

Có thể thêm.

```
FPS
```

```
Entity Count
```

```
Memory
```

```
Current Floor
```

Không dành cho người chơi.

Chỉ dành cho Developer.

---

# Kết quả sau chương này

Project sẽ có.

```text
Flutter

↓

Bootstrap

↓

GameWidget

↓

HalpGame

↓

Camera

↓

World

↓

Registry

↓

AssetManager

↓

EventBus

↓

Game Loop
```

Gameplay.

```
Chưa có
```

Engine.

```
Đã hoàn chỉnh
```

---

# Checklist

Sau chương này hãy đảm bảo.

✅ Game chạy được

✅ HalpGame hoạt động

✅ World được tạo

✅ Camera hoạt động

✅ Registry Update được

✅ AssetManager khởi tạo

✅ EventBus khởi tạo

✅ Logger hoạt động

✅ Game Loop chạy ổn định

---

# Sai lầm phổ biến

## Sai lầm 1

Đưa Gameplay vào HalpGame.

Gameplay luôn thuộc System.

---

## Sai lầm 2

System tự Update nhau.

Chỉ Registry được quyền Update.

---

## Sai lầm 3

Component tự Load Asset.

Asset chỉ đi qua AssetManager.

---

## Sai lầm 4

Không có Lifecycle.

Mọi System nên có.

```
Initialize

Load

Update

Dispose
```

---

## Sai lầm 5

Khởi tạo Hero ngay.

Đừng.

Engine phải hoàn chỉnh trước.

---

# Tổng kết

Đến đây chúng ta đã hoàn thành phần **Core Engine**.

Game đã có đầy đủ các thành phần nền tảng:

- Bootstrap.
- HalpGame.
- World.
- Camera.
- System Registry.
- AssetManager.
- EventBus.
- Logger.
- Game Loop.

Điều quan trọng nhất là:

**Engine đã sẵn sàng nhưng chưa có Gameplay.**

Đây chính là cách các game thương mại thường được xây dựng: hoàn thiện nền móng trước, sau đó mới lần lượt bổ sung Hero, Monster, Battle và các tính năng khác.

---

# Chương tiếp theo

Ở **Chương 19**, chúng ta sẽ tạo **Entity Framework**.

Đây là bước đầu tiên để có nhân vật thật sự trong game.

Bạn sẽ xây dựng:

- BaseEntity.
- HeroEntity.
- MonsterEntity.
- EntityId.
- StatComponent.
- TransformComponent.
- HealthComponent.
- EntityFactory.
- Entity Registry.

Sau chương này, game sẽ có những Entity đầu tiên và sẵn sàng tham gia vào Gameplay.