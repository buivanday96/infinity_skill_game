# Chapter 2 - Tạo Project Flutter Flame đầu tiên

# Mục tiêu

Sau chương này bạn sẽ có:

- Tạo một project Flutter mới
- Cài đặt Flame
- Hiểu GameWidget hoạt động như thế nào
- Hiểu FlameGame là gì
- Chạy được game đầu tiên
- Biết cấu trúc project mà chúng ta sẽ sử dụng xuyên suốt series

Chúng ta sẽ chưa viết gameplay.

Mục tiêu của chương này chỉ là xây dựng nền móng.

---

# Flutter có thật sự làm được game?

Đây là câu hỏi mà rất nhiều người mới bắt đầu đều thắc mắc.

Flutter vốn được tạo ra để xây dựng ứng dụng.

Ví dụ:

- Facebook
- Shopee
- Grab
- Banking App

đều có thể được xây dựng bằng Flutter.

Trong khi đó game lại cần:

- Render liên tục
- Animation
- Physics
- Collision
- Camera
- Input
- Audio

Flutter không được sinh ra cho mục đích này.

Đó là lý do Flame xuất hiện.

Flame chính là một game engine nhỏ được xây dựng trên Flutter.

Bạn có thể hiểu đơn giản:

```
Flutter
    ↓
Window

    ↓
Flame
    ↓
Game Engine
```

Flutter chịu trách nhiệm:

- Window
- UI
- Dialog
- Button
- Overlay
- Navigation

Flame chịu trách nhiệm:

- Render
- Update
- Camera
- Sprite
- Collision
- Animation

Hai framework phối hợp với nhau để tạo thành một game hoàn chỉnh.

---

# Tạo project

Tạo project Flutter như bình thường.

```bash
flutter create infinite_skill_dungeon
```

Di chuyển vào project.

```bash
cd infinite_skill_dungeon
```

---

# Cài đặt Flame

Mở file

```
pubspec.yaml
```

Thêm package.

```yaml
dependencies:
  flutter:
    sdk: flutter

  flame: ^1.x.x
```

Sau đó chạy

```bash
flutter pub get
```

Đến đây chúng ta đã có game engine.

---

# Cấu trúc project

Đây là cấu trúc chúng ta sẽ sử dụng.

```
lib/

    main.dart

    game/

        dungeon_game.dart

        systems/

        entities/

        components/

        world/

        ui/

        effects/

        data/

        services/

        utils/
```

Hiện tại hầu hết các tutorial trên Internet đều đặt tất cả code trong một file.

Ví dụ:

```
main.dart

↓

1000 dòng code
```

Điều này ổn với game demo.

Nhưng sẽ nhanh chóng trở thành thảm họa khi game lớn hơn.

Ngay từ đầu chúng ta sẽ tách project theo module.

---

# Tạo Game đầu tiên

Tạo file

```
game/dungeon_game.dart
```

```dart
import 'package:flame/game.dart';

class DungeonGame extends FlameGame {

}
```

Đây sẽ là class quan trọng nhất trong toàn bộ project.

Có thể xem nó như trái tim của game.

Mọi thứ cuối cùng đều sẽ được thêm vào đây.

---

# Hiển thị Game

Mở

```
main.dart
```

```dart
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'game/dungeon_game.dart';

void main() {
  runApp(
    GameWidget(
      game: DungeonGame(),
    ),
  );
}
```

Nếu chạy project bây giờ.

Bạn sẽ chỉ thấy một màn hình màu đen.

Điều này hoàn toàn bình thường.

Game đã chạy.

Chỉ là chúng ta chưa vẽ bất cứ thứ gì.

---

# FlameGame là gì?

Đây là class gốc của Flame.

```
FlameGame
```

Nó chịu trách nhiệm:

- Update
- Render
- Camera
- Components
- Lifecycle

Có thể hình dung:

```
Flutter

↓

GameWidget

↓

DungeonGame

↓

Components
```

DungeonGame sẽ quản lý toàn bộ thế giới game.

---

# GameWidget là gì?

GameWidget là cây cầu nối Flutter và Flame.

```
Flutter Widget Tree

↓

GameWidget

↓

Flame Game
```

Nhờ có GameWidget mà chúng ta vẫn có thể đặt:

- Button
- Dialog
- HUD
- Inventory
- Pause Menu

bằng Flutter.

Trong khi gameplay vẫn được Flame xử lý.

Đây là một ưu điểm rất lớn của Flutter Flame.

---

# Vòng đời của Game

Một game trong Flame sẽ trải qua các bước sau:

```
Game được tạo

↓

onLoad()

↓

onMount()

↓

update()

↓

render()

↓

update()

↓

render()

↓

...
```

Hai hàm quan trọng nhất là

```
update()

render()
```

Hai hàm này sẽ được gọi liên tục khoảng 60 lần mỗi giây.

Đây chính là Game Loop.

Chúng ta sẽ tìm hiểu chi tiết trong chương tiếp theo.

---

# Thêm Component

Thử tạo một component đơn giản.

```dart
class HeroComponent extends PositionComponent {

}
```

Sau đó thêm vào game.

```dart
@override
Future<void> onLoad() async {
  await super.onLoad();

  add(HeroComponent());
}
```

Hiện tại component chưa hiển thị gì.

Nhưng chúng ta đã biết cách đưa object vào game.

---

# Tư duy quan trọng

Một sai lầm rất phổ biến của người mới là xem Component như Widget.

Thực tế chúng hoàn toàn khác nhau.

Flutter

```
Widget

↓

Build

↓

Dispose
```

Flame

```
Component

↓

Update

↓

Render

↓

Remove
```

Component tồn tại trong suốt thời gian game chạy.

Không được tạo rồi huỷ liên tục như Widget.

Điều này cực kỳ quan trọng khi tối ưu hiệu năng.

---

# Chúng ta sẽ không viết gameplay trong Component

Trong series này, Component chỉ có nhiệm vụ:

- Hiển thị hình ảnh
- Animation
- Hiệu ứng
- Nhận input

Ví dụ:

```
HeroComponent
```

KHÔNG nên chứa:

- Damage
- Heal
- Buff
- AI
- Skill Logic

Thay vào đó:

```
BattleSystem

DamageSystem

AISystem

SkillSystem
```

sẽ xử lý toàn bộ gameplay.

Component chỉ nhận kết quả và hiển thị lên màn hình.

Kiến trúc này sẽ giúp project dễ bảo trì và mở rộng hơn khi game ngày càng lớn.

---

# Kết quả sau chương này

Đến đây chúng ta đã có:

✅ Project Flutter

✅ Flame được cài đặt

✅ GameWidget hoạt động

✅ DungeonGame

✅ Cấu trúc project ban đầu

✅ Component đầu tiên

Mặc dù màn hình vẫn còn trống, nhưng nền móng của game đã được xây dựng xong.

---

# Tổng kết

Trong chương này chúng ta đã tìm hiểu:

- Flame hoạt động như thế nào
- Mối quan hệ giữa Flutter và Flame
- GameWidget
- FlameGame
- Cấu trúc project
- Component đầu tiên

Đây là những khái niệm quan trọng sẽ được sử dụng xuyên suốt toàn bộ series.

---

# Chương tiếp theo

Ở chương 3, chúng ta sẽ tìm hiểu **Game Loop** — trái tim của mọi game.

Bạn sẽ hiểu vì sao game có thể chạy liên tục 60 FPS, Flame cập nhật thế giới như thế nào và cách sử dụng `update()` để điều khiển toàn bộ gameplay.