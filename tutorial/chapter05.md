# Chapter 5 - World & Camera - Xây dựng thế giới trong Flame

# Mục tiêu

Sau chương này bạn sẽ hiểu:

- World là gì
- Camera là gì
- Viewport hoạt động như thế nào
- Vì sao Camera quan trọng
- Cách tổ chức World trong game
- UI nên nằm ở đâu
- Kiến trúc Camera mà chúng ta sẽ sử dụng xuyên suốt series

Đây là chương đầu tiên chúng ta bắt đầu xây dựng một "thế giới" thực sự thay vì chỉ hiển thị một màn hình đen.

---

# Thế giới trong Game

Hãy tưởng tượng bạn đang chơi một game RPG.

```
Map

5000 x 5000 pixel
```

Trong khi màn hình điện thoại chỉ khoảng

```
1080 x 1920 pixel
```

Bạn không thể hiển thị toàn bộ map.

Thay vào đó game chỉ hiển thị một phần rất nhỏ.

Ví dụ.

```
+--------------------------------------+
|                                      |
|          Camera View                 |
|                                      |
+--------------------------------------+

          nằm trong

+-----------------------------------------------------------+

                      Whole World

+-----------------------------------------------------------+
```

Đó chính là nhiệm vụ của Camera.

---

# World là gì?

World là toàn bộ không gian của game.

Trong World sẽ có:

- Hero
- Monster
- Bullet
- Effect
- Background
- Dungeon
- Decoration

Có thể hình dung.

```
World

├── Hero

├── Monsters

├── Bullets

├── Effects

├── Trees

├── Dungeon

└── Ground
```

World không phải màn hình.

World chỉ đơn giản là nơi chứa toàn bộ object.

---

# Camera là gì?

Camera không tạo ra thế giới.

Camera chỉ quyết định:

> Người chơi đang nhìn thấy phần nào của World.

Ví dụ.

```
World

+------------------------------------------------+

H          M

               M

                           M

      Boss

+------------------------------------------------+
```

Camera chỉ nhìn thấy.

```
+----------------------+

H

        M

+----------------------+
```

Khi Hero di chuyển.

Camera cũng sẽ di chuyển theo.

---

# Một ví dụ đời thực

Hãy tưởng tượng bạn dùng camera điện thoại.

Căn phòng chính là:

```
World
```

Màn hình điện thoại chính là:

```
Viewport
```

Camera điện thoại chính là:

```
Camera
```

Bạn không làm căn phòng di chuyển.

Bạn chỉ di chuyển camera.

Game cũng hoạt động giống hệt như vậy.

---

# Camera trong Flame

Flame cung cấp sẵn Camera.

Kiến trúc cơ bản.

```dart
class DungeonGame extends FlameGame {

}
```

Sau này chúng ta sẽ có.

```
DungeonGame

↓

Camera

↓

World

↓

Hero

↓

Monster
```

Camera sẽ nhìn vào World.

---

# Viewport

Một khái niệm thường bị nhầm lẫn.

Viewport KHÔNG phải Camera.

Camera:

```
Nhìn vào đâu.
```

Viewport:

```
Hiển thị bao nhiêu.
```

Ví dụ.

Điện thoại.

```
390 x 844
```

Tablet.

```
1024 x 1366
```

Camera giống nhau.

Viewport khác nhau.

---

# Vì sao cần World?

Nếu không có World.

Ta sẽ thêm Hero trực tiếp vào Game.

```
Game

↓

Hero

↓

Monster

↓

Background
```

Điều này vẫn chạy.

Nhưng sau này.

- Camera
- Zoom
- Shake
- Infinite Map

sẽ rất khó làm.

Đó là lý do Flame tách riêng World.

---

# Kiến trúc chúng ta sẽ sử dụng

Trong toàn bộ series.

```
DungeonGame

│

├── Camera

│

├── World

│      │

│      ├── Background

│      ├── Hero

│      ├── Monsters

│      ├── Effects

│      ├── Bullet

│      └── Dungeon

│

└── Flutter UI
```

Đây cũng là kiến trúc được Flame khuyến nghị.

---

# UI không nằm trong World

Một sai lầm phổ biến.

```
World

↓

Health Bar

↓

Skill Button

↓

Pause Button
```

Sai.

Nếu Camera di chuyển.

Button cũng sẽ chạy theo.

Đó không phải điều chúng ta muốn.

UI luôn phải cố định.

```
Flutter UI

──────────────

❤️❤️❤️❤️❤️

Floor 25

[ Heal ]

[ Shield ]

```

Dù Hero chạy đến đâu.

