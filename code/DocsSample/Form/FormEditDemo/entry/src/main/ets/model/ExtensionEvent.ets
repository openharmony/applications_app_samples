/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

const TAG: string = 'FormEditDemo[ExtensionEvent] -->';
const LOCAL: Record<string, string> = { 'formId': '', 'previewFormId': '', 'message': '' };

export class ExtensionEvent {
  private static storage = new LocalStorage(LOCAL);
  public static getStorage(): LocalStorage {
    return ExtensionEvent.storage;
  }
  private startSecondPage: () => void = (): void => {
    console.info(`${TAG} startSecondPage is empty!`);
  };
  public setStartSecondPage(startSecondPage: () => void) {
    console.info(`${TAG} setStartSecondPage`);
    this.startSecondPage = startSecondPage;
  }
  public async startFormEditSecondPage() {
    console.info(`${TAG} startFormEditSecondPage call`);
    this.startSecondPage();
  }
}