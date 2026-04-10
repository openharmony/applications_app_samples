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

import { beforeAll, describe, expect, it } from '@ohos/hypium';
import { DisplayRotation } from '@ohos.UiTest';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { FakeUiComponent, FakeUiDriver } from './base/TestDoubles';
import { PhotosUiHarness } from './base/UiTestHarness';

const TAG: string = '[PhotosTvTest]';

class HomeTabOpenScenario {
  tab: string;
  component: FakeUiComponent;

  constructor(tab: string, component: FakeUiComponent) {
    this.tab = tab;
    this.component = component;
  }
}

class HomeTabFallbackScenario {
  name: string;
  tab: string;
  component: FakeUiComponent;

  constructor(name: string, tab: string, component: FakeUiComponent) {
    this.name = name;
    this.tab = tab;
    this.component = component;
  }
}

class DialogActionScenario {
  key: string;
  component: FakeUiComponent;

  constructor(key: string, component: FakeUiComponent) {
    this.key = key;
    this.component = component;
  }
}

class NormalizeTextScenario {
  value: string;
  expected: string;

  constructor(value: string, expected: string) {
    this.value = value;
    this.expected = expected;
  }
}

class LabelSetScenario {
  name: string;
  labels: string[];
  expected: boolean;

  constructor(name: string, labels: string[], expected: boolean) {
    this.name = name;
    this.labels = labels;
    this.expected = expected;
  }
}

class CandidateScenario {
  key: string;
  expectedText: string;
  expectedId: string;

  constructor(key: string, expectedText: string, expectedId: string) {
    this.key = key;
    this.expectedText = expectedText;
    this.expectedId = expectedId;
  }
}

class RotationScenario {
  rotation: DisplayRotation;
  expectedDelayLength: number;

  constructor(rotation: DisplayRotation, expectedDelayLength: number) {
    this.rotation = rotation;
    this.expectedDelayLength = expectedDelayLength;
  }
}

class WaitHistoryScenario {
  name: string;
  delays: number[];
  expectedFirst: number;
  expectedMiddle: number;
  expectedLast: number;

  constructor(name: string, delays: number[], expectedFirst: number, expectedMiddle: number, expectedLast: number) {
    this.name = name;
    this.delays = delays;
    this.expectedFirst = expectedFirst;
    this.expectedMiddle = expectedMiddle;
    this.expectedLast = expectedLast;
  }
}

class RotationNameScenario {
  expectedFirst: string;
  expectedLast: string;

  constructor(expectedFirst: string, expectedLast: string) {
    this.expectedFirst = expectedFirst;
    this.expectedLast = expectedLast;
  }
}

const HOME_TAB_OPEN_SCENARIOS: HomeTabOpenScenario[] = [
  new HomeTabOpenScenario('picture', new FakeUiComponent('menu0', 'Pictures')),
  new HomeTabOpenScenario('album', new FakeUiComponent('menu1', 'Albums')),
  new HomeTabOpenScenario('distributed', new FakeUiComponent('menu2', 'Distributed Gallery'))
];

const HOME_TAB_FALLBACK_SCENARIOS: HomeTabFallbackScenario[] = [
  new HomeTabFallbackScenario('distributed_id_fallback', 'distributed', new FakeUiComponent('menu2', 'placeholder')),
  new HomeTabFallbackScenario('album_id_fallback', 'album', new FakeUiComponent('menu1', 'placeholder')),
  new HomeTabFallbackScenario('picture_id_fallback', 'picture', new FakeUiComponent('menu0', 'placeholder'))
];

const DIALOG_ACTION_SCENARIOS: DialogActionScenario[] = [
  new DialogActionScenario('choose', new FakeUiComponent('dialog2', 'Choose')),
  new DialogActionScenario('share', new FakeUiComponent('dialog1', 'Share')),
  new DialogActionScenario('delete', new FakeUiComponent('dialog0', 'Delete'))
];

const NORMALIZE_TEXT_SCENARIOS: NormalizeTextScenario[] = [
  new NormalizeTextScenario('  分布式   图库 ', '分布式 图库'),
  new NormalizeTextScenario('  Photos   TV ', 'Photos TV'),
  new NormalizeTextScenario('  相册 ', '相册')
];

