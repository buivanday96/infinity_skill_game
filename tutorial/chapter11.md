# Chapter 11 - Dungeon System - Xây dựng Dungeon vô hạn (Infinite Dungeon)

# Mục tiêu

Sau chương này bạn sẽ hiểu:

- Dungeon System là gì
- Floor hoạt động như thế nào
- Sinh Monster theo từng tầng
- Difficulty Scaling
- Elite và Boss
- Reward System
- Infinite Dungeon
- Kiến trúc Dungeon của dự án

Đây là chương bắt đầu xây dựng gameplay cốt lõi của game.

Toàn bộ vòng lặp chơi (Gameplay Loop) sẽ xoay quanh Dungeon.

```
Battle

↓

Reward

↓

Upgrade

↓

Next Floor

↓

Battle
```

Người chơi sẽ lặp lại chu trình này hàng nghìn lần.

Do đó Dungeon System phải đơn giản nhưng cực kỳ linh hoạt.

---

# Dungeon là gì?

Dungeon là nơi diễn ra toàn bộ trận chiến.

Ví dụ.

```
Floor 1

↓

Battle

↓

Floor 2

↓

Battle

↓

Floor 3
```

Dungeon không phải là bản đồ.

Dungeon là toàn bộ tiến trình của một lượt chơi.

---

# Gameplay Loop

Gameplay của dự án cực kỳ đơn giản.

```
Enter Floor

↓

Spawn Monster

↓

Battle

↓

Victory

↓

Choose Skill

↓

Next Floor
```

Đây là gameplay loop chính.

Người chơi sẽ lặp lại liên tục.

---

# Dungeon Manager

Chúng ta sẽ có một hệ thống riêng.

```
DungeonSystem
```

Nó chịu trách nhiệm.

- Floor hiện tại
- Sinh Monster
- Sinh Boss
- Difficulty
- Reward
- Next Floor

DungeonSystem không quan tâm.

- Animation
- Combat
- UI

---

# Floor

Dungeon gồm nhiều Floor.

Ví dụ.

```
Floor 1

↓

Floor 2

↓

Floor 3

↓

...

↓

Floor 99999
```

Không có giới hạn.

---

# Một Floor gồm gì?

Một Floor chỉ cần vài thông tin.

```
Floor

├── Index

├── Monster Group

├── Reward

├── Environment

└── Boss?
```

Ví dụ.

```
Floor 15

↓

Monster

↓

Skeleton

Skeleton

Mage

Elite
```

---

# Flow của một Floor

Khi bắt đầu.

```
Generate Floor

↓

Spawn Hero

↓

Spawn Monster

↓

Battle

↓

Victory

↓

Reward

↓

Next Floor
```

Đây là toàn bộ vòng đời.

---

# Monster Group

Dungeon không sinh từng Monster riêng lẻ.

Thay vào đó.

Sinh theo nhóm.

Ví dụ.

```
Wave

↓

Goblin

Goblin

Goblin

Wolf
```

Hoặc.

```
Skeleton

Skeleton

Skeleton Archer

Elite
```

Điều này giúp cân bằng game dễ hơn.

---

# Difficulty Scaling

Monster không nên mạnh lên bằng cách.

```
Attack += 100
```

Thay vào đó.

Dungeon sẽ có.

```
Difficulty

↓

Multiplier
```

Ví dụ.

```
Floor

1

↓

x1.0
```

```
Floor

20

↓

x2.5
```

```
Floor

100

↓

x15
```

Sau đó.

StatSystem tự tính.

```
Base Attack

↓

Difficulty

↓

Final Attack
```

---

# Elite Monster

Một số Floor sẽ xuất hiện Elite.

Ví dụ.

```
Floor 5

↓

Elite
```

Elite không cần AI riêng.

Chỉ khác.

- HP nhiều hơn
- Damage cao hơn
- Skill nhiều hơn

Kiến trúc hoàn toàn giống Monster.

---

# Boss Floor

Ví dụ.

```
Floor 10

↓

Boss
```

```
Floor 20

↓

Boss
```

```
Floor 30

↓

Boss
```

Boss chỉ thay đổi.

- Pattern
- Skill
- Reward

DungeonSystem chỉ cần biết.

```
Boss Floor?
```

Nếu đúng.

Sinh Boss.

---

# Reward

Sau khi chiến thắng.

DungeonSystem tạo Reward.

Ví dụ.

```
Gold

EXP

Equipment

Skill Choice
```

Reward không được BattleSystem tạo.

Battle chỉ báo.

```
Victory
```

Dungeon xử lý phần còn lại.

---

# Skill Selection

Đây là điểm đặc biệt của game.

Sau mỗi tầng.

Người chơi chọn.

