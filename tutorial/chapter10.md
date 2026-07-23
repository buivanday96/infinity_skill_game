# Chapter 10 - AI System - Thiết kế trí tuệ nhân tạo cho Hero và Monster

# Mục tiêu

Sau chương này bạn sẽ hiểu:

- AI System là gì
- Finite State Machine (FSM)
- Target Selection
- Hero AI
- Monster AI
- Boss AI
- Threat System
- Kiến trúc AI của dự án

Sau chương này, game sẽ bắt đầu tự chơi.

Tank sẽ tự tìm quái.

Archer sẽ tự bắn.

Mage sẽ tự dùng phép.

Monster sẽ tự tấn công.

Boss sẽ có Pattern riêng.

Người chơi chỉ cần tập trung điều khiển Healer.

---

# AI là gì?

AI (Artificial Intelligence) trong game không phải ChatGPT.

AI trong game chỉ đơn giản là:

> **Một hệ thống giúp Entity tự đưa ra quyết định.**

Ví dụ.

Monster.

```
Nhìn thấy Hero

↓

Tiến lại gần

↓

Đánh
```

Hoặc.

Tank.

```
Có Monster

↓

Tiến lên

↓

Tank

↓

Đỡ đòn
```

Đó chính là AI.

---

# AI không nằm trong Component

Sai.

```dart
MonsterComponent

{

update()

{

move()

attack()

findTarget()

}

}
```

Thoạt nhìn có vẻ đơn giản.

Nhưng sau này.

- Boss
- Elite
- Summon
- Pet
- NPC

đều sẽ có AI riêng.

Project sẽ rất khó mở rộng.

---

Trong series này.

```
Monster

↓

AISystem

↓

BattleSystem

↓

MonsterComponent
```

MonsterComponent không tự quyết định.

AI quyết định.

---

# Kiến trúc AI

Trong game của chúng ta.

```
Game Loop

↓

AISystem

↓

BattleSystem

↓

Component
```

AI chỉ quyết định.

```
Làm gì?
```

BattleSystem mới thực hiện.

---

# Finite State Machine (FSM)

Đây là mô hình AI phổ biến nhất.

Một Entity chỉ ở một trạng thái tại một thời điểm.

Ví dụ.

```
Idle

↓

Move

↓

Attack

↓

Dead
```

Mỗi State quyết định hành vi.

---

# Vì sao dùng FSM?

Giả sử không có FSM.

```dart
if (...)

if (...)

if (...)

if (...)

```

Sau vài tháng.

Code AI sẽ đầy điều kiện lồng nhau.

FSM giúp hành vi rõ ràng hơn.

---

# Monster State

Monster thường chỉ cần vài trạng thái.

```text
Idle

↓

Find Target

↓

Move

↓

Attack

↓

Dead
```

Đủ để tạo ra phần lớn quái trong game.

---

# Idle

Monster vừa được sinh.

```
Không có Hero

↓

Đứng yên
```

Hoặc.

```
Đi tuần
```

Đây là trạng thái mặc định.

---

# Find Target

Monster tìm Hero.

Theo thiết kế AI của dự án, Monster có thể chọn mục tiêu theo nhiều cách. :contentReference[oaicite:0]{index=0}

```
Nearest

Lowest HP

Highest Threat

Random
```

Target Selector sẽ trả về Hero phù hợp.

---

# Move

Sau khi có Target.

Monster bắt đầu di chuyển.

```
Monster

↓

Target

↓

Move
```

AI không tự thay đổi Position.

Nó chỉ đưa ra mong muốn.

Movement System hoặc Component sẽ thực hiện việc di chuyển.

---

# Attack

Khi khoảng cách đủ gần.

```
Move

↓

Attack
```

BattleSystem sẽ xử lý Damage.

AI chỉ quyết định.

```
Attack Now
```

---

# Dead

Khi HP bằng 0.

```
Dead
```

AI dừng hoàn toàn.

Không còn.

- Move
- Attack
- Skill

---

# Hero AI

Không chỉ Monster.

Hero cũng có AI.

Ví dụ.

Tank.

```
Find Highest Threat

↓

Move

↓

Attack
```

Archer.

```
Find Nearest Monster

↓

Keep Distance

↓

Shoot
```

Mage.

```
Find Largest Monster Group

↓

Cast AOE
```

Healer.

Người chơi điều khiển.

Do đó.

Không cần Hero AI.

---

# Threat System

Theo thiết kế Stat.

Tank có Threat cao. :contentReference[oaicite:1]{index=1}

Monster.

```
Highest Threat

↓

Tank
```

Điều này giúp.

Tank luôn đứng tuyến đầu.

Nếu Tank chết.

Monster sẽ đổi mục tiêu.

---

# Boss AI

Boss không chỉ đánh bình thường.

