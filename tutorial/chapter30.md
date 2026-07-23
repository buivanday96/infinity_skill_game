# Chapter 30 - Dialogue & NPC System - Xây dựng hệ thống NPC chuyên nghiệp

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- NPC System
- Dialogue System
- Dialogue Tree
- Dialogue Choice
- Dialogue Condition
- Dialogue Event
- Quest Integration
- Merchant NPC
- Cutscene Trigger
- Dialogue Serialization

Đây là chương giúp thế giới trong game trở nên sống động.

Sau chương này.

NPC sẽ có thể:

- Nói chuyện
- Giao Quest
- Bán đồ
- Đổi đồ
- Phản ứng theo Story
- Kích hoạt Cutscene
- Thay đổi lời thoại theo Progress

---

# NPC là gì?

Rất nhiều người nghĩ.

NPC chỉ là.

```
Sprite

+

Dialogue
```

Thực tế.

NPC là.

```
Entity

+

AI

+

Dialogue

+

Interaction
```

NPC cũng là một Entity.

Giống Hero.

---

# NPC System

NPC không thuộc.

```
Dialogue
```

Dialogue cũng không thuộc.

```
Quest
```

Mọi thứ được quản lý.

Bởi.

```
NPCSystem
```

---

# NPC Flow

```text
Player

↓

Interact

↓

NPCSystem

↓

Dialogue

↓

Choice

↓

Event

↓

Gameplay
```

---

# NPC Entity

NPC có.

```
Transform
```

```
Animation
```

```
Dialogue
```

```
Interaction
```

```
Quest
```

Không có.

```
Combat
```

Nếu không cần.

---

# Interaction

Player.

Không thể.

Nói chuyện.

Từ mọi nơi.

NPC có.

```
Interaction Radius
```

Ví dụ.

```
150 px
```

Nếu Hero.

Trong vùng.

↓

Hiện.

```
Press E
```

---

# Dialogue System

Dialogue.

Không viết.

Trong Code.

Dialogue.

Là dữ liệu.

---

# Dialogue Definition

Ví dụ.

```
npc_blacksmith_intro
```

↓

```
Xin chào!

Tôi có thể giúp gì?
```

Definition.

Không thay đổi.

---

# Dialogue Instance

Nếu Dialogue.

Có lựa chọn.

↓

Player.

Có Progress riêng.

---

# Dialogue Tree

Dialogue.

Không phải.

Một đoạn Text.

Mà là.

```
Node

↓

Node

↓

Node
```

Giống.

Behavior Tree.

---

# Dialogue Node

Một Node.

Có.

```
Text
```

```
Choices
```

```
Events
```

```
Conditions
```

---

# Dialogue Choice

Ví dụ.

```
Xin chào

↓

1. Nhận Quest

2. Mua đồ

3. Tạm biệt
```

Player.

Chọn.

↓

Node tiếp theo.

---

# Branching

Dialogue.

Có thể.

Phân nhánh.

```text
Hello

├── Shop

├── Quest

└── Goodbye
```

---

# Dialogue Condition

Một Node.

Có thể yêu cầu.

```
Quest Complete
```

```
Level >=10
```

```
Has Item
```

Nếu không.

↓

Ẩn.

---

# Dynamic Dialogue

Ví dụ.

Quest.

Chưa hoàn thành.

↓

```
Hãy giúp tôi tìm 5 bông hoa.
```

Quest.

Đã hoàn thành.

↓

```
Cảm ơn bạn rất nhiều!
```

Cùng một NPC.

Khác lời thoại.

---

# Dialogue Event

Dialogue.

Không Update Gameplay.

Dialogue chỉ phát.

```
DialogueEvent
```

Ví dụ.

```
Start Quest
```

↓

QuestSystem.

---

# Start Quest

Ví dụ.

Player.

Chọn.

```
Tôi sẽ giúp.
```

↓

Dialogue.

↓

```
QuestAcceptedEvent
```

↓

QuestSystem.

---

# Complete Quest

Ví dụ.

NPC.

↓

```
Bạn đã mang đủ hoa?
```

↓

```
QuestCompletedEvent
```

↓

RewardSystem.

---

# Merchant NPC

Merchant.

Không có.

Logic riêng.

Merchant chỉ có.

```
Inventory
```

↓

ShopSystem.

Hiển thị.

---

# Shop Dialogue

Ví dụ.

```
Xin chào.

Bạn muốn?

↓

Buy

Sell

Leave
```

Dialogue.

Mở.

Shop.

---

# Trainer NPC

Trainer.

Không Upgrade.

Skill.

Trainer.

Chỉ phát.

```
LearnSkillEvent
```

↓

SkillSystem.

---

# Banker NPC

Bank.

Không dùng.

Inventory.

Bank.

Có.

```
Storage
```

Riêng.

---

# Craft NPC

Blacksmith.

Không Craft.

Dialogue.

↓

```
Open Craft UI
```

↓

CraftSystem.

---

# Dialogue Action

Một Node.

Có thể.

```
Give Item
```

```
Take Gold
```

