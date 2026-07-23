# Chapter 39 - Network & Multiplayer Architecture - Xây dựng kiến trúc Multiplayer chuyên nghiệp

# Mục tiêu

Sau chương này bạn sẽ xây dựng được:

- Client - Server Architecture
- Authoritative Server
- Entity Replication
- Snapshot System
- Network Commands
- RPC
- Client Prediction
- Interpolation
- Lag Compensation
- Multiplayer Debug Tools

Đây là chương dành cho những game có Multiplayer.

Hoặc.

Bạn muốn.

Kiến trúc.

Có thể mở rộng.

Trong tương lai.

---

# Multiplayer là gì?

Rất nhiều người nghĩ.

Multiplayer là.

```
Sync Position
```

Thực tế.

Multiplayer là.

```
Nhiều Client

↓

Một World

↓

Được đồng bộ
```

---

# Multiplayer Flow

```text
Client

↓

Network

↓

Server

↓

Network

↓

Clients
```

Server.

Là trung tâm.

---

# Peer To Peer

Đây là.

Kiến trúc.

Đơn giản.

```text
Player A

↔

Player B
```

Ưu điểm.

Nhanh.

Nhược điểm.

Dễ Cheat.

---

# Client Server

Hầu hết.

Game hiện đại.

Đều dùng.

```text
Client

↓

Server

↓

Clients
```

---

# Authoritative Server

Server.

Là nơi.

Quyết định.

Điều gì.

Là đúng.

Ví dụ.

Player.

Bắn.

↓

Server.

Kiểm tra.

↓

Hit.

Hay.

Không.

---

# Client

Client.

Không quyết định.

Gameplay.

Client.

Chỉ.

Hiển thị.

---

# Server

Server.

Chạy.

Gameplay.

```
Combat
```

```
Quest
```

```
Physics
```

```
AI
```

Client.

Không.

---

# Entity

Entity.

Có thể là.

```
Player
```

```
Monster
```

```
Projectile
```

```
NPC
```

Mọi Entity.

Có.

```
Network ID
```

---

# Network ID

Ví dụ.

```
Player

↓

ID = 1001
```

Server.

Dùng.

ID.

Để.

Đồng bộ.

---

# Spawn

Server.

Tạo.

Entity.

↓

Spawn Event.

↓

Clients.

Spawn.

---

# Destroy

Server.

Xóa.

Entity.

↓

Destroy Event.

↓

Clients.

Remove.

---

# Replication

Server.

Gửi.

```
HP
```

```
Position
```

```
Animation
```

↓

Clients.

---

# Snapshot

Server.

Định kỳ.

Gửi.

```
World Snapshot
```

Ví dụ.

```
20 lần

/

Giây
```

---

# Delta Snapshot

Không gửi.

Toàn bộ.

World.

↓

Chỉ gửi.

Thứ.

Đã thay đổi.

---

# Serialization

Entity.

Không gửi.

Object.

Chỉ gửi.

```
Position
```

```
Velocity
```

```
HP
```

```
Animation
```

---

# Network Tick

Server.

Không cần.

60 Tick.

Có thể.

```
20 Tick

/

Second
```

↓

Client.

Render.

60 FPS.

---

# Network Command

Player.

Không gửi.

```
Position
```

Player.

Chỉ gửi.

```
Move Command
```

↓

Server.

Move.

↓

Sync.

---

# Command Flow

```text
Input

↓

Move Command

↓

Server

↓

Simulation

↓

Snapshot

↓

Client
```

---

# RPC

Một số.

Gameplay.

Cần.

Remote Call.

Ví dụ.

```
Open Chest
```

↓

RPC.

---

# Reliable RPC

Ví dụ.

```
Quest Completed
```

Phải.

Đến.

100%.

---

# Unreliable RPC

Ví dụ.

```
Footstep
```

Mất.

Một Packet.

Không sao.

---

# Client Prediction

Nếu.

Đợi.

Server.

↓

Game.

Bị Delay.

Client.

Dự đoán.

Kết quả.

Trước.

---

# Prediction Flow

```text
Input

↓

Predict

↓

Server

↓

Correction
```

---

# Server Correction

Nếu.

Prediction.

Sai.

↓

Server.

Gửi.

State.

Đúng.

↓

Client.

Sửa.

---

# Reconciliation

Client.

Không Teleport.

↓

Nội suy.

Về.

State.

Đúng.

---

# Interpolation

Client.

Không Render.

Theo.

Snapshot.

↓

Nội suy.

Giữa.

Hai Snapshot.

↓

Mượt hơn.

---

# Extrapolation

Nếu.

Snapshot.

Đến.

Muộn.

↓

Ước lượng.

Vị trí.

Tạm thời.

---

# Lag Compensation

Player A.

Bắn.

↓

Server.

Kiểm tra.

Theo.

Thời điểm.

Player.

Đã bắn.

Không phải.

Hiện tại.

---

# Latency

Ví dụ.

```
Ping

50ms
```

↓

Gameplay.

Mượt.

```
250ms
```

↓

Prediction.

Quan trọng.

---

# Packet Loss

Nếu.

Mất Packet.

↓

Reliable.

Gửi lại.

↓

Unreliable.

Bỏ qua.

---

# Interest Management

Không gửi.

Toàn bộ.

World.

Cho.

Mọi Player.

Ví dụ.

Player.

Ở.

Village.

Không cần.

Monster.

Trong Dungeon.

---

# Area Of Interest

