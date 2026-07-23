# Chapter 40 - Plugin & Modular Architecture - Xây dựng kiến trúc Module và Plugin chuyên nghiệp

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- Modular Architecture
- Plugin System
- Feature Module
- Module Lifecycle
- Dependency Injection
- Service Registry
- Runtime Plugin
- Cross Module Communication
- Plugin SDK
- Module Debugger

Đây là chương giúp game của bạn.

Có thể phát triển.

Trong nhiều năm.

Mà không bị.

Spaghetti Code.

---

# Modular Architecture là gì?

Rất nhiều người nghĩ.

Module.

Chỉ là.

```
Folder
```

Thực tế.

Module.

Là.

```
Một Feature

Hoàn chỉnh

Độc lập
```

---

# Ví dụ

Combat.

Là.

Một Module.

Inventory.

Là.

Một Module.

Quest.

Là.

Một Module.

Shop.

Là.

Một Module.

Không phải.

Một Folder.

---

# Modular Game

Thay vì.

```text
Game

├── Utils
├── Models
├── Services
├── Widgets
├── Components
```

Bạn sẽ có.

```text
Game

├── Combat
├── Inventory
├── Quest
├── Audio
├── AI
├── Dialogue
├── Save
```

Theo.

Feature.

---

# Module

Một Module.

Thường có.

```text
Definition

Logic

UI

Data

Event

Tests
```

Đầy đủ.

Không phụ thuộc.

Module khác.

---

# Plugin

Plugin.

Là.

Một Module.

Có thể.

Cắm vào.

Hoặc.

Rút ra.

Không ảnh hưởng.

Game.

---

# Plugin Flow

```text
Plugin

↓

Register

↓

Initialize

↓

Running

↓

Dispose
```

---

# Module Lifecycle

Mỗi Module.

Có.

Vòng đời.

```text
Create

↓

Register

↓

Initialize

↓

Running

↓

Dispose
```

---

# Create

Module.

Được tạo.

Nhưng.

Chưa chạy.

---

# Register

Module.

Đăng ký.

```
Services
```

```
Events
```

```
Definitions
```

---

# Initialize

Module.

Load.

Config.

Asset.

Data.

---

# Running

Module.

Bắt đầu.

Hoạt động.

---

# Dispose

Module.

Giải phóng.

Memory.

↓

Hủy.

Listener.

↓

Release.

Resource.

---

# Module Registry

Toàn bộ.

Module.

Được quản lý.

Bởi.

```
ModuleRegistry
```

Không Module nào.

Tự.

Khởi tạo.

Module khác.

---

# Module Flow

```text
Game

↓

ModuleRegistry

↓

Inventory

↓

Quest

↓

Combat

↓

Audio

↓

AI
```

---

# Dependency

Ví dụ.

Quest.

Cần.

Inventory.

↓

Khai báo.

Dependency.

Không.

```
new Inventory()
```

---

# Dependency Injection

Module.

Không tự.

Tìm.

Service.

Service.

Được.

Inject.

Từ bên ngoài.

---

# Service Registry

Ví dụ.

```
SaveService
```

↓

Đăng ký.

↓

Module khác.

Có thể.

Sử dụng.

---

# Feature Module

Ví dụ.

Inventory.

Có.

```
Definition

Repository

UI

Events

Factory
```

Tất cả.

Nằm trong.

Inventory Module.

---

# Combat Module

Combat.

Không chứa.

Quest.

Không chứa.

Audio.

Combat.

Chỉ.

Combat.

---

# Quest Module

Quest.

Không biết.

Inventory.

Quest.

Chỉ.

Subscribe.

Event.

---

# Audio Module

Audio.

Không biết.

Combat.

↓

```
AttackEvent
```

↓

Play Sound.

---

# VFX Module

VFX.

Không biết.

Skill.

↓

```
ExplosionEvent
```

↓

Spawn Effect.

---

# Save Module

Save.

Không gọi.

Quest.

↓

Subscribe.

```
QuestCompletedEvent
```

↓

Auto Save.

---

# Analytics Module

Analytics.

Không đọc.

Gameplay.

↓

Subscribe.

Event.

---

# Cross Module Communication

Không gọi.

Trực tiếp.

```text
Quest

↓

Inventory
```

Đúng.

```text
Quest

↓

Event Bus

↓

Inventory
```

---

# Module Config

Mỗi Module.

Có.

Config.

Riêng.

Ví dụ.

```
inventory.json
```

```
quest.json
```

```
combat.json
```

---

# Module Asset

Asset.

Được nhóm.

Theo Module.

Ví dụ.

```
combat/

inventory/

quest/

dialogue/
```

---

# Plugin SDK

Nếu.

Cho phép.

Plugin.

Từ bên ngoài.

Bạn cần.

```
Plugin SDK
```

↓

API.

Cho.

Plugin.

---

# Runtime Plugin

Ví dụ.

Game.

Có DLC.

↓

Load.

Plugin.

Khi.

Game.

Đang chạy.

---

# Optional Module

Ví dụ.

Photo Mode.

↓

Có.

Hoặc.

Không.

Game.

Vẫn chạy.

---

# Required Module

Ví dụ.

```
Combat
```

↓

Bắt buộc.

---

