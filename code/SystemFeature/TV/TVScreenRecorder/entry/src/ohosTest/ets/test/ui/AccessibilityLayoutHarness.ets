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

export interface AccessibilityNodeRecord {
  id: string
  role: string
  text: string
  parentId: string
  readable: boolean
}

export interface LayoutRenderRecord {
  page: string
  width: number
  height: number
  rotation: number
  code: number
  overflow: boolean
}

export interface FocusActionRecord {
  direction: string
  code: number
  index: number
}

export interface JointStatusRecord {
  icon: string
  timer: string
  network: string
}

export interface JointRecentRecord {
  id: string
  title: string
  state: string
}

class AccessibilityNodeRecordEntity implements AccessibilityNodeRecord {
  id: string
  role: string
  text: string
  parentId: string
  readable: boolean

  constructor(id: string, role: string, text: string, parentId: string, readable: boolean) {
    this.id = id;
    this.role = role;
    this.text = text;
    this.parentId = parentId;
    this.readable = readable;
  }
}

export class AccessibilityTreeHarness {
  private nodes: Map<string, AccessibilityNodeRecord> = new Map()
  private order: string[] = []

  addNode(id: string, role: string, text: string, parentId: string = ''): number {
    if (id.length === 0 || role.length === 0) {
      return -1;
    }
    const node = new AccessibilityNodeRecordEntity(id, role, text, parentId, text.trim().length > 0);
    this.nodes.set(id, node);
    this.order.push(id);
    return 0;
  }

  markUnreadable(id: string): void {
    const node = this.nodes.get(id);
    if (node === undefined) {
      return;
    }
    const updatedNode = new AccessibilityNodeRecordEntity(node.id, node.role, node.text, node.parentId, false);
    this.nodes.set(id, updatedNode);
  }

  validateTree(): number {
    let rootCount = 0;
    let valid = true;
    this.nodes.forEach((node: AccessibilityNodeRecord) => {
      if (node.parentId.length === 0) {
        rootCount += 1
      } else if (!this.nodes.has(node.parentId)) {
        valid = false
      }
    });
    return valid && rootCount > 0 ? 0 : -1;
  }

  flattenReadableText(): string {
    const segments: string[] = [];
    for (let index = 0; index < this.order.length; index++) {
      const node = this.nodes.get(this.order[index]);
      if (node !== undefined && node.readable) {
        segments.push(node.text);
      }
    }
    return segments.join('|');
  }

  getNodeCount(): number {
    return this.nodes.size;
  }

  getReadableCount(): number {
    let total = 0;
    this.nodes.forEach((node: AccessibilityNodeRecord) => {
      if (node.readable) {
        total += 1
      }
    });
    return total;
  }

  getNodes(): AccessibilityNodeRecord[] {
    const records: AccessibilityNodeRecord[] = [];
    for (let index = 0; index < this.order.length; index++) {
      const node = this.nodes.get(this.order[index]);
      if (node !== undefined) {
        records.push(node);
      }
    }
    return records;
  }
}

export class DesktopLayoutHarness {
  private renders: LayoutRenderRecord[] = []
  private focusActions: FocusActionRecord[] = []
  private focusItems: string[] = ['start', 'recent', 'dialog', 'timer', 'stop']
  private focusIndex: number = 0

  render(page: string, width: number, height: number, rotation: number): number {
    const overflow = width < 120 || height < 60 || width > 8000 || height > 5000;
    const code = overflow ? -1 : 0;
    this.renders.push({ page, width, height, rotation, code, overflow });
    return code;
  }

  moveFocus(direction: string): number {
    if (direction === 'left' || direction === 'up') {
      if (this.focusIndex === 0) {
        this.focusActions.push({ direction, code: -1, index: this.focusIndex });
        return -1;
      }
      this.focusIndex -= 1;
      this.focusActions.push({ direction, code: 0, index: this.focusIndex });
      return 0;
    }
    if (direction === 'right' || direction === 'down') {
      if (this.focusIndex >= this.focusItems.length - 1) {
        this.focusActions.push({ direction, code: -2, index: this.focusIndex });
        return -2;
      }
      this.focusIndex += 1;
      this.focusActions.push({ direction, code: 0, index: this.focusIndex });
      return 0;
    }
    this.focusActions.push({ direction, code: -3, index: this.focusIndex });
    return -3;
  }

  getCurrentFocus(): string {
    return this.focusItems[this.focusIndex];
  }

  getFocusIndex(): number {
    return this.focusIndex;
  }

  getOverflowCount(): number {
    let total = 0;
    for (let index = 0; index < this.renders.length; index++) {
      if (this.renders[index].overflow) {
        total += 1
      }
    }
    return total;
  }

  getMaxArea(): number {
    let maxArea = 0;
    for (let index = 0; index < this.renders.length; index++) {
      const area = this.renders[index].width * this.renders[index].height;
      if (area > maxArea) {
        maxArea = area
      }
    }
    return maxArea;
  }

  getRenders(): LayoutRenderRecord[] {
    return this.renders.slice();
  }

  getFocusActions(): FocusActionRecord[] {
    return this.focusActions.slice();
  }
}

export class RecentStatusJointHarness {
  private recents: JointRecentRecord[] = []
  private status: JointStatusRecord = { icon: 'idle', timer: '00:00', network: 'wifi' }
  private actions: string[] = []

  openRecent(title: string, state: string): string {
    const id = `joint_${this.recents.length}_${title}`;
    this.recents.push({ id, title, state });
    this.actions.push(`open:${id}:${state}`);
    return id;
  }

  removeRecent(id: string): boolean {
    const index = this.recents.findIndex((item: JointRecentRecord) => item.id === id);
    if (index < 0) {
      this.actions.push(`remove-miss:${id}`);
      return false;
    }
    this.recents.splice(index, 1);
    this.actions.push(`remove:${id}`);
    return true;
  }

  syncStatus(icon: string, timer: string, network: string): void {
    this.status = { icon, timer, network }
    this.actions.push(`status:${icon}:${timer}:${network}`);
  }

  persist(storage: FoundationStorageEntity): void {
    for (let index = 0; index < this.recents.length; index++) {
      storage.set(`joint.recent.${index}.title`, this.recents[index].title);
      storage.set(`joint.recent.${index}.state`, this.recents[index].state);
    }
    storage.set('joint.status.icon', this.status.icon);
    storage.set('joint.status.timer', this.status.timer);
    storage.set('joint.status.network', this.status.network);
    this.actions.push(`persist:${storage.getSize()}`);
  }

  recover(storage: FoundationStorageEntity): number {
    const keys = storage.getKeys();
    let total = 0;
    for (let index = 0; index < keys.length; index++) {
      if (keys[index].indexOf('joint.recent.') === 0 || keys[index].indexOf('joint.status.') === 0) {
        total += 1
      }
    }
    this.actions.push(`recover:${total}`);
    return total;
  }

  getStatus(): JointStatusRecord {
    return {
      icon: this.status.icon,
      timer: this.status.timer,
      network: this.status.network
    }
  }

  getRecents(): JointRecentRecord[] {
    return this.recents.slice();
  }

  getActions(): string[] {
    return this.actions.slice();
  }
}
