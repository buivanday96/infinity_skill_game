# Chapter 21 - Movement System - Xây dựng hệ thống di chuyển chuyên nghiệp

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- Movement System
- Character Controller
- Velocity
- Acceleration
- Direction
- Rotation
- Camera Follow
- Movement State
- Collision Movement
- Dash Movement

Đây là Gameplay System đầu tiên của game.

Từ chương này trở đi, Hero sẽ bắt đầu có thể di chuyển trong thế giới.

---

# Movement là gì?

Rất nhiều người nghĩ.

Movement đơn giản là.

```dart
position += speed;
```

Thực tế.

Movement là một System hoàn chỉnh.

Bao gồm.

- Input
- Velocity
- Acceleration
- Collision
- Camera
- Animation
- State

---

# Movement không thuộc Hero

Sai.

```text
Hero

↓

Move()
```

Đúng.

```text
MovementSystem

↓

HeroEntity
```

Movement là Gameplay.

Do System xử lý.

---

# Movement Flow

Một Frame.

```text
Input

↓

Direction

↓

Velocity

↓

MovementSystem

↓

Transform

↓

Render
```

Đây là Flow chuẩn.

---

# Transform

Movement chỉ sửa.

```
TransformComponent
```

Ví dụ.

```
Position
```

```
Rotation
```

```
Scale
```

Không sửa Sprite.

---

# Direction

Direction không phải Velocity.

Ví dụ.

```
Left
```

```
Right
```

```
Up
```

```
Down
```

Hoặc.

```
Vector2
```

Direction chỉ thể hiện.

```
Muốn đi đâu
```

---

# Velocity

Velocity là.

```
Hướng

+

Tốc độ
```

Ví dụ.

```
Direction

Right

+

Speed

300
```

↓

```
Velocity

(300,0)
```

Movement dùng Velocity.

Không dùng Direction.

---

# Speed

Speed là.

```
Scalar
```

Ví dụ.

```
250 pixel/s
```

```
500 pixel/s
```

Không phụ thuộc FPS.

---

# Delta Time

Movement luôn sử dụng.

```
dt
```

Ví dụ.

```text
Position

↓

Velocity

×

dt
```

Không bao giờ viết.

```dart
x += 5;
```

---

# Acceleration

Một nhân vật.

Không nên.

```
0

↓

300
```

Ngay lập tức.

Thay vào đó.

```
0

↓

50

↓

100

↓

150

↓

300
```

Đây gọi là.

```
Acceleration
```

---

# Deceleration

Tương tự.

Khi nhả phím.

Không nên.

```
300

↓

0
```

Thay vào đó.

```
300

↓

220

↓

160

↓

80

↓

0
```

Movement sẽ mượt hơn.

---

# Character Controller

MovementSystem.

Không đọc Keyboard trực tiếp.

Có.

```
CharacterController
```

Controller chỉ tạo.

```
Move Command
```

Ví dụ.

```
Move Left
```

↓

MovementSystem.

---

# Input tách khỏi Movement

Sai.

```text
Keyboard

↓

Move
```

Đúng.

```text
Keyboard

↓

Controller

↓

Movement

↓

Transform
```

Sau này.

AI cũng có thể dùng Controller.

---

# AI Movement

AI không bấm phím.

Nhưng.

AI vẫn tạo.

```
Move Command
```

MovementSystem xử lý giống Player.

Đây là ưu điểm rất lớn.

---

# Rotation

Một số game.

Hero luôn nhìn theo hướng di chuyển.

Ví dụ.

```
Velocity

↓

Rotation
```

Movement sẽ cập nhật Rotation.

---

# Facing Direction

Ngoài Rotation.

Hero còn có.

```
Facing

Left
```

```
Facing

Right
```

Component.

↓

```
FlipX
```

Gameplay.

Không biết Flip.

---

# Movement State

Movement quyết định.

```
Idle
```

```
Walking
```

```
Running
```

```
Dash
```

```
Jump
```

Animation chỉ đọc State.

---

# Camera Follow

Movement.

↓

```
Hero Position
```

↓

Camera.

↓

```
Follow Hero
```

Camera.

Không biết Keyboard.

---

# Camera Smooth

Không nên.

```
Camera

↓

Teleport
```

Thay vào đó.

```
Lerp
```

Camera sẽ mượt hơn.

---

# Collision Movement

Một sai lầm.

```
Move

↓

Collision
```

Sau khi đã đi.

Đúng.

