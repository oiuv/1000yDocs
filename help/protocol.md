# 网络协议文档

> 源码: `Common/uCrypt.pas`, `Common/uPackets.pas`, `Common/uBuffer.pas`, `1000ydef/deftype.pas`

本文档详细描述千年(1000y)游戏的网络通信协议，包括数据包格式、加密算法、消息类型和服务间通信架构。

---

## 1. 数据包格式

### 1.1 TPacketData 结构

主要 TCP 服务消息使用 `TPacketData`，定义在 `uPackets.pas` 中。它不是所有通信的统一外层：Game 的 UDP 日志使用 `TComData` 长度前缀，Gate 向 Balance 上报时直接发送 packed `TBalanceData`。因此抓包或实现兼容服务时必须先按连接方向确定外层结构，不能把 UDP 数据按 `TPacketData` 解码。

```pascal
TPacketData = record
   PacketSize : Word;                          // 包大小（2字节）
   RequestID : Integer;                        // 请求ID（4字节）
   RequestMsg : Byte;                          // 消息类型（1字节）
   ResultCode : Byte;                          // 结果代码（1字节）
   Data : array[0..MAX_PACKET_SIZE - 1] of byte; // 数据内容（变长）
end;
```

### 1.2 字节布局

| 偏移量 | 字段名 | 类型 | 大小 | 说明 |
|:------:|--------|------|:----:|------|
| 0-1 | PacketSize | Word | 2字节 | 整个包的总大小（包括包头8字节） |
| 2-5 | RequestID | Integer | 4字节 | 请求标识符，用于匹配请求和响应 |
| 6 | RequestMsg | Byte | 1字节 | 外层服务消息类型。服务间包通常直接使用 `LG_*`、`DB_*`、`GM_*` 等；客户端游戏命令通常封装在 `TWordComData.Data` 中，此字段为 0 |
| 7 | ResultCode | Byte | 1字节 | 结果代码，0表示成功 |
| 8+ | Data | Byte[] | 变长 | 实际数据内容 |

**包头固定大小**: 8字节（PacketSize + RequestID + RequestMsg + ResultCode）

**结构体 Data 上限**：`MAX_PACKET_SIZE = 8192` 字节。完整 `TPacketData` 还包含 8 字节包头，因此结构最大为 8200 字节。这只是记录字段和 `PutPacket` 入参检查的上限，不是当前加密发送路径的安全载荷上限。

`TPacketSender.PutPacket` 使用固定 8192 字节临时缓冲区；加密会把 `(8 + Data长度)` 按每 3 字节扩展为 4 字节，并再写入起止标记和结尾零字节。按现有实现计算，启用加密时 `Data` 最多只能安全取 **6133 字节**。更大的载荷即使通过 `aSize <= MAX_PACKET_SIZE` 检查，也可能越界写入临时缓冲区；这是当前源码缺陷，兼容实现应在进入加密前采用更严格的长度检查。

### 1.3 加密数据包格式

当启用加密时（`FboUseCrypt = true`），数据包在传输时使用特殊格式：

```
┌──────────┬──────────────────────┬──────────┐
│ 包头     │   加密后的数据       │ 包尾     │
│ 0x28     │   (变长)             │ 0x29     │
└──────────┴──────────────────────┴──────────┘
```

**完整格式**: `0x28` + `加密数据` + `0x29`

- **包头**: `0x28`（ASCII '('）
- **包尾**: `0x29`（ASCII ')'）
- **加密数据**: 对 TPacketData 结构进行加密后的字节流

**示例**（空载荷、`RequestID=1`、`RequestMsg=5`）:
```
原始数据: 08 00 01 00 00 00 05 00
传输格式: 28 [加密后的字节流] 29
```

`0x28` 和 `0x29` 只属于加密传输外层，不是原始 `TPacketData` 的字段。

### 1.4 非加密数据包格式

当不启用加密时（`FboUseCrypt = false`），直接传输 TPacketData 结构：

```
┌──────────────┬───────────┬────────────┬────────────┬──────────┐
│ PacketSize   │ RequestID │ RequestMsg │ ResultCode │   Data   │
│ (2字节)      │ (4字节)   │ (1字节)    │ (1字节)    │ (变长)   │
└──────────────┴───────────┴────────────┴────────────┴──────────┘
```

**注意**: 服务间内部通信中，仅 Gate↔Game 不加密，Gate↔DB、Gate↔Login、Gate↔Paid 均启用加密。客户端连接通常启用加密。

---

## 2. 加密算法

### 2.1 算法概述

加密算法实现在 `uCrypt.pas` 中，采用类似 Base64 的编码方式，但使用自定义字符表：

1. **3字节→4字节编码**: 将每3字节明文编码为4字节密文
2. **自定义字符替换**: 使用 LCG 随机数生成器生成的加密表进行字符映射
3. **字符范围**: 加密后的字节值在 59-122（0x3B-0x7A）之间

