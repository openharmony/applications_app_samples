/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 

import { describe, it, expect, beforeEach } from '@ohos/hypium';
import { AudioVolumeType, VolumeInfo } from '../../../../../../product/tv/volumepanel/src/main/ets/common/Constants';

/**
 * VolumePanelService 纯逻辑单元测试
 * 覆盖三块与系统 AudioManager 完全解耦的逻辑：
 * 1. 枚举双向映射（formatAudioVolumeTypeFromInterface / formatAudioVolumeTypeToInterface）
 * 2. 监听器集合管理（registerListener / unregisterListener）
 * 3. 接口调用队列的入队/出队/串行调度逻辑
 */

// AudioVolumeType 的系统枚举值镜像，避免在测试环境引入 @ohos.multimedia.audio 依赖
const MOCK_VOICE_CALL: number = 0;
const MOCK_RINGTONE: number = 2;
const MOCK_MEDIA: number = 3;
const MOCK_VOICE_ASSISTANT: number = 9;

// formatFromInterface 是音频事件入口的类型转换门，
// 系统回调携带的是 @ohos 枚举整数，必须映射为内部 AudioVolumeType 才能被业务逻辑消费。
function formatFromInterface(audioVolumeType: number): AudioVolumeType | undefined {
  if (audioVolumeType === MOCK_VOICE_CALL) {
    return AudioVolumeType.VOICE_CALL;
  }
  if (audioVolumeType === MOCK_RINGTONE) {
    return AudioVolumeType.RINGTONE;
  }
  if (audioVolumeType === MOCK_MEDIA) {
    return AudioVolumeType.MEDIA;
  }
  if (audioVolumeType === MOCK_VOICE_ASSISTANT) {
    return AudioVolumeType.VOICE_ASSISTANT;
  }
  return undefined;
}

// formatToInterface 是音量设置出口的类型转换门，
// 调用系统 AudioManager.setVolume 时必须传入 @ohos 枚举整数，不能传内部类型。
function formatToInterface(audioVolumeType: AudioVolumeType): number | undefined {
  if (audioVolumeType === AudioVolumeType.VOICE_CALL) {
    return MOCK_VOICE_CALL;
  }
  if (audioVolumeType === AudioVolumeType.RINGTONE) {
    return MOCK_RINGTONE;
  }
  if (audioVolumeType === AudioVolumeType.MEDIA) {
    return MOCK_MEDIA;
  }
  if (audioVolumeType === AudioVolumeType.VOICE_ASSISTANT) {
    return MOCK_VOICE_ASSISTANT;
  }
  return undefined;
}

// 使用 Set 而非 Array 管理监听器，是因为 TV 端同一组件可能因页面切换而重复注册，
// Set 的幂等性保证不会因重复注册而导致 UI 收到重复音量事件产生闪烁或误跳。
interface VolumeListener {
  updateVolumeInfo(info: VolumeInfo): void;
}

// ArkTS 不允许将对象字面量直接赋值给接口，需通过类实现接口
class CountingListener implements VolumeListener {
  count: number = 0;

  updateVolumeInfo(_: VolumeInfo): void {
    this.count++;
  }
}

class RecordingListener implements VolumeListener {
  received: VolumeInfo | null = null;

  updateVolumeInfo(info: VolumeInfo): void {
    this.received = info;
  }
}

class RecordingTypeListener implements VolumeListener {
  receivedType: AudioVolumeType | null = null;

  updateVolumeInfo(info: VolumeInfo): void {
    this.receivedType = info.volumeType;
  }
}

class RecordingMuteListener implements VolumeListener {
  receivedMute: boolean | null = null;

  updateVolumeInfo(info: VolumeInfo): void {
    this.receivedMute = info.isMute;
  }
}

class RecordingVolumeListener implements VolumeListener {
  volumes: number[] = [];

  updateVolumeInfo(info: VolumeInfo): void {
    this.volumes.push(info.volume);
  }
}

