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
import { Constants } from '../../../main/ets/common/Constants';
import { FIRST_ROW_MAX_INDEX } from '../../../main/ets/common/PhotoPositionUtils';
import { PhotoGroupDataSource } from '../../../main/ets/models/IDataSource';
import { AlbumModel, AlbumType, PhotoGroupModel, PhotoModel } from '../../../main/ets/models/PhotoModel';
import { SessionModel } from '../../../main/ets/smaba/NasSessionManager';
import { TestAsserts } from './base/TestAsserts';
import { TestDataFactory } from './base/TestDataFactory';
import { MockFocusController } from './base/TestDoubles';

class MockWifiConnectionManager {
  closeCount: number = 0;

  async closeConnection(): Promise<void> {
    this.closeCount++;
  }
}

class ReceivedInfoModel {
  size: number;
  type: number;

  constructor(size: number, type: number) {
    this.size = size;
    this.type = type;
  }
}

class DeviceNameModel {
  deviceName: string;

  constructor(deviceName: string) {
    this.deviceName = deviceName;
  }
}

class PhotoGroupingScenario {
  name: string;
  photos: PhotoModel[];
  albumType: AlbumType;
  expectedGroupCount: number;
  expectedFirstGroupLength: number;

  constructor(
    name: string,
    photos: PhotoModel[],
    albumType: AlbumType,
    expectedGroupCount: number,
    expectedFirstGroupLength: number
  ) {
    this.name = name;
    this.photos = photos;
    this.albumType = albumType;
    this.expectedGroupCount = expectedGroupCount;
    this.expectedFirstGroupLength = expectedFirstGroupLength;
  }
}

class KeyCallbackScenario {
  name: string;
  chooseIndex: number;
  focusStr: string;
  dialogFlag: boolean;
  photoCount: number;
  expectDialog: boolean;
  expectDfs: boolean;
  expectedDialogFocus: string;

  constructor(
    name: string,
    chooseIndex: number,
    focusStr: string,
    dialogFlag: boolean,
    photoCount: number,
    expectDialog: boolean,
    expectDfs: boolean,
    expectedDialogFocus: string
  ) {
    this.name = name;
    this.chooseIndex = chooseIndex;
    this.focusStr = focusStr;
    this.dialogFlag = dialogFlag;
    this.photoCount = photoCount;
    this.expectDialog = expectDialog;
    this.expectDfs = expectDfs;
    this.expectedDialogFocus = expectedDialogFocus;
  }
}

class ReceivedStateScenario {
  name: string;
  initialState: number;
  initialFocus: string;
  expectReceive: boolean;
  expectFocus: string;
  expectWifiCloseCount: number;
  expectState: number;

  constructor(
    name: string,
    initialState: number,
    initialFocus: string,
    expectReceive: boolean,
    expectFocus: string,
    expectWifiCloseCount: number,
    expectState: number
  ) {
    this.name = name;
    this.initialState = initialState;
    this.initialFocus = initialFocus;
    this.expectReceive = expectReceive;
    this.expectFocus = expectFocus;
    this.expectWifiCloseCount = expectWifiCloseCount;
    this.expectState = expectState;
  }
}

class SizeLabelScenario {
  name: string;
  size: number;
  expected: string;

  constructor(name: string, size: number, expected: string) {
    this.name = name;
    this.size = size;
    this.expected = expected;
  }
}

type AlbumDirection = 'left' | 'up' | 'right' | 'down';

class AlbumNeighborScenario {
  current: AlbumType;
  direction: AlbumDirection;
  expected: number;

  constructor(current: AlbumType, direction: AlbumDirection, expected: number) {
    this.current = current;
    this.direction = direction;
    this.expected = expected;
  }
}

class DistributedReceiveHarness {
  chooseIndex: number = 0;
  photoGroupList: PhotoGroupDataSource = new PhotoGroupDataSource();
  focusStr: string = 'menu0';
  dialogFocusStr: string = '';
  dialogFlag: boolean = false;
  dialogIndex: number = 0;
  showToDfsDialog: boolean = false;
  receiveFlag: boolean = false;
  receiveIndex: number = 1;
  receivedState: number = 0;
  receivedInfo: ReceivedInfoModel = new ReceivedInfoModel(0, 1);
  progressValue: number = 0;
  progress: number = 0;
  fullSize: string = '';
  typeName: string = '';
  currentName: string = '已选设备';
  sizeConvert: number = 1024;
  allPhotos: PhotoModel[] = [];
  photoGroupModels: PhotoGroupModel[] = [];
  subTypeModels: (AlbumModel | undefined)[] = [];
  routeHistory: string[] = [];
  insertedPhotos: PhotoModel[][] = [];
  receivedStateHistory: number[] = [];
  private focusController: MockFocusController;
  private wifiManager: MockWifiConnectionManager;

