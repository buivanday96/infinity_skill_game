# Chapter 28 - Inventory & Equipment System - Xây dựng hệ thống Item chuyên nghiệp

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- Item System
- Inventory System
- Equipment System
- Equipment Slot
- Item Modifier
- Consumable Item
- Stackable Item
- Loot System
- Drop Table
- Item Serialization

Đây là chương giúp game trở thành một RPG thực sự.

Sau chương này.

Hero sẽ có thể:

- Nhặt đồ
- Mặc giáp
- Trang bị vũ khí
- Dùng Potion
- Thu thập nguyên liệu
- Mở rương
- Loot Boss

---

# Item là gì?

Rất nhiều người nghĩ.

Item là.

```
Sword
```

Hay.

```
Potion
```

Thực tế.

Item chỉ là.

```
Một Definition

+

Một Instance
```

Đây là nguyên tắc rất quan trọng.

---

# Item Definition

Definition là.

```
Template
```

Ví dụ.

```
Iron Sword
```

```
Small Potion
```

```
Diamond
```

Definition.

Không bao giờ thay đổi.

---

# Item Instance

Khi Hero.

Nhặt Item.

↓

Sinh ra.

```
Item Instance
```

Ví dụ.

Hai thanh kiếm.

Cùng.

```
Iron Sword
```

Nhưng.

Durability khác nhau.

---

# Item ID

Mỗi Item.

Có.

```
Item ID
```

Ví dụ.

```
iron_sword
```

```
health_potion
```

```
magic_staff
```

Không dùng.

Tên hiển thị.

Làm ID.

---

# Item Type

Mỗi Item.

Có Type.

Ví dụ.

```
Weapon
```

```
Armor
```

```
Potion
```

```
Material
```

```
Quest Item
```

```
Food
```

Gameplay.

Luôn dựa.

Trên Type.

---

# Inventory

Inventory.

Không phải.

```
List<Item>
```

Inventory.

Là một System.

Quản lý.

```
Add

Remove

Move

Sort

Split

Merge
```

---

# Inventory Flow

```text
Pickup Item

↓

InventorySystem

↓

Inventory

↓

UI Update
```

Inventory.

Không Update UI.

---

# Inventory Slot

Inventory.

Có nhiều Slot.

Ví dụ.

```
40 Slots
```

Hay.

```
100 Slots
```

Không phải.

Item nào.

Cũng Stack.

---

# Empty Slot

Slot.

Có thể.

```
Empty
```

↓

Không chứa Item.

Đây vẫn là.

Một Slot hợp lệ.

---

# Stackable Item

Ví dụ.

Potion.

```
99
```

Trong.

Một Slot.

---

# Non Stack Item

Ví dụ.

```
Sword
```

```
Shield
```

```
Armor
```

Mỗi Item.

Chiếm.

Một Slot.

---

# Max Stack

Ví dụ.

Potion.

```
99
```

Hero.

Nhặt thêm.

↓

Sinh.

Slot mới.

---

# Split Stack

Ví dụ.

```
Potion

99
```

↓

Tách.

```
40

+

59
```

Inventory.

Xử lý.

---

# Merge Stack

Ví dụ.

```
20 Potion
```

+

```
30 Potion
```

↓

```
50 Potion
```

---

# Equipment

Equipment.

Không nằm.

Trong Inventory.

Đây là.

Một System riêng.

---

# Equipment Slot

Ví dụ.

```
Weapon
```

```
Helmet
```

```
Armor
```

```
Ring
```

```
Boot
```

```
Accessory
```

---

# Equip Flow

```text
Inventory

↓

Equip Request

↓

EquipmentSystem

↓

Stat Modifier

↓

Hero Stats
```

Equipment.

Không tự.

Tăng Attack.

---

# Unequip

Khi.

Unequip.

↓

Modifier.

Biến mất.

Stat.

Tự tính lại.

---

# Equipment Modifier

Ví dụ.

Sword.

```
Attack

+25
```

Armor.

```
Defense

+40
```

Ring.

```
Critical

+10%
```

Modifier.

Đi vào.

Stat Pipeline.

---

# Durability

Một số Item.

Có.

```
Durability
```

Ví dụ.

```
100

↓

99

↓

98
```

Khi.

```
0
```

↓

Broken.

---

# Consumable

Potion.

Food.

Scroll.

Sau khi dùng.

↓

Item.

Biến mất.

---

# Quest Item

Quest Item.

Không thể.

Bán.

Không thể.

Drop.

Gameplay.

Quyết định.

---

# Currency

Gold.

Gem.

Coin.

Không nên.

Lưu.

Trong Inventory.

Nên có.

```
Wallet
```

Riêng.

---

# Loot System

Monster chết.

↓

```
LootSystem
```

↓

Spawn Item.

Không phải.

CombatSystem.

---

# Drop Table

Boss.

Không Hard Code.

```
Drop Sword
```

Boss.

Có.

```
Drop Table
```

Ví dụ.

```
Potion

50%
```

```
Sword

5%
```

```
Gem

1%
```

---

# Random Loot

LootSystem.

Đọc.

Drop Table.

↓

Roll.

↓

Spawn Item.

---

# Guaranteed Drop

Ví dụ.

Boss.

Luôn Drop.

```
Boss Soul
```

Không Random.

---

# Rare Item

