# Chapter 8 - Combat System - Xây dựng hệ thống chiến đấu

# Mục tiêu

Sau chương này bạn sẽ hiểu:

- Combat System là gì
- Luồng chiến đấu diễn ra như thế nào
- Hero và Monster tấn công ra sao
- Damage được tính như thế nào
- Shield hoạt động như thế nào
- Heal hoạt động như thế nào
- Khi nào Entity chết
- Kiến trúc Combat System của dự án

Đây là chương đánh dấu thời điểm game bắt đầu "sống".

Sau chương này, Hero và Monster sẽ có thể chiến đấu với nhau hoàn toàn tự động.

---

# Combat System là gì?

Combat System là trái tim của gameplay.

Nó chịu trách nhiệm:

- Hero tấn công
- Monster tấn công
- Dùng Skill
- Heal
- Shield
- Buff
- Debuff
- Critical
- Death
- Victory

Theo tài liệu thiết kế của dự án, Combat Flow sẽ diễn ra theo trình tự sau. :contentReference[oaicite:0]{index=0}

```text
Battle Start

↓

Every Tick

↓

Update AI

↓

Update Cooldown

↓

Use Skills

↓

Calculate Damage

↓

Apply Shield

↓

Apply HP

↓

Death Check

↓

Victory Check

↓

Next Tick
```

Đây sẽ là nền tảng cho toàn bộ gameplay.

---

# Vì sao cần Combat System riêng?

Một sai lầm rất phổ biến.

```dart
HeroComponent.attack();
```

Hoặc.

```dart
MonsterComponent.attack();
```

Thoạt nhìn có vẻ hợp lý.

Nhưng sau này sẽ phát sinh rất nhiều vấn đề.

Ví dụ.

Damage cần biết:

- Buff
- Debuff
- Shield
- Critical
- Dodge
- Equipment
- Passive
- Aura

Nếu HeroComponent tự tính Damage.

MonsterComponent cũng tự tính Damage.

Code sẽ bị lặp rất nhiều.

---

Trong series này.

Mọi tính toán đều đi qua.

```
BattleSystem
```

```text
Hero

↓

BattleSystem

↓

Monster
```

Nhờ vậy.

Toàn bộ luật chơi chỉ nằm ở một nơi.

---

# Luồng chiến đấu

Hãy tưởng tượng.

Game có.

```
Tank

Archer

Mage

Healer

↓

VS

↓

5 Monster
```

Mỗi frame.

BattleSystem sẽ cập nhật.

```text
Update AI

↓

Update Skill Cooldown

↓

Kiểm tra Skill

↓

Tính Damage

↓

Áp dụng Shield

↓

Trừ HP

↓

Kiểm tra chết

↓

Kiểm tra thắng
```

Sau đó.

Frame tiếp theo bắt đầu.

---

# Battle Tick

Combat không xảy ra cùng một lúc.

Mọi hành động đều diễn ra theo từng Tick.

Ví dụ.

```
Frame 1

↓

Monster A đánh
```

```
Frame 2

↓

Tank phản công
```

```
Frame 3

↓

Healer hồi máu
```

```
Frame 4

↓

Mage dùng Meteor
```

Game liên tục lặp lại quá trình này.

---

# AI quyết định hành động

Combat không tự chọn mục tiêu.

AISystem sẽ quyết định.

Ví dụ.

```
Monster

↓

Target

↓

Tank
```

Hoặc.

```
Boss

↓

Lowest HP
```

Sau đó.

BattleSystem chỉ thực hiện lệnh.

---

# Cooldown

Mỗi Skill đều có Cooldown.

Ví dụ.

```
Heal

5 giây
```

Mỗi frame.

```text
Cooldown

↓

Cooldown - dt
```

Khi.

```
Cooldown <= 0
```

Skill sẵn sàng.

Theo thiết kế Skill Lifecycle của dự án. :contentReference[oaicite:1]{index=1}

```text
Ready

↓

Cast

↓

Animation

↓

Effect

↓

Cooldown

↓

Ready
```

Combat System sẽ điều khiển toàn bộ vòng đời này.

---

# Damage Formula

Phiên bản đầu tiên của game sẽ sử dụng công thức đơn giản.

Theo tài liệu thiết kế. :contentReference[oaicite:2]{index=2}

```text
Final Damage

=

Attack

-

Defense

Minimum Damage = 1
```

Ví dụ.

```
Attack

120
```

```
Defense

40
```

Damage.

```
80
```

Nếu.

```
Attack

10
```

```
Defense

30
```

Damage vẫn bằng.

```
1
```

Để tránh việc một nhân vật hoàn toàn không thể gây sát thương.

---

# Damage chưa phải cuối cùng

Trong tương lai.

Combat sẽ mở rộng.

```text
Attack

↓

Critical

↓

Buff

↓

Defense

↓

Shield

↓

Damage Reduction

↓

HP
```

Đó là lý do Damage Formula nên nằm trong BattleSystem.