  constructor(focusController?: MockFocusController, wifiManager?: MockWifiConnectionManager) {
    this.focusController = focusController ?? new MockFocusController();
    this.wifiManager = wifiManager ?? new MockWifiConnectionManager();
    this.focusController.allow([
      'menu0',
      'menu1',
      'dialog2',
      'receive1',
      'dfs_dialog_confirm',
      'album0',
      'album1',
      'album2',
      'album3',
      'album4',
      'album5'
    ]);
  }

  keyCallback(): void {
    if (!this.dialogFlag && this.chooseIndex === 0 && this.photoGroupList.totalCount()) {
      if (this.focusStr === 'menu0') {
        this.dialogFlag = true;
        this.clickFocusBtn('dialog2', true);
        this.dialogIndex = 2;
      } else {
        this.getMenuClick();
      }
    }

    if (this.chooseIndex === 2) {
      this.showToDfsDialog = true;
      this.clickFocusBtn('dfs_dialog_confirm', true);
    }
  }

  allPhotoObserver(photos: PhotoModel[], albumModel: AlbumModel): void {
    this.allPhotos = photos;
    this.insertedPhotos.push([...photos]);
    const tmpList: PhotoGroupModel[] = [];
    if (photos && photos.length > 0) {
      photos.forEach((photo: PhotoModel) => {
        const index = tmpList.findIndex((item: PhotoGroupModel) => item.createTime === photo.dateAdded);
        if (index >= 0) {
          tmpList[index].photoList.push(photo);
        } else {
          const photoDateModel = new PhotoGroupModel();
          photoDateModel.createTime = photo.dateAdded;
          photoDateModel.photoList.push(photo);
          tmpList.push(photoDateModel);
        }
      });
    }
    this.photoGroupModels = tmpList;
    this.photoGroupList.setData(this.photoGroupModels);
    this.photoGroupModels.forEach((group, groupIndex) => {
      group.photoList.forEach((photo, photoIndex) => {
        photo.photoTag = `photo_${groupIndex}_${photoIndex}`;
      });
    });
    this.subTypeModels[AlbumType.ALL] = albumModel;
    this.subTypeModels.push(undefined);
    this.subTypeModels.pop();
  }

  favoritePhotoObserver(albumModel: AlbumModel): void {
    this.subTypeModels[AlbumType.FAVORITE] = albumModel;
    this.subTypeModels.push(undefined);
    this.subTypeModels.pop();
  }

  screenShotPhotoObserver(albumModel: AlbumModel): void {
    this.subTypeModels[AlbumType.SCREENSHOT] = albumModel;
    this.subTypeModels.push(undefined);
    this.subTypeModels.pop();
  }

  trashPhotoObserver(albumModel: AlbumModel): void {
    this.subTypeModels[AlbumType.TRASH] = albumModel;
    this.subTypeModels[AlbumType.TRASH]!.cover = 'app.media.cover_trash';
    this.subTypeModels.push(undefined);
    this.subTypeModels.pop();
  }

  nasSessionObserver(models: SessionModel[]): void {
    this.subTypeModels[AlbumType.NAS_SESSION] = new AlbumModel(AlbumType.NAS_SESSION, '更多');
    this.subTypeModels[AlbumType.NAS_SESSION]!.count = models.length;
    this.subTypeModels[AlbumType.NAS_SESSION]!.cover = 'app.media.cover_more';
    this.subTypeModels.push(undefined);
    this.subTypeModels.pop();
  }

  changeDevice(): void {
    if (this.deviceList.length === 0) {
      this.currentName = '';
    }
  }

  deviceList: DeviceNameModel[] = [];

  async receivedStateChange(): Promise<void> {
    if (this.receivedState === 6) {
      this.getReceiveBack();
      await this.wifiManager.closeConnection();
      this.receivedState = 0;
      this.receivedStateHistory.push(this.receivedState);
    } else if (this.receivedState === 2) {
      this.receiveFlag = true;
      this.receiveIndex = 1;
      this.clickFocusBtn('receive1', true);
    }
  }

  progressChange(): void {
    this.progress = Math.round((this.progressValue / this.receivedInfo.size) * 100);
  }