Ví dụ.

```
Legendary

0.1%
```

↓

LootSystem.

Roll.

Theo tỷ lệ.

---

# Auto Pickup

Hero.

Đi qua.

↓

```
Coin
```

↓

Inventory.

Tự Add.

---

# Manual Pickup

Ví dụ.

```
Chest
```

↓

Player.

Nhấn.

```
Interact
```

↓

Pickup.

---

# Chest

Chest.

Không chứa.

Item.

Chest.

Chỉ chứa.

```
Loot Table
```

Khi mở.

↓

LootSystem.

Sinh Item.

---

# Equipment Set

Ví dụ.

```
Knight Set

2 Pieces

↓

+20 Defense
```

```
4 Pieces

↓

+50 Defense
```

EquipmentSystem.

Theo dõi.

---

# Item Quality

Ví dụ.

```
Common
```

```
Rare
```

```
Epic
```

```
Legendary
```

Gameplay.

Không phụ thuộc.

Mà chỉ.

UI.

Hoặc.

Drop Rate.

---

# Item Affix

Ví dụ.

Sword.

```
+20 Attack
```

+

```
+10 Critical
```

+

```
Fire Damage
```

Affix.

Là Modifier.

---

# Generated Item

Ví dụ.

Boss.

Drop.

```
Sword

Random Affix
```

↓

Item Instance.

Khác nhau.

---

# Inventory Event

Inventory.

Không Update UI.

↓

```
ItemAddedEvent
```

↓

UI.

---

# Equipment Event

Equip.

↓

```
EquipmentChangedEvent
```

↓

Stats.

↓

UI.

↓

Save.

---

# Save Inventory

Chỉ lưu.

```
Item ID
```

```
Quantity
```

```
Durability
```

```
Affix
```

Không lưu.

Icon.

---

# Serialization

Equipment.

Inventory.

Chest.

Merchant.

Đều dùng.

Cùng.

```
Item Instance
```

Giúp.

Save.

Network.

Replay.

Dễ dàng.

---

# Merchant

Shop.

Không tạo.

Item riêng.

Merchant.

Chỉ có.

```
Inventory
```

Khác.

Hero.

---

# Crafting

Crafting.

Không tạo.

Item.

Crafting.

Chỉ.

```
Consume Materials

↓

Create Item
```

Inventory.

Tự Update.

---

# Debug

Developer Mode.

Hiển thị.

```
Inventory Slots
```

```
Equipment
```

```
Current Modifier
```

```
Drop Roll
```

```
Loot Table
```

---

# Kiến trúc hoàn chỉnh

```text
Loot

↓

InventorySystem

↓

EquipmentSystem

↓

Modifier Pipeline

↓

Hero Stats

↓

Gameplay
```

Inventory.

Không biết.

Combat.

Equipment.

Không biết.

UI.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ Item Definition

✅ Item Instance

✅ InventorySystem

✅ EquipmentSystem

✅ Equipment Slot

✅ Stack Item

✅ LootSystem

✅ Drop Table

✅ Consumable

✅ Serialization

---

# Sai lầm phổ biến

## Sai lầm 1

Sword.

Tự tăng Attack.

Attack.

Luôn đi qua.

```
Modifier Pipeline
```

---

## Sai lầm 2

Inventory.

Là.

```
List<Item>
```

Inventory.

Là một System.

---

## Sai lầm 3

Combat.

Drop Item.

Loot luôn thuộc.

```
LootSystem
```

---

## Sai lầm 4

Equipment.

Lưu trực tiếp.

Stat.

Stat.

Luôn được.

Tính lại.

Từ Modifier.

---

## Sai lầm 5

Hard Code.

Drop.

Trong Boss.

Boss.

Chỉ có.

```
Drop Table
```

LootSystem.

Tự xử lý.

---

# Tổng kết

Inventory & Equipment System là nền tảng của mọi game RPG có hệ thống vật phẩm.

Sau chương này:

- **Item Definition** mô tả dữ liệu tĩnh của vật phẩm.
- **Item Instance** lưu trạng thái riêng của từng vật phẩm.
- **InventorySystem** quản lý toàn bộ việc thêm, xóa, sắp xếp và gộp vật phẩm.
- **EquipmentSystem** quản lý các trang bị và chuyển Modifier vào Stat Pipeline.
- **LootSystem** sinh vật phẩm từ Drop Table thay vì Hard Code.
- **Serialization** giúp Inventory, Merchant, Chest và Save Game sử dụng chung một định dạng dữ liệu.

Nhờ kiến trúc này, bạn có thể dễ dàng mở rộng sang các tính năng như Crafting, Trading, Auction House hoặc Multiplayer mà không cần thay đổi nền tảng Inventory hiện tại.

---

# Chương tiếp theo

Ở **Chương 29**, chúng ta sẽ xây dựng **Quest System**.

Bạn sẽ học cách xây dựng:

- Quest Definition.
- Quest Instance.
- Quest Objective.
- Quest State Machine.
- Quest Trigger.
- Event Driven Quest.
- Daily Quest.
- Achievement.
- Reward Pipeline.
- Quest Serialization.

Sau chương này, game sẽ có hệ thống nhiệm vụ hoàn chỉnh, có thể mở rộng từ nhiệm vụ chính, nhiệm vụ phụ đến Daily Quest và Achievement.