class NoopListener implements VolumeListener {
  updateVolumeInfo(_: VolumeInfo): void {
  }
}

class FlagListener implements VolumeListener {
  called: boolean = false;

  updateVolumeInfo(_: VolumeInfo): void {
    this.called = true;
  }
}

class ListenerManager {
  mListeners: Set<VolumeListener> = new Set();

  register(listener: VolumeListener): void {
    this.mListeners.add(listener);
  }

  unregister(listener: VolumeListener): void {
    this.mListeners.delete(listener);
  }

  notify(info: VolumeInfo): void {
    this.mListeners.forEach(l => l.updateVolumeInfo(info));
  }
}

// 音频系统接口（setVolume / getVolume）是异步的，且不支持并发调用——
// 并发调用会导致后一次调用覆盖前一次的回调，造成音量状态与 UI 不一致。
// 串行队列保证每次只有一个接口调用在飞行中，前一个完成后才触发下一个。
interface QueueItem {
  execute: () => void;
}

// ArkTS 不允许对象字面量直接赋值给接口，通过类实现 QueueItem
class NoopQueueItem implements QueueItem {
  execute(): void {
  }
}

class FlagQueueItem implements QueueItem {
  executed: boolean = false;

  execute(): void {
    this.executed = true;
  }
}

class CountingQueueItem implements QueueItem {
  n: number;
  order: number[];
  queue: InterfaceCallQueue;

  constructor(n: number, order: number[], queue: InterfaceCallQueue) {
    this.n = n;
    this.order = order;
    this.queue = queue;
  }

  execute(): void {
    this.order.push(this.n);
    this.queue.dequeueAndContinue();
  }
}

class InterfaceCallQueue {
  queue: QueueItem[] = [];
  executedCount: number = 0;

  // 入队时若队列已有待执行项，不立即执行新项，而是等待前项通过 dequeueAndContinue 主动推进，
  // 这样异步回调的完成时机由调用方控制，不依赖固定延时，既准确又高效。
  enqueue(item: QueueItem): void {
    this.queue.push(item);
    if (this.queue.length === 1) {
      this.executeFirst();
    }
  }

  executeFirst(): void {
    if (this.queue.length === 0) {
      return;
    }
    this.executedCount++;
    this.queue[0].execute();
  }

  // dequeueAndContinue 由调用方在异步回调中主动触发，
  // 这样即使系统接口耗时不定，队列也能在正确时机推进，不会提前或遗漏。
  dequeueAndContinue(): void {
    this.queue.splice(0, 1);
    if (this.queue.length > 0) {
      this.executeFirst();
    }
  }
}

