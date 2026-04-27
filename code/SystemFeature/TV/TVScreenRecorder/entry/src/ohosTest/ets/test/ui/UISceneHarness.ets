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

import { FoundationStorageEntity } from '../foundation/FoundationAdvancedFixtures';

export interface UIPermissionRecord {
  name: string
  granted: boolean
}

export interface UIActionRecord {
  type: string
  target: string
  code: number
}

export interface UIRecentRecord {
  id: string
  title: string
  state: string
}

export interface UIStatusProjection {
  icon: string
  timer: string
  network: string
}

export class UIPermissionHarness {
  private permissions: Map<string, boolean> = new Map()
  private records: UIPermissionRecord[] = []

  request(name: string, granted: boolean): number {
    this.permissions.set(name, granted);
    this.records.push({ name, granted });
    return granted ? 0 : -1;
  }

  isGranted(name: string): boolean {
    return this.permissions.get(name) ?? false;
  }

  getRecords(): UIPermissionRecord[] {
    return this.records.slice();
  }

  getGrantedCount(): number {
    let total = 0;
    this.permissions.forEach((value: boolean) => {
      if (value) {
        total += 1
      }
    });
    return total;
  }
}

export class UIHomeInteractionHarness {
  private actions: UIActionRecord[] = []
  private started: boolean = false
  private lastToast: string = ''
  private status: UIStatusProjection = { icon: 'idle', timer: '00:00', network: 'wifi' }

  start(): number {
    if (this.started) {
      this.actions.push({ type: 'start', target: 'record', code: -1000 });
      this.lastToast = 'already-recording';
      return -1000;
    }
    this.started = true;
    this.status = { icon: 'recording', timer: '00:01', network: this.status.network }
    this.actions.push({ type: 'start', target: 'record', code: 0 });
    return 0;
  }

  stop(): number {
    if (!this.started) {
      this.actions.push({ type: 'stop', target: 'record', code: -1001 });
      this.lastToast = 'not-recording';
      return -1001;
    }
    this.started = false;
    this.status = { icon: 'idle', timer: '00:00', network: this.status.network }
    this.actions.push({ type: 'stop', target: 'record', code: 0 });
    this.lastToast = 'saved-to-photo';
    return 0;
  }

  showResolutionNotSupported(): void {
    this.actions.push({ type: 'dialog', target: 'resolution', code: 0 });
    this.lastToast = 'resolution-not-supported';
  }

  switchNetwork(name: string): void {
    this.status.network = name;
    this.actions.push({ type: 'network', target: name, code: 0 });
  }

  getActions(): UIActionRecord[] {
    return this.actions.slice();
  }

  isStarted(): boolean {
    return this.started;
  }

  getLastToast(): string {
    return this.lastToast;
  }

  getStatus(): UIStatusProjection {
    return {
      icon: this.status.icon,
      timer: this.status.timer,
      network: this.status.network
    }
  }
}

export class UIEditModeHarness {
  private items: string[] = []
  private focusIndex: number = 0
  private removed: string[] = []
  private actions: UIActionRecord[] = []

  constructor(items: string[]) {
    this.items = items.slice();
  }

  moveLeft(): void {
    if (this.focusIndex > 0) {
      this.focusIndex -= 1;
      this.actions.push({ type: 'move', target: 'left', code: this.focusIndex });
      return;
    }
    this.actions.push({ type: 'move', target: 'left-boundary', code: -1 });
  }

  moveRight(): void {
    if (this.focusIndex < this.items.length - 1) {
      this.focusIndex += 1;
      this.actions.push({ type: 'move', target: 'right', code: this.focusIndex });
      return;
    }
    this.actions.push({ type: 'move', target: 'right-boundary', code: -2 });
  }

  removeFocused(): string {
    if (this.items.length === 0) {
      this.actions.push({ type: 'remove', target: 'empty', code: -3 });
      return '';
    }
    const removed = this.items.splice(this.focusIndex, 1)[0];
    this.removed.push(removed);
    if (this.focusIndex >= this.items.length && this.items.length > 0) {
      this.focusIndex = this.items.length - 1;
    }
    if (this.items.length === 0) {
      this.focusIndex = 0;
    }
    this.actions.push({ type: 'remove', target: removed, code: 0 });
    return removed;
  }

  persist(storage: FoundationStorageEntity): void {
    for (let index = 0; index < this.items.length; index++) {
      storage.set(`edit.items.${index}`, this.items[index]);
    }
    for (let index = 0; index < this.removed.length; index++) {
      storage.set(`edit.removed.${index}`, this.removed[index]);
    }
    storage.set('edit.focusIndex', this.focusIndex);
    this.actions.push({ type: 'persist', target: 'storage', code: storage.getSize() });
  }

  getItems(): string[] {
    return this.items.slice();
  }

  getRemoved(): string[] {
    return this.removed.slice();
  }

  getFocusIndex(): number {
    return this.focusIndex;
  }

  getActions(): UIActionRecord[] {
    return this.actions.slice();
  }
}

export class UIRecentHarness {
  private recents: UIRecentRecord[] = []
  private status: UIStatusProjection = { icon: 'idle', timer: '00:00', network: 'wifi' }
  private actions: UIActionRecord[] = []

  addRecent(title: string, state: string): string {
    const id = `recent_${this.recents.length}_${title}`;
    this.recents.push({ id, title, state });
    this.actions.push({ type: 'recent-add', target: id, code: this.recents.length });
    return id;
  }

  removeRecent(id: string): boolean {
    const index = this.recents.findIndex((record: UIRecentRecord) => record.id === id);
    if (index < 0) {
      this.actions.push({ type: 'recent-remove', target: id, code: -1 });
      return false;
    }
    this.recents.splice(index, 1);
    this.actions.push({ type: 'recent-remove', target: id, code: 0 });
    return true;
  }

  clear(): void {
    this.recents = [];
    this.actions.push({ type: 'recent-clear', target: 'all', code: 0 });
  }

  switchStatus(icon: string, timer: string, network: string): void {
    this.status = { icon, timer, network }
    this.actions.push({ type: 'status-switch', target: icon, code: 0 });
  }

  persist(storage: FoundationStorageEntity): void {
    for (let index = 0; index < this.recents.length; index++) {
      storage.set(`recent.${index}.title`, this.recents[index].title);
      storage.set(`recent.${index}.state`, this.recents[index].state);
    }
    storage.set('status.icon', this.status.icon);
    storage.set('status.timer', this.status.timer);
    storage.set('status.network', this.status.network);
    this.actions.push({ type: 'persist', target: 'recent-status', code: storage.getSize() });
  }

  getRecents(): UIRecentRecord[] {
    return this.recents.slice();
  }

  getStatus(): UIStatusProjection {
    return {
      icon: this.status.icon,
      timer: this.status.timer,
      network: this.status.network
    }
  }

  getActions(): UIActionRecord[] {
    return this.actions.slice();
  }
}
