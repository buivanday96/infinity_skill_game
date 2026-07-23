# Chapter 29 - Quest System - Xây dựng hệ thống Quest chuyên nghiệp

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- Quest System
- Quest Definition
- Quest Instance
- Quest Objective
- Quest State Machine
- Event Driven Quest
- Quest Trigger
- Daily Quest
- Achievement
- Reward Pipeline

Quest là một trong những Gameplay System quan trọng nhất của game RPG.

Nó không chỉ hướng dẫn người chơi.

Mà còn kết nối gần như toàn bộ Gameplay.

- Combat
- Inventory
- NPC
- Map
- Dialogue
- Achievement
- Daily Quest

---

# Quest là gì?

Rất nhiều người nghĩ.

Quest là.

```
Kill 10 Slime
```

Thực tế.

Quest là.

```
Một State Machine

+

Một tập hợp Objective

+

Reward
```

Quest không phải.

Một đoạn Script.

---

# Quest System

Quest không thuộc.

```
NPC
```

Không thuộc.

```
Combat
```

Không thuộc.

```
Inventory
```

Quest được quản lý.

Bởi.

```
QuestSystem
```

---

# Quest Flow

```text
Player Action

↓

Gameplay Event

↓

QuestSystem

↓

Quest Progress

↓

Quest Complete

↓

Reward
```

Quest.

Không theo dõi Gameplay.

Gameplay phát Event.

---

# Quest Definition

Quest được mô tả.

Bằng dữ liệu.

Ví dụ.

```
Main Story 001
```

```
Daily Kill Monster
```

```
Collect Herbs
```

Definition.

Không thay đổi.

---

# Quest Instance

Khi người chơi.

Nhận Quest.

↓

Sinh ra.

```
Quest Instance
```

Mỗi Player.

Có Progress riêng.

---

# Quest ID

Mỗi Quest.

Có.

```
Quest ID
```

Ví dụ.

```
main_001
```

```
daily_kill_slime
```

```
achievement_first_blood
```

Không dùng.

Tên hiển thị.

Làm ID.

---

# Quest State

Một Quest.

Có nhiều trạng thái.

```text
Locked

↓

Available

↓

Accepted

↓

Completed

↓

Rewarded
```

Đây là.

Quest State Machine.

---

# Locked

Quest.

Chưa thể nhận.

Ví dụ.

Chưa hoàn thành.

Main Quest trước.

---

# Available

Quest.

Có thể nhận.

Ví dụ.

Nói chuyện.

Với NPC.

---

# Accepted

Quest.

Đã bắt đầu.

Gameplay.

Bắt đầu.

Theo dõi Progress.

---

# Completed

Objective.

Đã hoàn thành.

Nhưng.

Chưa nhận thưởng.

---

# Rewarded

Player.

Đã nhận thưởng.

Quest.

Kết thúc.

---

# Quest Objective

Một Quest.

Có thể có.

```
1

Hoặc

Nhiều Objective
```

Ví dụ.

```
Kill 10 Slime
```

```
Collect 5 Flower
```

```
Talk To NPC
```

---

# Objective Type

Ví dụ.

```
Kill Enemy
```

```
Collect Item
```

```
Visit Location
```

```
Talk NPC
```

```
Craft Item
```

```
Reach Level
```

```
Use Skill
```

Tất cả.

Được mô tả.

Bằng dữ liệu.

---

# Multiple Objective

Ví dụ.

```
Kill 10 Slime

+

Collect 5 Flower

+

Return NPC
```

Quest.

Hoàn thành.

Khi.

Mọi Objective.

Đều Complete.

---

# Optional Objective

Ví dụ.

```
Find Hidden Chest
```

Không bắt buộc.

Nhưng.

Có thêm Reward.

---

# Event Driven Quest

Đây là ý tưởng.

Quan trọng nhất.

Quest.

Không Polling.

Không Update.

60 FPS.

Quest.

Chỉ lắng nghe.

Event.

---

# Gameplay Event

Ví dụ.

```
MonsterKilledEvent
```

↓

QuestSystem.

↓

Update Progress.

---

# Inventory Event

Ví dụ.

```
ItemCollectedEvent
```

↓

Quest.

↓

Collect Objective.

---

# NPC Event

Ví dụ.

```
TalkNpcEvent
```

↓

Quest.

↓

Complete Objective.

---

# Location Event

Ví dụ.

```
EnterAreaEvent
```

↓

Quest.

↓

Update.

---

# Progress

Ví dụ.

```
Kill

3 / 10
```

Progress.

Luôn thuộc.

Quest Instance.

---

# Auto Complete

Một số Quest.

Khi đủ điều kiện.

↓

Complete.

Ngay.

---

# Manual Complete

Một số Quest.

Yêu cầu.

Quay lại.

NPC.

↓

Nhận thưởng.

---

# Reward

Reward.

Không chỉ có.

```
Gold
```

Có thể là.

```
EXP
```

```
Item
```

```
Skill
```

```
Unlock Map
```

```
Unlock NPC
```

Quest.

Không tự.

Add Reward.

---

# Reward Pipeline

```text
Quest Complete

↓

RewardSystem

↓

Inventory

↓

Experience

↓

Unlock
```

---

# Main Quest

Main Quest.

Có thứ tự.

```text
Quest 1

↓

Quest 2

↓

Quest 3
```

---

# Side Quest