Theo tài liệu thiết kế, Boss sẽ hoạt động theo Pattern. :contentReference[oaicite:2]{index=2}

```text
Idle

↓

Attack

↓

Charge

↓

AOE

↓

Recover

↓

Repeat
```

Đây là một FSM lớn hơn.

---

# Boss Pattern

Ví dụ.

```
Attack

3 lần

↓

Charge

↓

AOE

↓

Nghỉ

↓

Lặp lại
```

Người chơi sẽ dần học được quy luật.

Điều này khiến Boss thú vị hơn.

---

# AI Tick

Không nhất thiết AI phải cập nhật mỗi Frame.

Ví dụ.

Game chạy.

```
60 FPS
```

AI có thể chỉ cần suy nghĩ.

```
10 lần / giây
```

Điều này giúp giảm CPU rất nhiều.

Ví dụ.

```
Update()

↓

AI Timer

↓

0.1 giây

↓

Think
```

Đây là kỹ thuật rất phổ biến trong game.

---

# Decision và Action

AI nên được chia thành hai bước.

```
Think

↓

Action
```

Ví dụ.

```
Think

↓

Target = Tank
```

Sau đó.

```
Action

↓

Move
```

Hoặc.

```
Attack
```

Không nên vừa suy nghĩ vừa thực hiện trong cùng một đoạn code.

---

# Target Selector

Target Selector nên độc lập.

```
AISystem

↓

TargetSelector

↓

Hero
```

Nhờ vậy.

Heal.

```
Lowest HP Ally
```

Monster.

```
Highest Threat
```

Boss.

```
Random Hero
```

Đều có thể dùng lại cùng một hệ thống.

---

# AI và Combat

AI không gây Damage.

AI chỉ gửi lệnh.

Ví dụ.

```
AttackCommand
```

BattleSystem.

```
↓

Damage
```

Điều này giúp Combat Rule luôn thống nhất.

---

# AI và Animation

Một sai lầm phổ biến.

```dart
AI

↓

Play Animation
```

Không nên.

AI chỉ gửi.

```
Attack
```

Component sẽ tự phát.

```
Attack Animation
```

---

# Kiến trúc AI hoàn chỉnh

Sau chương này.

```
Game Loop

↓

AISystem

↓

Target Selector

↓

Command

↓

BattleSystem

↓

Event

↓

Component
```

AI không biết.

- Sprite
- Animation
- HP Bar

Nó chỉ biết.

```
Nên làm gì tiếp theo?
```

---

# Chuẩn bị cho Dungeon

Theo thiết kế Dungeon. :contentReference[oaicite:3]{index=3}

```
Floor

↓

Generate Monster Group

↓

Battle

↓

Reward

↓

Upgrade

↓

Next Floor
```

Mỗi tầng.

Monster AI vẫn hoạt động như cũ.

Chỉ khác.

- Nhiều quái hơn.
- Mạnh hơn.
- Boss thông minh hơn.

AI không cần thay đổi kiến trúc.

---

# Sai lầm phổ biến

## Sai lầm 1

AI tự tính Damage.

Sai.

Damage thuộc BattleSystem.

---

## Sai lầm 2

AI tự phát Animation.

Sai.

Animation thuộc Component.

---

## Sai lầm 3

Mỗi Monster có AI riêng.

Ví dụ.

```
GoblinAI

WolfAI

ZombieAI

SkeletonAI
```

Sau vài chục loại quái.

Project sẽ rất khó quản lý.

Hãy dùng.

```
AISystem

+

State

+

Pattern
```

---

## Sai lầm 4

FSM quá phức tạp.

Một Monster thường chỉ cần.

```
Idle

↓

Move

↓

Attack

↓

Dead
```

Đừng tạo hàng chục State nếu không thật sự cần.

---

# Tổng kết

AI System quyết định **Entity nên làm gì**, chứ không trực tiếp thực hiện hành động.

Trong dự án này:

- **AISystem** đưa ra quyết định.
- **Target Selector** chọn mục tiêu.
- **BattleSystem** thực thi chiến đấu.
- **Component** hiển thị Animation và Effect.

Hero, Monster và Boss đều sử dụng cùng một kiến trúc AI, chỉ khác State và Pattern.

Nhờ vậy, việc thêm một loại Monster mới thường chỉ cần thêm dữ liệu và Pattern mới, thay vì viết lại toàn bộ hệ thống AI.

---

# Chương tiếp theo

Ở chương 11, chúng ta sẽ xây dựng **Dungeon System**.

Bạn sẽ học:

- Sinh tầng (Floor Generation).
- Sinh nhóm quái (Monster Group).
- Difficulty Scaling.
- Elite và Boss.
- Reward sau mỗi tầng.
- Cách tạo một Dungeon có thể chạy vô hạn mà vẫn sử dụng rất ít bộ nhớ.