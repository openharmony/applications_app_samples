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

import { describe, expect, it } from '@ohos/hypium';
import { PhotoPositionUtils } from '../../../main/ets/common/PhotoPositionUtils';
import { PhotoDataSource, PhotoGroupDataSource } from '../../../main/ets/models/IDataSource';
import { PhotoGroupModel, PhotoModel, PhotoPosition } from '../../../main/ets/models/PhotoModel';
import { TestAsserts } from './base/TestAsserts';
import { TestDataFactory } from './base/TestDataFactory';
import { FakeUiComponent, FakeUiDriver, MockFocusController } from './base/TestDoubles';
import { PhotosUiHarness } from './base/UiTestHarness';

class DataChangeRecorder implements DataChangeListener {
  reloadCount: number = 0;
  addIndexes: number[] = [];
  deleteIndexes: number[] = [];
  changeIndexes: number[] = [];

  onDataReloaded(): void {
    this.reloadCount++;
  }

  onDatasetChange(): void {
    this.onDataReloaded();
  }

  onDataAdd(index: number): void {
    this.addIndexes.push(index);
  }

  onDataAdded(index: number): void {
    this.onDataAdd(index);
  }

  onDataDelete(index: number): void {
    this.deleteIndexes.push(index);
  }

  onDataDeleted(index: number): void {
    this.onDataDelete(index);
  }

  onDataChange(index: number): void {
    this.changeIndexes.push(index);
  }

  onDataChanged(index: number): void {
    this.onDataChange(index);
  }

  onDataMove(from: number, to: number): void {
  }

  onDataMoved(from: number, to: number): void {
    this.onDataMove(from, to);
  }
}

class GroupSourceScenario {
  name: string;
  groups: PhotoGroupModel[];
  expectedFirstUri: string;
  expectedGroupCount: number;

  constructor(name: string, groups: PhotoGroupModel[], expectedFirstUri: string, expectedGroupCount: number) {
    this.name = name;
    this.groups = groups;
    this.expectedFirstUri = expectedFirstUri;
    this.expectedGroupCount = expectedGroupCount;
  }
}

class PositionScenario {
  groupIndex: number;
  photoIndex: number;
  expectedRow: number;
  expectedColumn: number;

  constructor(groupIndex: number, photoIndex: number, expectedRow: number, expectedColumn: number) {
    this.groupIndex = groupIndex;
    this.photoIndex = photoIndex;
    this.expectedRow = expectedRow;
    this.expectedColumn = expectedColumn;
  }
}

class FlatIndexScenario {
  position: PhotoPosition;
  expectedIndex: number;

  constructor(position: PhotoPosition, expectedIndex: number) {
    this.position = position;
    this.expectedIndex = expectedIndex;
  }
}

class FocusFallbackScenario {
  name: string;
  groupIndex: number;
  photoIndex: number;
  expectedGroup: number;
  expectedRow: number;
  expectedColumn: number;

  constructor(name: string, groupIndex: number, photoIndex: number, expectedGroup: number, expectedRow: number,
    expectedColumn: number) {
    this.name = name;
    this.groupIndex = groupIndex;
    this.photoIndex = photoIndex;
    this.expectedGroup = expectedGroup;
    this.expectedRow = expectedRow;
    this.expectedColumn = expectedColumn;
  }
}

class DownFocusFallbackScenario extends FocusFallbackScenario {
  groupLength: number;

  constructor(name: string, groupIndex: number, photoIndex: number, groupLength: number, expectedGroup: number,
    expectedRow: number, expectedColumn: number) {
    super(name, groupIndex, photoIndex, expectedGroup, expectedRow, expectedColumn);
    this.groupLength = groupLength;
  }
}

class DeleteFocusScenario {
  name: string;
  groupIndex: number;
  photoIndex: number;
  expectedGroup: number;
  expectedColumn: number;

  constructor(name: string, groupIndex: number, photoIndex: number, expectedGroup: number, expectedColumn: number) {
    this.name = name;
    this.groupIndex = groupIndex;
    this.photoIndex = photoIndex;
    this.expectedGroup = expectedGroup;
    this.expectedColumn = expectedColumn;
  }
}

class HomeTabScenario {
  tab: string;
  component: FakeUiComponent;

  constructor(tab: string, component: FakeUiComponent) {
    this.tab = tab;
    this.component = component;
  }
}

class DialogActionScenario {
  name: string;
  key: string;
  component: FakeUiComponent;

