# Chapter 16 - Project Architecture - Thiết kế kiến trúc cho game Flutter Flame quy mô lớn

# Mục tiêu

Sau chương này bạn sẽ hiểu:

- Kiến trúc tổng thể của game
- Vì sao Architecture quan trọng
- Feature First
- Layered Architecture
- ECS-inspired Design
- Dependency Injection
- Game Systems
- Data Flow
- Folder Structure
- Cách tổ chức project có thể phát triển trong nhiều năm

Đây là chương quan trọng nhất của toàn bộ series.

Nếu những chương trước là xây từng viên gạch.

Thì chương này sẽ ghép toàn bộ thành một kiến trúc hoàn chỉnh.

---

# Tại sao cần Architecture?

Khi mới bắt đầu.

Project chỉ có.

```
Hero

Monster

Battle
```

Mọi thứ rất đơn giản.

Nhưng sau vài tháng.

Game sẽ có.

- 300 Hero
- 500 Skill
- 100 Monster
- Quest
- Achievement
- Inventory
- Shop
- Save
- Multiplayer (có thể)
- Live Event

Nếu không có kiến trúc tốt.

Project sẽ rất nhanh trở thành.

```
God Object
```

Hoặc.

```
1000 file phụ thuộc lẫn nhau
```

---

# Mục tiêu của Architecture

Một kiến trúc tốt phải đạt được.

- Dễ đọc
- Dễ mở rộng
- Dễ test
- Ít Coupling
- Tái sử dụng cao
- Có thể thay thế từng System

Đây là mục tiêu xuyên suốt của series.

---

# Triết lý của dự án

Game của chúng ta sẽ theo hướng.

```
Feature First

+

Layered Architecture

+

System Driven

+

ECS Inspired
```

Không phải ECS hoàn chỉnh.

Nhưng học những ý tưởng tốt nhất của ECS.

---

# Không phải mọi thứ đều là Component

Một sai lầm rất phổ biến.

```
HeroComponent

↓

AI

↓

Damage

↓

Save

↓

Skill

↓

Inventory
```

Một Component làm tất cả.

Đây là nguyên nhân khiến project ngày càng khó bảo trì.

---

Trong dự án.

Component chỉ có nhiệm vụ.

```
Render

Input

Animation
```

---

# Kiến trúc tổng thể

```text
Flutter App

↓

GameWidget

↓

HalpGame

↓

Systems

↓

Models

↓

Components
```

Gameplay nằm trong System.

Render nằm trong Component.

---

# Các System

Đến thời điểm này.

Chúng ta đã xây dựng.

```
BattleSystem
```

```
AISystem
```

```
SkillSystem
```

```
DungeonSystem
```

```
EventSystem
```

```
SaveSystem
```

```
AssetManager
```

Các System gần như độc lập.

---

# Mỗi System chỉ làm một việc

Ví dụ.

```
BattleSystem
```

Không biết.

```
Save
```

Không biết.

```
Audio
```

Không biết.

```
UI
```

Chỉ biết.

```
Battle
```

Đây là nguyên tắc.

```
Single Responsibility
```

---

# Data Layer

Toàn bộ dữ liệu nằm ở đây.

Ví dụ.

```
HeroModel
```

```
MonsterModel
```

```
SkillModel
```

```
DungeonModel
```

Không có Flame.

Không có Widget.

Không có Sprite.

Chỉ là dữ liệu.

---

# Presentation Layer

Bao gồm.

```
Component
```

```
Overlay UI
```

```
Animation
```

```
Effect
```

Đây là nơi người chơi nhìn thấy.

---

# Domain Layer

Domain là Gameplay.

Ví dụ.

```
Battle

AI

Skill

Stat

Quest

Inventory
```

Toàn bộ Logic đều ở đây.

---

# Data Flow

Một luồng dữ liệu điển hình.

```text
Input

↓

System

↓

Model

↓

Event

↓

Component

↓

Render
```

Không có bước nào đi ngược lại.

---

# Vì sao không cho Component sửa Model?

Sai.

```dart
HeroComponent.hp--;
```

Component chỉ hiển thị.

BattleSystem mới được sửa HP.

Điều này giúp.

Gameplay luôn thống nhất.

---

# Dependency Injection

Các System không tự tạo nhau.

Sai.

```dart
BattleSystem()

↓

new SaveSystem()
```

Đúng.

```text
DI

↓

BattleSystem

↓

SaveSystem
```

Battle chỉ biết Interface.

Không biết Implementation.

---

# Event Bus

Mọi System giao tiếp.

Thông qua.

```
GameEventBus
```

Ví dụ.

```
Battle

↓

MonsterDeadEvent

↓

Quest

↓

Achievement

↓

Audio

↓

UI
```

Không gọi trực tiếp.

---

# AssetManager

Gameplay không Load Asset.

```
Hero

↓

AssetManager

↓

Sprite
```

Không.

```dart
Sprite.load(...)
```

Khắp project.

---

# Save System

Gameplay không Save.

```
Battle

↓

FloorCompletedEvent

↓

SaveSystem
```

Save hoàn toàn độc lập.

---

# Folder Structure

Đây là cấu trúc mà series hướng tới.

```text
lib/

    core/

        engine/

        event/

        asset/

        save/

        config/

        utils/

    features/

        battle/

        dungeon/

        hero/

        monster/

        skill/

        inventory/

        quest/

        ui/

    game/

        systems/

        components/

        models/

        camera/

        world/

    shared/
```

Feature luôn đứng đầu.

Không chia theo Widget.

