# Chapter 3 - Hiểu Game Loop - Trái tim của mọi Game

# Mục tiêu

Sau chương này bạn sẽ hiểu:

- Game Loop là gì
- Tại sao game có thể chạy liên tục
- `update()` hoạt động như thế nào
- `render()` hoạt động như thế nào
- Delta Time (`dt`) là gì
- Vì sao không nên dùng `Timer.periodic()` để viết gameplay
- Cách tổ chức Game Loop trong dự án của chúng ta

Đây là chương quan trọng nhất của toàn bộ series.

Nếu hiểu Game Loop, bạn sẽ hiểu gần như mọi Game Engine đều hoạt động theo cùng một nguyên lý, từ Flame, Unity, Godot cho đến Unreal Engine.

---

# Một game khác ứng dụng như thế nào?

Hãy tưởng tượng bạn viết một ứng dụng Flutter.

```text
User bấm Button

↓

Xử lý

↓

Hiển thị kết quả

↓

Kết thúc
```

Ứng dụng chỉ làm việc khi người dùng tương tác.

Nếu không ai chạm vào màn hình.

Ứng dụng gần như không làm gì.

---

Trong game thì hoàn toàn khác.

Ngay cả khi người chơi không chạm vào màn hình.

Quái vẫn di chuyển.

Hero vẫn đánh.

Hiệu ứng vẫn chạy.

Máu vẫn giảm.

Animation vẫn phát.

Thời gian trong game vẫn trôi.

Điều này có nghĩa game phải **tự cập nhật liên tục**.

---

# Game Loop là gì?

Game Loop chính là một vòng lặp chạy liên tục từ lúc game bắt đầu đến lúc game kết thúc.

```text
Start Game

↓

Update

↓

Render

↓

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

Vòng lặp này thường chạy khoảng:

```
60 lần mỗi giây
```

Hay còn gọi là:

```
60 FPS
```

FPS là viết tắt của:

```
Frames Per Second
```

Mỗi Frame, game sẽ:

1. Cập nhật thế giới.
2. Vẽ lại màn hình.

Sau đó lặp lại.

---

# Flame Game Loop

Trong Flame, Game Loop đã được xây dựng sẵn.

Chúng ta không cần tự tạo vòng lặp.

Khi kế thừa `FlameGame`.

```dart
class DungeonGame extends FlameGame {

}
```

Flame sẽ tự động gọi:

```dart
update(dt);
```

và

```dart
render(canvas);
```

liên tục.

Bạn chỉ cần tập trung vào gameplay.

---

# Update và Render

Đây là hai khái niệm rất quan trọng.

## Update

Update dùng để thay đổi trạng thái của game.

Ví dụ:

- Hero di chuyển
- Quái tìm mục tiêu
- Hồi máu
- Giảm cooldown
- Sinh quái
- Đếm thời gian

Nói cách khác:

> Update là phần **logic**.

---

## Render

Render dùng để vẽ.

Ví dụ:

- Hero
- Quái
- Thanh máu
- Hiệu ứng
- Map

Render **không nên thay đổi dữ liệu**.

Nó chỉ đọc dữ liệu và hiển thị.

---

Có thể hình dung như sau.

```text
Update

↓

Thay đổi dữ liệu

↓

Render

↓

Đọc dữ liệu

↓

Hiển thị
```

---

# Delta Time (dt)

Nếu để ý bạn sẽ thấy.

```dart
@override
void update(double dt) {
    super.update(dt);
}
```

`dt`

chính là:

```
Delta Time
```

Hay:

> Thời gian giữa hai frame.

Ví dụ.

Game chạy 60 FPS.

Một frame sẽ mất khoảng:

```
1 / 60

=

0.016 giây
```

Khi đó.

```
dt

≈

0.016
```

Nếu game bị lag.

FPS giảm xuống còn:

```
30 FPS
```

Khi đó.

```
dt

≈

0.033
```

Đây là lý do chúng ta luôn dùng `dt`.

---

# Ví dụ di chuyển

Sai.

```dart
x += 5;
```

Hero sẽ chạy nhanh hơn trên máy mạnh.

Chậm hơn trên máy yếu.

---

Đúng.

```dart
x += speed * dt;
```

Ví dụ.

```
speed

=

100 pixel/giây
```

Sau một giây.

Hero luôn đi đúng:

```
100 pixel
```

Bất kể game đang chạy:

- 30 FPS
- 60 FPS
- 120 FPS

Đây là nguyên tắc quan trọng trong mọi Game Engine.

---

# Update không chỉ dành cho nhân vật

Mọi thứ trong game đều cập nhật bằng Game Loop.

Ví dụ.

```text
Hero

