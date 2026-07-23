# Chapter 37 - Data Driven Architecture - Xây dựng kiến trúc Data Driven chuyên nghiệp

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- Data Driven Architecture
- Definition vs Instance
- Registry System
- Config Database
- Factory Pattern
- Runtime Configuration
- Hot Reload
- Data Validation
- Dependency Resolution
- Mod Support

Đây là chương thay đổi hoàn toàn cách bạn phát triển game.

Sau chương này.

Bạn sẽ gần như.

Không còn.

Hard Code.

Gameplay.

---

# Data Driven là gì?

Rất nhiều người nghĩ.

Data Driven là.

```
Đọc JSON
```

Thực tế.

Data Driven là.

```
Gameplay

↓

Data

↓

Engine
```

Code.

Không biết.

```
Sword
```

```
Goblin
```

```
Fireball
```

Code.

Chỉ biết.

```
Definition
```

---

# Hard Code

Ví dụ.

Sai.

```dart
if(enemy == "Goblin"){
 attack = 10;
}
```

Mỗi lần.

Thêm Enemy.

↓

Sửa Code.

---

# Data Driven

Đúng.

```text
Goblin.json

↓

Attack = 10

↓

Engine đọc

↓

Gameplay
```

Không cần.

Compile lại.

---

# Engine

Engine.

Không biết.

```
Goblin
```

Engine.

Chỉ biết.

```
Enemy Definition
```

---

# Definition

Definition.

Là dữ liệu.

Không đổi.

Ví dụ.

```
Iron Sword
```

```
Slime
```

```
Fireball
```

Definition.

Không chứa.

Gameplay State.

---

# Instance

Instance.

Được sinh.

Từ Definition.

Ví dụ.

```
Goblin

HP 35
```

Goblin khác.

↓

```
HP 10
```

Cùng.

Definition.

Khác.

Instance.

---

# Config Database

Toàn bộ.

Definition.

Được lưu.

Trong.

```
Config Database
```

Ví dụ.

```
Enemy

Item

Quest

Skill

NPC
```

---

# Registry

Registry.

Quản lý.

Definition.

Ví dụ.

```
EnemyRegistry
```

↓

Tra cứu.

```
enemyId
```

↓

Definition.

---

# Registry Flow

```text
Enemy ID

↓

Enemy Registry

↓

Enemy Definition

↓

Factory

↓

Enemy Instance
```

---

# Factory Pattern

Gameplay.

Không tự.

```
new Goblin()
```

Gameplay.

Gọi.

```
EnemyFactory
```

↓

Factory.

Đọc.

Definition.

↓

Sinh.

Instance.

---

# Factory

Factory.

Không chứa.

Gameplay.

Factory.

Chỉ.

```
Create Object
```

---

# Runtime Configuration

Ví dụ.

Bạn sửa.

```
Goblin HP

50

↓

80
```

Không cần.

Compile.

Game.

Đọc lại.

Config.

---

# JSON

Ví dụ.

```
enemy_goblin.json
```

```
item_sword.json
```

```
skill_fireball.json
```

Gameplay.

Không biết.

Tên File.

---

# Config ID

Không dùng.

Tên File.

Để Gameplay.

Tra cứu.

Luôn dùng.

```
Definition ID
```

Ví dụ.

```
enemy_goblin
```

---

# Config Loader

Toàn bộ.

JSON.

Được Load.

Bởi.

```
ConfigLoader
```

Gameplay.

Không đọc.

JSON.

---

# Config Cache

Definition.

Đã Load.

↓

Cache.

Không Parse.

Nhiều lần.

---

# Runtime Lookup

Ví dụ.

```
enemy_goblin
```

↓

Registry

↓

EnemyDefinition

↓

EnemyFactory

↓

Enemy.

---

# Data Validation

Khi Build.

Kiểm tra.

```
Duplicate ID
```

```
Missing Asset
```

```
Missing Skill
```

```
Invalid Reference
```

Không để.

Gameplay.

Crash.

---

# Dependency

Ví dụ.

Enemy.

Có.

```
Skill

↓

Fireball
```

Config.

Phải kiểm tra.

```
Fireball

Có tồn tại?
```

---

# Circular Dependency

Sai.

```
Skill A

↓

Skill B

↓

Skill A
```

Không được.

Cho phép.

---

# Config Version

Ví dụ.

```
Config v1
```

↓

```
Config v2
```

Engine.

Có thể.

Migration.

---

# Hot Reload

Developer.

Sửa.

```
Fireball Damage
```

↓

Save File.

↓

Game.

Reload.

Không cần.

Restart.

---

# Data Editor

Khi Game lớn.

Không sửa.

JSON.

Bằng tay.

Có thể.

Làm.

```
Editor
```

↓

Xuất.

JSON.

---

# Localization

Definition.

Không lưu.

Text.

Ví dụ.

```
item.sword.name
```

↓

Localization.

---

# Shared Definition

Ví dụ.

```
Potion
```

Được dùng.

Bởi.

```
Shop
```

```
Loot
```