  getSize(size: number): string {
    if (size / (this.sizeConvert * this.sizeConvert) > 1) {
      return `${(size / (this.sizeConvert * this.sizeConvert)).toFixed(2)}MB`;
    }
    return `${(size / this.sizeConvert).toFixed(2)}KB`;
  }

  getMediaType(type: number): string {
    return type === 1 ? '张图片' : '个视频';
  }

  aboutToAppear(): void {
    if (this.receivedInfo && this.receivedInfo.size) {
      this.fullSize = this.getSize(this.receivedInfo.size);
      this.typeName = this.getMediaType(this.receivedInfo.type);
    }
  }

  dismissToDfsDialog(): void {
    this.showToDfsDialog = false;
    this.clickFocusBtn(this.focusStr, false);
  }

  toDfsDevicePage(): void {
    this.routeHistory.push('pages/DistributedDevicePage');
    this.dismissToDfsDialog();
  }

  getReceiveBack(): void {
    this.receiveFlag = false;
    this.receiveIndex = 1;
    this.clickFocusBtn('menu0', false);
  }

  getMenuClick(): void {
    this.dialogFlag = true;
    this.dialogIndex = 2;
    this.clickFocusBtn('dialog2', true);
  }

  clickFocusBtn(str: string, inDialog: boolean): boolean {
    const isSuccess = this.focusController.requestFocus(str);
    if (!isSuccess) {
      return false;
    }
    if (inDialog) {
      this.dialogFocusStr = str;
    } else {
      this.focusStr = str;
    }
    return true;
  }

  focusFirstAlbum(): void {
    const index = this.subTypeModels.findIndex((value) => value && value.count > 0);
    this.clickFocusBtn(`album${index}`, false);
  }

  nextAlbumClick(currentIndex: number, direction: 'left' | 'up' | 'right' | 'down'): void {
    const index = this.getNextAlbum(currentIndex, direction);
    if (index !== -1) {
      this.clickFocusBtn(`album${index}`, false);
    }
  }

  getNextAlbum(currentIndex: number, direction: 'left' | 'up' | 'right' | 'down'): number {
    const indexs: number[] = [];
    let trueIndex = 0;
    this.subTypeModels.forEach((value, index) => {
      if (value && (value.count > 0 || value.type === AlbumType.NAS_SESSION)) {
        indexs.push(index);
        if (index === currentIndex) {
          trueIndex = indexs.length - 1;
        }
      }
    });

    let newIndex = -1;
    if (direction === 'left' && trueIndex > 0) {
      newIndex = indexs[trueIndex - 1];
    }
    if (direction === 'right' && trueIndex < indexs.length - 1) {
      newIndex = indexs[trueIndex + 1];
    }
    if (direction === 'up' && trueIndex > FIRST_ROW_MAX_INDEX) {
      newIndex = indexs[trueIndex - FIRST_ROW_MAX_INDEX];
    }
    if (direction === 'down' && trueIndex < indexs.length - FIRST_ROW_MAX_INDEX) {
      newIndex = indexs[trueIndex + FIRST_ROW_MAX_INDEX];
    }
    return newIndex;
  }

  getFocusHistory(): string[] {
    return this.focusController.getFocusHistory().map((item) => item.focusId);
  }
}

function createObserverPhotos(): PhotoModel[] {
  return [
    TestDataFactory.createPhoto(0, { dateAdded: 1735689600000 }, { namePrefix: 'DFS_A' }),
    TestDataFactory.createPhoto(1, { dateAdded: 1735689600000 }, { namePrefix: 'DFS_B' }),
    TestDataFactory.createPhoto(2, { dateAdded: 1735776000000 }, { namePrefix: 'DFS_C' })
  ];
}

function createAlbumMatrix(): (AlbumModel | undefined)[] {
  const albums: (AlbumModel | undefined)[] = [];
  albums[AlbumType.ALL] = new AlbumModel(AlbumType.ALL, '全部');
  albums[AlbumType.ALL]!.count = 5;
  albums[AlbumType.FAVORITE] = new AlbumModel(AlbumType.FAVORITE, '收藏');
  albums[AlbumType.FAVORITE]!.count = 3;
  albums[AlbumType.SCREENSHOT] = new AlbumModel(AlbumType.SCREENSHOT, '截图');
  albums[AlbumType.SCREENSHOT]!.count = 0;
  albums[AlbumType.TRASH] = new AlbumModel(AlbumType.TRASH, '回收站');
  albums[AlbumType.TRASH]!.count = 2;
  albums[AlbumType.NAS_SESSION] = new AlbumModel(AlbumType.NAS_SESSION, '更多');
  albums[AlbumType.NAS_SESSION]!.count = 0;
  return albums;
}

