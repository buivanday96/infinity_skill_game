# Chapter 23 - Combat System - Xây dựng hệ thống chiến đấu chuyên nghiệp

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- Combat System
- Attack Pipeline
- Damage Pipeline
- Critical Hit
- Defense Calculation
- Damage Modifier
- Attack Cooldown
- Combo System
- Invincibility Frame (I-Frame)
- Death Pipeline

Đây là chương quan trọng nhất của Gameplay.

Nếu Movement giúp Hero di chuyển.

Thì Combat giúp Hero tương tác với thế giới.

Từ chương này game bắt đầu thực sự trở thành một Action RPG.

---

# Combat là gì?

Rất nhiều người nghĩ Combat chỉ là.

```
Attack

↓

HP -= Damage
```

Thực tế.

Combat là cả một Pipeline.

```text
Input

↓

Attack Request

↓

Validation

↓

Attack

↓

Collision

↓

Damage

↓

Death

↓

Reward
```

Mỗi bước đều là một System độc lập.

---

# Combat không nằm trong Hero

Sai.

```
Hero

↓

Attack()
```

Đúng.

```text
CombatSystem

↓

HeroEntity
```

Hero không tự đánh.

CombatSystem điều phối toàn bộ.

---

# Combat Flow

Một lượt tấn công.

```text
Input

↓

Attack Command

↓

CombatSystem

↓

Create Hitbox

↓

Collision

↓

Damage

↓

Animation

↓

Result
```

---

# Attack Request

Player nhấn nút.

```
Attack
```

Không có nghĩa.

Đòn đánh sẽ diễn ra.

Combat phải kiểm tra.

- Cooldown
- Mana
- Silence
- Dead
- Stun
- Attack Lock

Nếu hợp lệ.

Mới Attack.

---

# Attack State

Một Hero.

Không thể.

```
Attack

↓

Attack

↓

Attack

↓

Attack
```

Trong cùng một Frame.

Combat sẽ quản lý.

```
Idle

↓

Attack Windup

↓

Attacking

↓

Recovery

↓

Idle
```

---

# Attack Pipeline

Một đòn đánh chuẩn.

```text
Attack Request

↓

Can Attack?

↓

Create Attack

↓

Spawn Hitbox

↓

Collision

↓

Calculate Damage

↓

Apply Damage

↓

Apply Effect

↓

Finish
```

---

# Hitbox sinh ra khi nào?

Không phải.

```
Nhấn nút

↓

Có Damage
```

Thông thường.

Animation.

```
Attack

Frame 6

↓

Spawn Hitbox
```

Như vậy.

Animation và Gameplay.

Luôn đồng bộ.

---

# Hurtbox

Monster luôn có.

```
Hurtbox
```

Nếu.

```
Hitbox

↓

Hurtbox
```

↓

CombatSystem xử lý Damage.

---

# Damage Pipeline

Đây là Pipeline quan trọng nhất.

```text
Base Damage

↓

Attack Modifier

↓

Defense

↓

Critical

↓

Resistance

↓

Final Damage
```

Không nên.

```
Attack - Defense
```

Đơn giản.

---

# Base Damage

Ví dụ.

Hero.

```
Attack

120
```

Skill.

```
Multiplier

150%
```

↓

Base Damage.

```
180
```

---

# Defense

Monster.

```
Defense

40
```

Combat tính toán.

↓

Damage mới.

Không sửa.

```
Attack
```

---

# Critical Hit

Combat.

↓

Random.

↓

```
Critical?
```

Nếu đúng.

```
Damage

×

Critical Multiplier
```

Ví dụ.

```
180

↓

360
```

---

# Damage Modifier

Buff.

```
+20%
```

Debuff.

```
-30%
```

Element.

```
+50%
```

Boss.

```
-90%
```

Combat sẽ cộng toàn bộ Modifier.

Trước khi tính Damage cuối.

---

# Damage Type

Không phải Damage nào.

Cũng giống nhau.

Ví dụ.

```
Physical
```

```
Magic
```

```
Fire
```

```
Ice
```

```
Poison
```

```
True Damage
```

Mỗi loại.

Có cách tính riêng.

---

# Resistance

Monster có thể có.

```
Fire Resist

80%
```

↓

Fire Damage.

Giảm.

80%.

---

# True Damage

True Damage.

Bỏ qua.

```
Defense
```

```
Armor
```

```
Resistance
```

Chỉ áp dụng.

Trực tiếp.

---

# Miss

Không phải Attack nào.

Cũng trúng.

Combat có thể.

```
Miss
```

↓

Không Damage.

---

# Dodge

Monster.

```
Dodge

20%
```

Nếu Dodge.

↓

Không nhận Damage.

---

# Block

Khác Dodge.

Block.

↓

Vẫn nhận Damage.

Nhưng.

```
Damage

↓

30%
```

---

# Combo System

Combo.

Không phải Spam.

Combat quản lý.

```
Combo 1

↓

Combo 2

↓

Combo 3
```

Nếu quá thời gian.

↓

Reset.

---

# Combo Window

Ví dụ.

```
Attack

↓

0.5s

↓

Combo tiếp
```

Nếu quá.

↓

Quay lại.