### 2.2 LCG 随机数生成器

```pascal
function UniformRandom(aMax: integer): integer;
begin
   CurrentRandom := (1229 * CurrentRandom + 351750) mod 1664501;
   Result := CurrentRandom mod aMax;
end;
```

**参数**:
- **a (乘数)**: 1229
- **c (增量)**: 351750
- **m (模数)**: 1664501
- **初始种子**: 1

### 2.3 加密表生成

加密表通过 Fisher-Yates 洗牌算法生成：

```pascal
procedure InitCryptTable;
var
   i, idx, n: integer;
   List: TList;
begin
   List := TList.Create;
   for i := 0 to 63 do List.Add(TObject(i));  // 初始化 0-63
   
   CurrentRandom := 1;
   
   for i := 0 to 63 do begin
      idx := UniformRandom(List.Count);        // 随机选择
      n := Integer(List[idx]);
      List.Delete(idx);
      
      EnCryptTable[i] := n + $3B;              // 映射到 59-122
      DeCryptTable[EnCryptTable[i]] := i;      // 反向映射
   end;
   
   List.Free;
end;
```

**加密表**:
- `EnCryptTable[0..63]`: 将 0-63 映射到 59-122 的字符
- `DeCryptTable[59..122]`: 反向映射，用于解密

**Python 实现**:
```python
def _init_crypt_table(self):
    current_random = 1
    a, c, m = 1229, 351750, 1664501
    
    numbers = list(range(64))
    self.encrypt_table = [0] * 64
    self.decrypt_table = {}
    
    for i in range(64):
        current_random = (a * current_random + c) % m
        idx = current_random % len(numbers)
        n = numbers.pop(idx)
        self.encrypt_table[i] = n + 0x3B
        self.decrypt_table[self.encrypt_table[i]] = i
```

### 2.4 编码过程（Encoding4）

将3字节编码为4字节：

```pascal
procedure Encoding4(sour, dest: Pbyte);
var
   buf: array[0..4] of byte;
   b1, b2: byte;
begin
   move(sour^, buf, 3);
   
   dest^ := buf[0] shr 2;                    // 第1字节: 高6位
   inc(dest);
   
   b1 := (buf[0] and $03) shl 4;             // 第2字节: 低2位 + 高4位
   b2 := (buf[1] shr 4);
   dest^ := b1 or b2;
   inc(dest);
   
   b1 := (buf[1] and $0f) shl 2;             // 第3字节: 低4位 + 高2位
   b2 := (buf[2] shr 6);
   dest^ := b1 or b2;
   inc(dest);
   
   dest^ := buf[2] and $3f;                  // 第4字节: 低6位
end;
```

**编码逻辑**:
```
输入: [A A A A A A A A] [B B B B B B B B] [C C C C C C C C]
      \____6bit____/  \__2bit__/\__4bit_/  \_4bit_\  /_6bit_/
输出:     [  e0  ]      [  e1  ]      [  e2  ]     [  e3  ]

e0 = A >> 2
e1 = ((A & 0x03) << 4) | (B >> 4)
e2 = ((B & 0x0F) << 2) | (C >> 6)
e3 = C & 0x3F
```

### 2.5 解码过程（Decoding3）

将4字节解码为3字节：

```pascal
procedure Decoding3(sour, dest: Pbyte);
var
   buf: array[0..4] of byte;
   b1, b2: byte;
begin
   move(sour^, buf, 4);
   
   b1 := buf[0] shl 2;                       // 第1字节
   b2 := buf[1] shr 4;
   dest^ := b1 or b2;
   inc(dest);
   
   b1 := buf[1] shl 4;                       // 第2字节
   b2 := buf[2] shr 2;
   dest^ := b1 or b2;
   inc(dest);
   
   b1 := buf[2] shl 6;                       // 第3字节
   b2 := buf[3];
   dest^ := b1 or b2;
end;
```

**解码逻辑**:
```
输入: [  e0  ] [  e1  ] [  e2  ] [  e3  ]
输出: [A A A A A A A A] [B B B B B B B B] [C C C C C C C C]

A = (e0 << 2) | (e1 >> 4)
B = ((e1 & 0x0F) << 4) | (e2 >> 2)
C = ((e2 & 0x03) << 6) | e3
```

### 2.6 完整加密流程