function createDenseAlbumMatrix(): (AlbumModel | undefined)[] {
  const albums: (AlbumModel | undefined)[] = [];
  const enabledTypes: AlbumType[] = [
    AlbumType.ALL,
    AlbumType.FAVORITE,
    AlbumType.SCREENSHOT,
    AlbumType.TRASH,
    AlbumType.NAS_SESSION
  ];
  enabledTypes.forEach((type, index) => {
    const album = new AlbumModel(type, `album_${type}`);
    album.count = index + 1;
    albums[type] = album;
  });
  return albums;
}

const PHOTO_GROUPING_SCENARIOS: PhotoGroupingScenario[] = [
  new PhotoGroupingScenario(
    'single_day_all_album',
    [
      TestDataFactory.createPhoto(0, { dateAdded: 1735689600000 }, { namePrefix: 'SINGLE_A' }),
      TestDataFactory.createPhoto(1, { dateAdded: 1735689600000 }, { namePrefix: 'SINGLE_B' })
    ],
    AlbumType.ALL,
    1,
    2
  ),
  new PhotoGroupingScenario(
    'split_two_days_all_album',
    [
      TestDataFactory.createPhoto(0, { dateAdded: 1735689600000 }, { namePrefix: 'DUAL_A' }),
      TestDataFactory.createPhoto(1, { dateAdded: 1735776000000 }, { namePrefix: 'DUAL_B' }),
      TestDataFactory.createPhoto(2, { dateAdded: 1735776000000 }, { namePrefix: 'DUAL_C' })
    ],
    AlbumType.ALL,
    2,
    1
  ),
  new PhotoGroupingScenario(
    'favorite_album_grouping',
    [
      TestDataFactory.createPhoto(0, { dateAdded: 1735862400000 }, { namePrefix: 'FAVORITE_A' }),
      TestDataFactory.createPhoto(1, { dateAdded: 1735862400000 }, { namePrefix: 'FAVORITE_B' }),
      TestDataFactory.createPhoto(2, { dateAdded: 1735948800000 }, { namePrefix: 'FAVORITE_C' }),
      TestDataFactory.createPhoto(3, { dateAdded: 1735948800000 }, { namePrefix: 'FAVORITE_D' })
    ],
    AlbumType.FAVORITE,
    2,
    2
  ),
  new PhotoGroupingScenario(
    'trash_album_grouping',
    [
      TestDataFactory.createPhoto(0, { dateAdded: 1736035200000 }, { namePrefix: 'TRASH_A' }),
      TestDataFactory.createPhoto(1, { dateAdded: 1736121600000 }, { namePrefix: 'TRASH_B' })
    ],
    AlbumType.TRASH,
    2,
    1
  )
];

const KEY_CALLBACK_SCENARIOS: KeyCallbackScenario[] = [
  new KeyCallbackScenario('root_photo_shortcut', 0, 'menu0', false, 2, true, false, 'dialog2'),
  new KeyCallbackScenario('grid_shortcut', 0, 'photo_0_0', false, 1, true, false, 'dialog2'),
  new KeyCallbackScenario('distributed_shortcut', 2, 'menu2', false, 0, false, true, 'dfs_dialog_confirm'),
  new KeyCallbackScenario('dialog_locked_shortcut', 0, 'menu0', true, 3, true, false, ''),
  new KeyCallbackScenario('empty_photo_shortcut', 0, 'menu0', false, 0, false, false, '')
];

const RECEIVED_STATE_SCENARIOS: ReceivedStateScenario[] = [
  new ReceivedStateScenario('pending_state', 2, 'menu1', true, 'menu1', 0, 2),
  new ReceivedStateScenario('complete_state', 6, 'menu1', false, 'menu0', 1, 0),
  new ReceivedStateScenario('intermediate_state', 4, 'menu1', false, 'menu1', 0, 4),
  new ReceivedStateScenario('idle_state', 0, 'menu0', false, 'menu0', 0, 0)
];