Combo 1.

---

# Attack Cooldown

Combat.

Không cho phép.

Spam Attack.

Ví dụ.

```
Attack Speed

2 hit/s
```

↓

Cooldown.

```
0.5s
```

---

# Attack Speed

Attack Speed.

Không chỉ giảm Cooldown.

Mà còn.

```
Animation Speed
```

↓

Nhanh hơn.

---

# Multi Hit

Một Skill.

Có thể.

```
Hit

↓

Hit

↓

Hit
```

Combat phải quản lý.

Từng Hit riêng.

---

# Invincibility Frame (I-Frame)

Sau khi bị đánh.

Hero.

```
0.3s

Immune
```

Trong thời gian này.

Không nhận Damage.

Đây gọi là.

```
I-Frame
```

---

# Damage Event

Combat.

Không Update UI.

Combat chỉ phát.

```
DamageEvent
```

↓

HP Bar.

↓

Floating Text.

↓

Sound.

↓

Camera Shake.

---

# Death Pipeline

Khi HP.

≤0.

Không Destroy ngay.

Pipeline.

```text
HP <=0

↓

Dead State

↓

Death Animation

↓

Drop

↓

Reward

↓

Destroy
```

---

# Reward

Combat.

Không cộng EXP.

Combat phát.

```
MonsterDeadEvent
```

Quest.

↓

EXP.

↓

Loot.

↓

Achievement.

Tự xử lý.

---

# Knockback

Combat.

Không Move Hero.

Combat chỉ phát.

```
Knockback Event
```

MovementSystem.

Xử lý.

---

# Hit Stop

Một kỹ thuật.

Game Action.

Khi đánh trúng.

Game.

```
Pause

0.05s
```

Người chơi.

Cảm thấy.

Đòn đánh.

"Nặng".

---

# Camera Shake

Combat.

Không rung Camera.

Combat phát.

```
Critical Hit Event
```

CameraSystem.

↓

Shake.

---

# Sound

Combat.

Không Play Audio.

↓

```
AttackEvent
```

↓

AudioSystem.

---

# Combat Log

Developer Mode.

Hiển thị.

```
Attack

120

↓

Critical

240

↓

Monster HP

560
```

Giúp Debug.

Rất dễ.

---

# Performance

Combat.

Không nên.

Tìm toàn bộ Monster.

Mỗi Frame.

Combat chỉ xử lý.

```
Hitbox

↓

Collision Result
```

---

# Kiến trúc Combat

```text
Input

↓

CombatSystem

↓

Hitbox

↓

Collision

↓

Damage Pipeline

↓

Events

↓

Other Systems
```

Combat.

Không biết.

Animation.

Không biết.

Camera.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ CombatSystem

✅ Attack Pipeline

✅ Damage Pipeline

✅ Critical Hit

✅ Damage Modifier

✅ Resistance

✅ Combo

✅ Cooldown

✅ I-Frame

✅ Death Pipeline

---

# Sai lầm phổ biến

## Sai lầm 1

Hero tự gây Damage.

Damage luôn do CombatSystem.

---

## Sai lầm 2

Animation gây Damage.

Animation chỉ quyết định.

```
Khi nào Spawn Hitbox
```

---

## Sai lầm 3

Monster tự chết.

Combat chỉ đổi.

```
Dead State
```

Destroy xảy ra sau.

---

## Sai lầm 4

BattleSystem cập nhật UI.

Combat chỉ phát Event.

---

## Sai lầm 5

Không có Damage Pipeline.

Việc cộng thêm Buff, Debuff và Element sau này sẽ rất khó mở rộng.

---

# Tổng kết

Combat là Gameplay System trung tâm của hầu hết các game hành động.

Sau chương này:

- **CombatSystem** điều phối toàn bộ quá trình chiến đấu.
- **Attack Pipeline** quản lý từ lúc người chơi nhấn nút đến khi đòn đánh kết thúc.
- **Damage Pipeline** tính toán Damage theo nhiều bước để dễ mở rộng.
- **Hitbox** và **Hurtbox** kết nối Combat với Collision.
- **Critical**, **Resistance**, **Combo**, **Cooldown** và **I-Frame** tạo nên chiều sâu cho Gameplay.
- **Death Pipeline** giúp Monster chết một cách tự nhiên, có Animation, Loot và Reward.

Quan trọng nhất là Combat chỉ phát **Event**, còn Camera, Audio, UI, Quest và Reward đều phản ứng thông qua EventBus. Điều này giúp Combat luôn gọn gàng và dễ bảo trì.

---

# Chương tiếp theo

Ở **Chương 24**, chúng ta sẽ xây dựng **Skill System**.

Đây là hệ thống cho phép Hero và Monster sử dụng các kỹ năng phức tạp.

Bạn sẽ học cách xây dựng:

- Skill Definition.
- Active Skill.
- Passive Skill.
- Skill Casting.
- Cast Time.
- Channeling.
- Cooldown.
- Mana Cost.
- Buff và Debuff.
- Skill Effect Pipeline.

Sau chương này, Hero sẽ có thể sử dụng các kỹ năng với hiệu ứng, thời gian hồi chiêu và tài nguyên hoàn chỉnh.