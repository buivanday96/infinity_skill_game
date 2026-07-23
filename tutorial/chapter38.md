# Chapter 38 - AI Architecture & Behavior System - Xây dựng kiến trúc AI chuyên nghiệp

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- AI Brain
- State Machine AI
- Behavior Tree
- Utility AI
- Blackboard
- Perception System
- Navigation
- Decision Making
- AI Event Pipeline
- AI Debugger

Đây là chương giúp Enemy và NPC thực sự "sống".

Sau chương này.

Bạn có thể xây dựng.

- Slime
- Goblin
- Boss
- Merchant
- Animal
- Pet

Tất cả.

Chỉ bằng.

AI Architecture.

---

# AI là gì?

Rất nhiều người nghĩ.

AI là.

```
if(playerNear){
 attack();
}
```

Thực tế.

AI là.

```
Sense

↓

Think

↓

Decide

↓

Act
```

Đây là vòng đời.

Của mọi AI.

---

# AI Architecture

Gameplay.

Không nên.

Đặt Logic.

Trong Enemy.

Enemy.

Chỉ có.

```
AI Brain
```

↓

AI Brain.

Điều khiển.

Enemy.

---

# AI Flow

```text
Perception

↓

Blackboard

↓

Decision

↓

Behavior

↓

Action

↓

Gameplay
```

---

# AI Brain

AI Brain.

Là trung tâm.

Của AI.

AI Brain.

Không biết.

Goblin.

Hay.

Dragon.

Nó chỉ biết.

```
Behavior
```

---

# Definition vs AI

Enemy Definition.

Chứa.

```
HP

Speed

Skills
```

AI Brain.

Chứa.

```
Decision
```

Đừng.

Trộn.

Hai thứ.

---

# AI Tick

Không cần.

Update.

60 FPS.

Ví dụ.

```
Think

5 lần

/

Giây
```

Trong khi.

Movement.

Vẫn chạy.

60 FPS.

---

# State Machine

Đây là.

AI đơn giản nhất.

```text
Idle

↓

Patrol

↓

Chase

↓

Attack

↓

Return
```

---

# Idle

Enemy.

Đứng yên.

Hoặc.

Chơi.

Animation.

---

# Patrol

Enemy.

Đi tuần.

Theo.

Waypoint.

Hoặc.

Random.

---

# Chase

Player.

Vào.

Vision.

↓

Enemy.

Đuổi theo.

---

# Attack

Nếu.

Trong Range.

↓

Tấn công.

---

# Return

Player.

Chạy mất.

↓

Enemy.

Quay lại.

Điểm gốc.

---

# State Transition

Ví dụ.

```text
Player Seen

↓

Idle

↓

Chase
```

AI.

Không nhảy.

State.

Ngẫu nhiên.

---

# Behavior Tree

Khi.

AI.

Phức tạp hơn.

State Machine.

↓

Behavior Tree.

---

# Behavior Tree

```text
Selector

├── Attack

├── Chase

└── Patrol
```

Behavior.

Được.

Ghép.

Bằng.

Node.

---

# Selector

Selector.

Chọn.

Node đầu tiên.

Thành công.

---

# Sequence

Sequence.

Thực hiện.

Lần lượt.

```text
See Player

↓

Move

↓

Attack
```

Nếu.

Một bước.

Thất bại.

↓

Dừng.

---

# Condition

Ví dụ.

```
Can Attack?
```

```
HP < 30%
```

```
Player Visible?
```

---

# Action

Ví dụ.

```
Move
```

```
Attack
```

```
Cast Skill
```

```
Run Away
```

---

# Decorator

Decorator.

Thay đổi.

Hành vi.

Ví dụ.

```
Repeat
```

```
Invert
```

```
Cooldown
```

---

# Blackboard

Đây là.

Thành phần.

Quan trọng nhất.

Blackboard.

Là.

```
Shared Memory
```

Cho AI.

---

# Blackboard Data

Ví dụ.

```
Target
```

```
Last Seen Position
```

```
Current HP
```

```
Current Skill
```

Mọi Node.

Đọc.

Blackboard.

---

# Perception

AI.

Không biết.

Player.

Perception.

Là nơi.

Thu thập.

Thông tin.

---

# Vision

Ví dụ.

```
Radius

500
```

↓

Player.

Trong vùng.

↓

Visible.

---

# Field Of View

Không phải.

360°.

Ví dụ.

```
120°
```

↓

Player.

Đứng sau.

↓

Không thấy.

---

# Hearing

Ví dụ.

Player.

Chạy.

↓

Noise Event.

↓

Enemy.

Quay đầu.

---

# Damage Sense

Enemy.

Bị đánh.

↓

Biết.

Có người.

Tấn công.

---

# Memory

Player.

Chạy mất.

↓

Enemy.

Vẫn nhớ.

```
Last Seen Position
```

Trong.

5 giây.

---

# Investigation

Enemy.

Đi.

Đến.

Last Seen Position.

↓

Không thấy.

↓

Quay lại.

Patrol.

---

# Utility AI

Một số Game.

Không dùng.

Behavior Tree.

Mà dùng.

Utility Score.

Ví dụ.

```
Attack

80
```

```
Heal

95
```

↓

Heal.

---

# Utility Function

Điểm.

Có thể.

Được tính.

Theo.

```
HP
```

```
Distance
```

```
Cooldown
```

```
Danger
```

---

# Navigation

AI.

Không biết.

Đường đi.

Navigation.

Là.

System.

Riêng.

---

# Path Finding

Ví dụ.

```
A*

↓

Shortest Path
```

↓