const SIZE_LABEL_SCENARIOS: SizeLabelScenario[] = [
  new SizeLabelScenario('kb_boundary', 1024, '1.00KB'),
  new SizeLabelScenario('kb_fraction', 1536, '1.50KB'),
  new SizeLabelScenario('mb_boundary', 2 * 1024 * 1024, '2.00MB'),
  new SizeLabelScenario('mb_fraction', 5 * 1024 * 1024 + 512 * 1024, '5.50MB')
];

const ALBUM_NEIGHBOR_SCENARIOS: AlbumNeighborScenario[] = [
  new AlbumNeighborScenario(AlbumType.ALL, 'right', AlbumType.FAVORITE),
  new AlbumNeighborScenario(AlbumType.FAVORITE, 'left', AlbumType.ALL),
  new AlbumNeighborScenario(AlbumType.ALL, 'down', AlbumType.NAS_SESSION),
  new AlbumNeighborScenario(AlbumType.NAS_SESSION, 'up', -1),
  new AlbumNeighborScenario(AlbumType.TRASH, 'right', AlbumType.NAS_SESSION),
  new AlbumNeighborScenario(AlbumType.NAS_SESSION, 'right', -1)
];

export default function distributedAndReceiveInteractionTest() {
  describe('DistributedAndReceiveInteractionTest', () => {
    it('should group homepage photos by date and assign readable photo tags', 0, () => {
      const harness = new DistributedReceiveHarness();
      const albumModel = new AlbumModel(AlbumType.ALL, '全部');
      const photos = createObserverPhotos();
      harness.allPhotoObserver(photos, albumModel);

      expect(harness.insertedPhotos.length).assertEqual(1);
      expect(harness.photoGroupList.totalCount()).assertEqual(2);
      expect(harness.subTypeModels[AlbumType.ALL]?.type).assertEqual(AlbumType.ALL);
      expect(harness.photoGroupList.getData(0).photoList.length).assertEqual(2);
      TestAsserts.assertAllPhotoTagsReadable(harness.allPhotos);
    });

    it('should reset grouped homepage data when observer receives empty photo collection', 0, () => {
      const harness = new DistributedReceiveHarness();
      const albumModel = new AlbumModel(AlbumType.ALL, '全部');
      harness.allPhotoObserver(createObserverPhotos(), albumModel);

      harness.allPhotoObserver([], albumModel);

      expect(harness.allPhotos.length).assertEqual(0);
      expect(harness.photoGroupModels.length).assertEqual(0);
      expect(harness.photoGroupList.totalCount()).assertEqual(0);
      expect(harness.insertedPhotos.length).assertEqual(2);
    });

    it('should synthesize nas-session album metadata from session callback', 0, () => {
      const harness = new DistributedReceiveHarness();
      const sessions = TestDataFactory.createSessionModels(3);
      harness.nasSessionObserver(sessions);

      expect(harness.subTypeModels[AlbumType.NAS_SESSION]?.type).assertEqual(AlbumType.NAS_SESSION);
      expect(harness.subTypeModels[AlbumType.NAS_SESSION]?.count).assertEqual(3);
      expect(harness.subTypeModels[AlbumType.NAS_SESSION]?.cover).assertEqual('app.media.cover_more');
    });

    it('should open homepage selection dialog from shortcut key on photo tab root focus', 0, () => {
      const harness = new DistributedReceiveHarness();
      const group = new PhotoGroupModel();
      group.createTime = 20250325;
      group.photoList = TestDataFactory.createPhotoList(2, { namePrefix: 'SHORTCUT' });
      harness.photoGroupList.setData([group]);
      harness.focusStr = 'menu0';

      harness.keyCallback();

      expect(harness.dialogFlag).assertTrue();
      expect(harness.dialogIndex).assertEqual(2);
      expect(harness.dialogFocusStr).assertEqual('dialog2');
    });

    it('should route non-root photo shortcut to shared menu builder', 0, () => {
      const harness = new DistributedReceiveHarness();
      const group = new PhotoGroupModel();
      group.createTime = 20250325;
      group.photoList = TestDataFactory.createPhotoList(1, { namePrefix: 'MENU' });
      harness.photoGroupList.setData([group]);
      harness.focusStr = 'photo_0_0';

      harness.keyCallback();

      expect(harness.dialogFlag).assertTrue();
      expect(harness.dialogIndex).assertEqual(2);
      expect(harness.dialogFocusStr).assertEqual('dialog2');
    });

    it('should open dfs confirmation dialog from distributed tab shortcut', 0, () => {
      const harness = new DistributedReceiveHarness();
      harness.chooseIndex = 2;

      harness.keyCallback();

      expect(harness.showToDfsDialog).assertTrue();
      expect(harness.dialogFocusStr).assertEqual('dfs_dialog_confirm');
    });

    it('should ignore root shortcut when photo tab has no grouped photos yet', 0, () => {
      const harness = new DistributedReceiveHarness();
      harness.focusStr = 'menu0';

      harness.keyCallback();

      expect(harness.dialogFlag).assertFalse();
      expect(harness.dialogFocusStr).assertEqual('');
    });

    it('should keep current dialog state when shortcut is pressed during active dialog', 0, () => {
      const harness = new DistributedReceiveHarness();
      const group = new PhotoGroupModel();
      group.createTime = 20250325;
      group.photoList = TestDataFactory.createPhotoList(1, { namePrefix: 'DIALOG_LOCK' });
      harness.photoGroupList.setData([group]);
      harness.dialogFlag = true;
      harness.dialogIndex = 1;
      harness.dialogFocusStr = 'dialog2';

      harness.keyCallback();

      expect(harness.dialogFlag).assertTrue();
      expect(harness.dialogIndex).assertEqual(1);
      expect(harness.dialogFocusStr).assertEqual('dialog2');
    });

    it('should dismiss dfs dialog and keep previous focus trace', 0, () => {
      const harness = new DistributedReceiveHarness();
      harness.showToDfsDialog = true;
      harness.focusStr = 'menu1';

      harness.dismissToDfsDialog();

      expect(harness.showToDfsDialog).assertFalse();
      expect(harness.focusStr).assertEqual('menu1');
      TestAsserts.assertStringArrayContains(harness.getFocusHistory(), ['menu1']);
    });

    it('should navigate to distributed device page and close dfs dialog', 0, () => {
      const harness = new DistributedReceiveHarness();
      harness.showToDfsDialog = true;
      harness.focusStr = 'menu0';

      harness.toDfsDevicePage();

      expect(harness.routeHistory.length).assertEqual(1);
      expect(harness.routeHistory[0]).assertEqual('pages/DistributedDevicePage');
      expect(harness.showToDfsDialog).assertFalse();
    });

    it('should open receive dialog and focus confirm button when state becomes pending', 0, async () => {
      const harness = new DistributedReceiveHarness();
      harness.receivedState = 2;

      await harness.receivedStateChange();

      expect(harness.receiveFlag).assertTrue();
      expect(harness.receiveIndex).assertEqual(1);
      expect(harness.dialogFocusStr).assertEqual('receive1');
    });

    it('should close receive flow, disconnect wifi, and reset state after completion', 0, async () => {
      const wifiManager = new MockWifiConnectionManager();
      const harness = new DistributedReceiveHarness(undefined, wifiManager);
      harness.receiveFlag = true;
      harness.receivedState = 6;

      await harness.receivedStateChange();

      expect(harness.receiveFlag).assertFalse();
      expect(harness.focusStr).assertEqual('menu0');
      expect(wifiManager.closeCount).assertEqual(1);
      expect(harness.receivedState).assertEqual(0);
      expect(harness.receivedStateHistory[harness.receivedStateHistory.length - 1]).assertEqual(0);
    });

    it('should ignore unrelated receive states without changing dialog or wifi status', 0, async () => {
      const wifiManager = new MockWifiConnectionManager();
      const harness = new DistributedReceiveHarness(undefined, wifiManager);
      harness.receiveFlag = false;
      harness.receivedState = 4;
      harness.focusStr = 'menu1';

      await harness.receivedStateChange();

      expect(harness.receiveFlag).assertFalse();
      expect(harness.focusStr).assertEqual('menu1');
      expect(wifiManager.closeCount).assertEqual(0);
      expect(harness.receivedStateHistory.length).assertEqual(0);
    });

    it('should compute transfer progress and received summary from incoming file info', 0, () => {
      const harness = new DistributedReceiveHarness();
      harness.receivedInfo = new ReceivedInfoModel(2 * 1024 * 1024, 2);
      harness.progressValue = 512 * 1024;

      harness.progressChange();
      harness.aboutToAppear();

      expect(harness.progress).assertEqual(25);
      expect(harness.fullSize).assertEqual('2.00MB');
      expect(harness.typeName).assertEqual('个视频');
    });

    it('should keep receive summary empty when popup appears without size payload', 0, () => {
      const harness = new DistributedReceiveHarness();
      harness.receivedInfo = new ReceivedInfoModel(0, 1);

      harness.aboutToAppear();

      expect(harness.fullSize).assertEqual('');
      expect(harness.typeName).assertEqual('');
    });

    it('should format size and media type labels for receive popup text', 0, () => {
      const harness = new DistributedReceiveHarness();

      expect(harness.getSize(512 * 1024)).assertEqual('512.00KB');
      expect(harness.getSize(3 * 1024 * 1024)).assertEqual('3.00MB');
      expect(harness.getMediaType(1)).assertEqual('张图片');
      expect(harness.getMediaType(Constants.PHOTO_TYPE_VIDEO)).assertEqual('个视频');
    });

    it('should clear current selected device name when share device list becomes empty', 0, () => {
      const harness = new DistributedReceiveHarness();
      harness.deviceList = [];

      harness.changeDevice();

      expect(harness.currentName).assertEqual('');
    });

    it('should keep current selected device name when device list still has entries', 0, () => {
      const harness = new DistributedReceiveHarness();
      harness.currentName = '客厅电视';
      harness.deviceList = [new DeviceNameModel('LivingRoomTV')];

      harness.changeDevice();

      expect(harness.currentName).assertEqual('客厅电视');
    });

    it('should focus the first non-empty album card on album tab entry', 0, () => {
      const harness = new DistributedReceiveHarness();
      harness.subTypeModels = createAlbumMatrix();

      harness.focusFirstAlbum();

      expect(harness.focusStr).assertEqual('album0');
    });

    it('should skip empty leading album cards when focusing the first available album', 0, () => {
      const harness = new DistributedReceiveHarness();
      const albums: (AlbumModel | undefined)[] = [];
      albums[AlbumType.ALL] = new AlbumModel(AlbumType.ALL, '全部');
      albums[AlbumType.ALL]!.count = 0;
      albums[AlbumType.FAVORITE] = new AlbumModel(AlbumType.FAVORITE, '收藏');
      albums[AlbumType.FAVORITE]!.count = 0;
      albums[AlbumType.TRASH] = new AlbumModel(AlbumType.TRASH, '回收站');
      albums[AlbumType.TRASH]!.count = 2;
      harness.subTypeModels = albums;

      harness.focusFirstAlbum();

      expect(harness.focusStr).assertEqual(`album${AlbumType.TRASH}`);
    });

    it('should compute next album indexes across sparse album grid', 0, () => {
      const harness = new DistributedReceiveHarness();
      harness.subTypeModels = createAlbumMatrix();

      expect(harness.getNextAlbum(AlbumType.ALL, 'right')).assertEqual(AlbumType.FAVORITE);
      expect(harness.getNextAlbum(AlbumType.FAVORITE, 'left')).assertEqual(AlbumType.ALL);
      expect(harness.getNextAlbum(AlbumType.FAVORITE, 'down')).assertEqual(-1);
      expect(FIRST_ROW_MAX_INDEX > 0).assertTrue();
    });

    it('should compute up and down album targets across dense grid rows', 0, () => {
      const harness = new DistributedReceiveHarness();
      harness.subTypeModels = createDenseAlbumMatrix();

      expect(harness.getNextAlbum(AlbumType.ALL, 'down')).assertEqual(AlbumType.NAS_SESSION);
      expect(harness.getNextAlbum(AlbumType.NAS_SESSION, 'up')).assertEqual(-1);
      expect(harness.getNextAlbum(AlbumType.NAS_SESSION, 'right')).assertEqual(-1);
    });

    it('should move focus to computed album target when directional navigation is valid', 0, () => {
      const harness = new DistributedReceiveHarness();
      harness.subTypeModels = createAlbumMatrix();

      harness.nextAlbumClick(AlbumType.ALL, 'right');

      expect(harness.focusStr).assertEqual('album1');
    });

    it('should keep album focus unchanged when no directional target exists', 0, () => {
      const harness = new DistributedReceiveHarness();
      harness.subTypeModels = createAlbumMatrix();
      harness.focusStr = 'album0';

      harness.nextAlbumClick(AlbumType.ALL, 'left');

      expect(harness.focusStr).assertEqual('album0');
    });

    it('should return false and preserve focus state for disallowed focus target', 0, () => {
      const focusController = new MockFocusController();
      const harness = new DistributedReceiveHarness(focusController);
      harness.focusStr = 'menu0';
      harness.dialogFocusStr = 'dialog2';

      const focused = harness.clickFocusBtn('album99', false);

      expect(focused).assertFalse();
      expect(harness.focusStr).assertEqual('menu0');
      expect(harness.dialogFocusStr).assertEqual('dialog2');
      expect(harness.getFocusHistory().length).assertEqual(0);
    });

    PHOTO_GROUPING_SCENARIOS.forEach((scenario) => {
      it(`should regroup observer photos for ${scenario.name}`, 0, () => {
        const harness = new DistributedReceiveHarness();
        const albumModel = new AlbumModel(scenario.albumType, `album_${scenario.albumType}`);
        albumModel.count = scenario.photos.length;

        if (scenario.albumType === AlbumType.ALL) {
          harness.allPhotoObserver(scenario.photos, albumModel);
        } else if (scenario.albumType === AlbumType.FAVORITE) {
          harness.favoritePhotoObserver(albumModel);
        } else if (scenario.albumType === AlbumType.SCREENSHOT) {
          harness.screenShotPhotoObserver(albumModel);
        } else if (scenario.albumType === AlbumType.TRASH) {
          harness.trashPhotoObserver(albumModel);
        }

        expect(harness.allPhotos.length).assertEqual(scenario.albumType === AlbumType.ALL ? scenario.photos.length : 0);
        expect(harness.photoGroupModels.length).assertEqual(scenario.albumType === AlbumType.ALL ? scenario.expectedGroupCount : 0);
        expect(harness.photoGroupList.totalCount()).assertEqual(scenario.albumType === AlbumType.ALL ? scenario.expectedGroupCount : 0);
        if (scenario.albumType === AlbumType.ALL) {
          expect(harness.photoGroupList.getData(0).photoList.length).assertEqual(scenario.expectedFirstGroupLength);
        }
        expect(harness.subTypeModels[scenario.albumType]?.type).assertEqual(scenario.albumType);
        if (scenario.albumType === AlbumType.ALL) {
          TestAsserts.assertAllPhotoTagsReadable(harness.allPhotos);
        }
      });
    });

    KEY_CALLBACK_SCENARIOS.forEach((scenario) => {
      it(`should process distributed key callback for ${scenario.name}`, 0, () => {
        const harness = new DistributedReceiveHarness();
        const group = new PhotoGroupModel();
        group.createTime = 20250325;
        group.photoList = TestDataFactory.createPhotoList(scenario.photoCount, { namePrefix: scenario.name.toUpperCase() });
        harness.photoGroupList.setData(scenario.photoCount > 0 ? [group] : []);
        harness.chooseIndex = scenario.chooseIndex;
        harness.focusStr = scenario.focusStr;
        harness.dialogFlag = scenario.dialogFlag;

        harness.keyCallback();

        expect(harness.dialogFlag).assertEqual(scenario.expectDialog);
        expect(harness.showToDfsDialog).assertEqual(scenario.expectDfs);
        if (scenario.expectedDialogFocus.length > 0) {
          expect(harness.dialogFocusStr).assertEqual(scenario.expectedDialogFocus);
        }
      });
    });

    RECEIVED_STATE_SCENARIOS.forEach((scenario) => {
      it(`should process received state transition for ${scenario.name}`, 0, async () => {
        const wifiManager = new MockWifiConnectionManager();
        const harness = new DistributedReceiveHarness(undefined, wifiManager);
        harness.receivedState = scenario.initialState;
        harness.focusStr = scenario.initialFocus;
        harness.receiveFlag = scenario.initialState === 6;

        await harness.receivedStateChange();

        expect(harness.receiveFlag).assertEqual(scenario.expectReceive);
        expect(harness.focusStr).assertEqual(scenario.expectFocus);
        expect(wifiManager.closeCount).assertEqual(scenario.expectWifiCloseCount);
        expect(harness.receivedState).assertEqual(scenario.expectState);
      });
    });

    SIZE_LABEL_SCENARIOS.forEach((scenario) => {
      it(`should compute transfer size label for ${scenario.name}`, 0, () => {
        const harness = new DistributedReceiveHarness();

        expect(harness.getSize(scenario.size)).assertEqual(scenario.expected);
      });
    });

    ALBUM_NEIGHBOR_SCENARIOS.forEach((scenario) => {
      it(`should compute dense album neighbor from ${scenario.current} using ${scenario.direction}`, 0, () => {
        const harness = new DistributedReceiveHarness();
        harness.subTypeModels = createDenseAlbumMatrix();

        expect(harness.getNextAlbum(scenario.current, scenario.direction)).assertEqual(scenario.expected);
      });
    });
  });
}