Server.

Chỉ Sync.

Entity.

Gần.

Player.

---

# Bandwidth

Không gửi.

```
1000 Entity
```

Mỗi Tick.

↓

Chỉ gửi.

Những gì.

Cần thiết.

---

# Compression

Snapshot.

Có thể.

Compress.

↓

Giảm.

Bandwidth.

---

# Network Event

Gameplay.

Không gọi.

Socket.

↓

Gameplay.

Publish.

```
AttackEvent
```

↓

Network.

Sync.

---

# Chat

Chat.

Không nên.

Đi chung.

Snapshot.

Là.

Channel.

Riêng.

---

# Voice

Voice.

Không dùng.

Reliable.

Thông thường.

Realtime.

---

# Matchmaking

Client.

Không kết nối.

Gameplay Server.

Ngay.

↓

Matchmaking.

↓

Server.

↓

Join.

---

# Lobby

Player.

Chuẩn bị.

↓

Ready.

↓

Start Game.

---

# Host Migration

Nếu.

Host.

Thoát.

↓

Chuyển.

Host.

Cho.

Player khác.

(Peer-to-Peer)

---

# Save

Server.

Lưu.

Gameplay.

Client.

Không.

---

# Cheat

Không tin.

Client.

Ví dụ.

Client.

Gửi.

```
HP = 999999
```

↓

Server.

Bỏ qua.

---

# Anti Cheat

Server.

Kiểm tra.

```
Move Speed
```

```
Damage
```

```
Attack Rate
```

↓

Nếu.

Sai.

↓

Reject.

---

# Replay

Server.

Có thể.

Lưu.

```
Commands
```

↓

Replay.

Match.

---

# Debug

Developer Mode.

Hiển thị.

```
Ping
```

```
Packet Loss
```

```
Bandwidth
```

```
Network Tick
```

```
Prediction Error
```

```
Entity Count
```

---

# Performance

Không Sync.

Mỗi Frame.

↓

Sync.

Theo.

Network Tick.

---

# Flame Integration

Trong Flame.

Entity.

Vẫn là.

```
PositionComponent
```

Nhưng.

NetworkSystem.

Là nơi.

Đồng bộ.

State.

Gameplay.

Không biết.

Socket.

---

# Network Pipeline

```text
Input

↓

Command

↓

Server

↓

Simulation

↓

Snapshot

↓

Interpolation

↓

Render
```

Gameplay.

Không gọi.

Socket.

Trực tiếp.

---

# Kiến trúc hoàn chỉnh

```text
Input

↓

Command

↓

Network

↓

Server

↓

Gameplay

↓

Snapshot

↓

Replication

↓

Client

↓

Render
```

Client.

Không điều khiển.

Gameplay.

Server.

Là.

Nguồn dữ liệu.

Duy nhất.

---

# Checklist

Sau chương này.

Bạn nên có.

✅ Client-Server Architecture

✅ Network ID

✅ Snapshot

✅ Replication

✅ Client Prediction

✅ Reconciliation

✅ Interpolation

✅ Lag Compensation

✅ RPC

✅ Interest Management

---

# Sai lầm phổ biến

## Sai lầm 1

Client.

Tự tính.

Damage.

Server.

Phải là.

Authoritative.

---

## Sai lầm 2

Sync.

Toàn bộ.

World.

Mỗi Tick.

Chỉ Sync.

Những gì.

Cần thiết.

---

## Sai lầm 3

Không dùng.

Prediction.

↓

Gameplay.

Có độ trễ.

Rất lớn.

---

## Sai lầm 4

Tin tưởng.

Client.

↓

Cheat.

Rất dễ.

---

## Sai lầm 5

Gameplay.

Gọi.

Socket.

Trực tiếp.

Hãy để.

```
NetworkSystem
```

Làm việc đó.

---

# Tổng kết

Network & Multiplayer Architecture là nền tảng để xây dựng các game online có khả năng mở rộng và chống gian lận.

Sau chương này:

- **Authoritative Server** trở thành nguồn dữ liệu duy nhất của Gameplay.
- **Client** chỉ gửi **Command** và hiển thị kết quả nhận từ Server.
- **Snapshot**, **Replication** và **Interpolation** giúp trạng thái game được đồng bộ mượt mà.
- **Client Prediction** và **Reconciliation** giảm cảm giác trễ khi điều khiển nhân vật.
- **Interest Management** và **Compression** giúp giảm băng thông khi số lượng Entity tăng lên.
- **NetworkSystem** tách hoàn toàn Gameplay khỏi tầng giao tiếp mạng, giúp dễ bảo trì và mở rộng.

Kiến trúc này là nền tảng của hầu hết các game multiplayer hiện đại, từ game co-op nhỏ cho đến các MMO và game bắn súng trực tuyến.

---

# Chương tiếp theo

Ở **Chương 40**, chúng ta sẽ xây dựng **Plugin & Modular Architecture**.

Bạn sẽ học cách xây dựng:

- Modular Architecture.
- Plugin System.
- Feature Module.
- Dependency Injection.
- Service Locator.
- Module Lifecycle.
- Runtime Plugin Loading.
- Cross Module Communication.
- Module Registry.
- Plugin SDK.

Sau chương này, game sẽ được chia thành các module độc lập như Inventory, Quest, Combat, AI, Audio, VFX... giúp phát triển song song, tái sử dụng và mở rộng tính năng mà không ảnh hưởng đến phần còn lại của dự án.