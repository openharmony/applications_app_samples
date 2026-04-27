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

export interface ServiceActionRecord {
  type: string
  detail: string
  code: number
}

export class DoubleClickHarness {
  private timeout: number
  private firstClickTime: number = -1
  private callbackCount: number = 0

  constructor(timeout: number) {
    this.timeout = timeout;
  }

  handleClick(now: number): void {
    if (this.firstClickTime < 0) {
      this.firstClickTime = now;
      return;
    }
    const interval = now - this.firstClickTime;
    if (interval < this.timeout) {
      this.callbackCount += 1;
    }
    this.firstClickTime = -1;
  }

  reset(): void {
    this.firstClickTime = -1;
    this.callbackCount = 0;
  }

  getCallbackCount(): number {
    return this.callbackCount;
  }
}

export class InputShortcutGateHarness {
  private keyA: number
  private keyB: number
  private isDownKeyA: boolean = false
  private isDownKeyB: boolean = false
  private gateOpen: boolean = true
  private triggerCount: number = 0
  private records: ServiceActionRecord[] = []

  constructor(keyA: number, keyB: number) {
    this.keyA = keyA;
    this.keyB = keyB;
  }

  feed(keyCode: number, isDown: boolean): void {
    if (keyCode === this.keyA) {
      this.isDownKeyA = isDown;
      this.records.push({ type: 'key', detail: `A_${isDown ? 'down' : 'up'}`, code: keyCode });
      if (!isDown) {
        this.gateOpen = true;
      }
    }
    if (keyCode === this.keyB) {
      this.isDownKeyB = isDown;
      this.records.push({ type: 'key', detail: `B_${isDown ? 'down' : 'up'}`, code: keyCode });
      if (!isDown) {
        this.gateOpen = true;
      }
    }
    if (this.isDownKeyA && this.isDownKeyB && this.gateOpen) {
      this.gateOpen = false;
      this.triggerCount += 1;
      this.records.push({ type: 'trigger', detail: 'combo', code: this.triggerCount });
    }
  }

  getTriggerCount(): number {
    return this.triggerCount;
  }

  getRecords(): ServiceActionRecord[] {
    return this.records.slice();
  }
}

export class AbilityRequestHarness {
  private recording: boolean = false
  private terminated: number = 0
  private errorScheduled: boolean = false
  private records: ServiceActionRecord[] = []

  request(startId: number): number {
    if (startId === 1) {
      return this.start();
    }
    return this.stop();
  }

  start(): number {
    if (this.recording) {
      this.records.push({ type: 'start', detail: 'blocked', code: -1000 });
      return -1000;
    }
    this.recording = true;
    this.records.push({ type: 'start', detail: 'recording', code: 0 });
    return 0;
  }

  stop(): number {
    if (!this.recording) {
      this.records.push({ type: 'stop', detail: 'idle', code: -1001 });
      return -1001;
    }
    this.recording = false;
    this.terminated += 1;
    this.records.push({ type: 'stop', detail: 'terminate', code: 0 });
    return 0;
  }

  scheduleErrorTermination(): void {
    this.errorScheduled = true;
    this.records.push({ type: 'error', detail: 'scheduled', code: 0 });
  }

  flushError(): void {
    if (this.errorScheduled) {
      this.errorScheduled = false;
      this.terminated += 1;
      this.records.push({ type: 'error', detail: 'terminate', code: 0 });
    }
  }

  isRecording(): boolean {
    return this.recording;
  }

  getTerminateCount(): number {
    return this.terminated;
  }

  getRecords(): ServiceActionRecord[] {
    return this.records.slice();
  }
}

export class TimerProjectionHarness {
  private recording: boolean = false
  private iconHidden: boolean = false
  private timerLabel: string = '00:00'
  private records: ServiceActionRecord[] = []

  setRecording(value: boolean): void {
    this.recording = value;
    if (!value) {
      this.iconHidden = false;
      this.timerLabel = '00:00';
    }
    this.records.push({ type: 'state', detail: value ? 'recording' : 'idle', code: value ? 1 : 0 });
  }

  tick(second: number): void {
    if (!this.recording) {
      this.records.push({ type: 'tick', detail: 'ignored', code: second });
      return;
    }
    this.iconHidden = !this.iconHidden;
    const minute = Math.floor(second / 60).toString().padStart(2, '0');
    const value = (second % 60).toString().padStart(2, '0');
    this.timerLabel = `${minute}:${value}`;
    this.records.push({ type: 'tick', detail: this.timerLabel, code: this.iconHidden ? 1 : 0 });
  }

  isIconHidden(): boolean {
    return this.iconHidden;
  }

  getTimerLabel(): string {
    return this.timerLabel;
  }

  getRecords(): ServiceActionRecord[] {
    return this.records.slice();
  }
}

export class DialogPresentationHarness {
  private dialogs: string[] = []
  private records: ServiceActionRecord[] = []

  show(name: string): void {
    this.dialogs.push(name);
    this.records.push({ type: 'show', detail: name, code: this.dialogs.length });
  }

  hide(name: string): boolean {
    const index = this.dialogs.indexOf(name);
    if (index < 0) {
      this.records.push({ type: 'hide', detail: name, code: -1 });
      return false;
    }
    this.dialogs.splice(index, 1);
    this.records.push({ type: 'hide', detail: name, code: 0 });
    return true;
  }

  clear(): void {
    this.dialogs = [];
    this.records.push({ type: 'clear', detail: 'all', code: 0 });
  }

  getDialogs(): string[] {
    return this.dialogs.slice();
  }

  getRecords(): ServiceActionRecord[] {
    return this.records.slice();
  }
}