# Module Version

Plugin.

Có.

```
Version
```

↓

Kiểm tra.

Compatibility.

---

# Module Permission

Plugin.

Không nên.

Truy cập.

Toàn bộ.

Game.

Chỉ.

API.

Được phép.

---

# Module Event

Plugin.

Có thể.

Publish.

Event.

↓

Gameplay.

---

# Module Update

Có thể.

Update.

Một Module.

Không cần.

Build lại.

Toàn bộ.

Game.

---

# DLC

Ví dụ.

```
New Hero
```

↓

Combat Module.

Không sửa.

↓

Chỉ.

Thêm.

Plugin.

---

# Marketplace

Nếu.

Game.

Có.

Marketplace.

Plugin.

Là.

Một Feature.

Tự nhiên.

---

# Testing

Có thể.

Test.

Từng Module.

Riêng.

Không cần.

Chạy.

Toàn bộ.

Game.

---

# Flame Integration

Trong Flame.

Module.

Có thể.

Đăng ký.

```
Components
```

```
Systems
```

```
Definitions
```

↓

Game.

Không cần.

Biết.

Chi tiết.

---

# Module Pipeline

```text
Game

↓

Module Registry

↓

Module

↓

Services

↓

Event Bus

↓

Gameplay
```

Module.

Không gọi.

Module.

Khác.

---

# Debug

Developer Mode.

Hiển thị.

```
Loaded Modules
```

```
Dependencies
```

```
Plugin Version
```

```
Running Modules
```

```
Memory Usage
```

```
Lifecycle State
```

---

# Performance

Không Load.

Module.

Không dùng.

Ví dụ.

```
Photo Mode
```

↓

Không Load.

Cho đến.

Khi.

Player.

Mở.

---

# Project Structure

Ví dụ.

```text
modules/

    combat/

    inventory/

    quest/

    dialogue/

    ai/

    audio/

    save/

    analytics/
```

Core.

Không chứa.

Gameplay.

Core.

Chỉ chứa.

Framework.

---

# Core Module

Core.

Chứa.

```
Event Bus
```

```
Asset Manager
```

```
Save System
```

```
Game Loop
```

Không chứa.

Combat.

---

# Kiến trúc hoàn chỉnh

```text
Game

↓

Core

↓

Module Registry

↓

Feature Modules

↓

Event Bus

↓

Gameplay
```

Gameplay.

Được chia.

Theo.

Feature.

Không theo.

Layer.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ Module Registry

✅ Plugin System

✅ Feature Modules

✅ Dependency Injection

✅ Service Registry

✅ Runtime Plugin

✅ Plugin SDK

✅ Module Lifecycle

✅ Cross Module Communication

✅ Module Debugger

---

# Sai lầm phổ biến

## Sai lầm 1

Chia.

Theo.

```
models/

services/

widgets/
```

Khi Project lớn.

Hãy chia.

Theo.

Feature.

---

## Sai lầm 2

Module.

Gọi.

Module khác.

Trực tiếp.

Hãy dùng.

```
Event Bus
```

Hoặc.

```
Service Interface
```

---

## Sai lầm 3

Core.

Biết.

Gameplay.

Core.

Chỉ nên.

Chứa.

Framework.

---

## Sai lầm 4

Module.

Không có.

Lifecycle.

↓

Memory Leak.

↓

Listener Leak.

---

## Sai lầm 5

Plugin.

Có quyền.

Truy cập.

Toàn bộ.

Game.

Hãy.

Giới hạn.

API.

Thông qua.

Plugin SDK.

---

# Tổng kết

Plugin & Modular Architecture giúp game được chia thành các khối chức năng độc lập, dễ phát triển và dễ mở rộng.

Sau chương này:

- **Feature Module** trở thành đơn vị tổ chức chính của dự án thay vì chia theo Models, Services hay Widgets.
- **Module Registry** chịu trách nhiệm khởi tạo và quản lý vòng đời của mọi Module.
- **Dependency Injection** và **Service Registry** giúp giảm phụ thuộc giữa các Module.
- **Event Bus** là cơ chế giao tiếp chính giữa các Module.
- **Plugin SDK** mở đường cho DLC, Marketplace hoặc Mod từ bên thứ ba.
- **Core** chỉ chứa hạ tầng chung, còn toàn bộ Gameplay được tách thành các Module độc lập.

Đây là kiến trúc thường thấy trong các dự án game lớn, nơi hàng chục lập trình viên có thể phát triển Combat, Quest, Inventory, AI hay UI song song mà không gây xung đột lẫn nhau.

---

# Chương tiếp theo

Ở **Chương 41**, chúng ta sẽ xây dựng **Game Editor & Developer Tools**.

Bạn sẽ học cách xây dựng:

- Debug Overlay.
- In-game Console.
- Developer Commands.
- Inspector.
- Gizmos.
- Runtime Editor.
- Cheat Menu.
- Performance Profiler.
- Debug Visualization.
- Development Pipeline.

Sau chương này, bạn sẽ có một bộ công cụ phát triển mạnh mẽ ngay bên trong game, giúp debug AI, Combat, Physics, Navigation, Quest, Audio và VFX nhanh hơn rất nhiều mà không cần sửa mã nguồn liên tục.