```
Craft
```

```
Quest
```

Chỉ có.

Một Definition.

---

# Config Reference

Ví dụ.

Quest.

Không lưu.

```
Sword Object
```

Chỉ lưu.

```
item_sword
```

---

# Registry Separation

Không tạo.

```
EverythingRegistry
```

Nên tách.

```
Enemy Registry
```

```
Item Registry
```

```
Skill Registry
```

```
Quest Registry
```

---

# Script

Script.

Không nên.

Hard Code.

Gameplay.

Script.

Chỉ.

Ghép.

Definition.

---

# Random Config

Ví dụ.

Loot.

Không Hard Code.

```
Potion

50%
```

↓

Đọc.

JSON.

---

# Balancing

Designer.

Muốn.

Goblin mạnh hơn.

↓

Đổi.

```
HP

Attack

Speed
```

Không cần.

Developer.

---

# DLC

Nếu.

Game.

Có DLC.

↓

Chỉ thêm.

Definition.

Không cần.

Sửa Engine.

---

# Mod Support

Người chơi.

Có thể.

Thêm.

```
enemy_dragon.json
```

↓

Registry.

↓

Game.

Nhận.

Enemy mới.

Không sửa.

Code.

---

# Serialization

Save.

Không lưu.

Definition.

Chỉ lưu.

```
Definition ID
```

+

```
Runtime State
```

---

# Flame Integration

Trong Flame.

Bạn vẫn dùng.

```
SpriteComponent
```

```
PositionComponent
```

```
AnimationComponent
```

Nhưng.

Component.

Không biết.

```
Goblin
```

↓

Chỉ biết.

```
EnemyDefinition
```

---

# Event

Gameplay.

Đọc.

Definition.

↓

Spawn.

↓

Publish Event.

↓

Gameplay.

---

# Debug

Developer Mode.

Hiển thị.

```
Loaded Config
```

```
Registry Count
```

```
Missing Reference
```

```
Duplicate ID
```

```
Hot Reload Time
```

---

# Performance

Không Parse.

JSON.

Trong.

Gameplay.

Load.

Một lần.

↓

Cache.

---

# Kiến trúc hoàn chỉnh

```text
JSON

↓

Config Loader

↓

Registry

↓

Factory

↓

Definition

↓

Instance

↓

Gameplay
```

Gameplay.

Không biết.

JSON.

Không biết.

File.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ Config Loader

✅ Registry

✅ Factory

✅ Definition

✅ Instance

✅ Hot Reload

✅ Validation

✅ Dependency Check

✅ Runtime Config

✅ Mod Support

---

# Sai lầm phổ biến

## Sai lầm 1

Gameplay.

Đọc.

JSON.

Trực tiếp.

Hãy để.

```
ConfigLoader
```

Làm việc đó.

---

## Sai lầm 2

Definition.

Lưu.

HP.

Hiện tại.

Definition.

Chỉ chứa.

Dữ liệu.

Tĩnh.

---

## Sai lầm 3

Mỗi System.

Có Config.

Riêng.

Không có.

Registry.

Chung.

---

## Sai lầm 4

Hard Code.

Tên Asset.

Tên Skill.

Tên Enemy.

Khắp Project.

Luôn dùng.

```
Definition ID
```

---

## Sai lầm 5

Không kiểm tra.

Config.

Trước.

Build.

↓

Crash.

Khi Runtime.

---

# Tổng kết

Data Driven Architecture là nền tảng giúp game dễ mở rộng, dễ cân bằng và giảm phụ thuộc vào mã nguồn.

Sau chương này:

- **Definition** chứa toàn bộ dữ liệu tĩnh, còn **Instance** lưu trạng thái trong lúc chạy.
- **ConfigLoader** chịu trách nhiệm đọc dữ liệu và đưa vào **Registry**.
- **Factory** tạo các đối tượng Gameplay từ Definition mà không cần biết dữ liệu đến từ đâu.
- **Registry** trở thành nơi tra cứu duy nhất cho Item, Enemy, Skill, Quest và NPC.
- **Hot Reload** giúp thay đổi dữ liệu ngay trong lúc chạy game.
- **Validation** và **Dependency Check** giúp phát hiện lỗi cấu hình trước khi phát hành.

Kiến trúc này cho phép Designer cân bằng game chỉ bằng cách chỉnh dữ liệu, đồng thời mở đường cho DLC, Mod và các công cụ Editor mà gần như không phải thay đổi Gameplay Engine.

---

# Chương tiếp theo

Ở **Chương 38**, chúng ta sẽ xây dựng **AI Architecture & Behavior System**.

Bạn sẽ học cách xây dựng:

- AI Brain.
- State Machine AI.
- Behavior Tree.
- Utility AI.
- Blackboard.
- Perception System.
- Decision Making.
- Navigation.
- AI Event Pipeline.
- AI Debugger.

Sau chương này, Enemy, NPC và Boss sẽ có kiến trúc AI hiện đại, dễ mở rộng và có thể tái sử dụng cho hàng trăm loại nhân vật khác nhau.