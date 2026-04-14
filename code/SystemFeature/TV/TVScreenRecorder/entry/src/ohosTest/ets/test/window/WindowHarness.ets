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

import { MockWindowRect, MockWindowRectEntity } from '../foundation/TestTypes';

export interface WindowEventRecord {
  type: string
  name: string
  page: string
  ts: number
}

export interface WindowHarnessMetrics {
  created: number
  shown: number
  hidden: number
  destroyed: number
  moveCalls: number
  resizeCalls: number
  loadCalls: number
}

class WindowHarnessMetricsEntity implements WindowHarnessMetrics {
  created: number = 0
  shown: number = 0
  hidden: number = 0
  destroyed: number = 0
  moveCalls: number = 0
  resizeCalls: number = 0
  loadCalls: number = 0
}

class InMemoryWindowNode {
  name: string
  page: string
  rect: MockWindowRect
  visible: boolean = false
  destroyed: boolean = false
  focusable: boolean = false

  constructor(name: string, page: string, rect: MockWindowRect) {
    this.name = name
    this.page = page
    this.rect = rect
  }
}

export class WindowHarness {
  private windows: Map<string, InMemoryWindowNode> = new Map()
  private events: WindowEventRecord[] = []
  private metrics: WindowHarnessMetrics = new WindowHarnessMetricsEntity()
  private throwOnCreate: boolean = false
  private throwOnLoad: boolean = false
  private throwOnShow: boolean = false
  private nowSeed: number = 1700000000000

  setThrowOnCreate(value: boolean): void {
    this.throwOnCreate = value
  }

  setThrowOnLoad(value: boolean): void {
    this.throwOnLoad = value
  }

  setThrowOnShow(value: boolean): void {
    this.throwOnShow = value
  }

  openTimerWindow(name: string, page: string, rect: MockWindowRect): number {
    if (this.throwOnCreate) {
      return -1
    }
    if (!this.windows.has(name)) {
      const node = new InMemoryWindowNode(name, page, rect)
      this.windows.set(name, node)
      this.metrics.created += 1
      this.pushEvent('create', name, page)
    }
    this.metrics.moveCalls += 1
    this.metrics.resizeCalls += 1
    this.metrics.loadCalls += 1
    if (this.throwOnLoad) {
      return -2
    }
    if (this.throwOnShow) {
      return -3
    }
    const target = this.windows.get(name)
    if (target) {
      target.visible = true
    }
    this.metrics.shown += 1
    this.pushEvent('show', name, page)
    return 0
  }

  popupRecorderTip(name: string, page: string, rect: MockWindowRect, duration: number, callback?: () => void): number {
    const code = this.openTimerWindow(name, page, rect)
    if (code !== 0) {
      return code
    }
    const target = this.windows.get(name)
    if (target) {
      target.visible = false
      this.metrics.hidden += 1
      this.pushEvent('hide', name, page)
    }
    if (duration >= 0 && callback) {
      callback()
    }
    return 0
  }

  hide(name: string): number {
    const target = this.windows.get(name)
    if (!target) {
      return -10
    }
    target.visible = false
    this.metrics.hidden += 1
    this.pushEvent('hide', name, target.page)
    return 0
  }

  destroy(name: string): number {
    const target = this.windows.get(name)
    if (!target) {
      return -11
    }
    target.destroyed = true
    this.windows.delete(name)
    this.metrics.destroyed += 1
    this.pushEvent('destroy', name, target.page)
    return 0
  }

  release(): void {
    const keys = Array.from(this.windows.keys())
    for (let index = 0; index < keys.length; index++) {
      this.destroy(keys[index])
    }
  }

  getWindowCount(): number {
    return this.windows.size
  }

  hasWindow(name: string): boolean {
    return this.windows.has(name)
  }

  isVisible(name: string): boolean {
    const target = this.windows.get(name)
    if (!target) {
      return false
    }
    return target.visible
  }

  getMetrics(): WindowHarnessMetrics {
    const value = new WindowHarnessMetricsEntity()
    value.created = this.metrics.created
    value.shown = this.metrics.shown
    value.hidden = this.metrics.hidden
    value.destroyed = this.metrics.destroyed
    value.moveCalls = this.metrics.moveCalls
    value.resizeCalls = this.metrics.resizeCalls
    value.loadCalls = this.metrics.loadCalls
    return value
  }

  getEvents(): WindowEventRecord[] {
    return this.events.slice()
  }

  reset(): void {
    this.windows.clear()
    this.events = []
    this.metrics = new WindowHarnessMetricsEntity()
  }

  private pushEvent(type: string, name: string, page: string): void {
    this.events.push({
      type,
      name,
      page,
      ts: this.nowSeed++
    })
  }
}

export function createRectSequence(count: number): MockWindowRect[] {
  const rects: MockWindowRect[] = []
  for (let i = 0; i < count; i++) {
    rects.push(new MockWindowRectEntity(96 + i, 48 + i, 624 + i * 2, 56 + (i % 3)))
  }
  return rects
}
