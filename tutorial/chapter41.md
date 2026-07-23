# Chapter 41 - Game Editor & Developer Tools - Xây dựng bộ công cụ dành cho Developer

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- Debug Overlay
- Developer Console
- Runtime Inspector
- Gizmos
- Cheat Menu
- Performance Profiler
- Debug Visualization
- Developer Commands
- Runtime Editor
- Debug Pipeline

Đây là chương giúp bạn.

Tiết kiệm.

Hàng nghìn giờ.

Debug.

Nếu không có.

Developer Tools.

Bạn sẽ liên tục.

```
Sửa Code

↓

Build

↓

Run

↓

Test

↓

Lặp lại
```

---

# Developer Tools là gì?

Developer Tools.

Không phải.

Là.

```
print()
```

Developer Tools.

Là.

Một bộ.

Công cụ.

Giúp.

Quan sát.

Game.

Trong lúc chạy.

---

# Debug Flow

```text
Gameplay

↓

Debug Data

↓

Developer Tools

↓

Visualization
```

---

# Debug Overlay

Một Layer.

Luôn nằm.

Trên cùng.

Ví dụ.

Hiển thị.

```
FPS
```

```
Memory
```

```
Current Scene
```

```
Player Position
```

---

# Overlay Toggle

Developer.

Có thể.

```
F1
```

↓

Hiện.

Overlay.

↓

```
F1
```

↓

Ẩn.

---

# Developer Console

Console.

Cho phép.

Nhập.

Command.

Ví dụ.

```
help
```

```
spawn slime
```

```
god
```

```
teleport
```

---

# Command System

Không viết.

```
if(command)
```

Nhiều lần.

Mỗi Command.

Là.

Một Object.

---

# Command Flow

```text
Console

↓

Parser

↓

Command

↓

Execution
```

---

# Cheat Menu

Ví dụ.

```
Infinite HP
```

```
Unlimited Mana
```

```
Unlock Map
```

```
Unlock Skill
```

Cheat.

Không nên.

Nằm.

Trong Gameplay.

---

# Inspector

Inspector.

Cho phép.

Click.

Một Entity.

↓

Xem.

```
Component
```

```
State
```

```
Transform
```

```
AI
```

---

# Runtime Inspector

Không cần.

Restart.

Game.

Bạn có thể.

Đổi.

```
HP
```

```
Speed
```

```
Damage
```

Ngay.

Trong Game.

---

# Entity Picker

Click.

Một Enemy.

↓

Inspector.

Hiện.

Thông tin.

Enemy đó.

---

# Hierarchy

Hiển thị.

Cây.

Entity.

Ví dụ.

```text
World

├── Hero

├── Goblin

├── Slime

└── Camera
```

---

# Gizmos

Gizmos.

Là.

Các hình.

Chỉ dành.

Cho Developer.

Ví dụ.

```
Vision Radius
```

```
Attack Range
```

```
Collision Box
```

---

# Navigation Gizmo

Hiển thị.

```
Navigation Path
```

↓

AI.

Đang đi.

Đâu.

---

# Collision Gizmo

Hiển thị.

```
Hitbox
```

```
Hurtbox
```

```
Collision
```

↓

Debug.

Combat.

---

# AI Gizmo

Ví dụ.

Hiển thị.

```
Vision Cone
```

↓

```
Target
```

↓

```
Current State
```

---

# Audio Debug

Hiển thị.

```
Current Music
```

```
Playing SFX
```

```
Volume
```

```
Channels
```

---

# VFX Debug

Hiển thị.

```
Particle Count
```

```
Pool Size
```

```
Effect Lifetime
```

---

# Physics Debug

Ví dụ.

Hiển thị.

```
Velocity
```

```
Force
```

```
Collision
```

---

# Combat Debug

Hiển thị.

```
Damage
```

```
Critical
```

```
Armor
```

```
DPS
```

---

# Quest Debug

Hiển thị.

```
Quest State
```

```
Progress
```

```
Conditions
```

---

# Save Debug

Hiển thị.

```
Current Save
```

```
Save Slot
```

```
Save Time
```

---

# Event Debug

Hiển thị.

```
Current Event
```

```
Queue
```

```
Subscribers
```

---

# Network Debug

Nếu.

Có Multiplayer.

↓

Hiển thị.

```
Ping
```

```
Packet Loss
```

```
Bandwidth
```

---

# Performance Profiler

Hiển thị.

```
FPS
```

```
Frame Time
```

```
Memory
```

```
CPU
```

```
GPU
```

---

# Frame Profiler

Ví dụ.

```
Update

3ms
```

```
Render

5ms
```

```
AI

1ms
```

↓

Biết.

Nơi.

Game.

Chậm.

---

# Memory Viewer

Hiển thị.

```
Texture
```

```
Audio
```

```
Particles
```

```
Entities
```

↓

Dung lượng.

---

# Runtime Editor

Cho phép.

Sửa.

```
Enemy HP
```

↓

Game.

Cập nhật.

Ngay.

---

# Hot Reload Config

Ví dụ.

```
Goblin HP

50

↓

100
```

