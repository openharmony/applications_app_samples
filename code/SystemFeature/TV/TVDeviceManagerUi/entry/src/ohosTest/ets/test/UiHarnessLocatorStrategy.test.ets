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

import { describe, it } from '@ohos/hypium';
import { DisplayRotation, Driver } from '@ohos.UiTest';
import { SelectorCandidate, TVDeviceManagerUiHarness, UiLocator, UiDriverLike, UiComponentLike } from './base/UiTestHarness';
import { TestAsserts } from './base/TestAsserts';

class RecordingComponent implements UiComponentLike {
  public clickCount: number = 0;
  public text: string = '';
  public id: string = '';

  constructor(text: string = '', id: string = '') {
    this.text = text;
    this.id = id;
  }

  async click(): Promise<void> {
    this.clickCount++;
  }
}

class CandidateAwareDriver implements UiDriverLike {
  public locatorTrace: string[] = [];
  public delayHistory: number[] = [];
  private components: Map<string, RecordingComponent> = new Map();

  async delayMs(delay: number): Promise<void> {
    this.delayHistory.push(delay);
  }

  async setDisplayRotation(rotation: DisplayRotation): Promise<void> {
    // Mock implementation
  }

  async findComponent(locator: UiLocator): Promise<UiComponentLike | undefined> {
    const traceKey = `${locator.type}:${locator.value}`;
    this.locatorTrace.push(traceKey);
    
    const component = this.components.get(traceKey);
    return component;
  }

  registerText(text: string): RecordingComponent {
    const component = new RecordingComponent(text, '');
    this.components.set(`text:${text}`, component);
    return component;
  }

  registerId(id: string): RecordingComponent {
    const component = new RecordingComponent('', id);
    this.components.set(`id:${id}`, component);
    return component;
  }
}

class RotationProbeScenario {
  name: string;
  rotation: DisplayRotation;

  constructor(name: string, rotation: DisplayRotation) {
    this.name = name;
    this.rotation = rotation;
  }
}

function createRotationScenarios(): RotationProbeScenario[] {
  return [
    new RotationProbeScenario('rotation_0', DisplayRotation.ROTATION_0),
    new RotationProbeScenario('rotation_90', DisplayRotation.ROTATION_90),
    new RotationProbeScenario('rotation_180', DisplayRotation.ROTATION_180),
    new RotationProbeScenario('rotation_270', DisplayRotation.ROTATION_270)
  ];
}

async function probeTap(driver: UiDriverLike, candidates: SelectorCandidate[]): Promise<boolean> {
  return await TVDeviceManagerUiHarness.tapFirstAvailable(driver, candidates);
}