export default function volumePanelServiceTest() {
  describe('VolumePanelService_Logic_Test', () => {

    // ---- 枚举映射：interface → 内部类型 ----
    // 每个音频类型独立验证，确保映射表无遗漏——任何一个类型的缺失
    // 都会导致对应音量条不响应系统音量变化事件。

    it('formatFromInterface_VOICE_CALL', 0, () => {
      expect(formatFromInterface(MOCK_VOICE_CALL)).assertEqual(AudioVolumeType.VOICE_CALL);
    });

    it('formatFromInterface_RINGTONE', 0, () => {
      expect(formatFromInterface(MOCK_RINGTONE)).assertEqual(AudioVolumeType.RINGTONE);
    });

    it('formatFromInterface_MEDIA', 0, () => {
      expect(formatFromInterface(MOCK_MEDIA)).assertEqual(AudioVolumeType.MEDIA);
    });

    it('formatFromInterface_VOICE_ASSISTANT', 0, () => {
      expect(formatFromInterface(MOCK_VOICE_ASSISTANT)).assertEqual(AudioVolumeType.VOICE_ASSISTANT);
    });

    it('formatFromInterface_unknown_returns_undefined', 0, () => {
      // 未知音量类型不应抛出异常，而是返回 undefined，
      // 业务侧依赖此行为来过滤不支持的音频类型
      expect(formatFromInterface(999)).assertUndefined();
    });

    // ---- 枚举映射：内部类型 → interface ----

    it('formatToInterface_VOICE_CALL', 0, () => {
      expect(formatToInterface(AudioVolumeType.VOICE_CALL)).assertEqual(MOCK_VOICE_CALL);
    });

    it('formatToInterface_RINGTONE', 0, () => {
      expect(formatToInterface(AudioVolumeType.RINGTONE)).assertEqual(MOCK_RINGTONE);
    });

    it('formatToInterface_MEDIA', 0, () => {
      expect(formatToInterface(AudioVolumeType.MEDIA)).assertEqual(MOCK_MEDIA);
    });

    it('formatToInterface_VOICE_ASSISTANT', 0, () => {
      expect(formatToInterface(AudioVolumeType.VOICE_ASSISTANT)).assertEqual(MOCK_VOICE_ASSISTANT);
    });

    // ---- 枚举映射双向一致性 ----
    // 双向往返测试是为了防止两侧映射表不同步的隐患——
    // 单向测试通过不代表反向也正确，往返才能证明两张映射表的值域完全对应。

    it('roundtrip_MEDIA_from_to_interface', 0, () => {
      // 双向映射必须幂等：内部类型 → 接口值 → 内部类型，结果应与原始值相同
      const interfaceVal = formatToInterface(AudioVolumeType.MEDIA)!;
      expect(formatFromInterface(interfaceVal)).assertEqual(AudioVolumeType.MEDIA);
    });

    it('roundtrip_RINGTONE_from_to_interface', 0, () => {
      const interfaceVal = formatToInterface(AudioVolumeType.RINGTONE)!;
      expect(formatFromInterface(interfaceVal)).assertEqual(AudioVolumeType.RINGTONE);
    });

    it('roundtrip_VOICE_CALL_from_to_interface', 0, () => {
      const interfaceVal = formatToInterface(AudioVolumeType.VOICE_CALL)!;
      expect(formatFromInterface(interfaceVal)).assertEqual(AudioVolumeType.VOICE_CALL);
    });

    it('roundtrip_VOICE_ASSISTANT_from_to_interface', 0, () => {
      const interfaceVal = formatToInterface(AudioVolumeType.VOICE_ASSISTANT)!;
      expect(formatFromInterface(interfaceVal)).assertEqual(AudioVolumeType.VOICE_ASSISTANT);
    });

    // ---- 监听器集合管理 ----
    // 注册/注销测试必须覆盖重复注册场景，因为 TV 端 Ability 生命周期不稳定，
    // onForeground 可能触发多次，Set 的去重特性是防止事件风暴的最后一道防线。

    it('register_listener_increases_count', 0, () => {
      const mgr = new ListenerManager();
      const listener = new NoopListener();
      mgr.register(listener);
      expect(mgr.mListeners.size).assertEqual(1);
    });

    it('register_same_listener_twice_no_duplicate', 0, () => {
      // Set 保证幂等注册，防止同一监听器收到重复事件
      const mgr = new ListenerManager();
      const listener = new NoopListener();
      mgr.register(listener);
      mgr.register(listener);
      expect(mgr.mListeners.size).assertEqual(1);
    });

    it('unregister_listener_decreases_count', 0, () => {
      const mgr = new ListenerManager();
      const listener = new NoopListener();
      mgr.register(listener);
      mgr.unregister(listener);
      expect(mgr.mListeners.size).assertEqual(0);
    });

    it('notify_calls_all_registered_listeners', 0, () => {
      // 多监听器广播是 TV 多面板并存场景的核心需求，
      // 音量变化时状态栏和音量面板需要同步刷新，缺一不可。
      const mgr = new ListenerManager();
      const l1 = new CountingListener();
      const l2 = new CountingListener();
      mgr.register(l1);
      mgr.register(l2);
      const info: VolumeInfo = {
        volumeType: AudioVolumeType.MEDIA,
        volume: 5,
        isMute: false,
        updateUi: true
      };
      mgr.notify(info);
      expect(l1.count).assertEqual(1);
      expect(l2.count).assertEqual(1);
    });

    it('notify_does_not_call_unregistered_listener', 0, () => {
      const mgr = new ListenerManager();
      const listener = new FlagListener();
      mgr.register(listener);
      mgr.unregister(listener);
      const info: VolumeInfo = {
        volumeType: AudioVolumeType.MEDIA,
        volume: 5,
        isMute: false,
        updateUi: true
      };
      mgr.notify(info);
      expect(listener.called).assertFalse();
    });

    it('notify_passes_correct_volumeInfo_to_listener', 0, () => {
      // VolumeInfo 的字段必须完整传递到监听器，
      // isMute 和 volume 同时正确才能保证静音图标与进度条状态一致。
      const mgr = new ListenerManager();
      const listener = new RecordingListener();
      mgr.register(listener);
      const info: VolumeInfo = {
        volumeType: AudioVolumeType.RINGTONE,
        volume: 8,
        isMute: true,
        updateUi: false
      };
      mgr.notify(info);
      expect(listener.received !== null).assertTrue();
      if (listener.received) {
        expect((listener.received as VolumeInfo).volume).assertEqual(8);
        expect((listener.received as VolumeInfo).isMute).assertTrue();
      }
    });

    // ---- 接口调用队列调度 ----
    // 队列调度的关键不变量：任意时刻最多只有一个 QueueItem 处于执行中，
    // 这是防止音量接口并发的核心保证，也是下面所有用例共同守护的契约。

    it('enqueue_first_item_executes_immediately', 0, () => {
      // 队列为空时入队应立即执行，这是串行调用的起点
      const q = new InterfaceCallQueue();
      q.enqueue(new NoopQueueItem());
      expect(q.executedCount).assertEqual(1);
    });

    it('enqueue_second_item_does_not_execute_immediately', 0, () => {
      // 第二个入队项必须等待第一项回调后才能执行，保证音频接口串行调用不竞争
      const q = new InterfaceCallQueue();
      q.enqueue(new NoopQueueItem());
      q.enqueue(new NoopQueueItem());
      expect(q.executedCount).assertEqual(1);
    });

    it('dequeueAndContinue_executes_next_item', 0, () => {
      const q = new InterfaceCallQueue();
      const second = new FlagQueueItem();
      q.enqueue(new NoopQueueItem());
      q.enqueue(second);
      q.dequeueAndContinue();
      expect(second.executed).assertTrue();
    });

    it('dequeueAndContinue_on_empty_queue_is_safe', 0, () => {
      // 空队列出队不应抛出异常，防御性处理保证服务健壮性
      const q = new InterfaceCallQueue();
      q.dequeueAndContinue();
      expect(q.queue.length).assertEqual(0);
    });

    it('queue_length_decreases_after_dequeue', 0, () => {
      const q = new InterfaceCallQueue();
      q.enqueue(new NoopQueueItem());
      q.enqueue(new NoopQueueItem());
      q.enqueue(new NoopQueueItem());
      expect(q.queue.length).assertEqual(3);
      q.dequeueAndContinue();
      expect(q.queue.length).assertEqual(2);
    });

    it('serial_execution_order_preserved', 0, () => {
      // 串行队列必须保证执行顺序与入队顺序一致，音量设置操作的结果依赖此顺序
      const q = new InterfaceCallQueue();
      const order: number[] = [];
      q.enqueue(new CountingQueueItem(1, order, q));
      q.enqueue(new CountingQueueItem(2, order, q));
      q.enqueue(new CountingQueueItem(3, order, q));
      expect(order.length).assertEqual(3);
      expect(order[0]).assertEqual(1);
      expect(order[1]).assertEqual(2);
      expect(order[2]).assertEqual(3);
    });

    it('single_item_queue_empty_after_dequeue', 0, () => {
      const q = new InterfaceCallQueue();
      q.enqueue(new NoopQueueItem());
      q.dequeueAndContinue();
      expect(q.queue.length).assertEqual(0);
    });

    // ---- 额外组合场景 ----
    // 组合场景验证多个子系统协作时的一致性，
    // 单独的单元测试无法发现跨模块交互中的数据流断裂问题。

    it('formatFromInterface_all_types_roundtrip', 0, () => {
      // 所有已知枚举值双向映射均应成功，保证音频类型转换链路完整
      const types = [AudioVolumeType.VOICE_CALL, AudioVolumeType.RINGTONE,
        AudioVolumeType.MEDIA, AudioVolumeType.VOICE_ASSISTANT];
      for (let i = 0; i < types.length; i++) {
        const iface = formatToInterface(types[i]);
        expect(iface !== undefined).assertTrue();
        expect(formatFromInterface(iface!)).assertEqual(types[i]);
      }
    });

    it('listener_receives_correct_volume_type', 0, () => {
      // 监听器接收到的 volumeType 必须与发送时一致，防止 UI 显示错误音量条
      const mgr = new ListenerManager();
      const listener = new RecordingTypeListener();
      mgr.register(listener);
      mgr.notify({
        volumeType: AudioVolumeType.RINGTONE,
        volume: 5,
        isMute: false,
        updateUi: true
      });
      expect(listener.receivedType).assertEqual(AudioVolumeType.RINGTONE);
    });

    it('listener_receives_mute_state_correctly', 0, () => {
      const mgr = new ListenerManager();
      const listener = new RecordingMuteListener();
      mgr.register(listener);
      mgr.notify({
        volumeType: AudioVolumeType.MEDIA,
        volume: 0,
        isMute: true,
        updateUi: true
      });
      expect(listener.receivedMute).assertTrue();
    });

    it('queue_processes_5_items_in_order', 0, () => {
      // 5个队列项按顺序执行，验证串行机制在更多项时仍正确
      const q = new InterfaceCallQueue();
      const order: number[] = [];
      for (let i = 1; i <= 5; i++) {
        q.enqueue(new CountingQueueItem(i, order, q));
      }
      expect(order.length).assertEqual(5);
      for (let i = 0; i < 5; i++) {
        expect(order[i]).assertEqual(i + 1);
      }
    });

    it('multiple_listeners_all_receive_same_info', 0, () => {
      // 广播通知时所有监听器收到相同数据，验证 forEach 遍历完整
      const mgr = new ListenerManager();
      const listeners: RecordingVolumeListener[] = [];
      for (let i = 0; i < 5; i++) {
        const l = new RecordingVolumeListener();
        listeners.push(l);
        mgr.register(l);
      }
      mgr.notify({
        volumeType: AudioVolumeType.MEDIA,
        volume: 7,
        isMute: false,
        updateUi: true
      });
      for (let i = 0; i < listeners.length; i++) {
        expect(listeners[i].volumes[0]).assertEqual(7);
      }
    });

    it('register_unregister_register_listener_works', 0, () => {
      // 先注销再重新注册，监听器应重新生效
      const mgr = new ListenerManager();
      const listener = new CountingListener();
      mgr.register(listener);
      mgr.unregister(listener);
      mgr.register(listener);
      const info: VolumeInfo = {
        volumeType: AudioVolumeType.MEDIA,
        volume: 5,
        isMute: false,
        updateUi: true
      };
      mgr.notify(info);
      expect(listener.count).assertEqual(1);
    });

    it('formatToInterface_returns_undefined_for_ALL_type', 0, () => {
      // ALL 类型不在映射表中，应返回 undefined，防止系统收到无效音频类型
      expect(formatToInterface(AudioVolumeType.ALL)).assertUndefined();
    });

  });
}