↓

Không cần.

Restart.

---

# Time Control

Developer.

Có thể.

```
Pause
```

```
Resume
```

```
0.5x
```

```
2x
```

Gameplay.

---

# Frame Step

Pause.

↓

Next Frame.

↓

Next Frame.

Rất hữu ích.

Để Debug.

Animation.

Combat.

---

# Spawn Tool

Ví dụ.

```
Spawn

100 Goblin
```

↓

Stress Test.

---

# Teleport Tool

Ví dụ.

```
teleport village
```

↓

Không cần.

Đi bộ.

---

# Scene Tool

Có thể.

Đổi.

Scene.

Ngay.

Trong Game.

---

# Screenshot Tool

Developer.

Có thể.

Chụp.

Ảnh.

Gameplay.

Để.

Báo lỗi.

---

# Recording Tool

Ghi.

Video.

Gameplay.

↓

Bug Report.

---

# Bug Report

Developer.

Có thể.

Xuất.

```
Screenshot
```

+

```
Logs
```

+

```
Current Scene
```

+

```
Save File
```

↓

Một Click.

---

# Logging

Không dùng.

```
print()
```

Khắp Project.

Nên có.

```
Logger
```

↓

```
Info
```

```
Warning
```

```
Error
```

```
Debug
```

---

# Filter

Có thể.

Lọc.

```
Combat
```

```
AI
```

```
Quest
```

```
Audio
```

Log.

---

# Developer Build

Developer Build.

Có.

```
Console
```

```
Inspector
```

```
Profiler
```

Release Build.

Không có.

---

# Flame Integration

Trong Flame.

Developer Tools.

Có thể.

Là.

Một Layer.

Độc lập.

Không ảnh hưởng.

Gameplay.

↓

Bật.

↓

Tắt.

Theo.

Build Mode.

---

# Debug Pipeline

```text
Gameplay

↓

Logger

↓

Debug Manager

↓

Overlay

↓

Inspector

↓

Console
```

Gameplay.

Không gọi.

UI.

Debug.

---

# Kiến trúc hoàn chỉnh

```text
Game

↓

Debug Manager

├── Overlay

├── Console

├── Inspector

├── Gizmos

├── Profiler

├── Cheat Menu

└── Runtime Editor
```

Mọi Tool.

Hoạt động.

Độc lập.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ Debug Overlay

✅ Developer Console

✅ Runtime Inspector

✅ Gizmos

✅ Cheat Menu

✅ Performance Profiler

✅ Logger

✅ Runtime Editor

✅ Frame Step

✅ Debug Manager

---

# Sai lầm phổ biến

## Sai lầm 1

Debug.

Bằng.

```
print()
```

Khắp Project.

Hãy dùng.

```
Logger
```

---

## Sai lầm 2

Debug UI.

Can thiệp.

Gameplay.

Debug.

Chỉ nên.

Đọc.

Thông tin.

---

## Sai lầm 3

Release Build.

Chứa.

Cheat Menu.

Developer Tool.

Nên bị.

Loại bỏ.

Khi Release.

---

## Sai lầm 4

Không có.

Profiler.

↓

Không biết.

Game.

Chậm.

Ở đâu.

---

## Sai lầm 5

Mỗi System.

Tự làm.

Debug UI.

Hãy có.

```
Debug Manager
```

Quản lý.

Toàn bộ.

Developer Tools.

---

# Tổng kết

Developer Tools là khoản đầu tư mang lại hiệu quả lớn nhất trong quá trình phát triển game.

Sau chương này:

- **Debug Overlay** giúp quan sát trạng thái game theo thời gian thực.
- **Developer Console** cho phép thực thi các lệnh debug mà không cần sửa mã nguồn.
- **Inspector**, **Hierarchy** và **Gizmos** giúp phân tích Entity, AI và Collision trực quan.
- **Profiler** và **Logger** giúp xác định chính xác nguyên nhân gây giảm hiệu năng hoặc lỗi.
- **Runtime Editor** và **Hot Reload** cho phép thay đổi dữ liệu ngay trong lúc game đang chạy.
- **Debug Manager** trở thành trung tâm quản lý toàn bộ công cụ phát triển và chỉ tồn tại trong Developer Build.

Một bộ Developer Tools tốt sẽ giúp bạn phát triển, kiểm thử và cân bằng game nhanh hơn rất nhiều, đặc biệt khi dự án ngày càng lớn và có nhiều System hoạt động cùng lúc.

---

# Chương tiếp theo

Ở **Chương 42**, chúng ta sẽ xây dựng **Production Architecture & Shipping Game**.

Bạn sẽ học cách xây dựng:

- Build Pipeline.
- Development / Staging / Production.
- Feature Flags.
- Remote Config.
- Crash Reporting.
- Analytics.
- CI/CD.
- Automated Testing.
- Release Checklist.
- Long-term Maintenance.

Sau chương này, bạn sẽ hoàn thiện toàn bộ kiến trúc để có thể phát hành một game thực tế, từ quá trình build, kiểm thử, triển khai cho đến giám sát và cập nhật sau khi phát hành.