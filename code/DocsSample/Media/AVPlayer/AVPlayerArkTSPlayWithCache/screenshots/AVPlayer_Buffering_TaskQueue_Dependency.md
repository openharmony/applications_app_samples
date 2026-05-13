# AVPlayer Prepare缓冲流程与任务队列循环依赖问题

## 流程图

```mermaid
flowchart TB
    subgraph Prepare阶段
        A1[用户调用 prepare] --> A2[Prepare任务进入队列<br/>类型: STATE_CHANGE]
        A2 --> A3[PrepareAsync 开始执行]
        A3 --> A4[NotifyBufferingUpdate<br/>BUFFERING_START]
        A4 --> A5[Demuxer 开始缓冲数据]
        A5 --> A6[缓冲完成<br/>NotifyBufferingUpdate<br/>BUFFERING_END]
        A6 --> A7{问题点1<br/>BUFFERING_END触发}
        A7 --> A8[OnNotifyBufferingEnd<br/>创建 ResumeDemuxer 任务]
        A8 --> A9[ResumeDemuxer 任务<br/>进入 pending 队列<br/>等待 Prepare 完成]
        A3 --> A10[OnStateChanged READY]
        A10 --> A11[OnPrepareDone]
        A11 --> A12[MarkTaskDone Prepare]
        A12 --> A13[ResumeDemuxer 任务<br/>从队列取出执行]
        A13 --> A14[ResumeDemuxerReadLoop<br/>Demuxer恢复读取]
    end
    
    subgraph Play阶段
        B1[用户调用 play] --> B2[Play任务进入队列<br/>类型: STATE_CHANGE]
        B2 --> B3[Play任务等待<br/>ResumeDemuxer完成]
        A14 --> B4[MarkTaskDone<br/>ResumeDemuxer]
        B4 --> B5[Play任务开始执行]
        B5 --> B6[PlayInternal]
        B6 --> B7{问题点2<br/>isInitialPlay = true}
        B7 --> B8[不立即切换到PLAYING<br/>等待首帧回调]
        B8 --> B9[Play任务未调用<br/>MarkTaskDone<br/>任务仍占用队列]
    end
    
    subgraph 首帧等待阶段
        C1[解码器需要数据] --> C2[请求 Demuxer 提供数据]
        C2 --> C3{问题点3<br/>循环依赖}
        C3 --> C4[Demuxer 需要<br/>ResumeDemuxer恢复]
        C4 --> C5[ResumeDemuxer需要<br/>Play任务完成]
        C5 --> C6[Play任务完成需要<br/>首帧回调]
        C6 --> C7[首帧需要<br/>Demuxer提供数据]
        C7 --> C3
    end
    
    subgraph 阻塞结果
        D1[❌ 队列被阻塞] --> D2[Play任务未完成<br/>pending队列任务无法执行]
        D2 --> D3[ResumeDemuxer无法执行]
        D3 --> D4[Demuxer无法恢复]
        D4 --> D5[无法产生首帧]
        D5 --> D6[Play继续等待]
        D6 --> D1
    end
    
    A14 --> B1
    B9 --> C1
    C3 -.->|循环依赖| D1
    
    style A7 fill:#ff6b6b
    style B7 fill:#ff6b6b  
    style C3 fill:#ff6b6b
    style D1 fill:#ff6b6b
```

## 问题说明

### 循环依赖链：

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│  Play任务未完成 (等待首帧)                                │
│         ↓                                               │
│  队列中 ResumeDemuxer 无法执行                           │
│         ↓                                               │
│  Demuxer 未恢复读取                                      │
│         ↓                                               │
│  无法产生首帧                                            │
│         ↓                                               │
│  Play任务继续等待                                        │
│         ↓                                               │
│  🔁 回到起点，形成死锁                                    │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### 三个关键问题点：

| 问题点 | 触发位置 | 原因 |
|-------|---------|------|
| **问题点1** | Prepare完成时触发BUFFERING_END | Prepare阶段不应触发BUFFERING_END，导致提前创建ResumeDemuxer任务 |
| **问题点2** | Play执行时isInitialPlay=true | Play不立即切换状态，等待首帧，导致未调用MarkTaskDone |
| **问题点3** | 任务队列串行执行机制 | ResumeDemuxer依赖Play完成，Play依赖首帧，首帧依赖ResumeDemuxer |