export default function uiHarnessLocatorStrategyTest(): void {
  describe('TVDeviceManagerUiUiHarnessLocatorStrategyTest', () => {
    it('should provide fallback candidates for confirm action entry', 0, () => {
      const candidates: SelectorCandidate[] = TVDeviceManagerUiHarness.buildConfirmCandidates();

      TestAsserts.assertArrayLength(candidates, 3);
      TestAsserts.assertStringEquals(candidates[0].text ?? '', '本次允许');
      TestAsserts.assertStringEquals(candidates[1].text ?? '', 'confirm');
      TestAsserts.assertStringEquals(candidates[2].id ?? '', 'confirm');
    });

    it('should preserve typo compatible cancel candidate for legacy pin dialog key', 0, () => {
      const candidates: SelectorCandidate[] = TVDeviceManagerUiHarness.buildPinCancelCandidates();
      const ids: string[] = [];
      for (let i = 0; i < candidates.length; i++) {
        const candidateId = candidates[i].id ?? '';
        ids.push(candidateId);
      }

      TestAsserts.assertTrue(ids.includes('cancle'));
      TestAsserts.assertTrue(ids.includes('cancel'));
    });

    it('should build generic locator objects for non driver mock path', 0, () => {
      const mockDriver: CandidateAwareDriver = new CandidateAwareDriver();
      const locator: UiLocator = TVDeviceManagerUiHarness.buildLocator(mockDriver, 'id', 'pinInput');

      TestAsserts.assertStringEquals(locator.type, 'id');
      TestAsserts.assertStringEquals(locator.value, 'pinInput');
    });

    it('should return first text matched component before checking later candidates', 0, async () => {
      const driver: CandidateAwareDriver = new CandidateAwareDriver();
      const component: RecordingComponent = driver.registerText('本次允许');

      const found: UiComponentLike | undefined = await TVDeviceManagerUiHarness.findFirstAvailable(
        driver,
        TVDeviceManagerUiHarness.buildConfirmCandidates()
      );

      TestAsserts.assertTrue(found === component);
      TestAsserts.assertStringEquals(driver.locatorTrace[0], 'text:本次允许');
    });

    it('should fall back to id candidate when text candidate is absent', 0, async () => {
      const driver: CandidateAwareDriver = new CandidateAwareDriver();
      const component: RecordingComponent = driver.registerId('always');

      const found: UiComponentLike | undefined = await TVDeviceManagerUiHarness.findFirstAvailable(
        driver,
        TVDeviceManagerUiHarness.buildAlwaysAllowCandidates()
      );

      TestAsserts.assertTrue(found === component);
      let hasIdTrace = false;
      for (let i = 0; i < driver.locatorTrace.length; i++) {
        if (driver.locatorTrace[i] === 'id:always') {
          hasIdTrace = true;
          break;
        }
      }
      TestAsserts.assertTrue(hasIdTrace);
    });

    it('should return undefined when no candidate is available', 0, async () => {
      const driver: CandidateAwareDriver = new CandidateAwareDriver();
      const found: UiComponentLike | undefined = await TVDeviceManagerUiHarness.findFirstAvailable(
        driver,
        TVDeviceManagerUiHarness.buildPinInputCandidates()
      );

      TestAsserts.assertTrue(found === undefined);
      TestAsserts.assertNumberAtLeast(driver.locatorTrace.length, 1);
    });

    it('should tap first available candidate and wait for stability', 0, async () => {
      const driver: CandidateAwareDriver = new CandidateAwareDriver();
      const component: RecordingComponent = driver.registerText('取消');
      const tapped: boolean = await TVDeviceManagerUiHarness.tapFirstAvailable(
        driver,
        TVDeviceManagerUiHarness.buildCancelCandidates()
      );

      TestAsserts.assertTrue(tapped);
      TestAsserts.assertNumberEquals(component.clickCount, 1);
      TestAsserts.assertArrayLength(driver.delayHistory, 1);
    });

    it('should avoid fake tap success when no component can be resolved', 0, async () => {
      const driver: CandidateAwareDriver = new CandidateAwareDriver();
      const tapped: boolean = await TVDeviceManagerUiHarness.tapFirstAvailable(
        driver,
        TVDeviceManagerUiHarness.buildPinConfirmCandidates()
      );

      TestAsserts.assertFalse(tapped);
      TestAsserts.assertArrayLength(driver.delayHistory, 0);
    });

    it('should normalize visible labels before readability validation', 0, () => {
      const normalized: string = TVDeviceManagerUiHarness.normalizeVisibleText('  PIN码连接   请输入  连接码  ');
      TestAsserts.assertStringEquals(normalized, 'PIN码连接 请输入 连接码');
    });

    it('should reject undefined and null fragments in readable labels', 0, () => {
      TestAsserts.assertTrue(TVDeviceManagerUiHarness.isReadableLabel('本次允许'));
      TestAsserts.assertFalse(TVDeviceManagerUiHarness.isReadableLabel('undefined label'));
      TestAsserts.assertFalse(TVDeviceManagerUiHarness.isReadableLabel('null label'));
    });

    it('should expose focus candidate map for all interactive regions', 0, () => {
      const focusMap: Map<string, SelectorCandidate[]> = TVDeviceManagerUiHarness.buildFocusCandidates();

      TestAsserts.assertTrue(focusMap.has('confirm'));
      TestAsserts.assertTrue(focusMap.has('cancel'));
      TestAsserts.assertTrue(focusMap.has('always'));
      TestAsserts.assertTrue(focusMap.has('pinInput'));
      TestAsserts.assertTrue(focusMap.has('pinConfirm'));
      TestAsserts.assertTrue(focusMap.has('pinCancel'));
    });

    it('should keep display matrix and rotation names aligned for matrix runner', 0, () => {
      const rotations: string[] = TVDeviceManagerUiHarness.getRotationNames();
      const matrix: number[][] = TVDeviceManagerUiHarness.createDisplayMatrix();

      TestAsserts.assertRotationMatrix(rotations);
      TestAsserts.assertArrayLength(matrix, 4);
    });

    it('should build driver aware locator for id and keep type stable', 0, () => {
      const driver: UiDriverLike = new CandidateAwareDriver();
      const locator: UiLocator = TVDeviceManagerUiHarness.buildLocator(driver, 'id', 'pinInput');
      TestAsserts.assertReadableText(locator.type);
      TestAsserts.assertReadableText(locator.value);
    });

    it('should probe confirm tap availability across rotation matrix', 0, async () => {
      const driver: UiDriverLike = new CandidateAwareDriver();
      const trace: string[] = [];
      const scenarios: RotationProbeScenario[] = createRotationScenarios();

      for (let i = 0; i < scenarios.length; i++) {
        const scenario = scenarios[i];
        await TVDeviceManagerUiHarness.setRotation(driver, scenario.rotation);
        trace.push(`rotation-${scenario.name}`);

        const tapped: boolean = await probeTap(driver, TVDeviceManagerUiHarness.buildConfirmCandidates());
        trace.push(`confirm-tapped-${tapped}`);
      }

      TestAsserts.assertArrayLength(trace, scenarios.length * 2);
      TestAsserts.assertStringContains(trace[0], 'rotation-');
      TestAsserts.assertStringContains(trace[1], 'confirm-tapped-');
    });
  });
}
