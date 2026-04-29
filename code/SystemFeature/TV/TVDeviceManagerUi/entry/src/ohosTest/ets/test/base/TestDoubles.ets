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

export class MockBusinessError {
  code: number;
  message: string;

  constructor(code: number = 0, message: string = '') {
    this.code = code;
    this.message = message;
  }
}

export class MockReplyRecord {
  operation: number;
  extra: string;

  constructor(operation: number, extra: string) {
    this.operation = operation;
    this.extra = extra;
  }
}

export class MockDeviceManager {
  records: MockReplyRecord[] = [];
  eventNames: string[] = [];
  offNames: string[] = [];
  released: boolean = false;
  listener?: (data: MockReplyPayload) => void;

  replyUiAction(operation: number, extra: string): void {
    this.records.push(new MockReplyRecord(operation, extra));
  }

  on(eventName: string, listener: (data: MockReplyPayload) => void): void {
    this.eventNames.push(eventName);
    this.listener = listener;
  }

  off(eventName: string): void {
    this.offNames.push(eventName);
  }

  emitReply(payload: MockReplyPayload): void {
    if (this.listener) {
      this.listener(payload);
    }
  }
}

export class MockReplyPayload {
  param: string;

  constructor(param: string) {
    this.param = param;
  }
}

export class MockWindow {
  operations: string[] = [];
  destroyed: boolean = false;
  left: number = 0;
  top: number = 0;
  width: number = 0;
  height: number = 0;
  loadedPage: string = '';
  backgroundColor: string = '';
  radius: number = 0;
  shadowRadius: number = 0;

  moveWindowTo(left: number, top: number, callback?: (err: MockBusinessError) => void): void {
    this.operations.push('move');
    this.left = left;
    this.top = top;
    if (callback) {
      callback(new MockBusinessError());
    }
  }

  resize(width: number, height: number, callback?: (err: MockBusinessError) => void): void {
    this.operations.push('resize');
    this.width = width;
    this.height = height;
    if (callback) {
      callback(new MockBusinessError());
    }
  }

  loadContent(page: string, storage?: LocalStorage, callback?: (err: MockBusinessError) => void): void {
    this.operations.push('loadContent');
    this.loadedPage = page;
    if (callback) {
      callback(new MockBusinessError());
    }
  }

  showWindow(callback?: (err: MockBusinessError) => void): void {
    this.operations.push('show');
    if (callback) {
      callback(new MockBusinessError());
    }
  }

  setCornerRadius(radius: number): void {
    this.operations.push('radius');
    this.radius = radius;
  }

  setShadow(radius: number, color: string, offsetX: number, offsetY: number): void {
    const shadowSignature: string = `${color}:${offsetX}:${offsetY}`;
    this.operations.push('shadow');
    this.shadowRadius = radius;
    this.backgroundColor = shadowSignature;
  }

  destroyWindow(callback?: (err: MockBusinessError) => void): Promise<void> {
    this.destroyed = true;
    this.operations.push('destroy');
    if (callback) {
      callback(new MockBusinessError());
    }
    return Promise.resolve();
  }
}

export class MockSession {
  loadedPages: string[] = [];
  backgroundColors: string[] = [];
  terminateCount: number = 0;

  loadContent(page: string, storage: LocalStorage): void {
    const storageReady: boolean = storage !== undefined;

    // 透明承载页是所有浮窗能力的前置条件。
    // 记录 storage 是否注入，可以提前发现 session 初始化链路断裂。
    if (storageReady) {
      this.loadedPages.push(page);
    }
  }

  setWindowBackgroundColor(color: string): void {
    this.backgroundColors.push(color);
  }

  terminateSelf(): void {
    this.terminateCount += 1;
  }
}

export class MockExtensionContext {
  terminateCount: number = 0;

  terminateSelf(callback?: (err: MockBusinessError) => void): void {
    this.terminateCount += 1;
    if (callback) {
      callback(new MockBusinessError());
    }
  }
}

export class MockDisplay {
  width: number;
  height: number;

  constructor(width: number, height: number) {
    this.width = width;
    this.height = height;
  }
}

export class MockWindowFactory {
  createdNames: string[] = [];
  windows: MockWindow[] = [];

  createWindow(name: string): MockWindow {
    const windowItem: MockWindow = new MockWindow();
    this.createdNames.push(name);
    this.windows.push(windowItem);
    return windowItem;
  }
}

export class MockUiFocusController {
  active: boolean = false;
  focusRequests: string[] = [];

  activate(value: boolean): void {
    this.active = value;
  }

  requestFocus(key: string): void {
    this.focusRequests.push(key);
  }
}

export class MockUiContext {
  controller: MockUiFocusController = new MockUiFocusController();

  getFocusController(): MockUiFocusController {
    return this.controller;
  }
}

export class MockInputInjector {
  history: number[] = [];

  injectKey(keyCode: number): void {
    this.history.push(keyCode);
  }
}

export class MockOperationTracker {
  messages: string[] = [];

  add(message: string): void {
    this.messages.push(message);
  }
}