const LABEL_SET_SCENARIOS: LabelSetScenario[] = [
  new LabelSetScenario('zh_labels', ['照片', '相册', '分布式图库'], true),
  new LabelSetScenario('en_labels', ['Pictures', 'Albums', 'Distributed Gallery'], true),
  new LabelSetScenario('invalid_labels', ['Pictures', 'undefined distributed'], false)
];

const HOME_TAB_CANDIDATE_SCENARIOS: CandidateScenario[] = [
  new CandidateScenario('picture', '照片', 'menu0'),
  new CandidateScenario('album', '相册', 'menu1'),
  new CandidateScenario('distributed', '分布式图库', 'menu2')
];

const EDIT_DIALOG_CANDIDATE_SCENARIOS: CandidateScenario[] = [
  new CandidateScenario('choose', '选择', 'dialog2'),
  new CandidateScenario('share', '分享', 'dialog1'),
  new CandidateScenario('delete', '删除', 'dialog0')
];

const ROTATION_SCENARIOS: RotationScenario[] = [
  new RotationScenario(DisplayRotation.ROTATION_0, 1),
  new RotationScenario(DisplayRotation.ROTATION_90, 1),
  new RotationScenario(DisplayRotation.ROTATION_180, 1),
  new RotationScenario(DisplayRotation.ROTATION_270, 1)
];

const WAIT_HISTORY_SCENARIOS: WaitHistoryScenario[] = [
  new WaitHistoryScenario('120_80', [120, 80], 120, 80, 80),
  new WaitHistoryScenario('60_40', [60, 40], 60, 40, 40)
];

const ROTATION_NAME_SCENARIOS: RotationNameScenario[] = [
  new RotationNameScenario('ROTATION_0', 'ROTATION_270')
];

