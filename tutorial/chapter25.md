# Chapter 25 - Buff & Status Effect System - Xây dựng hệ thống Buff chuyên nghiệp

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- Buff System
- Status Effect
- Modifier Pipeline
- Buff Instance
- Stack Rule
- Duration
- Aura
- Damage Over Time (DoT)
- Heal Over Time (HoT)
- Crowd Control (CC)

Đây là chương giúp Gameplay trở nên sâu sắc hơn.

Nếu Combat quyết định Hero gây Damage.

Thì Buff System quyết định.

```
Hero mạnh lên

Hay

Yếu đi
```

---

# Buff là gì?

Buff không phải Skill.

Buff chỉ là.

```
Một Effect

Có thời gian tồn tại
```

Ví dụ.

```
Attack +20%
```

```
Defense +50
```

```
Move Speed +30%
```

Buff chỉ thay đổi thuộc tính.

---

# Debuff

Debuff.

Cũng chính là Buff.

Chỉ khác.

```
Modifier

Âm
```

Ví dụ.

```
Poison
```

```
Slow
```

```
Silence
```

```
Burn
```

---

# Status Effect

Buff.

Chỉ là một loại.

Status Effect.

Bao gồm.

```
Buff
```

```
Debuff
```

```
Crowd Control
```

```
Aura
```

```
Damage Over Time
```

```
Heal Over Time
```

---

# Buff System

Gameplay.

Không xử lý Buff.

Buff được quản lý.

Bởi.

```
BuffSystem
```

Không nằm trong.

```
Combat
```

Không nằm trong.

```
Hero
```

---

# Buff Flow

Một Buff.

```text
Skill

↓

Apply Buff

↓

BuffSystem

↓

Modifier

↓

Stats

↓

Gameplay
```

Buff không trực tiếp sửa.

```
Attack
```

---

# Buff Definition

Giống Skill.

Buff được mô tả.

Bằng dữ liệu.

Ví dụ.

```
Attack Up
```

```
Shield
```

```
Poison
```

```
Burn
```

Không Hard Code.

---

# Buff Instance

Definition.

Là.

```
Template
```

Khi áp dụng.

↓

```
Buff Instance
```

Mỗi Hero.

Có Instance riêng.

---

# Buff ID

Mỗi Buff.

Có.

```
ID
```

Ví dụ.

```
buff_attack_up
```

```
buff_poison
```

```
buff_freeze
```

Được dùng.

Cho.

- Save
- Remove
- Analytics

---

# Duration

Ví dụ.

```
10 giây
```

BuffSystem.

Giảm.

```
Duration
```

Mỗi Frame.

Khi.

```
0
```

↓

Remove.

---

# Infinite Buff

Một số Buff.

Không hết hạn.

Ví dụ.

```
Passive Skill
```

```
Equipment Bonus
```

Duration.

```
Infinite
```

---

# Refresh Rule

Nếu Buff.

Được Cast lại.

Có nhiều cách.

```
Refresh Time
```

Hoặc.

```
Ignore
```

Hoặc.

```
Stack
```

Buff Definition.

Quyết định.

---

# Stack

Ví dụ.

Poison.

```
1

↓

2

↓

3

↓

4

↓

5
```

Đến.

```
Max Stack
```

Sau đó.

Không tăng nữa.

---

# Stack Rule

Có nhiều cách.

```
Replace
```

```
Refresh
```

```
Add Stack
```

```
Ignore
```

Đây là.

Một phần.

Buff Definition.

---

# Modifier

Buff.

Không sửa.

```
Attack
```

Nó tạo.

```
Modifier
```

Ví dụ.

```
Attack +20%
```

↓

Modifier Pipeline.

↓

Attack cuối.

---

# Modifier Pipeline

Một Stat.

Được tính.

```text
Base Stat

↓

Equipment

↓

Passive

↓

Buff

↓

Debuff

↓

Final Stat
```

Buff.

Không thay đổi.

Base Stat.

---

# Temporary Modifier

Ví dụ.

```
Attack +100

10 giây
```

Sau 10 giây.

↓

Modifier biến mất.

Không cần.

Restore.

---

# Permanent Modifier

Ví dụ.

```
Equipment
```

```
Level Up
```

Không hết hạn.

---

# Aura

Ví dụ.

Paladin.

↓

```
Nearby Ally

↓

+20 Defense
```

Aura.

Tự Apply.

Tự Remove.

Khi ra khỏi vùng.

---

# Aura Radius

Aura.

Luôn kiểm tra.

```
Radius
```

Không cần.

Collision.

Mỗi Frame.

---

# Damage Over Time (DoT)

Ví dụ.

```
Burn
```

↓

```
5 Damage

Mỗi giây
```

BuffSystem.

Tự Tick.

---

# Heal Over Time (HoT)

Ví dụ.

```
Regeneration
```

↓

```
+10 HP

Mỗi giây
```

Không cần.

Combat.

---

# Tick Rate

DoT.

Không cần.

Update.

60 FPS.

Ví dụ.

```
1 Tick

/

1 giây
```

Hiệu quả hơn.

---

# Crowd Control (CC)

Status Effect.

Có thể.

```
Stun
```

```
Freeze
```

```
Root
```

```
Silence
```

```
Fear
```

```
Sleep
```

BuffSystem.

Quản lý.