```pascal
function EnCryption(sour, dest: pbyte; asize: integer): Integer;
var
   i, nblock: integer;
begin
   // 1. 填充0（确保3字节对齐）
   PBYTE(integer(sour)+asize)^ := 0;
   PBYTE(integer(sour)+asize+1)^ := 0;
   PBYTE(integer(sour)+asize+2)^ := 0;
   
   // 2. 计算块数
   nblock := asize div 3;
   if (asize mod 3) <> 0 then nblock := nblock + 1;
   
   // 3. 逐块编码并替换字符
   for i := 0 to nblock-1 do begin
      Encoding4(PBYTE(integer(sour)+i*3), PBYTE(integer(dest)+i*4));
      
      // 字符替换
      PBYTE(integer(dest)+i*4+0)^ := EncryptTable[PBYTE(integer(dest)+i*4+0)^];
      PBYTE(integer(dest)+i*4+1)^ := EncryptTable[PBYTE(integer(dest)+i*4+1)^];
      PBYTE(integer(dest)+i*4+2)^ := EncryptTable[PBYTE(integer(dest)+i*4+2)^];
      PBYTE(integer(dest)+i*4+3)^ := EncryptTable[PBYTE(integer(dest)+i*4+3)^];
   end;
   
   PBYTE(integer(dest)+nblock*4)^ := 0;
   Result := nblock*4;
end;
```

**加密步骤**:
1. 在数据末尾填充0，确保长度为3的倍数
2. 计算需要的块数（每块3字节→4字节）
3. 对每块执行 Encoding4 编码
4. 对编码后的4个字节使用 EncryptTable 进行字符替换
5. 返回加密后的数据长度（4的倍数）

### 2.7 完整解密流程

```pascal
function DeCryption(sour, dest: pbyte; asize: integer): Integer;
var
   i, nblock, dsize: integer;
   buf: array[0..8192 - 1] of byte;
begin
   // 1. 检查长度是否为4的倍数
   if asize mod 4 <> 0 then begin
      Result := -1;
      exit;
   end;
   nblock := asize div 4;
   
   move(sour^, buf, asize);
   buf[asize] := 0;
   
   // 2. 反向字符替换
   for i := 0 to (nblock*4)-1 do begin
      if (buf[i] < 59) or (buf[i] > 123 - 1) then begin
         Result := -1;  // 字符范围错误
         exit;
      end;
      buf[i] := DeCryptTable[buf[i]];
   end;
   
   // 3. 逐块解码
   for i := 0 to nblock-1 do
      Decoding3(@buf[i*4], PBYTE(integer(dest) + i * 3));
   
   dsize := nblock * 3;
   Result := dsize;
end;
```

**解密步骤**:
1. 验证输入长度是否为4的倍数
2. 验证所有字节在有效范围（59-122）内
3. 使用 DeCryptTable 进行反向字符替换
4. 对每块执行 Decoding3 解码
5. 返回解密后的数据长度（3的倍数）

### 2.8 数据包封装

```pascal
function TPacketSender.PutPacket(aID: Integer; aMsg, aRetCode: Byte; 
                                  aData: PChar; aSize: Integer): Boolean;
var
   nSize: Word;
   Packet: TPacketData;
   buffer: array[0..8192 - 1] of Byte;
begin
   // 1. 构建 TPacketData
   Packet.PacketSize := SizeOf(Word) + SizeOf(Integer) + SizeOf(Byte) * 2 + aSize;
   Packet.RequestID := aID;
   Packet.RequestMsg := aMsg;
   Packet.ResultCode := aRetCode;
   if aSize > 0 then Move(aData^, Packet.Data, aSize);
   
   // 2. 加密并封装
   if FboUseCrypt then begin
      buffer[0] := PACKET_START;  // 0x28
      nSize := EnCryption(@Packet, @buffer[1], Packet.PacketSize);
      buffer[nSize + 1] := PACKET_END;  // 0x29
      buffer[nSize + 2] := 0;
      SendBuffer.Put(@buffer, nSize + 2);
   end else begin
      SendBuffer.Put(@Packet, Packet.PacketSize);
   end;
end;
```

**封装流程**:
1. 构建 TPacketData 结构（包含 PacketSize、RequestID、RequestMsg、ResultCode、Data）
2. 如果启用加密：
   - 在缓冲区开头写入 `0x28`
   - 对 TPacketData 进行加密
   - 在加密数据后写入 `0x29`
3. 如果不加密：直接写入 TPacketData

---

## 3. 消息类型

### 3.1 包消息类型 (PACKET_*)

定义服务间通信的包类型，详见 [`constants/MESSAGES.md`](constants/MESSAGES.md)：

| 常量名 | 值 | 说明 |
|--------|---:|------|
| `PACKET_NONE` | 0 | 无类型 |
| `PACKET_GAME` | 1 | 游戏数据包（角色移动、攻击、技能等） |
| `PACKET_CLIENT` | 2 | 客户端数据包 |
| `PACKET_GATE` | 3 | 网关数据包 |
| `PACKET_DB` | 4 | 数据库数据包 |
| `PACKET_LOGIN` | 5 | 登录数据包（账号验证、角色选择） |
| `PACKET_PAID` | 6 | 计费数据包 |
| `PACKET_NOTICE` | 7 | 公告数据包 |