  constructor(name: string, key: string, component: FakeUiComponent) {
    this.name = name;
    this.key = key;
    this.component = component;
  }
}

class DelayScenario {
  name: string;
  delays: number[];
  expectedFirst: number;
  expectedLast: number;

  constructor(name: string, delays: number[], expectedFirst: number, expectedLast: number) {
    this.name = name;
    this.delays = delays;
    this.expectedFirst = expectedFirst;
    this.expectedLast = expectedLast;
  }
}

const GROUP_SOURCE_SCENARIOS: GroupSourceScenario[] = [
  new GroupSourceScenario('single_group_reverse', [createGroup(3, 0, 1)], 'file://media/2', 1),
  new GroupSourceScenario('double_group_reverse', [createGroup(3, 0, 1), createGroup(2, 10, 2)], 'file://media/2', 2),
  new GroupSourceScenario('triple_group_reverse', buildLocalGalleryGroups(), 'file://media/11', 3)
];

const POSITION_SCENARIOS: PositionScenario[] = [
  new PositionScenario(0, 0, 0, 0),
  new PositionScenario(0, 4, 0, 4),
  new PositionScenario(0, 5, 1, 0),
  new PositionScenario(0, 8, 1, 3),
  new PositionScenario(1, 0, 0, 0),
  new PositionScenario(2, 7, 1, 2)
];

const FLAT_INDEX_SCENARIOS: FlatIndexScenario[] = [
  new FlatIndexScenario(new PhotoPosition(0, 0, 0), 0),
  new FlatIndexScenario(new PhotoPosition(0, 0, 4), 4),
  new FlatIndexScenario(new PhotoPosition(0, 1, 0), 5),
  new FlatIndexScenario(new PhotoPosition(1, 1, 3), 8),
  new FlatIndexScenario(new PhotoPosition(2, 0, 2), 2)
];

const LEFT_FOCUS_SCENARIOS: FocusFallbackScenario[] = [
  new FocusFallbackScenario('left_in_second_row', 0, 5, 0, 0, 0),
  new FocusFallbackScenario('left_in_first_row', 0, 3, 0, 0, 2),
  new FocusFallbackScenario('left_boundary', 0, 0, -1, -1, -1)
];

const RIGHT_FOCUS_SCENARIOS: FocusFallbackScenario[] = [
  new FocusFallbackScenario('right_in_first_row', 0, 3, 0, 0, 4),
  new FocusFallbackScenario('right_in_second_row', 0, 6, 0, 1, 2),
  new FocusFallbackScenario('right_tail_boundary', 1, 3, -1, -1, -1)
];

const UP_FOCUS_SCENARIOS: FocusFallbackScenario[] = [
  new FocusFallbackScenario('up_inside_group', 0, 7, 0, 0, 3),
  new FocusFallbackScenario('up_to_previous_group', 1, 1, 0, 2, 1),
  new FocusFallbackScenario('up_boundary', 0, 0, -1, -1, -1)
];

const DOWN_FOCUS_SCENARIOS: DownFocusFallbackScenario[] = [
  new DownFocusFallbackScenario('down_inside_group', 0, 4, 12, 0, 1, 3),
  new DownFocusFallbackScenario('down_to_next_group', 1, 3, 4, 2, 0, 3),
  new DownFocusFallbackScenario('down_boundary', 2, 8, 9, -1, -1, -1)
];

const DELETE_FOCUS_SCENARIOS: DeleteFocusScenario[] = [
  new DeleteFocusScenario('delete_inside_group', 0, 4, 0, 4),
  new DeleteFocusScenario('delete_group_tail', 1, 7, 1, 2),
  new DeleteFocusScenario('delete_last_group_tail', 9, 1, 2, 1)
];

const HOME_TAB_SCENARIOS: HomeTabScenario[] = [
  new HomeTabScenario('picture', new FakeUiComponent('menu0', 'Pictures')),
  new HomeTabScenario('album', new FakeUiComponent('menu1', 'Albums')),
  new HomeTabScenario('distributed', new FakeUiComponent('menu2', 'Distributed Gallery'))
];

const DIALOG_ACTION_SCENARIOS: DialogActionScenario[] = [
  new DialogActionScenario('delete_action', 'delete', new FakeUiComponent('dialog0', '删除')),
  new DialogActionScenario('share_action', 'share', new FakeUiComponent('dialog1', 'Share')),
  new DialogActionScenario('choose_action', 'choose', new FakeUiComponent('dialog2', 'Choose'))
];

