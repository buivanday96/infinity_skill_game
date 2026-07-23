# Chapter 15 - Rendering & Performance - Xây dựng game 60 FPS với Flame

# Mục tiêu

Sau chương này bạn sẽ hiểu:

- Flame Render Pipeline hoạt động như thế nào
- Game Loop
- Update vs Render
- Render Layer
- Z Index
- Camera
- Viewport
- Culling
- Object Pooling
- Tối ưu CPU và GPU
- Cách xây dựng game có thể hiển thị hàng nghìn Entity

Đây là chương cực kỳ quan trọng.

Đa số game Flutter bị lag không phải vì Flutter chậm.

Mà vì kiến trúc Render chưa đúng.

Sau chương này, bạn sẽ biết cách thiết kế game có thể chạy mượt ở **60 FPS**, thậm chí **120 FPS**.

---

# Render là gì?

Render đơn giản là:

> Biến dữ liệu thành hình ảnh trên màn hình.

Ví dụ.

```
Hero

↓

Sprite

↓

Screen
```

Model.

```
HP = 100
```

Không ai nhìn thấy.

Component.

```
Draw Hero
```

Người chơi mới nhìn thấy.

---

# Game Loop

Toàn bộ game hoạt động theo vòng lặp.

```text
Update

↓

Render

↓

Update

↓

Render

↓

...
```

Khoảng.

```
60 lần / giây
```

Nếu game chạy.

```
120 FPS
```

Thì vòng lặp chạy.

```
120 lần / giây
```

---

# Update

Update là nơi xử lý Gameplay.

Ví dụ.

```
AI
```

```
Battle
```

```
Movement
```

```
Cooldown
```

```
Physics
```

Không được Draw ở đây.

---

# Render

Render chỉ làm một việc.

```
Draw
```

Ví dụ.

```
Hero
```

```
Monster
```

```
Particle
```

```
HP Bar
```

Không tính Damage.

Không tìm Target.

Không xử lý Gameplay.

---

# Vì sao phải tách?

Sai.

```dart
render() {

attack();

move();

draw();

}
```

Nếu Render bị gọi nhiều hơn Update.

Gameplay sẽ sai.

Do đó.

```
Update

↓

Gameplay
```

```
Render

↓

Drawing
```

Phải hoàn toàn độc lập.

---

# Fixed Update

Một kỹ thuật rất phổ biến.

Gameplay.

```
60 lần / giây
```

Render.

```
120 FPS
```

Hoặc.

```
40 FPS
```

Gameplay vẫn chính xác.

Điều này đặc biệt quan trọng với Combat.

---

# Delta Time (dt)

Flame truyền vào.

```
dt
```

Ví dụ.

```
0.016
```

≈

```
16 ms
```

Đừng viết.

```dart
x += 5;
```

Hãy viết.

```dart
x += speed * dt;
```

Nhờ vậy.

Game chạy giống nhau trên mọi thiết bị.

---

# FPS

FPS.

```
Frame Per Second
```

Ví dụ.

```
30 FPS
```

Game bắt đầu giật.

```
60 FPS
```

Mượt.

```
120 FPS
```

Rất mượt.

Mục tiêu của chúng ta.

```
>=60 FPS
```

---

# Render Pipeline

Một Frame.

```text
Update

↓

Camera

↓

Viewport

↓

Render Layer

↓

GPU

↓

Screen
```

Đây là toàn bộ quá trình.

---

# Render Layer

Không nên.

Draw mọi thứ lẫn nhau.

Thay vào đó.

```
Background
```

↓

```
Map
```

↓

```
Shadow
```

↓

```
Entity
```

↓

```
Effect
```

↓

```
UI
```

Mỗi Layer có nhiệm vụ riêng.

---

# Z Index

Nếu hai Sprite chồng nhau.

Ai sẽ ở trên?

```
Tree

z=1
```

```
Hero

z=5
```

Hero sẽ được vẽ sau.

Do đó.

Đứng phía trước.

---

# Camera

Camera không phải màn hình.

Camera chỉ quyết định.

```
Nhìn vào đâu
```

Ví dụ.

```
World

5000x5000
```

Camera.

```
800x600
```

Người chơi chỉ thấy phần Camera.

---

# Viewport

Viewport là vùng hiển thị.

Ví dụ.

```
Phone

1080x1920
```

Hay.

```
Tablet

2048x1536
```

Gameplay không cần biết.

Camera sẽ Scale phù hợp.

---

# World Coordinate

Không nên dùng.

```
Screen Position
```

Để Gameplay.

Gameplay luôn dùng.

```
World Position
```

Camera.

↓

```
World

↓

Screen
```

Đây là nguyên tắc rất quan trọng.

---

# Culling

Một kỹ thuật tối ưu cực kỳ hiệu quả.

Giả sử.

```
1000 Monster
```

Camera chỉ nhìn thấy.

```
12 Monster
```

Đừng Render.

```
1000
```

Chỉ Render.

```
12
```

Đó gọi là.

```
View Frustum Culling
```

---

# Culling Flow

```text
Entity

↓

Inside Camera ?

↓

Yes

↓

Render

↓

No

↓

Skip
```

CPU và GPU giảm tải rất nhiều.

---

# Object Pooling

Một sai lầm phổ biến.

```dart
Explosion()

↓

Destroy()

↓

Explosion()

↓

Destroy()
```

Tạo và hủy liên tục.

GC sẽ hoạt động rất nhiều.

Thay vào đó.

```
Pool

↓

Reuse
```

Ví dụ.

```
Explosion

20 object
```

Hết hiệu ứng.

↓

