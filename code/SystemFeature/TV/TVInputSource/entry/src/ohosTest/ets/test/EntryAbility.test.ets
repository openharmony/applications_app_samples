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
import { AbilityConstant, Want } from '@kit.AbilityKit';
import EntryAbility from '../../../main/ets/entryability/EntryAbility';
import { restoreAll } from './Batch1TestHelper';

interface EntryAbilityGlobalScope {
  pullBundleName?: string;
  AbilityContext?: Object;
  abilityWant?: Want;
  AbilityLauncherParam?: AbilityConstant.LaunchParam;
  windowStage?: EntryAbilityWindowStageMock;
}

interface EntryAbilityWindowStageMock {
  loadContent: (page: string) => void;
}

interface MockAbilityContext {
  tag?: string;
  terminateSelf?: () => void;
}

interface TaggedMockAbilityContext extends MockAbilityContext {
  tag: string;
}

interface TerminatingMockAbilityContext extends MockAbilityContext {
  terminateSelf: () => void;
}

interface EntryAbilityContextHolder {
  context: MockAbilityContext;
}

/**
 * Registers tests for want parsing, launch routing and lifecycle side effects.
 *
 * @returns void.
 */
export default function EntryAbilityTest(): void {
  describe('EntryAbility_real', () => {
    let ability: EntryAbility;
    let restores: Array<() => void> = [];

    beforeEach(() => {
      ability = new EntryAbility();
      restores = [];
      AppStorage.setOrCreate<number>('sourceId_reboot', -1);
    });

    afterEach(() => {
      restoreAll(restores);
      AppStorage.setOrCreate<number>('sourceId_reboot', -1);
      (globalThis as EntryAbilityGlobalScope).pullBundleName = undefined;
      (globalThis as EntryAbilityGlobalScope).AbilityContext = undefined;
      (globalThis as EntryAbilityGlobalScope).abilityWant = undefined;
      (globalThis as EntryAbilityGlobalScope).AbilityLauncherParam = undefined;
      (globalThis as EntryAbilityGlobalScope).windowStage = undefined;
    });

    it('should_route_dtv_bundle_to_indexdtv_page', 0, () => {
      const want = {
        parameters: {
          bundleNames: ['DTV']
        }
      } as Want;

      // DTV wants are a dedicated entry path because they bypass HDMI binding
      // and land directly in the channel-oriented experience.
      ability.getWantData(want);

      expect(ability.defaultPage).assertEqual('pages/IndexDtv');
    });

    it('should_route_hdmi_bundle_to_hdmi_page_and_cache_source_id', 0, () => {
      const want = {
        parameters: {
          bundleNames: ['HDMI3']
        }
      } as Want;

      // Reboot routing persists the requested HDMI source so the page can
      // recover the same input even before router params become available.
      ability.getWantData(want);

      expect(ability.defaultPage).assertEqual('pages/HdmiPage');
      expect(AppStorage.get<number>('sourceId_reboot')).assertEqual(3);
    });

    it('should_capture_pull_bundle_name_and_context_on_create', 0, () => {
      const mockContext: TaggedMockAbilityContext = {
        tag: 'mockContext'
      };
      (ability as EntryAbilityContextHolder).context = mockContext;
      const want = {
        parameters: {
          pullBundleName: 'com.ohos.launcher',
          bundleNames: ['HDMI1']
        }
      } as Want;

      // onCreate seeds globals that later pages reuse for return routing and
      // settings access, so both side effects must remain stable.
      ability.onCreate(want, {} as AbilityConstant.LaunchParam);

      expect((globalThis as EntryAbilityGlobalScope).pullBundleName).assertEqual('com.ohos.launcher');
      expect((globalThis as EntryAbilityGlobalScope).AbilityContext as Object).assertEqual(mockContext);
      expect(ability.defaultPage).assertEqual('pages/HdmiPage');
    });

    it('should_reload_current_default_page_on_new_want', 0, () => {
      const loadCalls: string[] = [];
      ability.defaultPage = 'pages/IndexDtv';
      (globalThis as EntryAbilityGlobalScope).windowStage = {
        loadContent: (page: string): void => {
          loadCalls.push(page);
        }
      };
      const want = {
        parameters: {
          pullBundleName: 'com.example.caller'
        }
      } as Want;

      // New wants refresh the existing window stage instead of recreating the
      // ability, which keeps task switching responsive for launcher callbacks.
      ability.onNewWant(want, {} as AbilityConstant.LaunchParam);

      expect((globalThis as EntryAbilityGlobalScope).pullBundleName).assertEqual('com.example.caller');
      expect((globalThis as EntryAbilityGlobalScope).abilityWant as Object).assertEqual(want);
      expect(loadCalls.join(',')).assertEqual('pages/IndexDtv');
    });

    it('should_terminate_self_when_entering_background', 0, () => {
      let terminateCount = 0;
      const mockContext: TerminatingMockAbilityContext = {
        terminateSelf: (): void => {
          terminateCount++;
        }
      };
      (ability as EntryAbilityContextHolder).context = mockContext;

      // The ability intentionally self-terminates in background to avoid stale
      // TV task stacks keeping heavyweight playback resources alive.
      ability.onBackground();

      expect(terminateCount).assertEqual(1);
    });
  });
}
