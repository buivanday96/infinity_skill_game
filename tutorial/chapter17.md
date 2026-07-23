# Chapter 17 - Khởi tạo dự án Flutter Flame chuyên nghiệp

# Mục tiêu

Sau chương này bạn sẽ có:

- Một project Flutter Flame hoàn chỉnh
- Kiến trúc thư mục ngay từ đầu
- Game class đầu tiên
- GameWidget
- Camera
- World
- AssetManager
- EventBus
- System Registry
- Dependency Injection

Đây là chương đánh dấu sự chuyển đổi của toàn bộ series.

16 chương trước chúng ta tập trung vào:

- Design
- Architecture
- Gameplay
- Theory

Từ chương này.

Chúng ta sẽ bắt đầu xây dựng game thật.

Không còn ví dụ nhỏ.

Mọi code đều sẽ được sử dụng trong toàn bộ project.

---

# Mục tiêu cuối cùng

Đến cuối series.

Chúng ta sẽ hoàn thành một game có kiến trúc như sau.

```text
Flutter

↓

GameWidget

↓

HalpGame

↓

World

↓

Camera

↓

Systems

↓

Components

↓

Models
```

Đây sẽ là "xương sống" của toàn bộ game.

---

# Bước 1 - Tạo Project

Khởi tạo project Flutter.

```bash
flutter create halp_game
```

Sau đó.

```bash
cd halp_game
```

---

# Bước 2 - Cài đặt Flame

Cài package.

```bash
flutter pub add flame
```

Ngoài Flame.

Chúng ta sẽ sử dụng thêm.

```yaml
dependencies:

  flame:

  flutter_riverpod:

  freezed_annotation:

  json_annotation:

  get_it:

  uuid:

  collection:

  equatable:

  logger:
```

Trong các chương sau.

Chúng ta sẽ bổ sung.

- Isar
- Dio
- Audio
- Localization

---

# Bước 3 - Cấu trúc Project

Ngay từ ngày đầu.

Chúng ta sẽ không để project như mặc định.

```
lib/

    main.dart

    game.dart
```

Thay vào đó.

```text
lib/

    app/

    core/

    features/

    game/

    shared/
```

Đây sẽ là cấu trúc xuyên suốt series.

---

# app/

```
app/

    app.dart

    bootstrap.dart

    routes.dart
```

Chịu trách nhiệm.

- Khởi tạo Flutter
- Theme
- Router
- Dependency Injection

Không chứa Gameplay.

---

# core/

Đây là nơi chứa các thành phần dùng chung.

```text
core/

    asset/

    event/

    save/

    config/

    engine/

    logger/

    utils/
```

Không chứa Hero.

Không chứa Monster.

---

# features/

Đây là thư mục lớn nhất.

```text
features/

    battle/

    hero/

    monster/

    skill/

    inventory/

    dungeon/

    quest/

    achievement/
```

Mỗi Feature độc lập.

---

# game/

Đây là nơi Flame hoạt động.

```text
game/

    camera/

    components/

    systems/

    world/

    overlays/
```

Đây sẽ là trái tim của game.

---

# shared/

Các Widget hoặc Model dùng chung.

Ví dụ.

```text
shared/

    widgets/

    extensions/

    constants/
```

---

# Bước 4 - Tạo Game Class

Tạo file.

```
game/

    halp_game.dart
```

Đây sẽ là Game chính.

Không nên đặt tên.

```
Game
```

Quá chung.

---

Kiến trúc.

```text
HalpGame

↓

FlameGame
```

Sau này.

HalpGame sẽ quản lý.

- Camera
- World
- Systems
- AssetManager
- EventBus

---

# HalpGame chưa xử lý Gameplay

Một sai lầm phổ biến.

Viết.

```dart
update() {

battle();

ai();

skill();

inventory();

}
```

Không.

HalpGame chỉ điều phối.

Gameplay nằm trong System.

---

# Bước 5 - main.dart

main.dart nên cực kỳ nhỏ.

Ví dụ.

```text
main()

↓

bootstrap()

↓

runApp()
```

Không khởi tạo Gameplay.

Không Load Hero.

Không Load Monster.

---

# Bước 6 - GameWidget

Flutter.

↓

GameWidget.

↓

HalpGame.

```text
MaterialApp

↓

GameWidget

↓

HalpGame
```

GameWidget là cầu nối giữa.

Flutter.

và.

Flame.

---

# Bước 7 - Camera

Ngay từ đầu.

Chúng ta tạo.

```
CameraComponent
```

Không dùng.

```
camera = ...
```

rải rác trong project.

Camera sẽ được quản lý tập trung.

---

# Bước 8 - World

Tạo.

```
GameWorld
```

Đây là nơi chứa.

```
Hero
```

```
Monster
```

```
Map
```

Không thêm Entity trực tiếp vào Game.

---

Kiến trúc.

```text
HalpGame

↓

World

↓

Components
```

---

# Bước 9 - AssetManager

