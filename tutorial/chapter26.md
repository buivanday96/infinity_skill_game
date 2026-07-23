# Chapter 26 - AI System - Xây dựng hệ thống AI chuyên nghiệp

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- AI System
- AI Brain
- State Machine
- Behavior Tree
- Decision Making
- Aggro System
- Target Selection
- Patrol
- Chase
- Attack Decision
- Boss AI

Đây là chương biến Monster từ những "hình ảnh biết di chuyển" thành những sinh vật có thể tự suy nghĩ.

Sau chương này.

Monster sẽ có thể.

- Đi tuần
- Phát hiện Hero
- Đuổi theo
- Tấn công
- Bỏ chạy
- Gọi đồng đội
- Quay về vị trí ban đầu

---

# AI là gì?

AI không phải.

```
if(playerNear)

attack();
```

AI thực tế là.

```
Perception

↓

Decision

↓

Action
```

Đây là vòng lặp liên tục.

---

# AI System

AI không nằm trong.

```
Monster
```

AI cũng không nằm trong.

```
Movement
```

Toàn bộ AI nằm trong.

```
AISystem
```

Monster chỉ chứa dữ liệu.

---

# AI Flow

Mỗi Frame.

```text
Perception

↓

Think

↓

Decision

↓

Action

↓

Movement

↓

Combat
```

Đây là vòng đời của AI.

---

# AI Brain

Mỗi Monster có.

```
Brain
```

Brain không chứa.

```
Sprite
```

Không chứa.

```
Animation
```

Brain chỉ biết.

```
Thông tin

↓

Quyết định
```

---

# AI Context

Brain cần biết.

```
Current Target
```

```
Current State
```

```
Aggro
```

```
Distance
```

```
Cooldown
```

Toàn bộ gọi là.

```
AI Context
```

---

# AI State Machine

Đơn giản nhất.

Monster có.

```
Idle

↓

Patrol

↓

Chase

↓

Attack

↓

Return

↓

Idle
```

State Machine.

Điều khiển toàn bộ.

---

# Idle

Monster.

```
Đứng yên
```

↓

Quan sát.

↓

Nếu thấy Hero.

↓

```
Chase
```

---

# Patrol

Monster.

Đi tuần.

```text
Point A

↓

Point B

↓

Point C

↓

Point A
```

Đây là trạng thái mặc định.

---

# Chase

Nếu Hero.

Trong.

```
Aggro Range
```

↓

Monster.

```
Chase
```

MovementSystem.

Thực hiện.

Việc di chuyển.

---

# Attack

Nếu Hero.

Trong.

```
Attack Range
```

↓

CombatSystem.

Được gọi.

AI không gây Damage.

---

# Return

Nếu Hero.

Chạy quá xa.

↓

Monster.

Quay về.

```
Spawn Point
```

---

# Dead

Nếu HP.

```
<=0
```

↓

AI dừng hoàn toàn.

---

# State Transition

Ví dụ.

```text
Idle

↓

Hero Found

↓

Chase

↓

Attack

↓

Target Lost

↓

Return

↓

Idle
```

State Machine.

Quản lý.

Toàn bộ.

---

# Aggro System

Monster.

Không nhìn toàn bộ Map.

Chỉ có.

```
Aggro Radius
```

Ví dụ.

```
500 px
```

Nếu Hero.

Ngoài vùng.

↓

Không biết.

---

# Vision

Ngoài Distance.

Có thể kiểm tra.

```
Line Of Sight
```

Nếu.

```
Wall
```

Ở giữa.

↓

Monster.

Không thấy Hero.

---

# Hearing

Một số Monster.

Có thể.

```
Nghe tiếng
```

Ví dụ.

```
Explosion
```

↓

Đi kiểm tra.

---

# Target Selection

Nếu có.

```
5 Hero
```

Monster.

Phải chọn.

Một Target.

Ví dụ.

```
Nearest
```

Hoặc.

```
Lowest HP
```

Hoặc.

```
Highest Threat
```

---

# Threat System

Boss thường không chọn.

Hero gần nhất.

Mà chọn.

```
Threat cao nhất
```

Ví dụ.

```
Tank

200 Threat
```

```
Mage

800 Threat
```

Boss.

Đổi Target.

---

# Memory

Monster.

Có thể nhớ.

Hero.

Trong.

```
5 giây
```

Sau đó.

Quên.

Quay về.

---

# Decision Making

AI.

Không phải.

```
if else

1000 dòng
```

Nó nên.

Tách thành.

```
Decision
```

↓

```
Action
```

---

# Decision Tree

Ví dụ.

```text
See Hero?

↓

Yes

↓

HP <30% ?

↓

Run

↓

No

↓

Attack
```

Decision.

Rất rõ ràng.

---

# Behavior Tree

Khi AI phức tạp.

State Machine.

Không đủ.

Có thể dùng.

```
Behavior Tree
```

Ví dụ.

```text
Selector

├── Dead

├── Attack

├── Chase

├── Patrol
```

Đây là kiến trúc.

Rất phổ biến.

---

# Selector

Selector.

Kiểm tra.

Từ trên xuống.

Node đầu tiên.

```
Success
```

↓

Dừng.

---

# Sequence

Sequence.

Thực hiện.

Theo thứ tự.

```text
Find Target

↓

Move

↓

Attack
```

Nếu bước nào.

Fail.

↓

Dừng.

---

# Condition Node

Ví dụ.