UI vẫn đứng yên.

---

# World sẽ chứa gì?

Theo thiết kế của dự án, các Component chính trong World gồm: :contentReference[oaicite:0]{index=0}

```
World

↓

HeroComponent

MonsterComponent

BackgroundComponent

EffectComponent

FloatingTextComponent
```

Đây đều là các đối tượng xuất hiện trong thế giới game.

---

# UI sẽ chứa gì?

Ngược lại.

UI sẽ chứa.

```
Skill Button

Hero HP

Boss HP

Floor

Battle Log

Menu

Pause

Inventory
```

Theo thiết kế UI của dự án, phần dưới màn hình sẽ là nơi người chơi sử dụng các nút kỹ năng, còn khu vực chiến đấu nằm ở giữa màn hình. :contentReference[oaicite:1]{index=1}

---

# Camera Follow

Một game RPG thường để Camera đi theo nhân vật.

```
Hero

↓

Camera

↓

Move Together
```

Người chơi luôn ở gần giữa màn hình.

Không cần phải tự kéo Camera.

Trong game của chúng ta.

Camera sẽ luôn theo Party.

---

# Camera Zoom

Camera không chỉ biết di chuyển.

Nó còn biết phóng to.

```
Zoom x1
```

```
+--------------------+

Hero

Monster

+--------------------+
```

---

```
Zoom x2
```

```
+-----------+

Hero

+-----------+
```

Mọi object đều lớn hơn.

---

# Camera Shake

Một hiệu ứng rất phổ biến.

Ví dụ.

Boss tung Ultimate.

```
BOOM
```

Camera rung nhẹ.

Người chơi sẽ cảm thấy cú đánh mạnh hơn rất nhiều.

Camera Shake hoàn toàn không làm Hero di chuyển.

Chỉ Camera rung.

---

# Infinite World

Game của chúng ta hướng tới Infinite Dungeon.

Điều đó có nghĩa.

World không có điểm kết thúc.

```
Floor 1

↓

Floor 2

↓

Floor 3

↓

...

↓

Floor 99999
```

Thay vì tạo toàn bộ map từ đầu.

Mỗi tầng sẽ được sinh khi cần.

Điều này giúp game sử dụng rất ít bộ nhớ.

---

# World không chứa Gameplay

Đây là điểm rất quan trọng.

World chỉ chứa Component.

Gameplay vẫn được xử lý bởi.

```
BattleSystem

AISystem

SkillSystem

DungeonSystem
```

World chỉ phản ánh kết quả.

Ví dụ.

BattleSystem.

```
Monster chết.
```

World.

```
Xóa MonsterComponent.
```

Không ngược lại.

---

# Sai lầm phổ biến

## Sai lầm 1

Đặt UI vào World.

```
Hero HP

↓

Di chuyển theo Camera
```

Hoàn toàn sai.

---

## Sai lầm 2

Đặt Monster ngoài World.

```
Game

↓

Monster
```

Sau này Camera sẽ không quản lý được.

---

## Sai lầm 3

Cho World xử lý gameplay.

```
World

↓

Damage

↓

Heal

↓

AI
```

World chỉ nên chứa Component.

Gameplay thuộc về System.

---

## Sai lầm 4

Di chuyển toàn bộ World thay vì Camera.

Nếu muốn người chơi "đi bộ".

Hãy để Hero di chuyển.

Camera theo Hero.

Đừng dịch chuyển cả World.

---

# Tổng kết

Trong chương này chúng ta đã xây dựng nền tảng của thế giới game.

Ba khái niệm quan trọng cần nhớ là:

- **World** là nơi chứa mọi đối tượng trong game.
- **Camera** quyết định người chơi nhìn thấy phần nào của World.
- **Viewport** quyết định kích thước vùng hiển thị trên màn hình.

Trong dự án này, chúng ta sẽ tách rõ:

- **World** chứa Hero, Monster, Effect và Background.
- **Flutter UI** chứa toàn bộ giao diện như Skill Button, HP và Menu.
- **Gameplay** được xử lý bởi các System, không nằm trong World.

Kiến trúc này sẽ giúp việc mở rộng lên bản đồ lớn, Infinite Dungeon và Camera Effect trở nên đơn giản hơn rất nhiều.

---

# Chương tiếp theo

Ở chương 6, chúng ta sẽ xây dựng **Entity System**.

Bạn sẽ học cách biểu diễn Hero, Monster, Boss và các đối tượng trong game bằng Model, Component và System, đồng thời hiểu vì sao việc tách dữ liệu khỏi hiển thị là nền tảng để xây dựng một game dễ mở rộng.