Ngay từ đầu.

Tạo.

```
AssetManager
```

Dù hiện tại.

Game mới có.

```
1 Hero
```

Sau này.

Sẽ có.

```
5000 Asset
```

Nếu không chuẩn bị từ đầu.

Sẽ rất khó sửa.

---

# Bước 10 - EventBus

Tạo.

```
GameEventBus
```

Ngay từ chương đầu tiên.

Mặc dù.

Chưa có Event.

Điều này giúp.

Mọi System sau này đều dùng chung.

---

# Bước 11 - System Registry

Chúng ta sẽ không viết.

```dart
BattleSystem()

AISystem()

DungeonSystem()
```

Rải rác.

Thay vào đó.

Có.

```
GameSystemRegistry
```

Ví dụ.

```text
Registry

↓

Battle

↓

Skill

↓

AI

↓

Dungeon

↓

Save
```

Toàn bộ Game chỉ cần biết Registry.

---

# Vì sao cần Registry?

Ví dụ.

Muốn Update.

```text
AISystem

↓

BattleSystem

↓

DungeonSystem
```

Registry sẽ quản lý.

Thứ tự Update.

Không phải HalpGame.

---

# Bước 12 - Dependency Injection

Ngay từ đầu.

Chúng ta sử dụng.

```
GetIt
```

Không nên.

```dart
new BattleSystem()
```

Khắp project.

Toàn bộ Dependency sẽ được đăng ký.

Trong.

```
bootstrap.dart
```

---

# Khởi tạo Game

Flow khi mở game.

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

GameWidget

↓

HalpGame

↓

World

↓

Systems

↓

Start
```

Đây là Flow cố định.

---

# Chưa tạo Hero

Ở chương này.

Chúng ta KHÔNG tạo.

```
Hero
```

Không tạo.

```
Monster
```

Không tạo.

```
Battle
```

Chúng ta chỉ xây nền móng.

Giống như xây nhà.

Phải làm móng trước.

---

# Kết quả sau chương này

Sau khi hoàn thành.

Project sẽ có.

```text
Flutter

↓

GameWidget

↓

HalpGame

↓

World

↓

Camera

↓

AssetManager

↓

EventBus

↓

SystemRegistry
```

Chưa có Gameplay.

Nhưng toàn bộ kiến trúc đã sẵn sàng.

---

# Checklist

Sau chương này hãy đảm bảo project của bạn có:

- ✅ Flutter + Flame chạy thành công.
- ✅ HalpGame.
- ✅ GameWidget.
- ✅ CameraComponent.
- ✅ World.
- ✅ AssetManager.
- ✅ GameEventBus.
- ✅ GameSystemRegistry.
- ✅ Dependency Injection.
- ✅ Cấu trúc thư mục chuẩn.

Nếu hoàn thành Checklist này.

Những chương sau sẽ chỉ tập trung vào Gameplay.

Không cần sửa lại Architecture.

---

# Sai lầm phổ biến

## Sai lầm 1

Viết toàn bộ game trong.

```
main.dart
```

---

## Sai lầm 2

Đưa Gameplay vào.

```
HalpGame
```

Gameplay nên nằm trong.

```
Systems
```

---

## Sai lầm 3

Không có.

```
World
```

Toàn bộ Entity nên nằm trong World.

---

## Sai lầm 4

Component tự Load Asset.

Hãy đi qua.

```
AssetManager
```

---

## Sai lầm 5

System tự tạo nhau.

Hãy dùng.

```
Dependency Injection
```

---

# Tổng kết

Đây là chương đầu tiên của phần thực hành.

Chúng ta chưa viết Gameplay.

Nhưng đã hoàn thành phần quan trọng nhất:

**Nền móng của toàn bộ project.**

Sau chương này, mọi tính năng mới đều sẽ được xây dựng trên cùng một kiến trúc:

- Flutter quản lý ứng dụng.
- Flame quản lý game loop.
- HalpGame điều phối.
- World chứa toàn bộ Entity.
- System xử lý Gameplay.
- Component chịu trách nhiệm Render.
- EventBus kết nối các System.
- AssetManager quản lý tài nguyên.
- DI quản lý phụ thuộc.

Nhờ chuẩn bị kỹ ngay từ đầu, project có thể phát triển lên hàng trăm nghìn dòng code mà vẫn giữ được cấu trúc rõ ràng.

---

# Chương tiếp theo

Ở **Chương 18**, chúng ta sẽ bắt đầu viết những dòng code gameplay đầu tiên.

Bạn sẽ xây dựng:

- Game bootstrap hoàn chỉnh.
- `HalpGame`.
- `GameWorld`.
- `CameraController`.
- `GameSystemRegistry`.
- `AssetManager`.
- `EventBus`.
- Vòng lặp `update()` đầu tiên.
- Cơ chế đăng ký và khởi động các System.

Đây sẽ là lần đầu tiên game thật sự "chạy" theo đúng kiến trúc mà chúng ta đã thiết kế.