```
Is Target Alive?
```

```
Has Mana?
```

```
Cooldown Ready?
```

Condition.

Không Action.

---

# Action Node

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

Đây là nơi.

Gameplay xảy ra.

---

# Blackboard

Behavior Tree.

Thường có.

```
Blackboard
```

Lưu.

```
Target
```

```
Destination
```

```
Threat
```

```
Cooldown
```

Các Node.

Dùng chung.

---

# AI Tick

AI.

Không cần.

Update.

60 FPS.

Ví dụ.

```
Think

5 lần

/

1 giây
```

Movement.

Vẫn.

60 FPS.

Giúp tiết kiệm CPU.

---

# Boss AI

Boss.

Có nhiều Phase.

```text
Phase 1

↓

70%

↓

Phase 2

↓

30%

↓

Phase 3
```

AI.

Thay đổi.

Theo HP.

---

# Elite AI

Elite.

Có thể.

```
Summon

↓

Dash

↓

Skill

↓

Teleport
```

Chỉ khác.

Behavior.

Không cần.

AI mới.

---

# Group AI

Monster.

Có thể.

```
Call Ally
```

↓

Monster khác.

Tham gia.

Chiến đấu.

---

# Flee

Một số Monster.

Khi HP thấp.

↓

```
Run Away
```

↓

```
Heal
```

↓

Quay lại.

---

# Wander

Không Patrol.

Mà.

Đi ngẫu nhiên.

Trong.

Một vùng.

---

# Spawn AI

Monster.

Vừa Spawn.

↓

```
Idle
```

↓

Sau vài giây.

↓

```
Patrol
```

Không Attack.

Ngay lập tức.

---

# AI Event

AI.

Không Update UI.

↓

```
TargetChangedEvent
```

↓

UI.

↓

Debug.

---

# Animation

AI.

Không Play Animation.

↓

```
State

↓

Animation
```

Movement.

Attack.

Quyết định.

State.

---

# Audio

AI.

Không phát Sound.

↓

```
AlertEvent
```

↓

AudioSystem.

---

# Camera

Boss.

Đổi Phase.

↓

```
BossPhaseChangedEvent
```

↓

Camera.

Shake.

---

# Debug AI

Developer Mode.

Hiển thị.

```
Current State
```

```
Target
```

```
Aggro
```

```
Distance
```

```
Behavior Node
```

```
Decision Time
```

Giúp Debug.

Rất dễ.

---

# Performance

Không Update.

```
1000 AI

×

60 FPS
```

Hãy.

```
LOD AI
```

Ví dụ.

Monster.

Ngoài Camera.

↓

Think.

```
1 lần

/

2 giây
```

Monster.

Gần Hero.

↓

Think.

```
10 lần

/

1 giây
```

---

# Kiến trúc AI

```text
Perception

↓

Brain

↓

Decision

↓

Behavior Tree

↓

Action

↓

Movement

↓

Combat
```

AI.

Không biết.

Sprite.

Không biết.

Camera.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ AISystem

✅ AI Brain

✅ AI Context

✅ State Machine

✅ Behavior Tree

✅ Aggro System

✅ Target Selection

✅ Patrol

✅ Chase

✅ Boss AI

---

# Sai lầm phổ biến

## Sai lầm 1

Viết toàn bộ AI bằng.

```
if else
```

Khi game lớn.

Code sẽ rất khó bảo trì.

---

## Sai lầm 2

AI tự Move.

Movement luôn thuộc.

```
MovementSystem
```

---

## Sai lầm 3

AI tự Attack.

Combat luôn thuộc.

```
CombatSystem
```

---

## Sai lầm 4

Behavior Tree xử lý Damage.

Behavior Tree.

Chỉ quyết định.

```
Làm gì
```

Không thực hiện Gameplay.

---

## Sai lầm 5

Update AI ở 60 FPS cho mọi Monster.

Điều này sẽ lãng phí CPU.

Hãy giảm tần suất suy nghĩ của AI theo khoảng cách hoặc mức độ quan trọng.

---

# Tổng kết

AI System là bộ não của mọi nhân vật không do người chơi điều khiển.

Sau chương này:

- **AISystem** điều phối toàn bộ hành vi của Monster.
- **AI Brain** lưu trạng thái và ngữ cảnh hiện tại.
- **State Machine** phù hợp cho AI đơn giản.
- **Behavior Tree** phù hợp cho Boss và AI phức tạp.
- **Perception**, **Aggro** và **Target Selection** quyết định AI sẽ phản ứng như thế nào với thế giới.
- **MovementSystem** và **CombatSystem** vẫn là những System thực hiện hành động, AI chỉ đưa ra quyết định.

Kiến trúc này giúp bạn có thể tạo từ những Slime đơn giản đến Boss nhiều giai đoạn mà vẫn sử dụng cùng một nền tảng AI.

---

# Chương tiếp theo

Ở **Chương 27**, chúng ta sẽ xây dựng **Animation System**.

Bạn sẽ học cách xây dựng:

- Animation Controller.
- Animation State Machine.
- Blend Tree.
- Transition.
- Animation Event.
- Root Motion.
- Animation Layer.
- Directional Animation.
- Sprite Animation Pipeline.

Sau chương này, Hero và Monster sẽ có hệ thống Animation hoàn chỉnh, đồng bộ chặt chẽ với Gameplay nhưng vẫn tách biệt hoàn toàn khỏi Combat và AI.