### 3.2 服务端消息 (SM_*)

服务端消息（Server Message）由服务器发送给客户端，按功能分类：

#### 连接和状态管理
- `SM_CLOSE` (255): 关闭连接（版本不匹配等）
- `SM_RECONNECT` (254): 重连
- `SM_CONNECTTHRU` (253): 连接转发
- `SM_SETCLIENTCONDITION` (2): 设置客户端条件

#### 角色信息
- `SM_CHARINFO` (3): 角色基本信息
- `SM_ATTRIBBASE` (5): 基础属性
- `SM_ATTRIB_VALUES` (23): 属性值
- `SM_ATTRIB_LIFE` (25): 活力数据
- `SM_HAVEITEM` (6): 物品列表
- `SM_HAVEMAGIC` (7): 武功列表
- `SM_WEARITEM` (8): 装备信息

#### 场景和对象
- `SM_NEWMAP` (9): 新地图
- `SM_SHOW` (10): 显示对象
- `SM_HIDE` (11): 隐藏对象
- `SM_SHOWITEM` (28): 显示物品
- `SM_SHOWMONSTER` (29): 显示怪物
- `SM_SHOWDYNAMICOBJECT` (47): 显示动态对象

#### 动作和交互
- `SM_MOVE` (13): 移动
- `SM_TURN` (15): 转向
- `SM_SAY` (12): 说话
- `SM_MOTION` (22): 动作
- `SM_MAGIC` (19): 使用武功

#### 窗口和UI
- `SM_WINDOW` (1): 通用窗口
- `SM_MESSAGE` (2): 消息窗口
- `SM_SHOWEXCHANGE` (44): 交换窗口
- `SM_SHOWSPECIALWINDOW` (50): 特殊窗口
- `SM_TRADEWINDOW` (65): 交易窗口
- `SM_MARKETWINDOW` (77): 个人商店窗口