export default function IndexTest() {
  describe('PhotosTvTest', () => {
    beforeAll(async () => {
      try {
        await PhotosUiHarness.startEntryAbility();
      } catch (err) {
        hilog.error(0x0000, TAG, '%{public}s', 'Ability startAbility fail');
        expect().assertFail();
      }
    });

    it('should start entry ability and expose readable core home labels', 0, async () => {
      const labels = await PhotosUiHarness.getCoreHomeLabels();
      expect(PhotosUiHarness.validateLabelSet(labels)).assertTrue();
      expect(labels.length).assertEqual(3);
      expect(labels[0].length > 0).assertTrue();
      expect(labels[1].length > 0).assertTrue();
      expect(labels[2].length > 0).assertTrue();
    });

    it('should open picture album and distributed tabs through selector fallback chain', 0, async () => {
      const driver = new FakeUiDriver();
      const picture = new FakeUiComponent('menu0', 'Pictures');
      const album = new FakeUiComponent('menu1', 'Albums');
      const distributed = new FakeUiComponent('menu2', 'Distributed Gallery');
      driver.registerComponent(picture);
      driver.registerComponent(album);
      driver.registerComponent(distributed);

      const pictureOpened = await PhotosUiHarness.openHomeTab(driver, 'picture');
      const albumOpened = await PhotosUiHarness.openHomeTab(driver, 'album');
      const distributedOpened = await PhotosUiHarness.openHomeTab(driver, 'distributed');

      expect(pictureOpened).assertTrue();
      expect(albumOpened).assertTrue();
      expect(distributedOpened).assertTrue();
      expect(picture.wasClicked()).assertTrue();
      expect(album.wasClicked()).assertTrue();
      expect(distributed.wasClicked()).assertTrue();
    });

    it('should fall back to menu id when localized tab text is unavailable', 0, async () => {
      const driver = new FakeUiDriver();
      const distributed = new FakeUiComponent('menu2', 'placeholder');
      driver.registerComponent(distributed);

      const distributedOpened = await PhotosUiHarness.openHomeTab(driver, 'distributed');

      expect(distributedOpened).assertTrue();
      expect(distributed.wasClicked()).assertTrue();
    });

    it('should open choose share and delete actions through dialog candidate fallback', 0, async () => {
      const driver = new FakeUiDriver();
      const choose = new FakeUiComponent('dialog2', 'Choose');
      const share = new FakeUiComponent('dialog1', 'Share');
      const deleteAction = new FakeUiComponent('dialog0', 'Delete');
      driver.registerComponent(choose);
      driver.registerComponent(share);
      driver.registerComponent(deleteAction);

      const chooseOpened = await PhotosUiHarness.tapFirstAvailable(
        driver,
        PhotosUiHarness.buildEditDialogCandidates().get('choose') ?? []
      );
      const shareOpened = await PhotosUiHarness.tapFirstAvailable(
        driver,
        PhotosUiHarness.buildEditDialogCandidates().get('share') ?? []
      );
      const deleteOpened = await PhotosUiHarness.tapFirstAvailable(
        driver,
        PhotosUiHarness.buildEditDialogCandidates().get('delete') ?? []
      );

      expect(chooseOpened).assertTrue();
      expect(shareOpened).assertTrue();
      expect(deleteOpened).assertTrue();
      expect(choose.wasClicked()).assertTrue();
      expect(share.wasClicked()).assertTrue();
      expect(deleteAction.wasClicked()).assertTrue();
    });

    it('should normalize labels and reject unreadable placeholder text', 0, () => {
      const normalized = PhotosUiHarness.normalizeVisibleText('  分布式   图库 ');
      const validLabels = [' 照片 ', normalized, ' Albums '].map((item) => PhotosUiHarness.normalizeVisibleText(item));
      const invalidLabels = ['Pictures', 'undefined distributed'];

      expect(normalized).assertEqual('分布式 图库');
      expect(PhotosUiHarness.validateLabelSet(validLabels)).assertTrue();
      expect(PhotosUiHarness.validateLabelSet(invalidLabels)).assertFalse();
    });

    it('should expose stable home tab candidate ordering for multilingual UI', 0, () => {
      const homeTabCandidates = PhotosUiHarness.buildHomeTabCandidates();
      const pictureCandidates = homeTabCandidates.get('picture') ?? [];
      const albumCandidates = homeTabCandidates.get('album') ?? [];
      const distributedCandidates = homeTabCandidates.get('distributed') ?? [];

      expect(pictureCandidates.length).assertEqual(3);
      expect(pictureCandidates[0].text).assertEqual('照片');
      expect(pictureCandidates[2].id).assertEqual('menu0');
      expect(albumCandidates[1].text).assertEqual('Albums');
      expect(distributedCandidates[2].id).assertEqual('menu2');
    });

    it('should expose stable edit action candidate ordering for menu dialog', 0, () => {
      const editDialogCandidates = PhotosUiHarness.buildEditDialogCandidates();
      const chooseCandidates = editDialogCandidates.get('choose') ?? [];
      const shareCandidates = editDialogCandidates.get('share') ?? [];
      const deleteCandidates = editDialogCandidates.get('delete') ?? [];

      expect(chooseCandidates.length).assertEqual(3);
      expect(chooseCandidates[0].text).assertEqual('选择');
      expect(chooseCandidates[2].id).assertEqual('dialog2');
      expect(shareCandidates[1].text).assertEqual('Share');
      expect(deleteCandidates[2].id).assertEqual('dialog0');
    });

    it('should record wait history and rotation history through UI harness helpers', 0, async () => {
      const driver = new FakeUiDriver();

      await PhotosUiHarness.waitForStable(driver, 120);
      await PhotosUiHarness.setRotation(driver, DisplayRotation.ROTATION_90);
      await PhotosUiHarness.waitForStable(driver, 80);

      const delayHistory = driver.getDelayHistory();
      const rotationHistory = driver.getRotationHistory();

      expect(delayHistory.length).assertEqual(3);
      expect(delayHistory[0]).assertEqual(120);
      expect(delayHistory[1]).assertEqual(600);
      expect(delayHistory[2]).assertEqual(80);
      expect(rotationHistory.length).assertEqual(1);
    });

    it('should expose complete rotation matrix for watch and fullscreen flows', 0, () => {
      const rotations = PhotosUiHarness.getRotationNames();
      expect(rotations.length).assertEqual(4);
      expect(rotations[0]).assertEqual('ROTATION_0');
      expect(rotations[1]).assertEqual('ROTATION_90');
      expect(rotations[2]).assertEqual('ROTATION_180');
      expect(rotations[3]).assertEqual('ROTATION_270');
    });

    HOME_TAB_OPEN_SCENARIOS.forEach((scenario: HomeTabOpenScenario) => {
      it(`should open home tab from fallback chain for ${scenario.tab}`, 0, async () => {
        const driver = new FakeUiDriver();
        driver.registerComponent(scenario.component);

        const opened = await PhotosUiHarness.openHomeTab(driver, scenario.tab);

        expect(opened).assertTrue();
        expect(scenario.component.wasClicked()).assertTrue();
      });
    });

    HOME_TAB_FALLBACK_SCENARIOS.forEach((scenario: HomeTabFallbackScenario) => {
      it(`should use menu id fallback for ${scenario.name}`, 0, async () => {
        const driver = new FakeUiDriver();
        driver.registerComponent(scenario.component);

        const opened = await PhotosUiHarness.openHomeTab(driver, scenario.tab);

        expect(opened).assertTrue();
        expect(scenario.component.wasClicked()).assertTrue();
      });
    });

    DIALOG_ACTION_SCENARIOS.forEach((scenario: DialogActionScenario) => {
      it(`should open edit dialog fallback candidate for ${scenario.key}`, 0, async () => {
        const driver = new FakeUiDriver();
        driver.registerComponent(scenario.component);

        const opened = await PhotosUiHarness.tapFirstAvailable(
          driver,
          PhotosUiHarness.buildEditDialogCandidates().get(scenario.key) ?? []
        );

        expect(opened).assertTrue();
        expect(scenario.component.wasClicked()).assertTrue();
      });
    });

    NORMALIZE_TEXT_SCENARIOS.forEach((scenario: NormalizeTextScenario) => {
      it(`should normalize visible text for ${scenario.expected}`, 0, () => {
        expect(PhotosUiHarness.normalizeVisibleText(scenario.value)).assertEqual(scenario.expected);
      });
    });

    LABEL_SET_SCENARIOS.forEach((scenario: LabelSetScenario) => {
      it(`should validate label set contract for ${scenario.name}`, 0, () => {
        expect(PhotosUiHarness.validateLabelSet(scenario.labels)).assertEqual(scenario.expected);
      });
    });

    HOME_TAB_CANDIDATE_SCENARIOS.forEach((scenario: CandidateScenario) => {
      it(`should expose home tab candidates for ${scenario.key}`, 0, () => {
        const candidates = PhotosUiHarness.buildHomeTabCandidates().get(scenario.key) ?? [];

        expect(candidates.length).assertEqual(3);
        expect(candidates[0].text).assertEqual(scenario.expectedText);
        expect(candidates[2].id).assertEqual(scenario.expectedId);
      });
    });

    EDIT_DIALOG_CANDIDATE_SCENARIOS.forEach((scenario: CandidateScenario) => {
      it(`should expose edit dialog candidates for ${scenario.key}`, 0, () => {
        const candidates = PhotosUiHarness.buildEditDialogCandidates().get(scenario.key) ?? [];

        expect(candidates.length).assertEqual(3);
        expect(candidates[0].text).assertEqual(scenario.expectedText);
        expect(candidates[2].id).assertEqual(scenario.expectedId);
      });
    });

    ROTATION_SCENARIOS.forEach((scenario: RotationScenario) => {
      it(`should record rotation helper flow for ${scenario.rotation}`, 0, async () => {
        const driver = new FakeUiDriver();

        await PhotosUiHarness.setRotation(driver, scenario.rotation);

        expect(driver.getRotationHistory().length).assertEqual(1);
        expect(driver.getDelayHistory().length).assertEqual(scenario.expectedDelayLength);
      });
    });

    WAIT_HISTORY_SCENARIOS.forEach((scenario: WaitHistoryScenario) => {
      it(`should record wait history sequence for ${scenario.name}`, 0, async () => {
        const driver = new FakeUiDriver();

        for (const delay of scenario.delays) {
          await PhotosUiHarness.waitForStable(driver, delay);
        }

        const history = driver.getDelayHistory();
        expect(history[0]).assertEqual(scenario.expectedFirst);
        expect(history.length >= 2).assertTrue();
        expect(history[1]).assertEqual(scenario.expectedMiddle);
        expect(history[history.length - 1]).assertEqual(scenario.expectedLast);
      });
    });

    ROTATION_NAME_SCENARIOS.forEach((scenario: RotationNameScenario) => {
      it(`should keep complete rotation name matrix for ${scenario.expectedLast}`, 0, () => {
        const rotations = PhotosUiHarness.getRotationNames();

        expect(rotations.length).assertEqual(4);
        expect(rotations[0]).assertEqual(scenario.expectedFirst);
        expect(rotations[rotations.length - 1]).assertEqual(scenario.expectedLast);
      });
    });
  });
}