const DELAY_SCENARIOS: DelayScenario[] = [
  new DelayScenario('120_80', [120, 80], 120, 80),
  new DelayScenario('60_60_60', [60, 60, 60], 60, 60)
];

function createPhotoWithDisplayName(index: number, displayName: string): PhotoModel {
  const photo = TestDataFactory.createPhoto(index);
  photo.displayName = displayName;
  return photo;
}

function createPhotoRange(count: number, startIndex: number): PhotoModel[] {
  const photos: PhotoModel[] = [];
  for (let index = 0; index < count; index++) {
    photos.push(TestDataFactory.createPhoto(startIndex + index));
  }
  return photos;
}

function createGroup(count: number, startIndex: number, createTime: number): PhotoGroupModel {
  const group = new PhotoGroupModel();
  group.createTime = createTime;
  group.photoList = createPhotoRange(count, startIndex);
  return group;
}

function buildLocalGalleryGroups(): PhotoGroupModel[] {
  return [
    createGroup(12, 0, 20250301),
    createGroup(4, 20, 20250302),
    createGroup(9, 40, 20250303)
  ];
}

export default function localPageInteractionTest() {
  describe('LocalPageInteractionTest', () => {
    {
      it('should reverse photo source data and keep preset items at the tail', 0, () => {
        const source = new PhotoDataSource();
        const recorder = new DataChangeRecorder();
        const photos = [
          createPhotoWithDisplayName(0, 'IMG_0.jpg'),
          createPhotoWithDisplayName(1, 'PRESET_WELCOME.jpg'),
          createPhotoWithDisplayName(2, 'IMG_2.jpg')
        ];
        source.registerDataChangeListener(recorder);

        // 首页和列表页都依赖数据源反转，来保证最新照片优先展示。
        // 同时预置素材要落在尾部，否则首次引导卡片会持续污染真实媒体排序。
        source.setData(photos);

        expect(source.totalCount()).assertEqual(3);
        expect((source.getData(0) as PhotoModel).displayName).assertEqual('IMG_2.jpg');
        expect((source.getData(2) as PhotoModel).displayName).assertEqual('PRESET_WELCOME.jpg');
        expect(recorder.reloadCount).assertEqual(2);
      });

      it('should notify add and reload when photo source inserts item', 0, () => {
        const source = new PhotoDataSource();
        const recorder = new DataChangeRecorder();
        source.registerDataChangeListener(recorder);
        source.setData(TestDataFactory.createPhotoList(2));
        source.addData(1, TestDataFactory.createPhoto(8));

        expect(recorder.addIndexes.includes(1)).assertTrue();
        expect(source.totalCount()).assertEqual(3);
      });

      it('should notify tail add index when pushing latest photo', 0, () => {
        const source = new PhotoDataSource();
        const recorder = new DataChangeRecorder();
        source.registerDataChangeListener(recorder);
        source.setData(TestDataFactory.createPhotoList(2));
        source.pushData(TestDataFactory.createPhoto(9));

        expect(recorder.addIndexes[recorder.addIndexes.length - 1]).assertEqual(2);
        expect(source.totalCount()).assertEqual(3);
      });

      it('should delete photo source entry and emit delete notification', 0, () => {
        const source = new PhotoDataSource();
        const recorder = new DataChangeRecorder();
        source.registerDataChangeListener(recorder);
        source.setData(TestDataFactory.createPhotoList(3));
        source.deleteData(1);

        expect(source.totalCount()).assertEqual(2);
        expect(recorder.deleteIndexes[0]).assertEqual(1);
      });

      it('should clear photo source data for empty state rendering', 0, () => {
        const source = new PhotoDataSource();
        const recorder = new DataChangeRecorder();
        source.registerDataChangeListener(recorder);
        source.setData(TestDataFactory.createPhotoList(4));
        const cleared = source.clearData();

        expect(cleared.length).assertEqual(0);
        expect(source.totalCount()).assertEqual(0);
        expect(recorder.reloadCount >= 3).assertTrue();
      });

      it('should reverse each group photo list for grouped gallery rendering', 0, () => {
        const source = new PhotoGroupDataSource();
        const groups = [createGroup(3, 0, 1), createGroup(2, 10, 2)];
        source.setData(groups);

        expect(source.totalCount()).assertEqual(2);
        expect(source.getData(0).photoList[0].uri).assertEqual('file://media/2');
        expect(source.getData(1).photoList[0].uri).assertEqual('file://media/11');
      });

      it('should support grouped source insertion and deletion', 0, () => {
        const source = new PhotoGroupDataSource();
        const recorder = new DataChangeRecorder();
        source.registerDataChangeListener(recorder);
        source.setData([createGroup(2, 0, 1)]);
        source.addData(1, createGroup(1, 10, 2));
        source.deleteData(0);

        expect(source.totalCount()).assertEqual(1);
        expect(recorder.addIndexes[0]).assertEqual(1);
        expect(recorder.deleteIndexes[0]).assertEqual(0);
      });

      it('should clear grouped source for trash page reset', 0, () => {
        const source = new PhotoGroupDataSource();
        source.setData([createGroup(2, 0, 1), createGroup(2, 10, 2)]);
        source.clearData();
        expect(source.totalCount()).assertEqual(0);
      });
    }

    {
      it('should convert photo index to focus position across row layouts', 0, () => {
        const positions = [
          PhotoPositionUtils.getPhotoPosition(0, 0),
          PhotoPositionUtils.getPhotoPosition(0, 4),
          PhotoPositionUtils.getPhotoPosition(0, 5),
          PhotoPositionUtils.getPhotoPosition(0, 8),
          PhotoPositionUtils.getPhotoPosition(0, 9)
        ];

        expect(positions[0].rowIndex).assertEqual(0);
        expect(positions[1].columIndex).assertEqual(4);
        expect(positions[2].rowIndex).assertEqual(1);
        expect(positions[3].columIndex).assertEqual(3);
        expect(positions[4].rowIndex).assertEqual(2);
      });

      it('should convert focus position back to flat index', 0, () => {
        const positions = [
          new PhotoPosition(0, 0, 3),
          new PhotoPosition(0, 1, 2),
          new PhotoPosition(0, 3, 4)
        ];
        const indexes = positions.map((item) => PhotoPositionUtils.getIndexByPhotoPosition(item));
        expect(indexes[0]).assertEqual(3);
        expect(indexes[1]).assertEqual(7);
        expect(indexes[2]).assertEqual(20);
      });

      it('should move focus left inside local grid and jump to poster anchor', 0, () => {
        const fromSecondRow = PhotoPositionUtils.findLeftFocusPhoto(0, 5);
        const fromFirstRow = PhotoPositionUtils.findLeftFocusPhoto(0, 3);
        const fromEdge = PhotoPositionUtils.findLeftFocusPhoto(0, 0);

        expect(fromSecondRow?.rowIndex).assertEqual(0);
        expect(fromSecondRow?.columIndex).assertEqual(0);
        expect(fromFirstRow?.columIndex).assertEqual(2);
        expect(fromEdge === undefined).assertTrue();
      });

      it('should move focus right until group boundary', 0, () => {
        const groups = buildLocalGalleryGroups();
        const nextInFirstRow = PhotoPositionUtils.findRightFocusPhoto(groups, 0, 3);
        const nextInSecondRow = PhotoPositionUtils.findRightFocusPhoto(groups, 0, 6);
        const noNextAtTail = PhotoPositionUtils.findRightFocusPhoto(groups, 1, 3);

        expect(nextInFirstRow?.rowIndex).assertEqual(0);
        expect(nextInFirstRow?.columIndex).assertEqual(4);
        expect(nextInSecondRow?.columIndex).assertEqual(2);
        expect(noNextAtTail === undefined).assertTrue();
      });

      it('should move focus up within group and across previous group', 0, () => {
        const groups = buildLocalGalleryGroups();
        const sameGroup = PhotoPositionUtils.findUpFocusPhoto(groups, 0, 7);
        const previousGroup = PhotoPositionUtils.findUpFocusPhoto(groups, 1, 1);

        expect(sameGroup?.rowIndex).assertEqual(0);
        expect(sameGroup?.columIndex).assertEqual(3);
        expect(previousGroup?.groupIndex).assertEqual(0);
      });

      it('should move focus down within group and to next group', 0, () => {
        const groups = buildLocalGalleryGroups();
        const sameGroup = PhotoPositionUtils.findDownFocusPhoto(groups, 0, 4, groups[0].photoList.length);
        const nextGroup = PhotoPositionUtils.findDownFocusPhoto(groups, 1, 3, groups[1].photoList.length);

        expect(sameGroup?.rowIndex).assertEqual(1);
        expect(sameGroup?.columIndex).assertEqual(3);
        expect(nextGroup?.groupIndex).assertEqual(2);
        expect(nextGroup?.rowIndex).assertEqual(0);
      });

      it('should find fallback focus position after deletion in current or previous group', 0, () => {
        const groups = buildLocalGalleryGroups();
        const sameGroup = PhotoPositionUtils.findFocusPositionOnDelete(groups, 0, 4);
        const tailInGroup = PhotoPositionUtils.findFocusPositionOnDelete(groups, 1, 7);
        const lastGroupTail = PhotoPositionUtils.findFocusPositionOnDelete(groups, 9, 1);

        expect(sameGroup?.columIndex).assertEqual(4);
        expect(tailInGroup?.groupIndex).assertEqual(1);
        expect(lastGroupTail?.groupIndex).assertEqual(2);
      });

      it('should return undefined delete focus on empty grouped data', 0, () => {
        const result = PhotoPositionUtils.findFocusPositionOnDelete([], 0, 0);
        expect(result === undefined).assertTrue();
      });

      it('should expose last position in target group', 0, () => {
        const groups = buildLocalGalleryGroups();
        const position = PhotoPositionUtils.getLastPositionInGroup(groups, 0);
        expect(position?.rowIndex).assertEqual(2);
        expect(position?.columIndex).assertEqual(2);
      });
    }

    {
      it('should open local home tabs through selector fallback chain', 0, async () => {
        const driver = new FakeUiDriver();
        driver.registerComponent(new FakeUiComponent('menu0', 'Pictures'));
        driver.registerComponent(new FakeUiComponent('menu1', 'Albums'));

        const pictureOpened = await PhotosUiHarness.openHomeTab(driver, 'picture');
        const albumOpened = await PhotosUiHarness.openHomeTab(driver, 'album');

        expect(pictureOpened).assertTrue();
        expect(albumOpened).assertTrue();
      });

      it('should open edit dialog action with text or id fallback', 0, async () => {
        const driver = new FakeUiDriver();
        const deleteButton = new FakeUiComponent('dialog0', '删除');
        driver.registerComponent(deleteButton);

        const opened = await PhotosUiHarness.tapFirstAvailable(
          driver,
          PhotosUiHarness.buildEditDialogCandidates().get('delete') ?? []
        );

        expect(opened).assertTrue();
        expect(deleteButton.wasClicked()).assertTrue();
      });

      it('should accumulate action delay history during fake UI interactions', 0, async () => {
        const driver = new FakeUiDriver();
        await PhotosUiHarness.waitForStable(driver, 120);
        await PhotosUiHarness.waitForStable(driver, 80);
        TestAsserts.assertNumberProgression(driver.getDelayHistory(), 120, -40);
      });

      it('should validate local tab labels are readable after normalization', 0, () => {
        const labels = ['  照片  ', ' 相册 ', 'Distributed  Gallery'];
        const normalized = labels.map((item) => PhotosUiHarness.normalizeVisibleText(item));
        expect(PhotosUiHarness.validateLabelSet(normalized)).assertTrue();
      });

      it('should maintain deterministic focus history for dialog back actions', 0, () => {
        const focusController = new MockFocusController();
        focusController.allow(['dialog0', 'dialog1', 'delete1']);
        focusController.requestFocus('dialog1');
        focusController.requestFocus('delete1');
        focusController.requestFocus('dialog0');

        const focusHistory = focusController.getFocusHistory().map((item) => item.focusId);
        expect(focusHistory.length).assertEqual(3);
        expect(focusHistory[0]).assertEqual('dialog1');
        expect(focusHistory[1]).assertEqual('delete1');
        expect(focusHistory[2]).assertEqual('dialog0');
      });

      GROUP_SOURCE_SCENARIOS.forEach((scenario) => {
        it(`should build grouped photo source for ${scenario.name}`, 0, () => {
          const source = new PhotoGroupDataSource();

          source.setData(scenario.groups);

          expect(source.totalCount()).assertEqual(scenario.expectedGroupCount);
          expect(source.getData(0).photoList[0].uri).assertEqual(scenario.expectedFirstUri);
        });
      });

      POSITION_SCENARIOS.forEach((scenario) => {
        it(`should compute photo position for group ${scenario.groupIndex} index ${scenario.photoIndex}`, 0, () => {
          const position = PhotoPositionUtils.getPhotoPosition(scenario.groupIndex, scenario.photoIndex);

          expect(position.groupIndex).assertEqual(scenario.groupIndex);
          expect(position.rowIndex).assertEqual(scenario.expectedRow);
          expect(position.columIndex).assertEqual(scenario.expectedColumn);
        });
      });

      FLAT_INDEX_SCENARIOS.forEach((scenario) => {
        it(`should compute flat index for row ${scenario.position.rowIndex} column ${scenario.position.columIndex}`, 0, () => {
          expect(PhotoPositionUtils.getIndexByPhotoPosition(scenario.position)).assertEqual(scenario.expectedIndex);
        });
      });

      LEFT_FOCUS_SCENARIOS.forEach((scenario) => {
        it(`should compute left focus fallback for ${scenario.name}`, 0, () => {
          const position = PhotoPositionUtils.findLeftFocusPhoto(scenario.groupIndex, scenario.photoIndex);

          if (scenario.expectedGroup === -1) {
            expect(position === undefined).assertTrue();
            return;
          }
          expect(position?.groupIndex).assertEqual(scenario.expectedGroup);
          expect(position?.rowIndex).assertEqual(scenario.expectedRow);
          expect(position?.columIndex).assertEqual(scenario.expectedColumn);
        });
      });

      RIGHT_FOCUS_SCENARIOS.forEach((scenario) => {
        it(`should compute right focus fallback for ${scenario.name}`, 0, () => {
          const position = PhotoPositionUtils.findRightFocusPhoto(buildLocalGalleryGroups(), scenario.groupIndex, scenario.photoIndex);

          if (scenario.expectedGroup === -1) {
            expect(position === undefined).assertTrue();
            return;
          }
          expect(position?.groupIndex).assertEqual(scenario.expectedGroup);
          expect(position?.rowIndex).assertEqual(scenario.expectedRow);
          expect(position?.columIndex).assertEqual(scenario.expectedColumn);
        });
      });

      UP_FOCUS_SCENARIOS.forEach((scenario) => {
        it(`should compute up focus fallback for ${scenario.name}`, 0, () => {
          const position = PhotoPositionUtils.findUpFocusPhoto(buildLocalGalleryGroups(), scenario.groupIndex, scenario.photoIndex);

          if (scenario.expectedGroup === -1) {
            expect(position === undefined).assertTrue();
            return;
          }
          expect(position?.groupIndex).assertEqual(scenario.expectedGroup);
          expect(position?.rowIndex).assertEqual(scenario.expectedRow);
          expect(position?.columIndex).assertEqual(scenario.expectedColumn);
        });
      });

      DOWN_FOCUS_SCENARIOS.forEach((scenario) => {
        it(`should compute down focus fallback for ${scenario.name}`, 0, () => {
          const position = PhotoPositionUtils.findDownFocusPhoto(
            buildLocalGalleryGroups(),
            scenario.groupIndex,
            scenario.photoIndex,
            scenario.groupLength
          );

          if (scenario.expectedGroup === -1) {
            expect(position === undefined).assertTrue();
            return;
          }
          expect(position?.groupIndex).assertEqual(scenario.expectedGroup);
          expect(position?.rowIndex).assertEqual(scenario.expectedRow);
          expect(position?.columIndex).assertEqual(scenario.expectedColumn);
        });
      });

      DELETE_FOCUS_SCENARIOS.forEach((scenario) => {
        it(`should compute delete fallback for ${scenario.name}`, 0, () => {
          const position = PhotoPositionUtils.findFocusPositionOnDelete(
            buildLocalGalleryGroups(),
            scenario.groupIndex,
            scenario.photoIndex
          );

          expect(position?.groupIndex).assertEqual(scenario.expectedGroup);
          expect(position?.columIndex).assertEqual(scenario.expectedColumn);
        });
      });

      HOME_TAB_SCENARIOS.forEach((scenario) => {
        it(`should open home tab fallback chain for ${scenario.tab}`, 0, async () => {
          const driver = new FakeUiDriver();
          driver.registerComponent(scenario.component);

          const opened = await PhotosUiHarness.openHomeTab(driver, scenario.tab);

          expect(opened).assertTrue();
          expect(scenario.component.wasClicked()).assertTrue();
        });
      });

      DIALOG_ACTION_SCENARIOS.forEach((scenario) => {
        it(`should open edit dialog action for ${scenario.name}`, 0, async () => {
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

      DELAY_SCENARIOS.forEach((scenario) => {
        it(`should record stable wait history for ${scenario.name}`, 0, async () => {
          const driver = new FakeUiDriver();

          for (const delay of scenario.delays) {
            await PhotosUiHarness.waitForStable(driver, delay);
          }

          const history = driver.getDelayHistory();
          expect(history[0]).assertEqual(scenario.expectedFirst);
          expect(history[history.length - 1]).assertEqual(scenario.expectedLast);
        });
      });
    }
  });
}