**完整列表**: 参见 [`constants/MESSAGES.md`](constants/MESSAGES.md#服务端消息-sm)

### 3.3 客户端消息 (CM_*)

客户端消息（Client Message）由客户端发送给服务器，按功能分类：

#### 连接和认证
- `CM_CLOSE` (1): 关闭连接
- `CM_VERSION` (2): 版本检查
- `CM_IDPASS` (3): 登录（账号密码）
- `CM_CREATEIDPASS` (4): 创建账号
- `CM_CHANGEPASSWORD` (5): 修改密码

#### 角色管理
- `CM_CREATECHAR` (6): 创建角色
- `CM_DELETECHAR` (7): 删除角色
- `CM_SELECTCHAR` (8): 选择角色

#### 游戏操作
- `CM_TURN` (10): 转向
- `CM_MOVE` (11): 移动
- `CM_SAY` (12): 说话
- `CM_HIT` (13): 攻击
- `CM_PICKUP` (14): 拾取
- `CM_CLICK` (20): 点击
- `CM_DBLCLICK` (21): 双击
- `CM_DRAGDROP` (22): 拖放

#### 窗口交互
- `CM_WINDOWCONFIRM` (30): 窗口确认
- `CM_INPUTSTRING` (26): 输入字符串
- `CM_SELECTCOUNT` (27): 选择数量
- `CM_TRADEWINDOW` (43): 交易窗口
- `CM_SKILLWINDOW` (44): 技能窗口

#### 门派和社交
- `CM_MAKEGUILDDATA` (32): 创建门派
- `CM_GUILDINFODATA` (33): 门派信息
- `CM_AGREEDATA` (34): 同意数据
- `CM_MARRY` (61): 结婚
- `CM_MARRYANSWER` (62): 结婚回应

**完整列表**: 参见 [`constants/MESSAGES.md`](constants/MESSAGES.md#客户端消息-cm)

### 3.4 场景消息 (FM_*)

场景消息（Field Message）用于场景内对象间通信，通过 `TFieldPhone.SendMessage` 分发：

#### 基础消息
- `FM_CREATE` (1): 创建对象
- `FM_DESTROY` (2): 销毁对象
- `FM_SHOW` (3): 显示对象
- `FM_HIDE` (4): 隐藏对象
- `FM_MOVE` (5): 移动
- `FM_TURN` (12): 转向

#### 战斗消息
- `FM_HIT` (8): 近战攻击
- `FM_BOW` (104): 弓术攻击
- `FM_GUILDATTACK` (109): 门派攻击
- `FM_DEADHIT` (121): 致命攻击
- `FM_WINDOFHAND` (147): 掌风攻击
- `FM_CRITICAL` (152): 暴击

#### 交互消息
- `FM_SAY` (9): 说话
- `FM_SHOUT` (100): 喊叫
- `FM_PICKUP` (11): 拾取
- `FM_ADDITEM` (27): 添加物品
- `FM_DELITEM` (75): 删除物品
- `FM_ADDMONEY` (29): 增加金钱
- `FM_DELMONEY` (30): 减少金钱

**完整列表**: 参见 [`constants/MESSAGES.md`](constants/MESSAGES.md#场景消息-fm)

---

## 4. 消息收发流程

### 4.1 客户端连接流程

```
客户端                    Balance (3053)              Gate (3054)
  │                           │                           │
  │──── TCP连接 ────────────>│                           │
  │                           │                           │
  │<─── 网关信息 ────────────│                           │
  │     (IP:Port, 加密)       │                           │
  │                           │                           │
  │──── 断开 ────────────────>│                           │
  │                           │                           │
  │──── TCP连接 ─────────────────────────────────────────>│
  │                                                         │
  │──── CM_VERSION ───────────────────────────────────────>│
  │     (目标Gate版本 + NATION_VERSION，加密)                 │
  │                                                         │
  │<─── SM_MESSAGE 或 SM_CLOSE ────────────────────────────│
  │     (版本通过或拒绝)                                      │
  │                                                         │
  │──── 登录请求 ────────────────────────────────────────>│
  │     (CM_IDPASS, 加密)                                    │
  │                                                         │
  │<─── 角色列表 ─────────────────────────────────────────│
  │     (SM_CHARINFO, 加密)                                  │
```

### 4.2 消息转发流程

#### 客户端 → Gate → Game

```
客户端 (加密)
  │
  │ 0x28 + 加密数据 + 0x29
  ▼
Gate (解密)
  │
  │ 解析 TPacketData
  │ 提取外层 RequestMsg 和 Data
  │
  │ 重新封装为未加密的 TPacketData
  ▼
Game Server
```

**Gate 的处理流程**:
1. 接收客户端的加密数据包
2. 查找 `0x28` 和 `0x29` 定位数据包边界
3. 提取加密数据并解密
4. 解析 TPacketData 结构
5. 登录/选角阶段由 Gate 解析 `TWordComData.Data` 首字节的 `CM_*`；游戏阶段按当前状态转发载荷
6. 以 `GM_SENDGAMEDATA` 转发给 Game Server；该连接的 `TPacketSender`/`TPacketReceiver` 明确以 `aboUseCrypt=false` 创建

#### Game → Gate → 客户端

```
Game Server
  │
  │ 未加密的 TPacketData
  ▼
Gate
  │
  │ 加密 TPacketData
  │ 封装: 0x28 + 加密数据 + 0x29
  ▼
客户端 (解密)
```

### 4.3 加密/解密环节

| 连接类型 | 加密 | 说明 |
|---------|------|------|
| 客户端 ↔ Balance | ✓ | 使用加密 |
| 客户端 ↔ Gate | ✓ | 使用加密 |
| Gate ↔ Game | ✗ | 不加密 |
| Gate ↔ DB | ✓ | 使用加密 |
| Gate ↔ Login | ✓ | 使用加密 |
| Gate ↔ Paid | ✓ | 使用加密 |

**加密判断**:
```pascal
constructor TPacketSender.Create(...; aboUseCrypt, aboServer: Boolean);
begin
   FboUseCrypt := aboUseCrypt;  // 是否启用加密
   FboServer := aboServer;      // 是否为服务端连接
end;
```

- 客户端连接: `aboUseCrypt = true`
- 服务端连接: 视具体连接而定（Gate↔Game 不加密，Gate↔DB/Login/Paid 加密）

### 4.4 缓冲区管理

#### TBuffer（环形缓冲区）

```pascal
TBuffer = class
   FPutSize, FGetSize: Integer;
   FSize: Integer;      // 缓冲区总大小
   FCount: Integer;     // 当前数据量
   ReadPos: Integer;    // 读位置
   WritePos: Integer;   // 写位置
   BufferPtr: PChar;    // 缓冲区指针
end;
```

**操作**:
- `Put`: 写入数据到缓冲区
- `Get`: 读取数据并移动读指针
- `View`: 查看数据但不移动读指针
- `Flush`: 丢弃数据并移动读指针

**环形缓冲**: 当 ReadPos 或 WritePos 到达缓冲区末尾时，自动回绕到开头。

#### TPacketBuffer（包缓冲区）

```pascal
TPacketBuffer = class
   FCount: Integer;
   ReadPos, WritePos: Integer;
   HavePacketSize: array[0..MAX_HAVE_PACKET - 1] of Integer;
   HavePacketBuffer: TBuffer;
end;
```

**功能**: 存储已解包的完整数据包，支持按包边界读取。

#### 接收流程

```pascal
procedure TPacketReceiver.Update;
begin
   while ReceiveBuffer.Count > 0 do begin
      // 1. 查找包头 0x28
      for i := iPos to nSize - 1 do begin
         if buffer[i] = PACKET_START then begin
            iStartPos := i + 1;
            break;
         end;
      end;
      
      // 2. 查找包尾 0x29
      for i := iPos to nSize - 1 do begin
         if buffer[i] = PACKET_END then begin
            iEndPos := i - 1;
            break;
         end;
      end;
      
      // 3. 解密数据包
      DeCryption(@buffer[iStartPos], @Packet, iEndPos - iStartPos + 1);
      
      // 4. 存入包缓冲区
      PacketBuffer.Put(@Packet, Packet.PacketSize);
   end;
end;
```

---

## 5. 服务间通信

### 5.1 TCP 连接架构

```
                    ┌─────────────┐
                    │   Balance   │
                    │  (TCP 3053) │
                    │  (UDP 3030) │
                    └──────┬──────┘
                           │ 客户端连接
                           ▼
┌──────────┐         ┌─────────────┐         ┌──────────┐
│  Client  │────────>│    Gate     │<────────│  Login   │
│          │  3053   │  (TCP 3054) │  3050   │(TCP 3050)│
└──────────┘         └──────┬──────┘         └──────────┘
                            │
              ┌─────────────┼─────────────┐
              │             │             │
              ▼             ▼             ▼
       ┌──────────┐  ┌──────────┐  ┌──────────┐
       │   Game   │  │    DB    │  │  Paid    │
       │(TCP 3052)│  │(TCP 3051)│  │(配置端口)│
       └──────────┘  └──────────┘  └──────────┘
```

### 5.2 端口分配

| 服务 | 端口 | 协议 | 说明 |
|------|:----:|:----:|------|
| **Balance** | 3053 | TCP | 负载均衡，客户端连接入口 |
| **Balance** | 3030 | UDP | 接收网关状态上报 |
| **Gate** | 3054 | TCP | 网关，客户端游戏连接 |
| **Login** | 3050 | TCP | 登录服务，账号验证 |
| **DB** | 3051 | TCP | 数据库服务，角色存档 |
| **Game** | 3052 | TCP | 游戏服务，游戏逻辑 |
| **Paid** | 配置决定 | TCP | 计费服务；Gate 新建配置时写入 5999，读取缺项时回退到 3049 |

### 5.3 UDP 通信

#### 网关状态上报

Gate 定期向 Balance 的 UDP 3030 端口发送状态信息：

```
格式: rMsg(Byte) + rIpAddr(20字节) + rPort(Integer) + rUserCount(Integer)

字段说明:
- rMsg: 消息类型（BM_GATEINFO = 0）
- rIpAddr: 网关IP地址（20字节，GBK编码）
- rPort: 网关端口（4字节，通常为3054）
- rUserCount: 当前用户数（4字节）
```

#### 日志记录

游戏事件通过 UDP 发送到日志服务器：

| 日志类型 | 端口 | 说明 |
|---------|:----:|------|
| ITEM | 6001 | 物品日志 |
| MOUSEEVENT | 6010 | 鼠标事件日志 |
| MONITER | 6011 | 监控日志 |
| CONNECT | 6022 | 连接日志 |
| PAY | 6000 | 支付日志 |
| OBJECT | 3003 | 对象日志 |
| RELATION | 3005 | 关系日志 |

### 5.4 服务间消息流

#### 登录流程

```
Client → Balance (3053)
  │ 请求网关信息
  ▼
Balance → Client
  │ 返回 Gate IP:Port (加密)
  ▼
Client → Gate (3054)
  │ 连接网关
  ▼
Gate → Login (3050)
  │ LG_SELECT，仅发送账号 PrimaryKey
  ▼
Login → Gate
  │ Login 自己查询 MSSQL 或 Login.sdb，返回 TLGRecord
  ▼
Gate
  │ 比对账号和密码，发送 LG_UPDATE 更新登录信息
  │ 随后向 Paid 发起 PM_CHECKPAID（启用计费校验时）
  ▼
Gate → Client
  │ 返回角色列表 (加密)
```

#### 游戏流程

```
Client → Gate (3054)
  │ 游戏操作（移动、攻击等）
  ▼
Gate → Game (3052)
  │ 转发游戏消息
  ▼
Game → Gate
  │ 返回游戏状态
  ▼
Gate → Client
  │ 返回游戏更新 (加密)
```

#### 存档流程

```
Game → Gate
  │ 请求保存角色数据
  ▼
Gate → DB (3051)
  │ 转发存档请求
  ▼
DB → Gate
  │ 返回存档结果
  ▼
Gate → Game
  │ 返回存档确认
```

### 5.5 配置文件

各服务的端口配置通过 INI 文件管理：

**BALANCE.INI**:
```ini
[BALANCE]
TCPLOCALPORT=3053
UDPLOCALPORT=3030
```

**GATE.INI**:
```ini
[GATE_SERVER]
LOCALIP=127.0.0.1
LOCALPORT=3054
SERVERNAME=<服务器显示名>
LIMITUSERCOUNT=0
LIMITPACKETCOUNT=10
CHECKPAIDINFO=TRUE
BUFFERSIZES2S=16384
BUFFERSIZES2C=8192
BALANCEIP=127.0.0.1
BALANCEPORT=3030

[GAME_SERVER]
REMOTEIP=127.0.0.1
REMOTEPORT=3052

[DB_SERVER]
REMOTEIP=127.0.0.1
REMOTEPORT=3051

[LOGIN_SERVER]
REMOTEIP=127.0.0.1
REMOTEPORT=3050

[PAID_SERVER]
REMOTEIP=127.0.0.1
REMOTEPORT=5999
LOCALPORT=5998
```

`REMOTEPORT=5999` 是缺少 `GATE.INI` 时生成的模板值；读取已有配置且该键缺失时，源码缺省值是 3049。`LOCALPORT=5998` 会被生成，但当前 Gate 源码没有读取或使用该键。`LIMITPACKETCOUNT` 是配置阈值，不代表当前环形采样实现能够稳定执行一秒限包，实际缺陷见架构文档。

Gate 还读取两个独立文件：

```ini
; Village.INI
[VILLAGE]
COUNT=1
NAME0=<出生村名>
X0=513
Y0=205
ServerID0=0

; CreateChar.INI
[CLOTHES]
CLOTHES_COAT_MAN=COATMAN
CLOTHES_PANTS_MAN=PANTSMAN
CLOTHES_COAT_WOMAN=COATWOMAN
CLOTHES_PANTS_WOMAN=PANTSWOMAN
[WEAPON]
WEAPON_SWORD=SWORD
WEAPON_KNIFE=KNIFE
WEAPON_SPEAR=SPEAR
WEAPON_AX=AX
[ETC]
ETC_01=ETC01
```

**DB.INI**:
```ini
[DB_SERVER]
FileName=TESTDB.FDB
BufferSizeS2S=1048576
GateAcceptPort=3051
RemotePort=1024
ItemRemotePort=1020
```

**SDB Login 的 login.ini**（`loginsdb_biscuit`）：
```ini
[ODBC]
DSN=account1000y
UserName=sa
Password=sa

[SERVER]
CLIENTACCEPTPORT=3050
REMOTEACCEPTPORT=1021
```

该实现读取 `REMOTEACCEPTPORT` 并监听远程连接，但数据库对象创建代码已被注释，账号实际由 `TSDBAdapter` 管理；`ODBC` 三个键仍会读取，却不用于建立 SQL 连接。

**SQL Login 的 login.ini**（`loginsql`）：

```ini
[ODBC]
DSN=account1000y
UserName=<SimplePass 编码值>
Password=<SimplePass 编码值>

[SERVER]
CLIENTACCEPTPORT=3050

[REMOTE_SERVER]
IP=127.0.0.1
PORT=6060
```

SQL 实现不会读取 `REMOTEACCEPTPORT`；它读取 `[REMOTE_SERVER]`，并作为客户端主动连接该地址。`UserName` 和 `Password` 在交给 BDE/ODBC 前都会调用 `SimplePass.Decode`，不能把示例中的明文 `sa` 当成已验证可用的部署值。

---

## 6. 数据结构参考

### 6.1 基本数据类型

| Delphi 类型 | 大小 | Python 对应 | 说明 |
|------------|:----:|------------|------|
| Byte | 1 | `B` | 无符号字节 |
| Word | 2 | `H` | 无符号短整数 |
| Integer | 4 | `i` | 有符号整数 |
| LongInt | 4 | `i` | 有符号长整数 |
| Boolean | 1 | `?` | 布尔值 |

### 6.2 字符串类型

| 类型 | 大小 | 说明 |
|------|:----:|------|
| TNameString | 19字节 | 角色名（中文9字符，GBK编码） |
| TCaptionString | 40字节 | 标题（中文20字符，GBK编码） |
| TWordString | 最多4096字节 | 内存类型为固定数组；线上有效数据是“2字节小端长度 + 文本字节”，文本从偏移2开始 |

`SetWordString` 把文本长度写入 `[0..1]`，`SizeofWordString` 返回“文本长度 + 2”。`GetWordString` 会在内存中临时写入 null 以便转换，但 null 不属于必须发送的有效载荷。

**注意**: 当前中国版程序和随附数据使用 GBK/CP936 兼容编码，不是 UTF-8。

### 6.3 TFeature 结构

角色外观特征：

```pascal
TFeature = packed record
   rrace: byte;                     // 种族（人、怪物、NPC等）
   raninumber: byte;                // 动画编号
   rfeaturestate: TFeatureState;    // 状态（正常、战斗、死亡等）
   rboman: Boolean;                 // 性别（男/女）
   rhitmotion: byte;                // 攻击动作
   rArr: array[0..31] of byte;      // 外观数组（图像+颜色）
   rImageNumber: word;              // 图像编号
   rImageColorIndex: byte;          // 颜色索引
   rTeamColor: word;                // 门派颜色
   rNameColor: word;                // 名字颜色
   rHideState: THiddenState;        // 隐藏状态
   rActionState: TActionState;      // 动作状态
   rEffectNumber: word;             // 特效编号
   rEffectKind: TLightEffectKind;   // 特效类型
   rFlyHeight: Word;                // 飞行高度
end;
```

---

## 7. 常见问题

### 7.1 数据包解析失败

**问题**: 解密后数据长度不正确

**原因**: 
- 加密数据长度不是4的倍数
- 字节值超出有效范围（59-122）

**解决**: 
- 确保正确识别 `0x28` 和 `0x29` 边界
- 验证所有加密字节在有效范围内

### 7.2 中文乱码

**问题**: 角色名、物品名显示乱码

**原因**: 使用 UTF-8 解码 GBK 编码的字符串

**解决**: 
```python
# 错误
name = data.decode('utf-8')

# 正确
name = data.decode('gbk').rstrip('\x00')
```

### 7.3 版本号不匹配

**问题**: 连接后被服务器断开

**原因**: 客户端版本号与目标 Gate 的实际构建版本不一致

**解决**: 
- 检查目标 Gate 使用的 `PROGRAM_VERSION` 和 `NATION_VERSION`
- 仓库 `deftype.pas` 当前启用 40，旁边保留注释值 39；用户确认当前线上炎黄 Gate 要求 39
- 不要以仓库源码常量替代线上部署确认值

---

## 8. 附录

### 8.1 加密表示例

前10个加密表值（基于 LCG 种子=1）：

| 索引 | 加密值 | ASCII |
|:----:|:------:|:-----:|
| 0 | 91 | '[' |
| 1 | 75 | 'K' |
| 2 | 104 | 'h' |
| 3 | 67 | 'C' |
| 4 | 112 | 'p' |
| 5 | 83 | 'S' |
| 6 | 59 | ';' |
| 7 | 98 | 'b' |
| 8 | 118 | 'v' |
| 9 | 71 | 'G' |

**完整加密算法**：以 `Common/uCrypt.pas` 为源码标准；Python 版本只用于辅助分析和兼容性验证。

### 8.2 数据包示例

**登录请求**（CM_IDPASS；`RequestID` 取当前连接的 `SendPacketCount`）：
```
44 00  xx xx xx xx  00  00  3A 00  03 ...
|Size|  | RequestID | Msg Ret |ComData|CM_IDPASS...

加密后: 28 [加密字节流] 29
```

客户端先把 58 字节 `TCIdPass`（`rmsg` + 3 个 19 字节 `TNameString`）封装进 `TWordComData`，所以 Data 为 60 字节，完整 `TPacketData.PacketSize` 为 68（`0x0044`）。外层 `RequestMsg` 为 0，`CM_IDPASS=3` 位于 `TWordComData.Data` 的第一个字节。每次建立连接时 `SendPacketCount` 重置为 0，并在每次 `PutPacket` 后递增，因此不能把登录包的 `RequestID` 固定写成 0。

**角色移动** (CM_MOVE):
```
外层 RequestMsg = 0
Data:
  TWordComData.Size (2字节，小端，值为 sizeof(TCMove)=11)
  TCMove.rmsg       (1字节，CM_MOVE=11)
  TCMove.rdir       (2字节)
  TCMove.rx         (2字节)
  TCMove.ry         (2字节)
  TCMove.rTick      (4字节，客户端写入移动校验值)
```

客户端在 `FLogOn.SocketAddData` 中把完整 `TCMove` 复制到 `TWordComData.Data`，再以 `PutPacket(RequestMsg=0, ResultCode=0)` 发送，不能把 `CM_MOVE` 当作外层包头字段。

### 8.3 相关文档

- [客户端连接与通信](client-communication.md) — 按客户端源码说明入口配置、重定向、登录和收发调用链
- [消息类型常量](constants/MESSAGES.md) — 完整的 SM_*/CM_*/FM_* 常量列表
- [数据结构定义](deftype.pas) — deftype.pas 的详细文档
- [Balance 服务](../../py1000y/balance/README.md) — 负载均衡服务说明
- [Gate 服务](../../py1000y/gate/README.md) — 网关服务说明
- [Python CLI 客户端](../../py1000y/client/README.md) — 炎黄协议联调入口与当前实现范围

---

**文档版本**: 1.0  
**最后更新**: 2026-02  
**源码版本**: 1000y Delphi 7  
**协议版本**: 仓库源码 40；当前线上炎黄部署 39
