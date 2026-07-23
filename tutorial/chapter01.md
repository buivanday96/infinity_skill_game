# Chapter 1 - Giới thiệu dự án

# Infinite Skill Dungeon

> Xây dựng một game Roguelike Auto Battle hoàn chỉnh bằng Flutter và Flame.

---

# Mục tiêu của series

Trong series này, chúng ta sẽ xây dựng từ đầu một game hoàn chỉnh bằng **Flutter + Flame**.

Đây không phải là một game AAA, nhưng toàn bộ kiến trúc đều được thiết kế theo hướng có thể mở rộng thành một dự án lớn.

Sau khi hoàn thành, bạn sẽ hiểu cách xây dựng:

- Game Loop
- Entity System
- Battle System
- AI
- Skill System
- Dungeon Generation
- Infinite Skill Tree
- Save/Load
- UI
- Animation
- Performance Optimization

Thay vì chỉ học API của Flame, mục tiêu là học **tư duy phát triển game**.

---

# Game Overview

Tên dự án:

> Infinite Skill Dungeon

Thể loại:

- Auto Battle
- Dungeon
- Roguelike
- Infinite Progression

Người chơi sẽ điều khiển **Healer**.

Các Hero còn lại sẽ được AI điều khiển.

```
        Tank

           ↑

Archer ← Monsters → Mage

           ↓

        Healer
```

Người chơi không cần điều khiển di chuyển.

Thay vào đó sẽ tập trung vào:

- Heal
- Shield
- Buff
- Ultimate
- Chọn Skill sau mỗi tầng

---

# Gameplay Loop

Toàn bộ game chỉ xoay quanh một vòng lặp cực kỳ đơn giản.

```
Start Run

↓

Generate Floor

↓

Spawn Heroes

↓

Spawn Monsters

↓

Battle

↓

Victory

↓

Choose Skill

↓

Next Floor

↓

Repeat Forever
```

Mỗi lần vượt qua một tầng:

- Quái mạnh hơn
- Hero mạnh hơn
- Skill nhiều hơn
- Build đa dạng hơn

Không có kết thúc.

Người chơi sẽ cố gắng đi được xa nhất có thể.

---

# Điều kiện thắng

Không tồn tại.

Game sẽ tiếp tục vô hạn.

Đây là đặc trưng của Roguelike.

---

# Điều kiện thua

Khi:

- Tank chết
- Archer chết
- Mage chết

=> Game Over.

Healer không ảnh hưởng đến điều kiện thất bại.

Điều này buộc người chơi luôn phải giữ đồng đội sống sót.

---

# Vai trò của từng Hero

## Tank

Nhiệm vụ:

- Chịu sát thương
- Thu hút quái
- Bảo vệ tuyến sau

Đặc điểm:

- HP cao
- Defense cao
- Damage thấp

---

## Archer

Nhiệm vụ:

- Gây Physical Damage

Đặc điểm:

- Damage cao
- Máu thấp

---

## Mage

Nhiệm vụ:

- Gây Magic Damage

Đặc điểm:

- Damage diện rộng
- Cooldown dài

---

## Healer (Player)

Đây là nhân vật duy nhất người chơi điều khiển.

Có thể:

- Heal
- Shield
- Buff
- Ultimate

Không cần di chuyển.

Toàn bộ gameplay sẽ tập trung vào việc sử dụng kỹ năng đúng thời điểm.

---

# Infinite Skill

Sau mỗi tầng, người chơi sẽ nhận được 3 lựa chọn.

Ví dụ:

```
+20% Heal

+15% Archer Damage

Meteor

Life Steal

Chain Lightning

Poison Arrow

Healing Aura
```

Người chơi chỉ được chọn **một**.

Skill sẽ tồn tại cho đến khi Game Over.

Sau hàng trăm tầng, mỗi người chơi sẽ có một build hoàn toàn khác nhau.

Đây chính là điểm hấp dẫn nhất của game.

---

# Vì sao chọn Flutter + Flame?

Flutter vốn được tạo ra để xây dựng ứng dụng.

Tuy nhiên Flutter có rất nhiều ưu điểm khi làm game 2D.

Ưu điểm:

- Hot Reload cực nhanh
- Dart dễ học
- UI mạnh
- Chạy Android
- iOS
- Windows
- macOS
- Linux
- Web

Flame sẽ bổ sung:

- Game Loop
- Sprite
- Animation
- Camera
- Collision
- Audio
- Component System

Flutter chịu trách nhiệm UI.

Flame chịu trách nhiệm gameplay.

Hai framework hoạt động rất tốt cùng nhau.

---

# Kiến thức cần có

Để theo hết series này bạn nên biết:

Flutter cơ bản:

- Widget
- StatefulWidget
- Future
- Stream
- Async

Dart:

- Class
- Inheritance
- Mixins
- Extension
- Generics

Không cần biết:

- OpenGL
- Unity
- Unreal
- Godot

Series sẽ giải thích từ đầu.

---

# Kiến trúc chúng ta sẽ xây dựng

```
Flutter

│

├── UI

├── Riverpod

└── Flame

        │

        ├── Game

        ├── World

        ├── Camera

        ├── Components

        └── Systems
```

Trong đó:

Flutter dùng để xây dựng:

- Menu
- Dialog
- Inventory
- Setting
- Overlay

Flame dùng để:

- Battle
- Character
- AI
- Animation
- Effect

Đây là cách tổ chức phổ biến trong các game Flutter hiện đại.

---

# Mục tiêu cuối cùng

Sau khi hoàn thành series, chúng ta sẽ có:

✅ Một game hoàn chỉnh

✅ Kiến trúc có thể mở rộng

✅ Dễ bảo trì

✅ Tách biệt UI và Gameplay

✅ Có thể thêm Hero mới

✅ Có thể thêm Monster mới

✅ Có thể thêm Skill mới

Mà gần như không phải sửa code cũ.

Đây cũng là mục tiêu quan trọng nhất của toàn bộ series.

---

# Chương tiếp theo

Trong chương 2, chúng ta sẽ tạo project Flutter đầu tiên, cài đặt Flame và chạy game đầu tiên chỉ với vài dòng code.