### 任务队列状态图：

```
时间轴:
────────────────────────────────────────────────────────────────→
  
  T1: Prepare执行中
      ├─ currTask: Prepare
      └─ pending: []
      
  T2: BUFFERING_END触发
      ├─ currTask: Prepare
      └─ pending: [ResumeDemuxer]  ⚠️ 进入队列
      
  T3: Prepare完成
      ├─ currTask: ResumeDemuxer
      └─ pending: []
      
  T4: 用户调用play()
      ├─ currTask: ResumeDemuxer
      └─ pending: [Play]  ⚠️ 进入队列
      
  T5: ResumeDemuxer完成
      ├─ currTask: Play
      └─ pending: []
      
  T6: Play等待首帧 ⚠️ 卡住
      ├─ currTask: Play (未完成)
      └─ pending: [后续任务无法执行]
      
  T7+ : 死锁状态
       Play无法完成 → ResumeDemuxer无法再次执行 → 无首帧
```

## 问题根因分析

### 核心代码位置

| 文件 | 功能 |
|------|------|
| `hiplayer_impl.cpp:716-768` | PrepareAsync实现 |
| `hiplayer_impl.cpp:2897-2918` | BUFFERING_END事件处理 |
| `player_server.cpp:2134-2146` | OnNotifyBufferingEnd |
| `player_server_task_mgr.cpp:73-103` | 任务队列LaunchTask |
| `hiplayer_impl.cpp:2941-2977` | HandleInitialPlayingStateChange |

### 关键代码片段

**1. BUFFERING_END触发ResumeDemuxer (hiplayer_impl.cpp:2897-2910)**

```cpp
case EventType::BUFFERING_END : {
    isBufferingEnd_ = true;
    if (!isBufferingStartNotified_.load() || isSeekClosest_.load()) {
        break;  // ✅ 正常情况应该break，但prepare时可能触发
    }
    NotifyBufferingEnd(AnyCast<int32_t>(event.param));  // ❌ 触发ResumeDemuxer任务
}
```

**2. ResumeDemuxer任务创建 (player_server.cpp:2134-2146)**

```cpp
void PlayerServer::OnNotifyBufferingEnd() {
    auto playingTask = std::make_shared<TaskHandler<void>>([this]() {
        auto currState = std::static_pointer_cast<BaseState>(GetCurrState());
        (void)currState->ResumeDemuxer();  // ❌ 进入任务队列
    });
    taskMgr_.LaunchTask(playingTask, PlayerServerTaskType::LIGHT_TASK, "ResumeDemuxer");
}
```

**3. 任务队列机制 (player_server_task_mgr.cpp:73-103)**

```cpp
int32_t PlayerServerTaskMgr::LaunchTask(...) {
    if (currTwoPhaseTask_ == nullptr) {
        return EnqueueTask(task, type, taskName);  // 直接执行
    }
    // ❌ 当前有任务，放入pending队列
    pendingTwoPhaseTasks_.push_back({ type, task, nullptr, taskName });
}
```

**4. Play等待首帧 (hiplayer_impl.cpp:998-1007)**

```cpp
if (ret == MSERR_OK) {
    if (!isInitialPlay_) {
        OnStateChanged(PlayerStateId::PLAYING);  // ✅ 直接切换
    } else {
        MEDIA_LOG_D_SHORT("InitialPlay, pending to change state of playing");  
        // ❌ 等待首帧，不调用MarkTaskDone
    }
}
```

## 死锁形成原因总结

这就是 prepare 缓冲结束后，ResumeDemuxer 任务进入队列，但 Play 任务需要首帧才能完成，而首帧需要 ResumeDemuxer 恢复 Demuxer 读取，形成了循环依赖导致死锁。

**完整的循环依赖链**：
```
Play任务未完成(等待首帧) 
→ 队列中ResumeDemuxer无法执行
→ Demuxer未恢复读取
→ 无法产生首帧
→ Play任务继续等待
→ ♻️ 循环阻塞
```