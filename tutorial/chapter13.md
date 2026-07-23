# Chapter 13 - Save & Load System - Thiết kế hệ thống lưu game chuyên nghiệp

# Mục tiêu

Sau chương này bạn sẽ hiểu:

- Save System là gì
- Những gì cần lưu
- Những gì không nên lưu
- Snapshot Save
- Auto Save
- Continue Game
- Serialization
- Kiến trúc Save System của dự án

Đây là chương rất quan trọng.

Rất nhiều game thất bại vì Save System được thiết kế quá muộn.

Khi game đã có hàng chục System, việc thêm Save trở nên cực kỳ khó khăn.

Trong series này, Save System sẽ được thiết kế ngay từ đầu để mọi System đều có thể lưu và khôi phục trạng thái một cách dễ dàng.

---

# Save Game là gì?

Save Game không phải là lưu toàn bộ RAM.

Save Game là:

> Lưu đủ dữ liệu để có thể khôi phục lại trạng thái của trò chơi.

Ví dụ.

```
Floor

150
```

```
Gold

12345
```

```
Hero Level

35
```

```
Skill

15
```

Lần sau mở game.

Người chơi tiếp tục đúng tại đó.

---

# Điều đầu tiên cần hiểu

Một sai lầm phổ biến.

```
Save

↓

Component
```

Không.

Component chỉ là giao diện.

Thứ cần lưu là.

```
Model
```

Ví dụ.

```
HeroComponent
```

Không cần lưu.

```
HeroModel
```

Mới cần lưu.

---

# Chúng ta sẽ lưu gì?

Một Save File nên chứa.

```
Player Progress

↓

Hero

↓

Inventory

↓

Skill

↓

Dungeon

↓

Currency

↓

Setting
```

Đây là toàn bộ dữ liệu cần thiết.

---

# Những gì KHÔNG nên lưu

Rất nhiều thứ có thể tạo lại.

Ví dụ.

```
Sprite
```

```
Animation
```

```
Particle
```

```
Camera
```

```
Monster Component
```

```
Background
```

Không cần lưu.

Lần sau mở game.

Flame sẽ tạo lại.

---

# Save Model

Kiến trúc.

```
HeroModel

↓

HeroSaveData

↓

JSON
```

Không nên.

```
HeroComponent

↓

JSON
```

Component không được Serialize.

---

# Snapshot Save

Trong dự án này.

Chúng ta sẽ sử dụng.

```
Snapshot
```

Có nghĩa.

Mỗi lần Save.

Toàn bộ Progress được ghi lại.

Ví dụ.

```text
Game Snapshot

↓

Hero

↓

Dungeon

↓

Inventory

↓

Skill

↓

Currency
```

Không lưu từng thay đổi nhỏ.

---

# Save File

Ví dụ.

```json
{

  "floor": 125,

  "gold": 12500,

  "heroLevel": 40

}
```

File rất nhỏ.

Nhưng đủ để khôi phục game.

---

# Save theo Domain

Thay vì một file khổng lồ.

Chúng ta chia.

```
PlayerSave
```

```
HeroSave
```

```
InventorySave
```

```
DungeonSave
```

```
SettingSave
```

Sau đó.

```
GameSave

↓

Combine
```

Kiến trúc sẽ rõ ràng hơn.

---

# Continue Game

Người chơi mở game.

```
Load Save

↓

Restore Model

↓

Generate Dungeon

↓

Spawn Hero

↓

Continue
```

Component được tạo mới.

Gameplay tiếp tục.

---

# Save không lưu Battle

Một sai lầm phổ biến.

Người chơi.

```
Đang đánh Boss

↓

Save
```

Lần sau.

```
Boss còn 523 HP
```

Điều này rất phức tạp.

Trong phiên bản đầu tiên.

Chúng ta KHÔNG hỗ trợ.

Save giữa trận đấu.

Chỉ Save.

```
Sau khi hoàn thành Floor
```

Điều này đơn giản hơn rất nhiều.

---

# Auto Save

Game sẽ tự Save khi.

```
Floor Complete
```

```
Choose Skill
```

```
Receive Reward
```

```
Back To Lobby
```

Người chơi gần như không cần bấm Save.

---

# Save Trigger

SaveSystem không nên được gọi trực tiếp.

Thay vào đó.

```
FloorCompletedEvent

↓

SaveSystem

↓

Auto Save
```

Hoặc.

```
PlayerExitEvent

↓

Save
```

Save System hoạt động thông qua Event.

---

# Serialization

Save Data cần chuyển thành.

```
JSON
```

Ví dụ.

```dart
HeroSaveData

↓

toJson()
```

Khi Load.

```dart
HeroSaveData

↓

fromJson()
```

Model được tạo lại.

---

# Version

Một Save File nên có Version.

Ví dụ.

```json
{

"version":2

}
```

Sau này.

Nếu thêm.

