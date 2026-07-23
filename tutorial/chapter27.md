# Chapter 27 - Animation System - Xây dựng hệ thống Animation chuyên nghiệp

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- Animation System
- Animation Controller
- Animation State Machine
- Animation Transition
- Animation Layer
- Animation Event
- Root Motion
- Directional Animation
- Animation Queue
- Blend Tree

Đây là chương giúp Gameplay trở nên "có hồn".

Nếu Combat tạo ra Damage.

Movement tạo ra chuyển động.

Thì Animation giúp người chơi cảm nhận được mọi hành động diễn ra trên màn hình.

---

# Animation là gì?

Rất nhiều người nghĩ.

Animation chỉ là.

```
Play Sprite
```

Thực tế.

Animation chỉ là.

```
Biểu diễn

Gameplay State
```

Gameplay luôn đi trước.

Animation luôn theo sau.

---

# Gameplay luôn là nguồn sự thật

Một nguyên tắc cực kỳ quan trọng.

Sai.

```text
Animation

↓

Attack
```

Đúng.

```text
Combat

↓

Attack State

↓

Animation
```

Animation không điều khiển Gameplay.

Gameplay điều khiển Animation.

---

# Animation System

Toàn bộ Animation.

Được quản lý.

Bởi.

```
AnimationSystem
```

Không nằm trong.

```
HeroComponent
```

Không nằm trong.

```
CombatSystem
```

---

# Animation Flow

Mỗi Frame.

```text
Gameplay State

↓

Animation State

↓

Animation Controller

↓

Sprite Frame

↓

Render
```

Đây là Pipeline chuẩn.

---

# Animation State

Hero.

Không biết.

```
Walk Animation
```

Hero chỉ biết.

```
Idle
```

```
Walk
```

```
Run
```

```
Attack
```

```
Dead
```

AnimationSystem.

Tự chọn.

Animation phù hợp.

---

# Animation Controller

Mỗi Character.

Có một.

```
Animation Controller
```

Controller.

Quản lý.

```
Current Animation
```

```
Next Animation
```

```
Transition
```

```
Playback Speed
```

---

# Animation State Machine

Ví dụ.

```text
Idle

↓

Walk

↓

Run

↓

Attack

↓

Idle
```

Animation.

Không chuyển.

Ngẫu nhiên.

Mọi Transition.

Đều được định nghĩa.

---

# Transition

Ví dụ.

```
Walk

↓

Run
```

Có thể.

```
Blend

0.2 giây
```

Animation sẽ mượt hơn.

---

# Interrupt

Ví dụ.

Hero đang.

```
Attack
```

Boss.

Đánh trúng.

↓

```
Hit
```

Animation.

Có thể bị.

Interrupt.

---

# Animation Priority

Không phải.

Animation nào.

Cũng có.

Độ ưu tiên.

Giống nhau.

Ví dụ.

```
Dead

Priority 100
```

```
Attack

80
```

```
Run

30
```

```
Idle

10
```

Dead.

Luôn thắng.

---

# Loop Animation

Ví dụ.

```
Idle
```

```
Walk
```

```
Run
```

Loop.

Liên tục.

---

# One Shot Animation

Ví dụ.

```
Attack
```

```
Hit
```

```
Die
```

Phát.

Một lần.

Sau đó.

Quay về.

State tiếp theo.

---

# Animation Queue

Ví dụ.

Hero.

```
Attack

↓

Skill

↓

Celebrate
```

Animation.

Có thể.

Được Queue.

---

# Directional Animation

Game Top Down.

Có thể có.

```
Walk Up
```

```
Walk Down
```

```
Walk Left
```

```
Walk Right
```

AnimationSystem.

Tự chọn.

Theo Direction.

---

# 8 Direction Animation

Một số game.

Có.

```
N

NE

E

SE

S

SW

W

NW
```

Animation.

Đầy đủ.

8 hướng.

---

# Flip Animation

Nếu chỉ có.

```
Walk Right
```

Có thể.

```
FlipX
```

↓

```
Walk Left
```

Tiết kiệm Asset.

---

# Animation Layer

Một Character.

Có nhiều Layer.

Ví dụ.

```
Body
```

```
Weapon
```

```
Hat
```

```
Cape
```

Mỗi Layer.

Animation.

Độc lập.

---

# Upper Body Layer

Ví dụ.

Hero.

```
Run
```

Đồng thời.

```
Shoot
```

Chân.

↓

Run.

Tay.

↓

Shoot.

---

# Blend Tree

Một Animation.

Không cần.

```
Walk
```

```
Run
```

Riêng biệt.

Có thể.

Blend.

Theo Speed.

```text
Speed

↓

Blend

↓

Walk / Run
```

---

# Playback Speed

Attack Speed.

Tăng.

↓

Animation.

Nhanh hơn.

Ví dụ.

```
Attack Speed

150%
```

↓

Animation.

1.5x.

---

# Root Motion

Có hai cách.

## Gameplay Driven

Gameplay.

↓

Move.

↓

Animation.

Đây là cách.

Series này sử dụng.

---

## Animation Driven

Animation.

↓

Move Character.

Thường dùng.