Không nên đặt trong Hero.

---

# Shield

Theo thiết kế.

Shield luôn hấp thụ Damage trước HP. :contentReference[oaicite:3]{index=3}

```text
Damage

↓

Shield

↓

Remaining Damage

↓

HP
```

Ví dụ.

Hero có.

```
Shield

50
```

Monster gây.

```
Damage

30
```

Kết quả.

```
Shield

20
```

```
HP

Không đổi
```

---

Nếu.

```
Shield

20
```

```
Damage

70
```

Kết quả.

```
Shield

0
```

```
HP

-50
```

Điều này giúp Shield hoạt động tự nhiên hơn.

---

# Heal

Heal ngược lại với Damage.

Ví dụ.

```
Current HP

250
```

```
Heal

100
```

Kết quả.

```
350
```

Nhưng.

HP không được vượt.

```
Max HP
```

Ví dụ.

```
Max HP

400
```

```
Current HP

380
```

```
Heal

100
```

Kết quả.

```
400
```

Không phải.

```
480
```

---

# Death Check

Sau khi Damage được áp dụng.

BattleSystem kiểm tra.

```
HP <= 0 ?
```

Nếu đúng.

```
Dead
```

HeroComponent.

```
↓

Death Animation
```

Animation kết thúc.

```
↓

Remove Component
```

Model vẫn có thể được giữ lại để tính thống kê sau trận đấu.

---

# Victory Check

Sau mỗi lần có Entity chết.

BattleSystem kiểm tra.

Theo thiết kế gameplay ban đầu. :contentReference[oaicite:4]{index=4}

Người chơi chiến thắng khi:

- Toàn bộ Monster bị tiêu diệt.

Người chơi thất bại khi:

- Tank chết.
- Archer chết.
- Mage chết.

Healer không ảnh hưởng đến điều kiện thất bại.

---

# Combat System không biết Animation

Một nguyên tắc rất quan trọng.

BattleSystem.

Không biết.

```
Sprite

Animation

Particle
```

Nó chỉ biết.

```
Monster A

↓

Take Damage

50
```

HeroComponent sẽ tự phát.

```
Hit Animation
```

Điều này giúp Gameplay và Rendering hoàn toàn tách biệt.

---

# Combat Event

BattleSystem không nên gọi trực tiếp Component.

Thay vào đó.

Nó phát ra Event.

Ví dụ.

```text
MonsterHitEvent

↓

MonsterComponent

↓

Play Hit Animation
```

Hoặc.

```text
HeroDeadEvent

↓

HeroComponent

↓

Play Death Animation
```

Kiến trúc Event giúp các hệ thống ít phụ thuộc vào nhau hơn.

---

# Kiến trúc Combat hoàn chỉnh

Sau chương này.

Combat sẽ hoạt động như sau.

```text
BattleSystem

↓

AISystem

↓

SkillSystem

↓

Damage Calculator

↓

Shield

↓

HP

↓

Death

↓

Event

↓

Component
```

Mỗi phần chỉ làm đúng một nhiệm vụ.

---

# Sai lầm phổ biến

## Sai lầm 1

Hero tự gây Damage.

```dart
hero.attack(monster);
```

Combat Rule sẽ bị phân tán.

---

## Sai lầm 2

Monster tự trừ HP.

```dart
monster.hp -= damage;
```

BattleSystem mới nên là nơi duy nhất thay đổi HP.

---

## Sai lầm 3

Damage Formula nằm trong nhiều class.

Ví dụ.

```
Hero

↓

Damage
```

```
Monster

↓

Damage
```

```
Skill

↓

Damage
```

Hãy gom toàn bộ công thức vào BattleSystem hoặc DamageCalculator.

---

## Sai lầm 4

BattleSystem gọi Animation.

Ví dụ.

```dart
playHitAnimation();
```

Gameplay không nên biết Render.

---

# Tổng kết

Combat System là nơi thực thi toàn bộ luật chơi.

Trong phiên bản đầu tiên, Combat sẽ hoạt động theo luồng:

```text
AI

↓

Cooldown

↓

Skill

↓

Damage

↓

Shield

↓

HP

↓

Death

↓

Victory
```

Tất cả phép tính đều đi qua BattleSystem.

Hero và Monster chỉ là dữ liệu.

Component chỉ hiển thị kết quả.

Kiến trúc này giúp chúng ta dễ dàng bổ sung Critical, Buff, Debuff, Element, Combo và hàng trăm Skill mới mà không cần thay đổi cách Combat hoạt động.

---

# Chương tiếp theo

Ở chương 9, chúng ta sẽ xây dựng **Skill System**.

Bạn sẽ học:

- Thiết kế Active Skill và Passive Skill.
- Skill Lifecycle.
- Target Selection.
- Cooldown.
- Mana Cost.
- Cách Infinite Skill hoạt động sau mỗi tầng và ảnh hưởng đến Combat System.