```
Check Collision

↓

Move
```

Movement luôn kiểm tra.

Trước khi cập nhật Position.

---

# Slide Movement

Nếu va tường.

Không nên.

```
Stop
```

Có thể.

```
Slide
```

Ví dụ.

Đi chéo.

Va tường.

↓

Trượt dọc tường.

---

# Dash

Dash không phải Teleport.

Dash vẫn là Movement.

Chỉ khác.

```
Velocity

×

3
```

Trong.

```
0.2 giây
```

Sau đó.

Trở lại bình thường.

---

# Knockback

Khi bị đánh.

Hero bị đẩy.

```
Damage

↓

Knockback Force

↓

Velocity
```

MovementSystem xử lý.

Không phải BattleSystem.

---

# External Force

Movement nhận.

```
Player Input
```

Hoặc.

```
External Force
```

Ví dụ.

```
Wind
```

```
Explosion
```

```
Boss Push
```

Tất cả đều thành Velocity.

---

# Path Following

AI.

Không đi trực tiếp.

```
Target
```

↓

```
Path
```

↓

Movement.

Sau này.

Navigation System.

Sẽ cung cấp Path.

---

# Sprint

Sprint.

Không phải Movement khác.

Chỉ thay đổi.

```
Speed Modifier
```

Ví dụ.

```
Speed

250

↓

400
```

---

# Slow

Khi bị Debuff.

```
Speed

300

↓

120
```

MovementSystem.

Tự tính.

---

# Movement Modifier

Có thể có.

```
Buff
```

```
Slow
```

```
Freeze
```

```
Root
```

Movement chỉ đọc Modifier.

---

# Teleport

Teleport.

Không dùng Velocity.

Chỉ.

```
Position

=

Target
```

Movement vẫn chịu trách nhiệm.

---

# Animation

Movement.

↓

State.

↓

Animation.

Ví dụ.

```
Speed

0
```

↓

Idle.

```
Speed

>0
```

↓

Walk.

---

# Debug

Developer Mode.

Hiển thị.

```
Velocity
```

```
Direction
```

```
Speed
```

```
Acceleration
```

```
Facing
```

Giúp Debug dễ dàng.

---

# Kiến trúc hoàn chỉnh

```text
Input

↓

Character Controller

↓

MovementSystem

↓

Transform

↓

Camera

↓

Animation

↓

Render
```

Movement.

Không biết Sprite.

Không biết Battle.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ MovementSystem

✅ CharacterController

✅ Direction

✅ Velocity

✅ Acceleration

✅ Rotation

✅ Camera Follow

✅ Movement State

✅ Collision Movement

---

# Sai lầm phổ biến

## Sai lầm 1

Hero tự Move.

Movement luôn thuộc.

```
MovementSystem
```

---

## Sai lầm 2

Không dùng Delta Time.

Gameplay sẽ phụ thuộc FPS.

---

## Sai lầm 3

Animation tự tính Speed.

Animation chỉ đọc State.

---

## Sai lầm 4

Camera đọc Keyboard.

Camera chỉ theo Hero.

---

## Sai lầm 5

BattleSystem đẩy Hero.

Battle chỉ phát.

```
Knockback Event
```

Movement xử lý.

---

# Tổng kết

Movement là Gameplay System đầu tiên mà chúng ta xây dựng.

Sau chương này:

- **MovementSystem** quản lý toàn bộ việc di chuyển.
- **CharacterController** tạo lệnh điều khiển.
- **Velocity** và **Acceleration** tạo cảm giác chuyển động tự nhiên.
- **Camera** theo dõi Hero.
- **Animation** đồng bộ theo Movement State.
- **Collision**, **Dash**, **Knockback** đều được xử lý trong cùng một System.

Nhờ vậy, toàn bộ cơ chế di chuyển của Player, AI, Boss và NPC đều sử dụng chung một kiến trúc, giúp việc mở rộng và bảo trì trở nên rất dễ dàng.

---

# Chương tiếp theo

Ở **Chương 22**, chúng ta sẽ xây dựng **Collision System**.

Đây là nền tảng cho mọi Gameplay trong game.

Bạn sẽ học cách xây dựng:

- Collision Layer.
- Collision Mask.
- Trigger.
- Hitbox.
- Hurtbox.
- Raycast.
- Collision Detection.
- Collision Resolution.

Sau chương này, Hero sẽ có thể va chạm với tường, Monster và các vật thể khác trong thế giới game.