Quay lại Pool.

Không tạo mới.

---

# Những gì nên Pool

```
Bullet
```

```
Damage Text
```

```
Particle
```

```
Explosion
```

```
Skill Effect
```

Không nên Pool.

```
Boss
```

Vì xuất hiện rất ít.

---

# Sprite Cache

Nếu.

```
100 Goblin
```

Không nên.

```
100 Sprite.load()
```

Chỉ.

```
Load

1 lần

↓

Reuse
```

Đây là lý do chúng ta đã xây dựng AssetManager.

---

# Update Optimization

Không phải Entity nào cũng cần Update.

Ví dụ.

```
Dead Monster
```

↓

```
Skip Update
```

Hoặc.

```
Outside Camera
```

↓

```
AI Sleep
```

Điều này giúp CPU giảm đáng kể.

---

# Distance Update

Ví dụ.

```
Monster

5000 pixel
```

Xa Camera.

Không cần.

```
60 Update/s
```

Có thể.

```
5 Update/s
```

Người chơi sẽ không nhận ra.

---

# Batch Rendering

Một GPU thích.

```
1 lần Draw

100 Sprite
```

Hơn.

```
100 lần Draw

1 Sprite
```

Đó là lý do.

Sprite Atlas rất quan trọng.

---

# Overdraw

Một lỗi phổ biến.

```
Background

↓

Fog

↓

Shadow

↓

Grass

↓

Water

↓

UI Blur

↓

Hero
```

Quá nhiều Layer chồng lên nhau.

GPU phải vẽ đi vẽ lại.

Hãy giữ Layer đơn giản.

---

# Debug Performance

Trong quá trình phát triển.

Hãy luôn hiển thị.

```
FPS
```

```
Memory
```

```
Draw Calls
```

```
Entity Count
```

Nếu FPS giảm.

Bạn sẽ biết nguyên nhân.

---

# Performance Budget

Ví dụ.

```
16 ms
```

Một Frame.

Có thể chia.

```
AI

2 ms
```

```
Battle

2 ms
```

```
Physics

3 ms
```

```
Render

7 ms
```

```
Other

2 ms
```

Nếu vượt.

```
16 ms
```

FPS sẽ giảm dưới.

```
60
```

---

# Performance trước tối ưu

Một nguyên tắc quan trọng.

Đừng tối ưu quá sớm.

Đầu tiên.

```
Game

↓

Hoạt động đúng
```

Sau đó.

```
Profiler

↓

Tối ưu
```

Không nên đoán.

Hãy đo.

---

# Flame Performance Tips

Một số kinh nghiệm khi dùng Flame.

- Không tạo Object mới trong `update()`.
- Hạn chế cấp phát `Vector2` liên tục.
- Tái sử dụng Component nếu có thể.
- Dùng Sprite Sheet thay vì nhiều PNG nhỏ.
- Chỉ Update Component thật sự cần thiết.
- Không đặt Business Logic trong `render()`.

Những nguyên tắc này sẽ giúp game ổn định hơn trên cả Android và iOS.

---

# Kiến trúc Rendering

Sau chương này.

```text
Game Loop

↓

Update

↓

AISystem

↓

BattleSystem

↓

MovementSystem

↓

Camera

↓

Culling

↓

Render Layer

↓

GPU

↓

Screen
```

Gameplay.

Không phụ thuộc.

Render.

Render.

Không phụ thuộc.

Gameplay.

---

# Sai lầm phổ biến

## Sai lầm 1

Tính Gameplay trong `render()`.

Gameplay chỉ nằm trong `update()`.

---

## Sai lầm 2

Không dùng `dt`.

Game sẽ chạy nhanh hoặc chậm tùy FPS.

---

## Sai lầm 3

Không dùng Object Pool.

Particle và Bullet sẽ gây GC liên tục.

---

## Sai lầm 4

Render mọi Entity.

Hãy sử dụng Culling.

---

## Sai lầm 5

Load Asset khi đang Render.

Asset nên được Preload hoặc Lazy Load thông qua `AssetManager`.

---

## Sai lầm 6

Gameplay phụ thuộc Camera.

Camera chỉ thay đổi góc nhìn.

Gameplay luôn tính theo World Coordinate.

---

# Tổng kết

Rendering không chỉ là vẽ Sprite.

Đó là toàn bộ quá trình biến dữ liệu thành hình ảnh với hiệu năng cao.

Trong dự án này:

- **Update** xử lý Gameplay.
- **Render** chỉ vẽ.
- **Camera** quyết định góc nhìn.
- **Culling** loại bỏ Entity ngoài màn hình.
- **Object Pooling** giảm Garbage Collection.
- **Sprite Cache** và **Atlas** giảm Draw Call.
- **Fixed Update + dt** giúp gameplay ổn định trên mọi thiết bị.

Nếu tuân thủ những nguyên tắc này, game có thể mở rộng lên hàng nghìn Entity mà vẫn duy trì tốc độ khung hình ổn định.

---

# Chương tiếp theo

Ở chương 16, chúng ta sẽ xây dựng **Project Architecture**.

Đây sẽ là chương tổng hợp toàn bộ series, trong đó chúng ta sẽ thiết kế kiến trúc hoàn chỉnh cho một game Flutter Flame quy mô lớn theo hướng **Feature First + ECS-inspired + System-driven**, bao gồm:

- Cấu trúc thư mục.
- Domain, Data và Presentation.
- Game Systems.
- Dependency Injection.
- Event Bus.
- Save System.
- Asset System.
- Cách tổ chức project để có thể phát triển trong nhiều năm mà vẫn dễ bảo trì.