# Chapter 31 - Save & Load System - Xây dựng hệ thống Save Game chuyên nghiệp

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- Save System
- Save Manager
- Serialization
- Snapshot
- Auto Save
- Manual Save
- Incremental Save
- Save Slot
- Versioning
- Data Migration

Đây là một trong những System quan trọng nhất của mọi game.

Nếu Save Game được thiết kế sai.

Sau này gần như không thể sửa.

Đặc biệt.

Khi game đã phát hành.

---

# Save Game là gì?

Rất nhiều người nghĩ.

Save Game là.

```
jsonEncode(player)
```

Hoặc.

```
Hive.put()
```

Thực tế.

Save Game là.

```
Snapshot

+

Serialization

+

Versioning

+

Recovery
```

---

# Save System

Save.

Không thuộc.

```
Hero
```

Không thuộc.

```
Inventory
```

Không thuộc.

```
Quest
```

Toàn bộ.

Được quản lý.

Bởi.

```
SaveSystem
```

---

# Save Flow

```text
Gameplay

↓

Snapshot

↓

Serialize

↓

Storage

↓

Load

↓

Deserialize

↓

Restore World
```

---

# Snapshot

Snapshot.

Là.

```
Ảnh chụp

Toàn bộ

Game State
```

Không phải.

Ảnh màn hình.

---

# Game State

Một Save.

Bao gồm.

```
Player
```

```
Inventory
```

```
Equipment
```

```
Quest
```

```
NPC
```

```
World
```

```
Settings
```

---

# Serialization

Serialization.

Là quá trình.

```
Object

↓

Data
```

Ví dụ.

```
Hero

↓

JSON
```

Hoặc.

```
Binary
```

---

# Deserialization

Ngược lại.

```
JSON

↓

Hero
```

---

# Save Manager

Toàn bộ Save.

Đi qua.

```
SaveManager
```

Không System nào.

Được.

Ghi File.

Trực tiếp.

---

# Save Request

Ví dụ.

```text
Quest Completed

↓

Request Save

↓

SaveManager
```

---

# Save Slot

Một game.

Có thể có.

```
Slot 1
```

```
Slot 2
```

```
Slot 3
```

Không chỉ.

Một File.

---

# Auto Save

Ví dụ.

```
Quest Complete
```

↓

Auto Save.

---

# Manual Save

Ví dụ.

Player.

↓

```
Menu

↓

Save
```

---

# Checkpoint Save

Ví dụ.

```
Boss Room
```

↓

Checkpoint.

↓

Auto Save.

---

# Incremental Save

Không phải.

Lần nào.

Cũng Save.

Toàn bộ.

Ví dụ.

```
Only Inventory Changed
```

↓

Save.

Inventory.

---

# Full Save

Một số trường hợp.

Vẫn cần.

```
Full Snapshot
```

Ví dụ.

Thoát Game.

---

# Save Frequency

Không nên.

Save.

```
60 FPS
```

Chỉ Save.

Khi.

Gameplay.

Thay đổi.

---

# Dirty Flag

Mỗi System.

Có.

```
Dirty
```

Ví dụ.

Inventory.

Không đổi.

↓

Không Save.

---

# Save Pipeline

```text
Inventory

↓

Dirty

↓

SaveManager

↓

Serialize

↓

Disk
```

---

# World Save

Không chỉ.

Player.

Map.

Cũng cần.

```
Chest Opened
```

```
Boss Dead
```

```
Puzzle Solved
```

---

# NPC Save

NPC.

Có thể lưu.

```
Friendship
```

```
Current State
```

```
Quest State
```

---

# Quest Save

Quest.

Chỉ lưu.

```
Quest ID
```

```
State
```

```
Progress
```

Không lưu.

UI.

---

# Inventory Save

Chỉ lưu.

```
Item ID
```

```
Quantity
```

```
Affix
```

```
Durability
```

---

# Equipment Save

Chỉ lưu.

```
Equipped Item ID
```

Không lưu.

Attack.

Defense.

Modifier.

---

# Save Metadata

Mỗi Save.

Có.

```
Save Time
```

```
Player Level
```

```
Map
```

```
Play Time
```

```
Game Version
```

UI.

Đọc.

Metadata.

---

# Thumbnail

Một số Game.

Lưu.

```
Screenshot
```

Cho.

Save Slot.

Không bắt buộc.

---

# Compression

Save.

Có thể.

```
Compress
```

↓

Giảm.

Dung lượng.

---

# Encryption

Nếu Game.

Online.

Có thể.

Encrypt.

Save.

Để tránh.

Cheat.

---

# Versioning

Đây là.

Phần quan trọng nhất.

Ví dụ.

Game.

```
Version 1
```

↓

Thêm.

Skill Tree.

↓

```
Version 2
```

Save cũ.

Vẫn phải.