```
1 trong 3 Skill
```

Ví dụ.

```
+20% Heal
```

```
+15% Archer Attack
```

```
Critical Heal
```

Sau khi chọn.

Skill sẽ được thêm vào Hero.

Dungeon tiếp tục.

---

# Infinite Dungeon

Một sai lầm phổ biến.

```
Generate

10000 Floor
```

Điều này tốn rất nhiều RAM.

Thay vào đó.

Chỉ tạo.

```
Current Floor
```

Ví dụ.

```
Floor 100
```

Sau khi hoàn thành.

```
Delete Floor 100

↓

Generate Floor 101
```

Bộ nhớ luôn gần như không đổi.

---

# Seed Generation

Dungeon nên sử dụng Seed.

Ví dụ.

```
Seed

123456
```

Floor.

```
100
```

Luôn sinh.

```
Skeleton

Mage

Elite
```

Nhờ vậy.

Có thể.

- Replay
- Debug
- Share Dungeon

---

# Environment

Floor không chỉ khác Monster.

Có thể thay đổi.

```
Forest

↓

Desert

↓

Ice

↓

Volcano
```

Environment chỉ thay đổi.

- Background
- Effect
- Music

Combat không đổi.

---

# Progression

Độ khó không nên tăng tuyến tính.

Ví dụ.

Sai.

```
Floor

1

Attack

100
```

```
Floor

2

Attack

101
```

Đúng.

```
Early

Tăng nhanh
```

```
Mid

Ổn định
```

```
Late

Tăng theo cấp số nhân
```

Điều này khiến game luôn có thử thách.

---

# Dungeon Event

Sau này.

Dungeon có thể thêm.

```
Treasure Room
```

```
Shop
```

```
Healing Fountain
```

```
Mini Boss
```

```
Random Event
```

Tất cả đều chỉ là.

```
Floor Type
```

Không cần sửa Combat.

---

# Dungeon System hoàn chỉnh

Sau chương này.

Kiến trúc sẽ là.

```text
DungeonSystem

↓

Generate Floor

↓

Spawn Monster

↓

BattleSystem

↓

Victory

↓

Reward

↓

Skill Selection

↓

Next Floor
```

Dungeon chỉ điều phối.

Không xử lý Gameplay.

---

# Chuẩn bị cho Save/Load

Dungeon nên lưu rất ít dữ liệu.

Ví dụ.

```
Current Floor

Current Seed

Hero Data

Inventory

Skill

Gold
```

Khi Load.

Dungeon chỉ cần.

```
Generate Floor(Current Floor)
```

Không cần lưu toàn bộ Map.

Đây là cách rất nhiều game Roguelike hoạt động.

---

# Sai lầm phổ biến

## Sai lầm 1

Lưu toàn bộ Dungeon.

Ví dụ.

```
Floor

1

↓

99999
```

Rất tốn bộ nhớ.

Chỉ lưu Floor hiện tại.

---

## Sai lầm 2

Dungeon xử lý Combat.

Sai.

Combat thuộc BattleSystem.

---

## Sai lầm 3

Boss có Dungeon riêng.

Boss cũng chỉ là.

```
Monster

+

Boss Pattern
```

---

## Sai lầm 4

Difficulty sửa trực tiếp Stat.

Đừng.

```
Attack += 500
```

Hãy dùng.

```
Difficulty Multiplier
```

StatSystem sẽ tính.

---

# Tổng kết

Dungeon System là hệ thống điều phối toàn bộ gameplay loop.

Trong dự án này, Dungeon sẽ chịu trách nhiệm:

- Sinh Floor.
- Sinh Monster.
- Quyết định Boss.
- Tăng độ khó.
- Phát Reward.
- Chuyển sang Floor tiếp theo.

Điểm quan trọng nhất là:

- **BattleSystem** chỉ xử lý chiến đấu.
- **DungeonSystem** chỉ xử lý tiến trình của cuộc phiêu lưu.
- **StatSystem** tính toán chỉ số.
- **SkillSystem** quản lý kỹ năng.

Việc tách các hệ thống như vậy giúp game có thể mở rộng lên hàng chục nghìn Floor mà không làm kiến trúc trở nên phức tạp.

---

# Chương tiếp theo

Ở chương 12, chúng ta sẽ xây dựng **Event System**.

Bạn sẽ học:

- Event Bus là gì.
- Vì sao các System không nên gọi trực tiếp lẫn nhau.
- Publish / Subscribe.
- Battle Event.
- UI Event.
- Sound Event.
- Achievement Event.

Sau chương này, toàn bộ các System trong game sẽ được kết nối với nhau nhưng vẫn giữ mức độ phụ thuộc (coupling) rất thấp.