Trong Game 3D.

---

# Animation Event

Một Animation.

Có thể phát.

Event.

Ví dụ.

```
Frame 6

↓

Spawn Hitbox
```

Hoặc.

```
Frame 10

↓

Play Sound
```

Đây gọi là.

```
Animation Event
```

---

# Animation Marker

Ví dụ.

```
Attack Start
```

```
Attack Hit
```

```
Attack End
```

Gameplay.

Có thể đọc.

Marker.

---

# Animation Finished

Ví dụ.

```
Death Animation

↓

Finished

↓

Destroy Entity
```

Không cần.

Timer.

---

# Hit Reaction

Hero.

Bị đánh.

↓

```
Hit Animation
```

Sau đó.

↓

```
Idle
```

Hoặc.

↓

```
Run
```

---

# Death Animation

Dead.

Không Destroy.

Ngay.

Flow.

```text
Dead State

↓

Death Animation

↓

Animation Finished

↓

Destroy
```

---

# Spawn Animation

Monster.

Vừa Spawn.

↓

```
Spawn Animation
```

↓

Idle.

---

# Skill Animation

Skill.

Không Play Animation.

Skill phát.

```
CastEvent
```

AnimationSystem.

Quyết định.

Animation nào.

Được chạy.

---

# Animation Override

Ví dụ.

Hero.

```
Frozen
```

↓

Walk Animation.

Không còn.

↓

```
Frozen Idle
```

Animation.

Được Override.

---

# Animation Variant

Ví dụ.

Sword.

```
Attack Sword
```

Bow.

```
Attack Bow
```

Staff.

```
Attack Magic
```

Gameplay.

Chỉ biết.

```
Attack
```

Animation.

Tự chọn.

Variant.

---

# Animation Cache

Không Load.

Sprite Sheet.

Nhiều lần.

AnimationSystem.

Cache.

Toàn bộ.

Animation.

Sau khi Load.

---

# Debug

Developer Mode.

Hiển thị.

```
Current Animation
```

```
Current State
```

```
Frame Index
```

```
Playback Speed
```

```
Layer
```

```
Transition
```

Giúp Debug.

Rất dễ.

---

# Performance

Không Update.

Animation.

Ngoài Camera.

Ví dụ.

Monster.

Xa Hero.

↓

Pause.

Animation.

Giúp giảm CPU.

---

# Kiến trúc hoàn chỉnh

```text
Gameplay

↓

Animation State

↓

Animation Controller

↓

Animation State Machine

↓

Animation Event

↓

Sprite Animation

↓

Render
```

Animation.

Không biết.

Combat.

Không biết.

Movement.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ AnimationSystem

✅ Animation Controller

✅ Animation State Machine

✅ Transition

✅ Animation Layer

✅ Animation Event

✅ Playback Speed

✅ Directional Animation

✅ Animation Queue

✅ Root Motion Strategy

---

# Sai lầm phổ biến

## Sai lầm 1

Animation gây Damage.

Damage luôn thuộc.

```
CombatSystem
```

---

## Sai lầm 2

Movement.

Đọc Animation.

Gameplay.

Không bao giờ.

Đọc Animation.

---

## Sai lầm 3

Animation.

Điều khiển State.

State.

Luôn thuộc Gameplay.

---

## Sai lầm 4

Mỗi Component.

Tự Play Animation.

Hãy dùng.

```
Animation Controller
```

Tập trung.

---

## Sai lầm 5

Hard Code.

Tên Animation.

Khắp Project.

Hãy dùng.

```
Animation Definition
```

Hoặc.

```
Animation ID
```

Để dễ thay đổi Asset.

---

# Tổng kết

Animation System là lớp kết nối giữa Gameplay và hình ảnh hiển thị.

Sau chương này:

- **AnimationSystem** chịu trách nhiệm phát và quản lý mọi Animation.
- **Animation Controller** quyết định Animation nào sẽ được phát dựa trên Gameplay State.
- **Animation State Machine** giúp việc chuyển Animation mượt và có quy tắc.
- **Animation Layer** cho phép nhiều Animation chạy đồng thời trên cùng một nhân vật.
- **Animation Event** đồng bộ chính xác thời điểm gây sát thương, phát âm thanh hoặc tạo hiệu ứng.
- **Gameplay** vẫn là nguồn dữ liệu duy nhất, còn Animation chỉ phản ánh những gì Gameplay đang diễn ra.

Kiến trúc này giúp Animation luôn đồng bộ với Combat, Movement và AI mà không tạo ra sự phụ thuộc ngược giữa các System.

---

# Chương tiếp theo

Ở **Chương 28**, chúng ta sẽ xây dựng **Inventory & Equipment System**.

Bạn sẽ học cách xây dựng:

- Item System.
- Inventory.
- Equipment Slot.
- Equipment Modifier.
- Consumable Item.
- Stackable Item.
- Loot.
- Drop Table.
- Item Serialization.
- Equipment Pipeline.

Sau chương này, Hero sẽ có thể nhặt đồ, trang bị vũ khí, mặc giáp và sử dụng vật phẩm giống như trong các game RPG chuyên nghiệp.