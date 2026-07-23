# Chapter 24 - Skill System - Xây dựng hệ thống kỹ năng chuyên nghiệp

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- Skill System
- Skill Definition
- Active Skill
- Passive Skill
- Skill Pipeline
- Skill Casting
- Cooldown
- Mana Cost
- Buff & Debuff
- Skill Effect Pipeline

Đây là chương giúp game của chúng ta trở nên thú vị.

Nếu Combat chỉ cho phép Hero đánh thường.

Thì Skill sẽ tạo ra hàng trăm kiểu Gameplay khác nhau.

---

# Skill là gì?

Nhiều người nghĩ Skill là.

```
Fireball
```

Hay.

```
Heal
```

Thực tế.

Skill chỉ là.

```
Một tập hợp các Effect
```

Ví dụ.

Fireball.

```
Spawn Projectile

+

Fire Damage

+

Explosion

+

Burn
```

Heal.

```
Restore HP

+

Play Effect

+

Cooldown
```

Skill không phải Animation.

Skill không phải Projectile.

---

# Skill System

Skill thuộc về.

```
SkillSystem
```

Không thuộc.

```
Hero
```

Không thuộc.

```
Combat
```

SkillSystem điều phối toàn bộ.

---

# Skill Flow

Một lần sử dụng Skill.

```text
Input

↓

Cast Request

↓

Validation

↓

Casting

↓

Execute

↓

Skill Effects

↓

Finish
```

Đây là Pipeline chuẩn.

---

# Skill Definition

Skill được mô tả bằng dữ liệu.

Ví dụ.

```
Fireball
```

```
Heal
```

```
Dash
```

```
Meteor
```

Skill không Hard Code.

---

# Skill ID

Mỗi Skill có.

```
Skill ID
```

Ví dụ.

```
fireball_lv1
```

```
heal_lv2
```

```
ice_blast
```

Skill ID được dùng.

Cho.

- Save
- Network
- Analytics
- Upgrade

---

# Active Skill

Active Skill.

Người chơi phải.

```
Nhấn nút
```

Ví dụ.

```
Fireball
```

```
Dash
```

```
Heal
```

---

# Passive Skill

Passive.

Không cần Cast.

Ví dụ.

```
+10% HP
```

```
+5% Critical
```

```
+20 Attack
```

Luôn hoạt động.

---

# Toggle Skill

Một số Skill.

Có thể.

```
ON

↓

OFF
```

Ví dụ.

```
Shield Aura
```

```
Stealth
```

---

# Skill Casting

Cast.

Không phải.

```
Nhấn nút

↓

Có Damage
```

Thông thường.

```
Cast

↓

Animation

↓

Execute
```

---

# Cast Time

Ví dụ.

```
Meteor

Cast Time

2 giây
```

Trong 2 giây.

Có thể.

```
Interrupt
```

---

# Instant Skill

Một số Skill.

```
Cast Time

0
```

Ví dụ.

```
Dash
```

```
Potion
```

Thực thi ngay.

---

# Channel Skill

Ví dụ.

```
Laser

↓

Hold

↓

Continue Damage
```

Skill hoạt động.

Cho đến khi.

```
Release
```

Hoặc.

```
Mana hết
```

---

# Cooldown

Sau khi dùng.

Skill vào.

```
Cooldown
```

Ví dụ.

```
10 giây
```

Trong thời gian này.

Không thể Cast.

---

# Global Cooldown

Một số game.

Có.

```
Global Cooldown
```

Ví dụ.

```
0.5 giây
```

Mọi Skill đều bị khóa.

Trong thời gian này.

---

# Mana Cost

Trước khi Cast.

Skill kiểm tra.

```
Mana

>=

Mana Cost
```

Nếu không đủ.

↓

Cast thất bại.

---

# Energy Cost

Ngoài Mana.

Có thể có.

```
Rage
```

```
Stamina
```

```
Energy
```

SkillSystem.

Không quan tâm.

Đó là loại Resource gì.

---

# Validation

Trước khi Cast.

Skill phải kiểm tra.

```
Cooldown
```

```
Mana
```

```
Dead
```

```
Silence
```

```
Stun
```

```
Target
```

Nếu hợp lệ.

↓

Cast.

---

# Skill Target

Một Skill.

Có thể cần.

```
No Target
```

```
Enemy
```

```
Ally
```

```
Ground
```

```
Self
```

Skill Definition.

Quyết định.

---

# Skill Range

Ví dụ.

```
Range

600
```

Nếu Target.

Ngoài Range.

↓

Cast thất bại.

---

# Area Skill

Ví dụ.

```
Explosion

Radius

300
```

↓

Damage.

Toàn bộ Monster.

Trong vùng.

---

# Projectile Skill

Ví dụ.

```
Fireball

↓

Projectile

↓

Collision

↓

Explosion
```

Skill.

Không tự bay.

ProjectileSystem.

Xử lý.

---

# Buff

Skill.

Có thể tạo.

```
Attack Up
```

```
Defense Up
```

```
Shield
```

Buff là Effect.

Không phải Skill.

---

# Debuff

Ví dụ.

```
Burn
```

```
Freeze
```

```
Poison
```

```
Slow
```

Skill.

Chỉ thêm Debuff.

BuffSystem.

Quản lý.

---

# Stack

Một Buff.

Có thể.

```
Stack

5
```

Ví dụ.

```
Poison

1

↓

2

↓

3
```

Skill.