↓

Move
```

```text
Monster

↓

AI
```

```text
Skill

↓

Cooldown
```

```text
Projectile

↓

Fly
```

```text
Buff

↓

Duration
```

```text
Dungeon

↓

Spawn Monster
```

Toàn bộ đều chạy trong Game Loop.

---

# Vì sao không dùng Timer.periodic()?

Nhiều lập trình viên Flutter mới thường nghĩ như sau.

```dart
Timer.periodic(
    Duration(milliseconds: 16),
    (_) {

});
```

Điều này hoạt động.

Nhưng không phù hợp để viết gameplay.

Ví dụ.

Bạn sẽ có:

- Timer AI
- Timer Heal
- Timer Spawn
- Timer Skill
- Timer Buff

Sau vài tháng.

Project sẽ có hàng chục Timer chạy cùng lúc.

Rất khó kiểm soát.

Game Engine đã có sẵn Game Loop.

Hãy để mọi thứ chạy trong Game Loop.

---

# Game Loop trong dự án của chúng ta

Trong series này.

`DungeonGame`

không trực tiếp xử lý gameplay.

Nó chỉ đóng vai trò điều phối.

```text
DungeonGame

↓

BattleSystem

↓

AISystem

↓

SkillSystem

↓

DungeonSystem

↓

RewardSystem
```

Điều này giúp code dễ bảo trì hơn.

---

Ví dụ.

```dart
@override
void update(double dt) {
  super.update(dt);

  battleSystem.update(dt);
  aiSystem.update(dt);
  dungeonSystem.update(dt);
  rewardSystem.update(dt);
}
```

Game chỉ biết gọi từng hệ thống.

Mỗi hệ thống sẽ tự xử lý công việc của mình.

---

# Điều gì xảy ra trong một Frame?

Hãy tưởng tượng game đang có:

- 4 Hero
- 5 Monster
- 20 Projectile
- 15 Buff

Một frame sẽ diễn ra như sau.

```text
Frame

↓

Update Hero

↓

Update Monster

↓

Update AI

↓

Update Projectile

↓

Update Buff

↓

Update Dungeon

↓

Check Victory

↓

Render
```

Sau đó.

Frame tiếp theo bắt đầu.

---

# Một ví dụ thực tế

Tank đang có:

```
Cooldown Skill

=

3 giây
```

Mỗi frame.

```dart
cooldown -= dt;
```

Nếu `dt`

=

```
0.016
```

Sau khoảng:

```
187 frame
```

Cooldown sẽ về:

```
0
```

Tank có thể dùng skill.

Không cần bất kỳ Timer nào.

---

# Sai lầm phổ biến

## Sai lầm 1

Thay đổi dữ liệu trong `render()`.

Ví dụ.

```dart
render() {

    hp--;

}
```

Sai.

Render chỉ dùng để vẽ.

---

## Sai lầm 2

Dùng nhiều Timer.

```dart
Timer Heal

Timer Spawn

Timer AI

Timer Buff
```

Game sẽ rất khó bảo trì.

---

## Sai lầm 3

Không dùng `dt`.

```dart
x += 5;
```

Game sẽ chạy khác nhau trên từng thiết bị.

---

## Sai lầm 4

Đặt toàn bộ gameplay trong `update()` của Game.

Ví dụ.

```dart
update()

{

AI

Damage

Buff

Heal

Spawn

Reward

Save

Quest

....

}
```

Sau vài tháng.

File này có thể dài hơn 3000 dòng.

Đó là lý do chúng ta tách thành nhiều System.

---

# Tổng kết

Game Loop chính là trái tim của mọi game.

Mỗi frame.

Game sẽ:

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

Trong đó.

- Update thay đổi dữ liệu.
- Render hiển thị dữ liệu.

Mọi gameplay như:

- AI
- Damage
- Heal
- Cooldown
- Spawn
- Buff

đều sẽ chạy trong `update()`.

Việc hiểu Game Loop sẽ giúp bạn dễ dàng học bất kỳ Game Engine nào sau này.

---

# Chương tiếp theo

Ở chương 4, chúng ta sẽ tìm hiểu **Component System** trong Flame.

Bạn sẽ hiểu:

- Component là gì?
- Component khác Widget ở điểm nào?
- Khi nào nên tạo một Component mới?
- Làm thế nào để quản lý hàng trăm Component mà vẫn giữ code sạch và dễ mở rộng?