```
Teleport
```

```
Play Animation
```

Nhưng.

Dialogue.

Không tự làm.

Chỉ phát Event.

---

# Cutscene Trigger

Dialogue.

Có thể.

↓

```
Start Cutscene
```

↓

CutsceneSystem.

---

# Camera

Dialogue.

Có thể.

↓

```
Focus NPC
```

↓

CameraSystem.

---

# Emotion

NPC.

Có thể.

Đổi.

```
Happy
```

```
Angry
```

```
Sad
```

Animation.

Đọc.

Emotion.

---

# Portrait

Dialogue.

Có thể.

Hiển thị.

```
NPC Portrait
```

Không nằm.

Trong Gameplay.

---

# Voice

Dialogue.

Có thể.

Phát.

```
Voice
```

↓

AudioSystem.

---

# Localization

Dialogue.

Không lưu.

Text.

Chỉ lưu.

```
Localization Key
```

Ví dụ.

```
npc.blacksmith.greeting
```

---

# Dialogue History

Player.

Có thể.

Đọc lại.

Lịch sử.

Dialogue.

---

# Dialogue Skip

Cutscene.

Có thể.

```
Skip
```

Nhưng.

Gameplay Event.

Chỉ chạy.

Một lần.

---

# NPC Schedule

Một số NPC.

Có thể.

```
Morning

Shop
```

```
Night

Home
```

Dialogue.

Thay đổi.

Theo.

Thời gian.

---

# Relationship

NPC.

Có thể có.

```
Friendship
```

```
Trust
```

↓

Mở.

Dialogue mới.

---

# Serialization

Save.

```
NPC State
```

```
Dialogue Progress
```

```
Friendship
```

Không lưu.

UI.

---

# Multiplayer

Dialogue.

Thuộc.

Player.

Không thuộc.

NPC.

Hai Player.

Có thể.

Đang.

Ở hai Node.

Khác nhau.

---

# Debug

Developer Mode.

Hiển thị.

```
Current NPC
```

```
Dialogue ID
```

```
Current Node
```

```
Current Choice
```

```
Conditions
```

```
Triggered Events
```

---

# Kiến trúc hoàn chỉnh

```text
Interact

↓

NPCSystem

↓

Dialogue Tree

↓

Choice

↓

Dialogue Event

↓

Quest

↓

Shop

↓

Cutscene

↓

Gameplay
```

Dialogue.

Không biết.

Quest.

Không biết.

Shop.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ NPCSystem

✅ Dialogue Tree

✅ Dialogue Node

✅ Dialogue Choice

✅ Dialogue Condition

✅ Dialogue Event

✅ Merchant NPC

✅ Quest Integration

✅ Localization

✅ Serialization

---

# Sai lầm phổ biến

## Sai lầm 1

Hard Code.

Dialogue.

Trong Code.

Hãy dùng.

```
Dialogue Definition
```

---

## Sai lầm 2

Dialogue.

Tự Add Item.

Dialogue.

Chỉ phát Event.

---

## Sai lầm 3

NPC.

Lưu Quest Progress.

Quest.

Luôn thuộc.

Player.

---

## Sai lầm 4

Shop.

Viết riêng.

Merchant.

Merchant.

Chỉ mở.

```
ShopSystem
```

---

## Sai lầm 5

Dialogue.

Lưu Text.

Trong Save.

Chỉ lưu.

```
Dialogue ID

Current Node
```

---

# Tổng kết

Dialogue & NPC System là cầu nối giữa Gameplay và cốt truyện.

Sau chương này:

- **NPCSystem** quản lý toàn bộ NPC trong thế giới.
- **Dialogue Tree** cho phép xây dựng các cuộc hội thoại có nhiều nhánh.
- **Dialogue Condition** giúp lời thoại thay đổi theo Quest, Item và Story Progress.
- **Dialogue Event** kết nối Dialogue với Quest, Shop, Crafting và Cutscene mà không tạo phụ thuộc trực tiếp.
- **Merchant**, **Trainer** và **Blacksmith** chỉ là các NPC có vai trò khác nhau, nhưng đều dùng chung kiến trúc.
- **Localization** giúp toàn bộ Dialogue dễ dàng hỗ trợ nhiều ngôn ngữ.

Nhờ thiết kế này, bạn có thể tạo hàng nghìn NPC và hàng chục nghìn đoạn hội thoại chỉ bằng dữ liệu, đồng thời giữ cho Gameplay, Quest và UI luôn tách biệt và dễ bảo trì.

---

# Chương tiếp theo

Ở **Chương 31**, chúng ta sẽ xây dựng **Save & Load System**.

Bạn sẽ học cách xây dựng:

- Save Manager.
- Serialization.
- Snapshot.
- Versioning.
- Auto Save.
- Manual Save.
- Incremental Save.
- Cloud Save.
- Migration.
- Data Integrity.

Sau chương này, toàn bộ trạng thái của game (Hero, Inventory, Quest, NPC, World...) sẽ có thể được lưu và khôi phục một cách an toàn và dễ mở rộng.