Không xử lý.

Stack.

---

# Duration

Buff.

Có.

```
10 giây
```

Debuff.

Có.

```
5 giây
```

BuffSystem.

Tự giảm.

Thời gian.

---

# Skill Effect

Đây là ý tưởng quan trọng nhất.

Một Skill.

Không làm gì.

Nó chỉ chứa.

```
Effects
```

Ví dụ.

Fireball.

```
Damage

↓

Burn

↓

Explosion

↓

Camera Shake
```

---

# Skill Effect Pipeline

```text
Skill

↓

Skill Effects

↓

Combat

↓

Movement

↓

Buff

↓

Event
```

Skill.

Không biết.

Combat.

---

# Multi Effect

Ví dụ.

```
Heal

+

Remove Poison

+

Shield

+

Play Animation
```

Một Skill.

Có nhiều Effect.

---

# Skill Chain

Ví dụ.

```
Meteor

↓

Explosion

↓

Spawn Fire

↓

Burn

↓

Knockback
```

Skill.

Có thể.

Gọi.

Nhiều Effect.

---

# Interrupt

Nếu.

```
Stun
```

Trong lúc Cast.

↓

Cast bị hủy.

Skill.

Không Execute.

---

# Skill Queue

Nếu.

Player.

Spam Skill.

↓

```
Queue
```

↓

Skill tiếp theo.

Tự Cast.

Sau khi.

Skill hiện tại.

Kết thúc.

---

# Skill Animation

Skill.

Không Play Animation.

Skill phát.

```
CastEvent
```

AnimationSystem.

Xử lý.

---

# Audio

Skill.

Không phát Sound.

↓

```
SkillCastEvent
```

↓

AudioSystem.

---

# Camera

Skill.

Không Shake Camera.

↓

```
UltimateSkillEvent
```

↓

CameraSystem.

---

# UI

Skill.

Không Update Icon.

↓

```
CooldownChangedEvent
```

↓

UI.

---

# Skill Upgrade

Ví dụ.

```
Fireball

Lv1

↓

Lv2

↓

Lv3
```

Skill Definition.

Chỉ thay đổi.

```
Damage
```

```
Cooldown
```

```
Mana
```

Không cần.

Skill mới.

---

# Skill Tree

Sau này.

SkillSystem.

Sẽ kết nối.

```
Skill Tree
```

↓

Unlock.

↓

Upgrade.

↓

Passive.

---

# Debug

Developer Mode.

Hiển thị.

```
Current Skill
```

```
Cooldown
```

```
Mana Cost
```

```
Cast Time
```

```
Current State
```

Giúp Debug.

Rất dễ.

---

# Kiến trúc hoàn chỉnh

```text
Input

↓

SkillSystem

↓

Validation

↓

Casting

↓

Skill Effects

↓

Combat

↓

Movement

↓

Buff

↓

Events
```

Skill.

Không biết.

Animation.

Không biết.

UI.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ SkillSystem

✅ Skill Definition

✅ Active Skill

✅ Passive Skill

✅ Cast Time

✅ Cooldown

✅ Mana Cost

✅ Skill Effects

✅ Skill Queue

✅ Skill Upgrade

---

# Sai lầm phổ biến

## Sai lầm 1

Hard Code từng Skill.

Hãy mô tả Skill bằng dữ liệu.

---

## Sai lầm 2

Skill tự gây Damage.

Skill chỉ tạo.

```
Damage Effect
```

CombatSystem xử lý.

---

## Sai lầm 3

Skill tự Play Animation.

Animation luôn do.

AnimationSystem.

---

## Sai lầm 4

Buff nằm trong Skill.

Buff nên được quản lý.

Bởi.

```
BuffSystem
```

---

## Sai lầm 5

Mỗi Skill có một class riêng.

Khi game có.

```
300 Skill
```

Kiến trúc này sẽ rất khó mở rộng.

Hãy xây dựng theo hướng:

```
Skill Definition

+

Skill Effect

+

Skill Pipeline
```

---

# Tổng kết

Skill System là trái tim của mọi game RPG hiện đại.

Sau chương này:

- **SkillSystem** điều phối toàn bộ việc sử dụng kỹ năng.
- **Skill Definition** mô tả kỹ năng bằng dữ liệu thay vì Hard Code.
- **Cast Time**, **Cooldown** và **Mana Cost** tạo nên vòng đời của Skill.
- **Skill Effect Pipeline** giúp một Skill có thể kết hợp nhiều hiệu ứng khác nhau.
- **Buff**, **Debuff**, **Projectile** và **Combat** đều là các System độc lập mà Skill có thể kích hoạt thông qua Event và Effect.

Kiến trúc này cho phép bạn tạo hàng trăm hoặc hàng nghìn Skill chỉ bằng cách cấu hình dữ liệu, thay vì phải viết một class mới cho mỗi kỹ năng.

---

# Chương tiếp theo

Ở **Chương 25**, chúng ta sẽ xây dựng **Buff & Status Effect System**.

Bạn sẽ học cách xây dựng:

- Buff System.
- Status Effect.
- Modifier Pipeline.
- Stack Rule.
- Duration.
- Aura.
- Damage Over Time (DoT).
- Heal Over Time (HoT).
- Crowd Control (CC).
- Buff Serialization.

Sau chương này, Hero và Monster sẽ có thể nhận Buff, Debuff và mọi hiệu ứng trạng thái giống như trong các game RPG chuyên nghiệp.