---

# Stun

Ví dụ.

```
Stun

2 giây
```

Movement.

↓

Disabled.

Combat.

↓

Disabled.

---

# Root

Khác.

```
Stun
```

Root.

↓

Không Move.

↓

Vẫn Attack.

---

# Silence

Silence.

↓

Không dùng.

Skill.

↓

Vẫn đánh thường.

---

# Freeze

Freeze.

↓

Không Move.

↓

Không Attack.

↓

Play Frozen Effect.

---

# Poison

Poison.

↓

Damage Over Time.

Không giảm.

Attack.

---

# Burn

Burn.

↓

Damage.

↓

Fire Effect.

↓

Có thể.

Lan sang.

Monster khác.

---

# Shield

Shield.

Không Heal.

Shield.

Là.

```
Temporary HP
```

Damage.

Ăn vào.

Shield.

Trước.

---

# Absorb

Ví dụ.

```
Magic Shield
```

↓

Chỉ chặn.

Magic Damage.

---

# Immunity

Ví dụ.

Boss.

```
Immune

Freeze
```

BuffSystem.

Kiểm tra.

Trước khi Apply.

---

# Cleanse

Ví dụ.

Heal.

↓

```
Remove Poison
```

↓

```
Remove Burn
```

BuffSystem.

Tự Remove.

---

# Dispel

Khác Cleanse.

Dispel.

↓

Remove.

```
Buff
```

Không Remove.

Debuff.

---

# Exclusive Buff

Ví dụ.

```
Attack Aura A
```

Không thể.

Cùng tồn tại.

Với.

```
Attack Aura B
```

Buff Definition.

Quyết định.

---

# Priority

Ví dụ.

```
Slow

30%
```

```
Slow

60%
```

BuffSystem.

Quyết định.

Buff nào.

Được áp dụng.

---

# Buff Event

Buff.

Không Update UI.

↓

```
BuffAddedEvent
```

↓

UI.

↓

Icon.

---

# Expiration

Khi Buff.

Hết.

↓

```
BuffExpiredEvent
```

↓

Animation.

↓

Sound.

↓

Gameplay.

---

# Save Buff

Khi Save.

Lưu.

```
Buff ID
```

```
Duration
```

```
Stack
```

Không lưu.

Animation.

---

# Debug

Developer Mode.

Hiển thị.

```
Current Buffs
```

```
Duration
```

```
Stack
```

```
Tick Time
```

```
Modifiers
```

---

# Kiến trúc hoàn chỉnh

```text
Skill

↓

BuffSystem

↓

Buff Instance

↓

Modifier

↓

Stat Pipeline

↓

Gameplay
```

Buff.

Không biết.

Combat.

Không biết.

UI.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ BuffSystem

✅ Buff Definition

✅ Buff Instance

✅ Duration

✅ Stack

✅ Modifier Pipeline

✅ DoT

✅ HoT

✅ Aura

✅ Crowd Control

---

# Sai lầm phổ biến

## Sai lầm 1

Buff sửa trực tiếp Attack.

Hãy tạo.

```
Modifier
```

---

## Sai lầm 2

Hard Code từng Buff.

Buff nên được mô tả.

Bằng dữ liệu.

---

## Sai lầm 3

DoT nằm trong Combat.

DoT thuộc.

```
BuffSystem
```

---

## Sai lầm 4

Không hỗ trợ Stack.

Sau này.

Poison.

Burn.

Bleeding.

Sẽ rất khó mở rộng.

---

## Sai lầm 5

Mỗi Buff có một class riêng.

Nếu game có.

```
500 Buff
```

Kiến trúc này sẽ nhanh chóng trở nên khó bảo trì.

Hãy xây dựng theo hướng:

```
Buff Definition

+

Buff Instance

+

Modifier Pipeline
```

---

# Tổng kết

Buff System là nền tảng cho mọi hiệu ứng trạng thái trong game RPG.

Sau chương này:

- **BuffSystem** quản lý toàn bộ vòng đời của Buff và Debuff.
- **Buff Definition** mô tả Buff bằng dữ liệu thay vì mã nguồn.
- **Modifier Pipeline** tính toán chỉ số cuối cùng mà không làm thay đổi Base Stat.
- **Duration**, **Stack** và **Refresh Rule** giúp Buff có hành vi linh hoạt.
- **DoT**, **HoT**, **Aura** và **Crowd Control** đều là các dạng Status Effect được quản lý thống nhất.
- **Cleanse**, **Dispel** và **Immunity** giúp Gameplay dễ mở rộng khi game ngày càng phức tạp.

Với kiến trúc này, bạn có thể tạo hàng trăm hiệu ứng trạng thái chỉ bằng dữ liệu cấu hình và các Effect có sẵn, thay vì phải viết logic riêng cho từng Buff.

---

# Chương tiếp theo

Ở **Chương 26**, chúng ta sẽ xây dựng **AI System**.

Bạn sẽ học cách xây dựng:

- AI Brain.
- State Machine.
- Behavior Tree.
- Decision Making.
- Aggro System.
- Target Selection.
- Patrol.
- Chase.
- Attack Decision.
- Boss AI.

Sau chương này, Monster sẽ có thể tự suy nghĩ, tìm mục tiêu và chiến đấu với Hero như trong các game RPG chuyên nghiệp.