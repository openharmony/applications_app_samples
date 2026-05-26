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

import { DeviceLibraryManager } from './DeviceLibraryManager';
import { LibraryManager } from './LibraryManager';
import { SceneLibraryManager } from './SceneLibraryManager';

/**
 * 库管理类工厂
 */
export class LibraryManagerFactory {
  private static instance: LibraryManagerFactory;
  private static deviceLibMgr: LibraryManager;
  private static sceneLibMgr: LibraryManager;

  public static getInstance(): LibraryManagerFactory {
    if (!LibraryManagerFactory.instance) {
      LibraryManagerFactory.instance = new LibraryManagerFactory();
      LibraryManager.init();
      LibraryManagerFactory.deviceLibMgr = new DeviceLibraryManager();
      LibraryManagerFactory.deviceLibMgr.loadPresetLibrary();
      LibraryManagerFactory.sceneLibMgr = new SceneLibraryManager();
      LibraryManagerFactory.sceneLibMgr.loadPresetLibrary();
    }
    return LibraryManagerFactory.instance;
  }

  getManager(type: LibraryManagerType): LibraryManager {
    switch (type) {
      case LibraryManagerType.DEVICE:
        return LibraryManagerFactory.deviceLibMgr;
      case LibraryManagerType.SCENE:
        return LibraryManagerFactory.sceneLibMgr;
    }
  }
}

export enum LibraryManagerType {
  DEVICE = 0, SCENE
}