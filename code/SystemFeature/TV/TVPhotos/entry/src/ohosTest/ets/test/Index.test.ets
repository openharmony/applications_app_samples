import { beforeAll, describe, expect, it } from '@ohos/hypium';
import { DisplayRotation } from '@ohos.UiTest';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { FakeUiComponent, FakeUiDriver } from './base/TestDoubles';
import { PhotosUiHarness } from './base/UiTestHarness';

const TAG: string = '[PhotosTvTest]';

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

    [
      {
        tab: 'picture',
        component: new FakeUiComponent('menu0', 'Pictures')
      },
      {
        tab: 'album',
        component: new FakeUiComponent('menu1', 'Albums')
      },
      {
        tab: 'distributed',
        component: new FakeUiComponent('menu2', 'Distributed Gallery')
      }
    ].forEach((scenario) => {
      it(`should open home tab from fallback chain for ${scenario.tab}`, 0, async () => {
        const driver = new FakeUiDriver();
        driver.registerComponent(scenario.component);

        const opened = await PhotosUiHarness.openHomeTab(driver, scenario.tab);

        expect(opened).assertTrue();
        expect(scenario.component.wasClicked()).assertTrue();
      });
    });

    [
      {
        name: 'distributed_id_fallback',
        tab: 'distributed',
        component: new FakeUiComponent('menu2', 'placeholder')
      },
      {
        name: 'album_id_fallback',
        tab: 'album',
        component: new FakeUiComponent('menu1', 'placeholder')
      },
      {
        name: 'picture_id_fallback',
        tab: 'picture',
        component: new FakeUiComponent('menu0', 'placeholder')
      }
    ].forEach((scenario) => {
      it(`should use menu id fallback for ${scenario.name}`, 0, async () => {
        const driver = new FakeUiDriver();
        driver.registerComponent(scenario.component);

        const opened = await PhotosUiHarness.openHomeTab(driver, scenario.tab);

        expect(opened).assertTrue();
        expect(scenario.component.wasClicked()).assertTrue();
      });
    });

    [
      {
        key: 'choose',
        component: new FakeUiComponent('dialog2', 'Choose')
      },
      {
        key: 'share',
        component: new FakeUiComponent('dialog1', 'Share')
      },
      {
        key: 'delete',
        component: new FakeUiComponent('dialog0', 'Delete')
      }
    ].forEach((scenario) => {
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

    [
      {
        value: '  分布式   图库 ',
        expected: '分布式 图库'
      },
      {
        value: '  Photos   TV ',
        expected: 'Photos TV'
      },
      {
        value: '  相册 ',
        expected: '相册'
      }
    ].forEach((scenario) => {
      it(`should normalize visible text for ${scenario.expected}`, 0, () => {
        expect(PhotosUiHarness.normalizeVisibleText(scenario.value)).assertEqual(scenario.expected);
      });
    });

    [
      {
        labels: ['照片', '相册', '分布式图库'],
        expected: true
      },
      {
        labels: ['Pictures', 'Albums', 'Distributed Gallery'],
        expected: true
      },
      {
        labels: ['Pictures', 'undefined distributed'],
        expected: false
      }
    ].forEach((scenario) => {
      it(`should validate label set contract for ${scenario.labels.join('_')}`, 0, () => {
        expect(PhotosUiHarness.validateLabelSet(scenario.labels)).assertEqual(scenario.expected);
      });
    });

    [
      {
        key: 'picture',
        expectedText: '照片',
        expectedId: 'menu0'
      },
      {
        key: 'album',
        expectedText: '相册',
        expectedId: 'menu1'
      },
      {
        key: 'distributed',
        expectedText: '分布式图库',
        expectedId: 'menu2'
      }
    ].forEach((scenario) => {
      it(`should expose home tab candidates for ${scenario.key}`, 0, () => {
        const candidates = PhotosUiHarness.buildHomeTabCandidates().get(scenario.key) ?? [];

        expect(candidates.length).assertEqual(3);
        expect(candidates[0].text).assertEqual(scenario.expectedText);
        expect(candidates[2].id).assertEqual(scenario.expectedId);
      });
    });

    [
      {
        key: 'choose',
        expectedText: '选择',
        expectedId: 'dialog2'
      },
      {
        key: 'share',
        expectedText: '分享',
        expectedId: 'dialog1'
      },
      {
        key: 'delete',
        expectedText: '删除',
        expectedId: 'dialog0'
      }
    ].forEach((scenario) => {
      it(`should expose edit dialog candidates for ${scenario.key}`, 0, () => {
        const candidates = PhotosUiHarness.buildEditDialogCandidates().get(scenario.key) ?? [];

        expect(candidates.length).assertEqual(3);
        expect(candidates[0].text).assertEqual(scenario.expectedText);
        expect(candidates[2].id).assertEqual(scenario.expectedId);
      });
    });

    [
      {
        rotation: DisplayRotation.ROTATION_0,
        expectedDelayLength: 2
      },
      {
        rotation: DisplayRotation.ROTATION_90,
        expectedDelayLength: 2
      },
      {
        rotation: DisplayRotation.ROTATION_180,
        expectedDelayLength: 2
      },
      {
        rotation: DisplayRotation.ROTATION_270,
        expectedDelayLength: 2
      }
    ].forEach((scenario) => {
      it(`should record rotation helper flow for ${scenario.rotation}`, 0, async () => {
        const driver = new FakeUiDriver();

        await PhotosUiHarness.setRotation(driver, scenario.rotation);

        expect(driver.getRotationHistory().length).assertEqual(1);
        expect(driver.getDelayHistory().length).assertEqual(scenario.expectedDelayLength);
      });
    });

    [
      {
        delays: [120, 80],
        expectedFirst: 120,
        expectedMiddle: 600,
        expectedLast: 80
      },
      {
        delays: [60, 40],
        expectedFirst: 60,
        expectedMiddle: 40,
        expectedLast: 40
      }
    ].forEach((scenario) => {
      it(`should record wait history sequence for ${scenario.delays.join('_')}`, 0, async () => {
        const driver = new FakeUiDriver();

        for (const delay of scenario.delays) {
          await PhotosUiHarness.waitForStable(driver, delay);
        }

        const history = driver.getDelayHistory();
        expect(history[0]).assertEqual(scenario.expectedFirst);
        expect(history[history.length - 1]).assertEqual(scenario.expectedLast);
      });
    });

    [
      {
        expectedFirst: 'ROTATION_0',
        expectedLast: 'ROTATION_270'
      }
    ].forEach((scenario) => {
      it(`should keep complete rotation name matrix for ${scenario.expectedLast}`, 0, () => {
        const rotations = PhotosUiHarness.getRotationNames();

        expect(rotations.length).assertEqual(4);
        expect(rotations[0]).assertEqual(scenario.expectedFirst);
        expect(rotations[rotations.length - 1]).assertEqual(scenario.expectedLast);
      });
    });
  });
}