Side Quest.

Hoàn toàn.

Độc lập.

Không ảnh hưởng.

Main Story.

---

# Daily Quest

Daily Quest.

Được Reset.

Mỗi ngày.

Ví dụ.

```
Kill 20 Monster
```

↓

Reset.

08:00.

---

# Weekly Quest

Ví dụ.

```
Complete 30 Dungeon
```

↓

Reset.

Mỗi tuần.

---

# Achievement

Achievement.

Thực chất.

Là một Quest.

Không cần.

Accept.

Ví dụ.

```
Kill 1000 Monster
```

↓

Unlock.

Achievement.

---

# Hidden Quest

Một số Quest.

Không hiển thị.

Cho đến khi.

Player.

Đạt điều kiện.

---

# Quest Chain

Ví dụ.

```text
Find Sword

↓

Kill Boss

↓

Return King

↓

Unlock New Chapter
```

---

# Quest Dependency

Quest.

Có thể.

Phụ thuộc.

Quest khác.

Ví dụ.

```
Main 003
```

↓

Yêu cầu.

```
Main 002
```

---

# Quest Trigger

Quest.

Có thể bắt đầu.

Bằng.

```
NPC
```

Hoặc.

```
Area
```

Hoặc.

```
Item
```

Hoặc.

```
Cutscene
```

---

# Quest Fail

Một số Quest.

Có thể.

Fail.

Ví dụ.

```
Protect NPC
```

↓

NPC chết.

↓

Quest Failed.

---

# Quest Retry

Sau khi Fail.

Có thể.

```
Retry
```

Hoặc.

```
Restart
```

---

# Quest Serialization

Save.

```
Quest ID
```

```
State
```

```
Progress
```

```
Completed Time
```

Không lưu.

UI.

---

# Multiplayer

Quest.

Không nên.

Lưu.

Trong NPC.

Quest.

Luôn thuộc.

Player.

---

# UI

Quest.

Không Update UI.

↓

```
QuestUpdatedEvent
```

↓

Quest UI.

---

# Notification

Quest.

Complete.

↓

```
QuestCompletedEvent
```

↓

Popup.

↓

Sound.

↓

Animation.

---

# Debug

Developer Mode.

Hiển thị.

```
Quest ID
```

```
Current State
```

```
Progress
```

```
Objective
```

```
Reward
```

Giúp Debug.

Rất dễ.

---

# Kiến trúc hoàn chỉnh

```text
Gameplay Event

↓

QuestSystem

↓

Quest Instance

↓

Quest Objective

↓

RewardSystem

↓

Inventory

↓

UI
```

Quest.

Không biết.

Combat.

Không biết.

NPC.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ QuestSystem

✅ Quest Definition

✅ Quest Instance

✅ Quest State Machine

✅ Objective

✅ Event Driven Quest

✅ Reward Pipeline

✅ Daily Quest

✅ Achievement

✅ Serialization

---

# Sai lầm phổ biến

## Sai lầm 1

Quest.

Kiểm tra.

Gameplay.

Mỗi Frame.

Quest.

Chỉ nên.

Nghe Event.

---

## Sai lầm 2

NPC.

Lưu Progress.

Quest.

Luôn thuộc.

Player.

---

## Sai lầm 3

Hard Code.

Quest.

Trong Code.

Hãy.

Dùng.

```
Quest Definition
```

---

## Sai lầm 4

Reward.

Được Add.

Trong Quest.

Quest.

Chỉ phát.

```
QuestCompletedEvent
```

RewardSystem.

Xử lý.

---

## Sai lầm 5

Achievement.

Là System riêng.

Achievement.

Thực chất.

Là.

Một loại.

Quest.

Không cần Accept.

---

# Tổng kết

Quest System là trung tâm điều phối tiến trình của người chơi trong game.

Sau chương này:

- **Quest Definition** mô tả nhiệm vụ bằng dữ liệu.
- **Quest Instance** lưu trạng thái và tiến độ của từng người chơi.
- **Quest State Machine** quản lý toàn bộ vòng đời của Quest.
- **Objective** giúp xây dựng những nhiệm vụ phức tạp với nhiều điều kiện.
- **Event Driven Quest** giúp Quest hoạt động hiệu quả mà không cần kiểm tra liên tục.
- **Reward Pipeline** tách riêng việc trao thưởng khỏi Quest.
- **Daily Quest**, **Achievement** và **Main Quest** đều có thể dùng chung một kiến trúc.

Nhờ thiết kế này, bạn có thể xây dựng hàng nghìn nhiệm vụ chỉ bằng dữ liệu cấu hình, đồng thời dễ dàng mở rộng thêm Seasonal Quest, Guild Quest hoặc Event Quest trong tương lai.

---

# Chương tiếp theo

Ở **Chương 30**, chúng ta sẽ xây dựng **Dialogue & NPC System**.

Bạn sẽ học cách xây dựng:

- NPC System.
- Dialogue Tree.
- Dialogue Choice.
- Dialogue Condition.
- Quest Integration.
- Shop NPC.
- Merchant.
- Cutscene Trigger.
- Localization.
- Dialogue Serialization.

Sau chương này, NPC sẽ có thể trò chuyện, giao nhiệm vụ, mở Shop, kích hoạt Cutscene và phản ứng theo tiến trình của người chơi giống như trong các game RPG chuyên nghiệp.