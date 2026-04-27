/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, beforeEach, afterEach, it, expect } from '@ohos/hypium';
import { display, window } from '@kit.ArkUI';
import EntryAbility from '../../../main/ets/entryability/EntryAbility';
import { restoreAll } from './Batch1TestHelper';

interface WindowRect {
  width: number;
  height: number;
}

interface MockWindowProperties {
  windowRect: WindowRect;
}

interface DisplayDensityInfo {
  densityDPI: number;
}

interface AbilityWindowStageRunner {
  onWindowStageCreate: (windowStage: window.WindowStage) => void;
}

interface MockWindowLike {
  setWindowLayoutFullScreen: (value: boolean) => void;
  setWindowKeepScreenOn: (value: boolean) => Promise<void>;
  getWindowProperties: () => Promise<MockWindowProperties>;
}

interface LoadContentError {
  code: number;
}

class MockWindowStage {
  private readonly mockWindow: MockWindowLike;
  private readonly loadCalls: string[];

  constructor(mockWindow: MockWindowLike, loadCalls: string[]) {
    this.mockWindow = mockWindow;
    this.loadCalls = loadCalls;
  }

  public async getMainWindow(): Promise<MockWindowLike> {
    return this.mockWindow;
  }

  public loadContent(page: string, callback?: (err: LoadContentError) => void): void {
    this.loadCalls.push(page);
    callback?.({ code: 0 });
  }
}

/**
 * Replaces the ArkUI display sync getter for one test case.
 *
 * @param replacement Replacement display info factory.
 * @returns () => void Restore callback for the original API.
 */
function patchGetDefaultDisplaySync(replacement: () => DisplayDensityInfo): () => void {
  const original = display.getDefaultDisplaySync;
  display.getDefaultDisplaySync = (): display.Display => {
    return replacement() as Object as display.Display;
  };
  return (): void => {
    display.getDefaultDisplaySync = original;
  };
}

/**
 * Registers tests for EntryAbility window-stage initialization.
 *
 * @returns void.
 */
export default function LifecycleTest(): void {
  describe('Lifecycle_real', () => {
    let restores: Array<() => void> = [];

    beforeEach(() => {
      restores = [];
      AppStorage.setOrCreate<number>('screen_px_w', -1);
      AppStorage.setOrCreate<number>('screen_px_h', -1);
      AppStorage.setOrCreate<number>('screen_lpx_w', -1);
      AppStorage.setOrCreate<number>('screen_lpx_h', -1);
      AppStorage.setOrCreate<number>('screen_dpi', -1);
      AppStorage.setOrCreate<number>('screen_lpi', -1);
    });

    afterEach(() => {
      restoreAll(restores);
    });

    it('should_initialize_window_metrics_and_load_default_page', 0, async () => {
      const fullScreenFlags: boolean[] = [];
      const keepScreenOnFlags: boolean[] = [];
      const loadCalls: string[] = [];
      const ability = new EntryAbility();
      ability.defaultPage = 'pages/HdmiPage';
      const mockWindow: MockWindowLike = {
        setWindowLayoutFullScreen: (value: boolean): void => {
          fullScreenFlags.push(value);
        },
        setWindowKeepScreenOn: async (value: boolean): Promise<void> => {
          keepScreenOnFlags.push(value);
        },
        getWindowProperties: async (): Promise<MockWindowProperties> => {
          return {
            windowRect: {
              width: 3840,
              height: 2160
            }
          };
        }
      };
      const stage = new MockWindowStage(mockWindow, loadCalls);
      restores.push(
        patchGetDefaultDisplaySync((): DisplayDensityInfo => {
          return { densityDPI: 320 };
        }),
      );

      // Window-stage startup seeds the page metrics that multiple UI modules
      // rely on for layout calculations before rendering their first frame.
      (ability as AbilityWindowStageRunner).onWindowStageCreate(stage as Object as window.WindowStage);
      await Promise.resolve();
      await Promise.resolve();
      await Promise.resolve();

      expect(fullScreenFlags.join(',')).assertEqual('true');
      expect(keepScreenOnFlags.join(',')).assertEqual('true');
      expect(loadCalls.join(',')).assertEqual('pages/HdmiPage');
      expect(AppStorage.get<number>('screen_px_w')).assertEqual(3840);
      expect(AppStorage.get<number>('screen_px_h')).assertEqual(2160);
      expect(AppStorage.get<number>('screen_lpx_w')).assertEqual(1920);
      expect(AppStorage.get<number>('screen_lpx_h')).assertEqual(1080);
      expect(AppStorage.get<number>('screen_dpi')).assertEqual(2);
      expect(AppStorage.get<number>('screen_lpi')).assertEqual(2);
    });
  });
}
