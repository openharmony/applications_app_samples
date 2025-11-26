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

import selectionManager from '@ohos.selectionInput.selectionManager';
import SelectionExtensionContext from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

export class SelectionModel {
  private selectionInfo: selectionManager.SelectionInfo | undefined;
  private selectionPanel: selectionManager.Panel | undefined;
  private context: SelectionExtensionContext | undefined;
  private listener: (selectionInfo: selectionManager.SelectionInfo) => void;

  private constructor() {
    this.selectionPanel = undefined;
    this.context = undefined;
    this.selectionInfo = undefined;
    this.listener = (selectionInfo: selectionManager.SelectionInfo) => {
      hilog.info(0x0000, 'SelectionModel', `Received selection selectionInfo: ${selectionInfo}`);
    }
  }

  public static getInstance(): SelectionModel {
    if (globalThis.instance == null) {
      globalThis.instance = new SelectionModel();
    }
    return globalThis.instance;
  }

  public setSelectionInfo(selectionInfo: selectionManager.SelectionInfo) {
    this.listener(selectionInfo);
    this.selectionInfo = selectionInfo;
  }

  public getSelectionPanel(): selectionManager.Panel | undefined {
    return this.selectionPanel;
  }

  public setSelectionPanel(selectionPanel: selectionManager.Panel) {
    this.selectionPanel = selectionPanel;
  }

  public getContext(): SelectionExtensionContext | undefined {
    return this.context;
  }

  public setContext(context: SelectionExtensionContext) {
    this.context = context;
  }

  public registerListener(listener: (selectionInfo: selectionManager.SelectionInfo) => void) {
    this.listener = listener;
  }

  public getSelectionInfo(): selectionManager.SelectionInfo | undefined {
    return this.selectionInfo;
  }
}