```
Pet System
```

```
Equipment
```

Game vẫn biết cách đọc Save cũ.

---

# Infinite Dungeon

Một điều thú vị.

Chúng ta không cần lưu.

```
Floor 1

↓

999
```

Chỉ cần.

```
Current Floor

150
```

```
Seed

12345
```

Dungeon sẽ tự sinh lại.

Đây là ưu điểm rất lớn của Procedural Generation.

---

# Inventory

Inventory nên lưu.

```
Item ID
```

```
Quantity
```

Ví dụ.

```text
Potion

x20
```

Không cần lưu.

```
Potion Icon
```

Game sẽ tự tải Asset.

---

# Hero Save

Hero chỉ cần lưu.

```
Level

EXP

Current HP

Skill

Equipment
```

Không cần lưu.

```
Animation

Position

Sprite
```

---

# Skill Save

Skill chỉ cần.

```
Skill ID
```

Ví dụ.

```
heal_lv3
```

```
meteor_lv2
```

Game sẽ tự đọc Database.

Không cần lưu toàn bộ Skill.

---

# Equipment Save

Ví dụ.

```
weapon_001
```

```
armor_005
```

Không lưu.

```
Attack +20
```

Game sẽ tính lại Stat.

---

# Save Manager

Kiến trúc.

```
SaveSystem

↓

Collect Save Data

↓

Serialize

↓

Write Storage
```

Load.

```
Read Storage

↓

Deserialize

↓

Restore Model
```

---

# Save Flow

Toàn bộ quá trình.

```
Game

↓

Event

↓

SaveSystem

↓

JSON

↓

Local Storage
```

Khi mở game.

```
Local Storage

↓

JSON

↓

Model

↓

Game
```

---

# Local Database

Trong Flutter.

Có rất nhiều lựa chọn.

```
SharedPreferences
```

```
Hive
```

```
Isar
```

```
SQLite
```

Trong series này.

Chúng ta sẽ ưu tiên.

```
Isar
```

hoặc.

```
Hive
```

vì tốc độ nhanh và làm việc tốt với dữ liệu offline.

---

# Cloud Save

Sau này.

Có thể mở rộng.

```
Local Save

↓

Sync

↓

Cloud
```

Ví dụ.

```
Firebase

Supabase

Custom API
```

Điều này hoàn toàn không ảnh hưởng Save System.

---

# Backup

Một kỹ thuật phổ biến.

Lưu.

```
save.json
```

Đồng thời.

```
save_backup.json
```

Nếu Save lỗi.

Game vẫn có bản dự phòng.

---

# Sai lầm phổ biến

## Sai lầm 1

Serialize Component.

Không nên.

Chỉ Serialize Model.

---

## Sai lầm 2

Lưu mọi thứ.

Ví dụ.

```
Animation

Sprite

Particle

Camera
```

Đều có thể tạo lại.

---

## Sai lầm 3

Save giữa Combat.

Điều này khiến việc khôi phục cực kỳ phức tạp.

Phiên bản đầu tiên nên Save sau mỗi Floor.

---

## Sai lầm 4

Không có Version.

Sau vài bản Update.

Save cũ sẽ không đọc được.

---

## Sai lầm 5

Gameplay tự gọi Save.

Ví dụ.

```dart
BattleSystem.save();
```

Sai.

Battle chỉ phát Event.

SaveSystem tự quyết định.

---

# Kiến trúc Save hoàn chỉnh

Sau chương này.

```
Game

↓

GameEventBus

↓

SaveSystem

↓

Collect Models

↓

JSON

↓

Local Storage
```

Khi Load.

```
Local Storage

↓

JSON

↓

Restore Models

↓

Generate Components

↓

Continue Game
```

Toàn bộ Gameplay đều được khôi phục từ dữ liệu.

Không phụ thuộc vào Flame.

---

# Tổng kết

Save System không phải là lưu toàn bộ trò chơi.

Mà là lưu **những dữ liệu tối thiểu cần thiết** để tái tạo lại trò chơi.

Trong dự án này:

- Chỉ **Model** được Serialize.
- **Component** luôn được tạo lại.
- Dungeon được khôi phục bằng **Floor + Seed**.
- Combat không được lưu giữa trận ở phiên bản đầu tiên.
- Save hoạt động thông qua **Event System**.

Kiến trúc này giúp Save File rất nhỏ, dễ mở rộng và ít bị lỗi khi game ngày càng lớn.

---

# Chương tiếp theo

Ở chương 14, chúng ta sẽ xây dựng **Asset Management System**.

Bạn sẽ học:

- Cách tổ chức Asset cho dự án lớn.
- Sprite Atlas.
- Animation.
- Audio.
- Font.
- Lazy Loading.
- Asset Cache.
- Cách quản lý hàng nghìn Asset mà vẫn giữ thời gian khởi động game ở mức tối thiểu.