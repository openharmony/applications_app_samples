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

import { afterEach, beforeEach, describe, expect, it } from '@ohos/hypium';
import { Want } from '@kit.AbilityKit';
import { AbilityConstant } from '@kit.AbilityKit';

class MockAbilityContext {
  terminateCount: number = 0;

  terminateSelf(): void {
    this.terminateCount += 1;
  }
}

class AbilityWantParameters {
  uri?: string;
  type?: string;
  close?: boolean;
  maxSelectCount?: number;

  constructor(uri?: string, type?: string, close?: boolean, maxSelectCount?: number) {
    this.uri = uri;
    this.type = type;
    this.close = close;
    this.maxSelectCount = maxSelectCount;
  }
}

class AbilityWantModel {
  parameters?: AbilityWantParameters;

  constructor(parameters?: AbilityWantParameters) {
    this.parameters = parameters;
    }
}

class LaunchParamModel {
}

class EntryWantScenario {
  name: string;
  expectedBundle: string;
  expectedAbility: string;

  constructor(name: string, expectedBundle: string, expectedAbility: string) {
    this.name = name;
    this.expectedBundle = expectedBundle;
    this.expectedAbility = expectedAbility;
  }
}

class FileManagerPayloadScenario {
  name: string;
  uri: string;
  type: string;

  constructor(name: string, uri: string, type: string) {
    this.name = name;
    this.uri = uri;
    this.type = type;
  }
}

class CloseScenario {
  name: string;
  close?: boolean;
  expectedTerminate: number;

  constructor(name: string, close: boolean | undefined, expectedTerminate: number) {
    this.name = name;
    this.close = close;
    this.expectedTerminate = expectedTerminate;
  }
}

class PickerCountScenario {
  name: string;
  maxSelectCount: number;

  constructor(name: string, maxSelectCount: number) {
    this.name = name;
    this.maxSelectCount = maxSelectCount;
  }
}

class WindowSizeScenario {
  name: string;
  width: number;
  height: number;

  constructor(name: string, width: number, height: number) {
    this.name = name;
    this.width = width;
    this.height = height;
  }
}

class MainAbilityReceiver {
  context: MockAbilityContext;

  constructor(context: MockAbilityContext) {
    this.context = context;
  }

  handleWant(want: Want): void {
    const picUri: string = want?.parameters?.uri as string;
    const picType: string = want?.parameters?.type as string;
    const close: boolean = want?.parameters?.close as boolean;
    if (close) {
      this.context.terminateSelf();
    } else if (picUri) {
      globalThis.startByFileMgr = true;
      AppStorage.setOrCreate('directUri', picUri);
      AppStorage.setOrCreate('directType', picType);
    }
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    globalThis.startByFileMgr = false;
    this.handleWant(want);
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.handleWant(want);
  }
}

class PickerAbilityReceiver {
  context: MockAbilityContext;

  constructor(context: MockAbilityContext) {
    this.context = context;
  }

  handleWant(want: Want): void {
    const count: number = want?.parameters?.maxSelectCount as number;
    const close: boolean = want?.parameters?.close as boolean;
    if (close) {
      this.context.terminateSelf();
    } else if (want?.parameters?.maxSelectCount !== undefined && want?.parameters?.maxSelectCount !== null) {
      AppStorage.setOrCreate('pickMaxSelectCount', count);
    }
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.handleWant(want);
  }
}

function createMockContext(): MockAbilityContext {
  return new MockAbilityContext();
}

function createWant(parameters: AbilityWantParameters): Want {
  const model = new AbilityWantModel(parameters);
  return model as Want;
}

function createLaunchParam(): AbilityConstant.LaunchParam {
  return new LaunchParamModel() as AbilityConstant.LaunchParam;
}

function isStorageEmpty(key: string): boolean {
  const value: Object | undefined | null = AppStorage.get(key);
  return value === undefined || value === null;
}

function createMainAbilityReceiver(): MainAbilityReceiver {
  return new MainAbilityReceiver(createMockContext());
}

function createPickerAbilityReceiver(): PickerAbilityReceiver {
  return new PickerAbilityReceiver(createMockContext());
}

const ENTRY_WANT_SCENARIOS: EntryWantScenario[] = [
  new EntryWantScenario('entry_want_contract', 'com.samples.album', 'EntryAbility')
];

const FILE_MANAGER_PAYLOAD_SCENARIOS: FileManagerPayloadScenario[] = [
  new FileManagerPayloadScenario('image_jpeg_payload', 'file://media/10', 'image/jpeg'),
  new FileManagerPayloadScenario('image_png_payload', 'file://media/11', 'image/png'),
  new FileManagerPayloadScenario('video_mp4_payload', 'file://media/12', 'video/mp4'),
  new FileManagerPayloadScenario('distributed_payload', 'distributed://media/13', 'image/jpeg')
];

const MAIN_CLOSE_SCENARIOS: CloseScenario[] = [
  new CloseScenario('main_close_true', true, 1),
  new CloseScenario('main_close_false', false, 0),
  new CloseScenario('main_close_missing', undefined, 0)
];

const PICKER_LIMIT_SCENARIOS: PickerCountScenario[] = [
  new PickerCountScenario('picker_single_limit', 1),
  new PickerCountScenario('picker_normal_limit', 9),
  new PickerCountScenario('picker_large_limit', 99),
  new PickerCountScenario('picker_zero_limit', 0)
];

const PICKER_CLOSE_SCENARIOS: CloseScenario[] = [
  new CloseScenario('picker_close_true', true, 1),
  new CloseScenario('picker_close_false', false, 0),
  new CloseScenario('picker_close_missing', undefined, 0)
];

const WINDOW_SIZE_SCENARIOS: WindowSizeScenario[] = [
  new WindowSizeScenario('destroy_with_window_size', 1920, 1080),
  new WindowSizeScenario('destroy_with_4k_window', 3840, 2160),
  new WindowSizeScenario('destroy_with_small_window', 1280, 720)
];

function resetAbilityState(): void {
  AppStorage.clear();
  globalThis.startByFileMgr = false;
  globalThis.pickAbilityContext = undefined;
}

export default function abilityTest() {
  describe('PhotosAbilityContractTest', () => {
    beforeEach(() => {
      resetAbilityState();
    });

    afterEach(() => {
      resetAbilityState();
    });


    it('should terminate picker ability when close flag is dispatched', 0, () => {
      const pickerAbility = createPickerAbilityReceiver();

      pickerAbility.handleWant(createWant(new AbilityWantParameters(undefined, undefined, true)));

      expect(pickerAbility.context.terminateCount).assertEqual(1);
    });


  });
}
