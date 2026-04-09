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
import Want from '@ohos.app.ability.Want';
import { AbilityConstant } from '@kit.AbilityKit';
import EntryAbility from '../../main/ets/MainAbility/EntryAbility';
import MainAbility from '../../main/ets/MainAbility/MainAbility';
import PickerAbility from '../../main/ets/MainAbility/PickerAbility';
import { PhotosUiHarness } from './base/UiTestHarness';

interface MockAbilityContext {
  terminateCount: number;
  terminateSelf(): void;
}

type MainAbilityWithContext = MainAbility & { context: MockAbilityContext };
type PickerAbilityWithContext = PickerAbility & { context: MockAbilityContext };

function createMockContext(): MockAbilityContext {
  return {
    terminateCount: 0,
    terminateSelf() {
      this.terminateCount++;
    }
  };
}

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

    it('should expose entry ability want used by UI harness', 0, () => {
      const want = PhotosUiHarness.getEntryWant();
      expect(want.bundleName).assertEqual('com.samples.album');
      expect(want.abilityName).assertEqual('EntryAbility');
    });

    it('should route file manager payload through main ability onCreate', 0, () => {
      const ability = new MainAbility();
      const context = createMockContext();
      const mainAbility = ability as MainAbilityWithContext;
      const want = {
        parameters: {
          uri: 'file://media/10',
          type: 'image/jpeg'
        }
      } as Want;

      mainAbility.context = context;
      mainAbility.onCreate(want, {} as AbilityConstant.LaunchParam);

      expect(globalThis.startByFileMgr).assertTrue();
      expect(AppStorage.get('directUri') as string).assertEqual('file://media/10');
      expect(AppStorage.get('directType') as string).assertEqual('image/jpeg');
      expect(context.terminateCount).assertEqual(0);
    });

    it('should terminate main ability when close flag arrives on new want', 0, () => {
      const ability = new MainAbility();
      const context = createMockContext();
      const mainAbility = ability as MainAbilityWithContext;

      mainAbility.context = context;
      mainAbility.onNewWant({
        parameters: {
          close: true
        }
      } as Want, {} as AbilityConstant.LaunchParam);

      expect(context.terminateCount).assertEqual(1);
    });

    it('should persist picker max select count from incoming want', 0, () => {
      const ability = new PickerAbility();
      const context = createMockContext();
      const pickerAbility = ability as PickerAbilityWithContext;

      pickerAbility.context = context;
      pickerAbility.onNewWant({
        parameters: {
          maxSelectCount: 9
        }
      } as Want, {} as AbilityConstant.LaunchParam);

      expect(AppStorage.get('pickMaxSelectCount') as number).assertEqual(9);
      expect(context.terminateCount).assertEqual(0);
    });

    it('should terminate picker ability when close flag is dispatched', 0, () => {
      const ability = new PickerAbility();
      const context = createMockContext();
      const pickerAbility = ability as PickerAbilityWithContext;

      pickerAbility.context = context;
      pickerAbility.handleWant({
        parameters: {
          close: true
        }
      } as Want);

      expect(context.terminateCount).assertEqual(1);
    });

    it('should clear app storage on entry ability destroy', 0, () => {
      const ability = new EntryAbility();
      AppStorage.setOrCreate('window_width', 1920);
      AppStorage.setOrCreate('window_height', 1080);

      ability.onDestroy();

      const width = AppStorage.get('window_width');
      const height = AppStorage.get('window_height');
      expect(width === undefined || width === null).assertTrue();
      expect(height === undefined || height === null).assertTrue();
    });

    [
      {
        name: 'entry_want_contract',
        expectedBundle: 'com.samples.album',
        expectedAbility: 'EntryAbility'
      }
    ].forEach((scenario) => {
      it(`should keep entry want contract for ${scenario.name}`, 0, () => {
        const want = PhotosUiHarness.getEntryWant();

        expect(want.bundleName).assertEqual(scenario.expectedBundle);
        expect(want.abilityName).assertEqual(scenario.expectedAbility);
      });
    });

    [
      {
        name: 'image_jpeg_payload',
        uri: 'file://media/10',
        type: 'image/jpeg'
      },
      {
        name: 'image_png_payload',
        uri: 'file://media/11',
        type: 'image/png'
      },
      {
        name: 'video_mp4_payload',
        uri: 'file://media/12',
        type: 'video/mp4'
      },
      {
        name: 'distributed_payload',
        uri: 'distributed://media/13',
        type: 'image/jpeg'
      }
    ].forEach((scenario) => {
      it(`should route file manager onCreate payload for ${scenario.name}`, 0, () => {
        const ability = new MainAbility();
        const context = createMockContext();
        const mainAbility = ability as MainAbilityWithContext;
        const want = {
          parameters: {
            uri: scenario.uri,
            type: scenario.type
          }
        } as Want;

        mainAbility.context = context;
        mainAbility.onCreate(want, {} as AbilityConstant.LaunchParam);

        expect(globalThis.startByFileMgr).assertTrue();
        expect(AppStorage.get('directUri') as string).assertEqual(scenario.uri);
        expect(AppStorage.get('directType') as string).assertEqual(scenario.type);
        expect(context.terminateCount).assertEqual(0);
      });
    });

    [
      {
        name: 'main_close_true',
        close: true,
        expectedTerminate: 1
      },
      {
        name: 'main_close_false',
        close: false,
        expectedTerminate: 0
      },
      {
        name: 'main_close_missing',
        close: undefined,
        expectedTerminate: 0
      }
    ].forEach((scenario) => {
      it(`should handle main ability new want for ${scenario.name}`, 0, () => {
        const ability = new MainAbility();
        const context = createMockContext();
        const mainAbility = ability as MainAbilityWithContext;

        mainAbility.context = context;
        mainAbility.onNewWant({
          parameters: {
            close: scenario.close
          }
        } as Want, {} as AbilityConstant.LaunchParam);

        expect(context.terminateCount).assertEqual(scenario.expectedTerminate);
      });
    });

    [
      {
        name: 'picker_single_limit',
        maxSelectCount: 1
      },
      {
        name: 'picker_normal_limit',
        maxSelectCount: 9
      },
      {
        name: 'picker_large_limit',
        maxSelectCount: 99
      },
      {
        name: 'picker_zero_limit',
        maxSelectCount: 0
      }
    ].forEach((scenario) => {
      it(`should persist picker max select count for ${scenario.name}`, 0, () => {
        const ability = new PickerAbility();
        const context = createMockContext();
        const pickerAbility = ability as PickerAbilityWithContext;

        pickerAbility.context = context;
        pickerAbility.onNewWant({
          parameters: {
            maxSelectCount: scenario.maxSelectCount
          }
        } as Want, {} as AbilityConstant.LaunchParam);

        expect(AppStorage.get('pickMaxSelectCount') as number).assertEqual(scenario.maxSelectCount);
        expect(context.terminateCount).assertEqual(0);
      });
    });

    [
      {
        name: 'picker_close_true',
        close: true,
        expectedTerminate: 1
      },
      {
        name: 'picker_close_false',
        close: false,
        expectedTerminate: 0
      },
      {
        name: 'picker_close_missing',
        close: undefined,
        expectedTerminate: 0
      }
    ].forEach((scenario) => {
      it(`should handle picker want close flag for ${scenario.name}`, 0, () => {
        const ability = new PickerAbility();
        const context = createMockContext();
        const pickerAbility = ability as PickerAbilityWithContext;

        pickerAbility.context = context;
        pickerAbility.handleWant({
          parameters: {
            close: scenario.close
          }
        } as Want);

        expect(context.terminateCount).assertEqual(scenario.expectedTerminate);
      });
    });

    [
      {
        name: 'destroy_with_window_size',
        width: 1920,
        height: 1080
      },
      {
        name: 'destroy_with_4k_window',
        width: 3840,
        height: 2160
      },
      {
        name: 'destroy_with_small_window',
        width: 1280,
        height: 720
      }
    ].forEach((scenario) => {
      it(`should clear app storage for ${scenario.name}`, 0, () => {
        const ability = new EntryAbility();
        AppStorage.setOrCreate('window_width', scenario.width);
        AppStorage.setOrCreate('window_height', scenario.height);

        ability.onDestroy();

        const width = AppStorage.get('window_width');
        const height = AppStorage.get('window_height');
        expect(width === undefined || width === null).assertTrue();
        expect(height === undefined || height === null).assertTrue();
      });
    });
  });
}