Load được.

---

# Migration

Ví dụ.

Version 1.

Không có.

```
Achievement
```

Version 2.

Có.

↓

Migration.

Tự tạo.

Default Data.

---

# Data Integrity

Khi Load.

Kiểm tra.

```
Missing Field
```

↓

Default Value.

Không Crash.

---

# Backup Save

Trước khi.

Save mới.

↓

Đổi tên.

```
save.bak
```

↓

Nếu lỗi.

↓

Restore.

---

# Recovery

Ví dụ.

Save.

Bị hỏng.

↓

Khôi phục.

Từ.

Backup.

---

# Cloud Save

Cloud Save.

Không thay đổi.

Save Format.

Chỉ thay đổi.

```
Storage
```

Ví dụ.

```
Disk
```

↓

```
Cloud
```

---

# Cross Platform

Một Save.

Có thể dùng.

Cho.

```
Android
```

```
iOS
```

```
PC
```

```
Web
```

Nếu Format.

Giống nhau.

---

# Save Event

Save.

Không Update UI.

↓

```
SaveCompletedEvent
```

↓

UI.

↓

Notification.

---

# Load Event

Load.

↓

```
GameLoadedEvent
```

↓

Gameplay.

↓

Camera.

↓

UI.

---

# Restore Order

Không phải.

System nào.

Cũng Restore.

Cùng lúc.

Ví dụ.

```text
Player

↓

Inventory

↓

Equipment

↓

Quest

↓

NPC

↓

World
```

Đúng thứ tự.

Giúp tránh lỗi.

---

# Async Save

Save.

Không nên.

Block.

Main Thread.

Hãy.

Save.

Bất đồng bộ.

---

# Save Queue

Nếu.

Player.

Spam Save.

↓

Queue.

↓

Chỉ Save.

Một lần.

---

# Debug

Developer Mode.

Hiển thị.

```
Save Size
```

```
Save Time
```

```
Version
```

```
Dirty Systems
```

```
Serialize Time
```

---

# Kiến trúc hoàn chỉnh

```text
Gameplay

↓

Save Request

↓

SaveManager

↓

Snapshot

↓

Serialization

↓

Storage

↓

Load

↓

Restore
```

Save.

Không biết.

Inventory.

Không biết.

Quest.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ SaveManager

✅ Snapshot

✅ Serialization

✅ Save Slot

✅ Auto Save

✅ Manual Save

✅ Dirty Flag

✅ Versioning

✅ Migration

✅ Backup

---

# Sai lầm phổ biến

## Sai lầm 1

Mỗi System.

Tự ghi File.

Hãy để.

```
SaveManager
```

Điều phối.

---

## Sai lầm 2

Save.

Toàn bộ.

Sau mỗi Frame.

Chỉ Save.

Khi.

Có thay đổi.

---

## Sai lầm 3

Lưu.

Attack.

Defense.

HP Max.

Đây đều là.

```
Derived Data
```

Chỉ lưu.

Nguồn dữ liệu.

---

## Sai lầm 4

Không có.

Version.

Sau vài bản Update.

Save cũ.

Không Load được.

---

## Sai lầm 5

Không có.

Backup.

Nếu Save.

Lỗi giữa chừng.

Player.

Mất toàn bộ.

Tiến trình.

---

# Tổng kết

Save & Load System là nền tảng đảm bảo mọi tiến trình của người chơi được bảo toàn.

Sau chương này:

- **SaveManager** là điểm duy nhất chịu trách nhiệm lưu và tải dữ liệu.
- **Snapshot** đại diện cho toàn bộ trạng thái của game tại một thời điểm.
- **Serialization** chuyển đổi dữ liệu giữa Object và định dạng lưu trữ.
- **Dirty Flag** và **Incremental Save** giúp giảm số lần ghi dữ liệu và tăng hiệu năng.
- **Versioning** và **Migration** đảm bảo các bản Save cũ vẫn hoạt động sau khi game được cập nhật.
- **Backup**, **Recovery** và **Cloud Save** giúp hệ thống lưu game an toàn và dễ mở rộng.

Kiến trúc này đủ linh hoạt để sử dụng cho cả game offline lẫn game online có đồng bộ dữ liệu.

---

# Chương tiếp theo

Ở **Chương 32**, chúng ta sẽ xây dựng **Audio System**.

Bạn sẽ học cách xây dựng:

- Audio Manager.
- BGM (Background Music).
- Sound Effect (SFX).
- Audio Channel.
- Audio Event.
- Audio Pooling.
- 2D / 3D Audio.
- Volume Mixer.
- Audio Serialization.
- Dynamic Music.

Sau chương này, game sẽ có hệ thống âm thanh chuyên nghiệp, tách biệt hoàn toàn khỏi Gameplay và dễ dàng mở rộng cho mọi thể loại game.