Move.

---

# Obstacle

Nếu.

Có.

Tường.

↓

Navigation.

Tự.

Tìm.

Đường.

Khác.

---

# Skill Decision

AI.

Có nhiều.

Skill.

Ví dụ.

```
Fireball

Cooldown
```

↓

Không dùng.

↓

Chọn.

Skill khác.

---

# Boss AI

Boss.

Không nên.

Có.

Một State.

Boss.

Có thể.

Có.

Nhiều Phase.

---

# Boss Phase

Ví dụ.

```
100%

↓

Phase 1
```

↓

```
50%

↓

Phase 2
```

↓

```
10%

↓

Enrage
```

---

# Team AI

Monster.

Có thể.

Chia sẻ.

Blackboard.

Ví dụ.

```
Target

↓

Leader

↓

Followers
```

---

# Friendly AI

Pet.

NPC.

Đồng đội.

Cũng dùng.

AI Brain.

Chỉ khác.

Behavior.

---

# Event Driven AI

AI.

Không Polling.

Mọi thứ.

Ví dụ.

```
PlayerDiedEvent
```

↓

AI.

Ngừng.

Tấn công.

---

# Cooldown

AI.

Không Spam.

Attack.

↓

Cooldown.

Trong.

Blackboard.

---

# Serialization

Save.

```
Current State
```

```
Blackboard
```

```
Current Target
```

Không lưu.

Behavior Tree.

---

# Debug

Developer Mode.

Hiển thị.

```
Current State
```

```
Behavior Tree
```

```
Current Target
```

```
Blackboard
```

```
Decision Score
```

```
Navigation Path
```

---

# Performance

Không Update.

1000 AI.

Trong.

Cùng.

Một Frame.

Có thể.

```
AI Group A

↓

Frame 1
```

```
AI Group B

↓

Frame 2
```

```
AI Group C

↓

Frame 3
```

Giảm.

CPU.

Đáng kể.

---

# Flame Integration

Trong Flame.

Enemy.

Có thể là.

```
PositionComponent
```

AI Brain.

Không kế thừa.

Component.

AI Brain.

Chỉ.

Điều khiển.

Enemy.

↓

Enemy.

Thực hiện.

Movement.

Animation.

Combat.

---

# AI Event Pipeline

```text
Perception

↓

Blackboard

↓

Behavior Tree

↓

Decision

↓

Action

↓

Gameplay Event
```

AI.

Không gọi.

Quest.

Không gọi.

Audio.

Không gọi.

VFX.

---

# Kiến trúc hoàn chỉnh

```text
Enemy

↓

AI Brain

↓

Behavior Tree

↓

Blackboard

↓

Navigation

↓

Combat

↓

Event Bus
```

Enemy.

Không chứa.

Logic.

AI.

Không chứa.

Render.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ AI Brain

✅ State Machine

✅ Behavior Tree

✅ Blackboard

✅ Perception

✅ Navigation

✅ Utility AI

✅ AI Debugger

✅ Boss Phase

✅ Event Driven AI

---

# Sai lầm phổ biến

## Sai lầm 1

Viết toàn bộ.

AI.

Trong.

Enemy.

Hãy tách.

```
AI Brain
```

Ra riêng.

---

## Sai lầm 2

Behavior Tree.

Đọc.

Gameplay.

Trực tiếp.

Hãy đọc.

```
Blackboard
```

---

## Sai lầm 3

Update.

Mọi AI.

60 FPS.

AI.

Không cần.

Suy nghĩ.

Mỗi Frame.

---

## Sai lầm 4

Navigation.

Nằm trong.

Behavior Tree.

Navigation.

Là.

Một System.

Riêng.

---

## Sai lầm 5

Boss.

Chỉ có.

Một State.

Boss.

Nên có.

```
Phase
```

Để tạo.

Gameplay.

Đa dạng.

---

# Tổng kết

AI Architecture quyết định cách Enemy, NPC và Boss phản ứng với thế giới trong game.

Sau chương này:

- **AI Brain** chịu trách nhiệm ra quyết định, còn Entity chỉ thực hiện hành động.
- **Behavior Tree** và **State Machine** phù hợp với các mức độ phức tạp khác nhau của AI.
- **Blackboard** đóng vai trò là bộ nhớ dùng chung cho toàn bộ quá trình ra quyết định.
- **Perception System** giúp AI nhận biết thế giới thông qua tầm nhìn, âm thanh và các sự kiện Gameplay.
- **Navigation** xử lý việc tìm đường độc lập với AI.
- **Utility AI**, **Boss Phase** và **Event Driven AI** giúp tạo nên những đối thủ thông minh, đa dạng và dễ mở rộng.

Kiến trúc này có thể tái sử dụng cho mọi loại thực thể trong game, từ Enemy, NPC, Pet cho đến Boss nhiều giai đoạn mà không cần viết lại toàn bộ hệ thống AI.

---

# Chương tiếp theo

Ở **Chương 39**, chúng ta sẽ xây dựng **Network & Multiplayer Architecture**.

Bạn sẽ học cách xây dựng:

- Client–Server Architecture.
- Entity Replication.
- Network Snapshot.
- Prediction.
- Interpolation.
- Lag Compensation.
- Authoritative Server.
- RPC & Commands.
- Network Event Pipeline.
- Multiplayer Debug Tools.

Sau chương này, bạn sẽ hiểu cách thiết kế kiến trúc multiplayer hiện đại, từ co-op đơn giản đến các game online quy mô lớn mà vẫn giữ được khả năng mở rộng và đồng bộ trạng thái hiệu quả.