---

# Ví dụ Feature

```
battle/

    data/

    domain/

    presentation/
```

Trong đó.

```
domain/
```

Là Gameplay.

```
presentation/
```

Là Flame Component.

---

# Không tạo Utility khổng lồ

Sai.

```
utils/

↓

500 file
```

Hoặc.

```
GameHelper.dart

3500 dòng
```

Nếu Utility chỉ dùng cho Battle.

Hãy đặt ngay trong.

```
battle/
```

---

# Game Context

Một số System cần dùng chung.

Ví dụ.

```
Camera
```

```
World
```

```
GameTime
```

```
Difficulty
```

Có thể gom vào.

```
GameContext
```

Nhưng.

Không biến nó thành.

```
God Object
```

---

# Update Order

Một Frame.

```text
Input

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

↓

Event

↓

Render
```

Thứ tự rất quan trọng.

Ví dụ.

Không thể.

```
Battle

↓

AI
```

Nếu AI chưa chọn Target.

---

# Component Tree

Render.

```text
World

├── Background

├── Monster Layer

├── Hero Layer

├── Effect Layer

├── UILayer
```

Mỗi Layer độc lập.

---

# Module độc lập

Một Feature nên có thể phát triển riêng.

Ví dụ.

```
Quest
```

Không nên phụ thuộc.

```
Shop
```

```
Inventory
```

```
Achievement
```

Nếu cần.

Trao đổi qua Event.

---

# Testing

Nhờ Architecture này.

Có thể Test.

```
BattleSystem
```

Không cần Flame.

Có thể Test.

```
SkillSystem
```

Không cần UI.

Đây là lợi ích rất lớn.

---

# Mở rộng trong tương lai

Sau này.

Muốn thêm.

```
Guild
```

Hoặc.

```
PvP
```

Hoặc.

```
Co-op
```

Chỉ cần.

```
Feature mới
```

Không phải sửa toàn bộ Game.

---

# Kiến trúc hoàn chỉnh

Sau 16 chương.

Game sẽ có.

```text
Flutter

↓

GameWidget

↓

HalpGame

↓

Input

↓

Game Systems

    AI

    Battle

    Skill

    Dungeon

    Save

    Asset

↓

Models

↓

Event Bus

↓

Components

↓

Render
```

Đây chính là "xương sống" của toàn bộ dự án.

---

# Những nguyên tắc quan trọng nhất

Trong toàn bộ series.

Chúng ta luôn tuân thủ.

### 1. Model không biết Flame

```
✔ HeroModel
```

Không import.

```
SpriteComponent
```

---

### 2. Component không chứa Gameplay

Component chỉ.

- Render
- Animation
- Input

---

### 3. Gameplay nằm trong System

```
Battle

AI

Skill

Dungeon
```

Đều là System.

---

### 4. System giao tiếp bằng Event

Không gọi trực tiếp.

---

### 5. Asset đi qua AssetManager

Không Hard Code đường dẫn.

---

### 6. Save chỉ Serialize Model

Không Serialize Component.

---

### 7. Mỗi System chỉ có một trách nhiệm

Đây là nguyên tắc quan trọng nhất.

---

# Sai lầm phổ biến

## Sai lầm 1

Đặt toàn bộ code trong.

```
game.dart
```

Sau vài tháng.

File sẽ hàng chục nghìn dòng.

---

## Sai lầm 2

Component chứa Gameplay.

Điều này khiến Logic và Render bị trộn lẫn.

---

## Sai lầm 3

Feature phụ thuộc lẫn nhau.

Ví dụ.

```
Quest

↓

Battle

↓

Inventory

↓

Quest
```

Tạo vòng lặp phụ thuộc.

---

## Sai lầm 4

System gọi trực tiếp nhau.

Hãy sử dụng Event.

---

## Sai lầm 5

Không có ranh giới giữa Domain và Presentation.

Sau này rất khó Test và tái sử dụng.

---

# Tổng kết

Sau 16 chương, chúng ta đã xây dựng được một kiến trúc hoàn chỉnh cho một game Flutter Flame quy mô lớn.

Các nguyên tắc cốt lõi là:

- **Feature First** để tổ chức mã nguồn theo tính năng.
- **Layered Architecture** để tách Domain, Data và Presentation.
- **System-driven Design** để Gameplay nằm trong các System thay vì Component.
- **ECS-inspired** để dữ liệu, hành vi và hiển thị được tách biệt.
- **Event Bus** để giảm Coupling.
- **AssetManager** để quản lý toàn bộ tài nguyên.
- **Save System** chỉ lưu Model.
- **Flame Component** chỉ chịu trách nhiệm Render.

Kiến trúc này đủ linh hoạt để phát triển game trong thời gian dài, đồng thời vẫn giữ được mã nguồn rõ ràng, dễ mở rộng và dễ kiểm thử.

---

# Chương tiếp theo

Ở chương 17, chúng ta sẽ bắt đầu **xây dựng dự án thực tế từ đầu**.

Không còn nói về lý thuyết nữa.

Chúng ta sẽ từng bước tạo một game hoàn chỉnh bằng Flutter Flame, bao gồm:

- Khởi tạo project.
- Thiết lập cấu trúc thư mục.
- Cài đặt Flame.
- Tạo Game class.
- Camera.
- World.
- AssetManager.
- EventBus.
- GameSystemRegistry.

Từ chương này trở đi, toàn bộ series sẽ chuyển sang **code thực tế**, áp dụng tất cả những kiến thức đã học trong 16 chương đầu.