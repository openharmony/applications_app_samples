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
import { AlbumModel, AlbumType, PhotoModel } from '../../../main/ets/models/PhotoModel';
import { DirectoryEntry } from 'smbProtocol';
import { TestDataFactory } from './base/TestDataFactory';
import { MockFocusController, MockInputConsumer } from './base/TestDoubles';

const FOCUS_CHANGE_DELAY = 100;
const KEY_DOWN = 0;
const KEYCODE_DPAD_LEFT = 2012;
const KEYCODE_DPAD_RIGHT = 2013;
const KEYCODE_DPAD_UP = 2014;
const KEYCODE_DPAD_DOWN = 2015;
const KEYCODE_DPAD_CENTER = 2016;
const KEYCODE_MENU = 1;
const KEYCODE_NUMPAD_1 = 2017;
const KEYCODE_NUMPAD_2 = 2018;
const KEYCODE_ENTER = 2054;

type PhotoDataModel = PhotoModel | DirectoryEntry;

class RouteRecord {
  url: string;
  photoIndex?: number;
  nasHost?: string;
  photoListLength?: number;

  constructor(url: string, photoIndex?: number, nasHost?: string, photoListLength?: number) {
    this.url = url;
    this.photoIndex = photoIndex;
    this.nasHost = nasHost;
    this.photoListLength = photoListLength;
  }
}

class DeleteHistoryRecord {
  type: AlbumType;
  count: number;

  constructor(type: AlbumType, count: number) {
    this.type = type;
    this.count = count;
  }
}

class NasDeleteHistoryRecord {
  host: string;
  count: number;

  constructor(host: string, count: number) {
    this.host = host;
    this.count = count;
  }
}

class DialogRecord {
  uri: string;
  name: string;

  constructor(uri: string, name: string) {
    this.uri = uri;
    this.name = name;
  }
}

class DeviceRecord {
  deviceName: string;

  constructor(deviceName: string) {
    this.deviceName = deviceName;
  }
}

class InputOptions {
}

class KeyEventRecord {
  keyCode: number;
  type: number;

  constructor(keyCode: number, type: number) {
    this.keyCode = keyCode;
    this.type = type;
  }
}

class LocalDeleteScenario {
  name: string;
  albumType: AlbumType;
  albumName: string;
  flags: boolean[];
  expectedDeleteCount: number;
  expectedToast: string;

  constructor(name: string, albumType: AlbumType, albumName: string, flags: boolean[],
    expectedDeleteCount: number, expectedToast: string) {
    this.name = name;
    this.albumType = albumType;
    this.albumName = albumName;
    this.flags = flags;
    this.expectedDeleteCount = expectedDeleteCount;
    this.expectedToast = expectedToast;
  }
}

class NasDeleteScenario {
  name: string;
  flags: boolean[];
  expectedDeleteCount: number;

  constructor(name: string, flags: boolean[], expectedDeleteCount: number) {
    this.name = name;
    this.flags = flags;
    this.expectedDeleteCount = expectedDeleteCount;
  }
}

class GridNavigationScenario {
  name: string;
  startIndex: number;
  keyCode: number;
  expectedIndex: number;
  expectScroll: boolean;

  constructor(name: string, startIndex: number, keyCode: number, expectedIndex: number, expectScroll: boolean) {
    this.name = name;
    this.startIndex = startIndex;
    this.keyCode = keyCode;
    this.expectedIndex = expectedIndex;
    this.expectScroll = expectScroll;
  }
}

class WatchRouteScenario {
  name: string;
  keyCode: number;
  albumType: AlbumType;
  albumName: string;
  expectedHost: string;

  constructor(name: string, keyCode: number, albumType: AlbumType, albumName: string, expectedHost: string) {
    this.name = name;
    this.keyCode = keyCode;
    this.albumType = albumType;
    this.albumName = albumName;
    this.expectedHost = expectedHost;
  }
}

class EditToggleScenario {
  name: string;
  keyCode: number;
  initialFlags: boolean[];
  expectedFlags: boolean[];
  itemIndex: number;

  constructor(name: string, keyCode: number, initialFlags: boolean[], expectedFlags: boolean[], itemIndex?: number) {
    this.name = name;
    this.keyCode = keyCode;
    this.initialFlags = initialFlags;
    this.expectedFlags = expectedFlags;
    this.itemIndex = itemIndex ?? 0;
  }
}

class ShortcutScenario {
  name: string;
  keyCode: number;
  expectedDialog: boolean;
  expectedDialogIndex: number;

  constructor(name: string, keyCode: number, expectedDialog: boolean, expectedDialogIndex: number) {
    this.name = name;
    this.keyCode = keyCode;
    this.expectedDialog = expectedDialog;
    this.expectedDialogIndex = expectedDialogIndex;
  }
}

class DeleteDialogScenario {
  name: string;
  index: number;
  expectedDeleteFlag: boolean;
  expectedDeleteIndex: number;
  expectedFocus: string;

  constructor(name: string, index: number, expectedDeleteFlag: boolean, expectedDeleteIndex: number,
    expectedFocus: string) {
    this.name = name;
    this.index = index;
    this.expectedDeleteFlag = expectedDeleteFlag;
    this.expectedDeleteIndex = expectedDeleteIndex;
    this.expectedFocus = expectedFocus;
  }
}

class MockPhotoLoader {
  registerCount: number = 0;
  unregisterCount: number = 0;
  callback?: (photos: PhotoModel[], albumModel: AlbumModel) => void;

  registerChangeCallback(callback: (photos: PhotoModel[], albumModel: AlbumModel) => void): void {
    this.registerCount++;
    this.callback = callback;
  }

  unRegisterChangeCallback(callback: (photos: PhotoModel[], albumModel: AlbumModel) => void): void {
    this.unregisterCount++;
    if (this.callback === callback) {
      this.callback = undefined;
    }
  }
}

class MockPhotoManager {
  deleteHistory: DeleteHistoryRecord[] = [];
  loader: MockPhotoLoader = new MockPhotoLoader();
  shouldDeleteFail: boolean = false;

  getLoader(type: AlbumType): MockPhotoLoader {
    return this.loader;
  }

  async delete(type: AlbumType, photos: PhotoModel[]): Promise<void> {
    if (this.shouldDeleteFail) {
      throw new Error('delete failed');
    }
    this.deleteHistory.push(new DeleteHistoryRecord(type, photos.length));
  }
}

class MockNasSessionManager {
  registerFileHistory: string[] = [];
  unregisterFileHistory: string[] = [];
  deleteHistory: NasDeleteHistoryRecord[] = [];
  fileCallback?: (files: DirectoryEntry[]) => void;
  shouldDeleteFail: boolean = false;

  registerFileChangeCallback(host: string, callback: (files: DirectoryEntry[]) => void): void {
    this.registerFileHistory.push(host);
    this.fileCallback = callback;
  }

  unRegisterFileChangeCallback(host: string, callback: (files: DirectoryEntry[]) => void): void {
    this.unregisterFileHistory.push(host);
    if (this.fileCallback === callback) {
      this.fileCallback = undefined;
    }
  }

  async deleteImage(host: string, files: DirectoryEntry[]): Promise<void> {
    if (this.shouldDeleteFail) {
      throw new Error('delete nas failed');
    }
    this.deleteHistory.push(new NasDeleteHistoryRecord(host, files.length));
  }
}

class PhotoListHarness {
  photoTitle: string;
  photoType: AlbumType;
  photoList: PhotoDataModel[] = [];
  photoListSize: number = 0;
  pictureIndex: number = 0;
  pictureFlag: boolean = false;
  focusPhotoStr: string = 'picture0';
  focusDialogStr: string = '';
  dialogIndex: number = 0;
  pictureChooseFlags: boolean[] = [];
  isCheckAll: boolean = false;
  dialogList: DialogRecord[] = [
    new DialogRecord('app.media.p_del_disabled', 'delete'),
    new DialogRecord('app.media.p_share_disabled', 'share'),
    new DialogRecord('app.media.p_check_default', 'choose')
  ];
  dialogFlag: boolean = false;
  deleteFlag: boolean = false;
  deleteIndex: number = 1;
  deviceFlag: boolean = false;
  deviceIndex: number = 0;
  currentName: string = '';
  deviceList: DeviceRecord[] = [];
  toastHistory: string[] = [];
  routeHistory: RouteRecord[] = [];
  scrollHistory: number[] = [];
  pendingTasks: Array<() => void> = [];
  photoObserver: (photos: PhotoModel[], albumModel: AlbumModel) => void;
  nasImageObserver: (files: DirectoryEntry[]) => void;
  private inputConsumer: MockInputConsumer;
  private photoManager: MockPhotoManager;
  private nasSessionManager: MockNasSessionManager;
  private focusController: MockFocusController;

  constructor(photoType?: AlbumType, photoTitle?: string, photoManager?: MockPhotoManager,
    nasSessionManager?: MockNasSessionManager, inputConsumer?: MockInputConsumer, focusController?: MockFocusController) {
    this.photoType = photoType ?? AlbumType.ALL;
    this.photoTitle = photoTitle ?? '全部';
    this.photoManager = photoManager ?? new MockPhotoManager();
    this.nasSessionManager = nasSessionManager ?? new MockNasSessionManager();
    this.inputConsumer = inputConsumer ?? new MockInputConsumer();
    this.focusController = focusController ?? new MockFocusController();
    this.focusController.allow([
      'picture0',
      'picture1',
      'picture2',
      'picture3',
      'picture4',
      'picture5',
      'picture6',
      'picture7',
      'dialog0',
      'dialog1',
      'dialog2',
      'delete0',
      'delete1',
      'device0',
      'device1'
    ]);
    this.photoObserver = (photos: PhotoModel[]) => {
      this.photoList = [...photos];
      this.pictureChooseFlags = new Array(this.photoList.length).fill(false);
      this.photoListSize = photos.length;
    };
    this.nasImageObserver = (files: DirectoryEntry[]) => {
      this.photoList = [...files];
      this.pictureChooseFlags = new Array(this.photoList.length).fill(false);
      this.photoListSize = files.length;
    };
  }

  onPageShow(): void {
    this.inputConsumer.on('key', new InputOptions(), this.getMenuClick);
    this.inputConsumer.on('key', new InputOptions(), this.getMenuClick);
    if (this.photoType === AlbumType.NAS_SESSION) {
      this.nasSessionManager.registerFileChangeCallback(this.photoTitle, this.nasImageObserver);
    } else {
      this.photoManager.getLoader(this.photoType).registerChangeCallback(this.photoObserver);
    }
  }

  onPageHide(): void {
    this.inputConsumer.off('key', new InputOptions(), this.getMenuClick);
    this.inputConsumer.off('key', new InputOptions(), this.getMenuClick);
    if (this.photoType === AlbumType.NAS_SESSION) {
      this.nasSessionManager.unRegisterFileChangeCallback(this.photoTitle, this.nasImageObserver);
    } else {
      this.photoManager.getLoader(this.photoType).unRegisterChangeCallback(this.photoObserver);
    }
  }

  allBackFun(): boolean | void {
    if (this.deviceFlag) {
      this.getDeviceBack();
      return true;
    }
    if (this.deleteFlag) {
      this.getDeleteBack();
      return true;
    }
    if (this.dialogFlag) {
      this.getDialogBack();
      return true;
    }
    if (this.pictureFlag) {
      this.getPhotoBack();
      return true;
    }
  }

  async getDeleteAssets(uris: PhotoDataModel[]): Promise<void> {
    if (uris.length === 0) {
      return;
    }
    try {
      if (this.isPhotoModel(uris[0])) {
        await this.photoManager.delete(this.photoType, uris as PhotoModel[]);
      } else {
        await this.nasSessionManager.deleteImage(this.photoTitle, uris as DirectoryEntry[]);
      }
      this.getPhotoBack();
      this.deleteFlag = false;
      this.deleteIndex = 1;
      this.getDialogBack();
      this.toastHistory.push('delete_success');
    } catch (error) {
      this.toastHistory.push('delete_error');
    }
  }

  getPhotoUris(): PhotoDataModel[] {
    const uris: PhotoDataModel[] = [];
    this.pictureChooseFlags.forEach((item, index) => {
      if (item) {
        uris.push(this.photoList[index]);
      }
    });
    return uris;
  }

  getDialogBack(): void {
    this.dialogFlag = false;
    this.pendingTasks.push(() => {
      this.clickFocusBtn(this.focusPhotoStr, false);
    });
  }

  getPhotoBack(): void {
    this.pictureFlag = false;
    this.isCheckAll = false;
    this.pictureChooseFlags = this.pictureChooseFlags.fill(false);
    this.dialogList[0].uri = 'app.media.p_del_disabled';
    this.dialogList[1].uri = 'app.media.p_share_disabled';
    this.dialogList[2].name = 'choose';
    this.dialogList[2].uri = 'app.media.p_check_default';
  }

  getDeleteBack(): void {
    this.deleteFlag = false;
    this.deleteIndex = 1;
    this.pendingTasks.push(() => {
      this.clickFocusBtn('dialog0', true);
    });
  }

  getDeviceBack(): void {
    this.deviceFlag = false;
    this.pendingTasks.push(() => {
      this.clickFocusBtn('dialog1', true);
    });
  }

  getMenuClick = (): void => {
    const tempList = [...this.dialogList];
    if (this.pictureFlag && this.isCheckAll) {
      tempList[2].name = 'cancel_all_select';
      tempList[2].uri = 'app.media.p_check_all_default';
    } else if (this.pictureFlag) {
      tempList[2].name = 'select_all';
      tempList[2].uri = 'app.media.p_check_no_default';
    } else {
      tempList[2].name = 'choose';
      tempList[2].uri = 'app.media.p_check_default';
    }
    const count = this.pictureChooseFlags.filter((item) => item).length;
    if (count > 0) {
      tempList[0].uri = 'app.media.p_del_default';
      tempList[1].uri = 'app.media.p_share_default';
    } else {
      tempList[0].uri = 'app.media.p_del_disabled';
      tempList[1].uri = 'app.media.p_share_disabled';
    }
    this.dialogList = tempList;
    this.dialogFlag = true;
    this.pendingTasks.push(() => {
      this.clickFocusBtn('dialog2', true);
      this.dialogIndex = 2;
    });
  };

  flushPendingTasks(): void {
    while (this.pendingTasks.length > 0) {
      const task = this.pendingTasks.shift();
      task?.();
    }
  }

  clickFocusBtn(str: string, inDialog: boolean): boolean {
    const isSuccess = this.focusController.requestFocus(str);
    if (isSuccess) {
      if (inDialog) {
        this.focusDialogStr = str;
      } else {
        this.focusPhotoStr = str;
      }
    }
    return isSuccess;
  }

  selectPhoto(index: number): void {
    this.pictureChooseFlags[index] = !this.pictureChooseFlags[index];
    const count = this.pictureChooseFlags.filter((item) => item).length;
    this.isCheckAll = count === this.photoList.length;
  }

  onDialogClick(index: number): void {
    this.dialogIndex = index;
    this.clickFocusBtn(`dialog${index}`, true);
    if (this.focusDialogStr === 'dialog0') {
      this.deleteFlag = true;
      this.pendingTasks.push(() => {
        this.clickFocusBtn('delete1', true);
      });
      return;
    }
    if (this.focusDialogStr === 'dialog1') {
      this.toastHistory.push('share');
      return;
    }
    if (this.focusDialogStr === 'dialog2') {
      if (this.pictureFlag) {
        const tempList = [...this.dialogList];
        if (this.isCheckAll) {
          tempList[0].uri = 'app.media.p_del_disabled';
          tempList[1].uri = 'app.media.p_share_disabled';
          tempList[2].name = 'select_all';
          tempList[2].uri = 'app.media.p_check_no_default';
        } else {
          tempList[0].uri = 'app.media.p_del_default';
          tempList[1].uri = 'app.media.p_share_default';
          tempList[2].name = 'cancel_all_select';
          tempList[2].uri = 'app.media.p_check_all_default';
        }
        this.dialogList = tempList;
        this.pictureChooseFlags = this.isCheckAll
          ? new Array(this.photoList.length).fill(false)
          : new Array(this.photoList.length).fill(true);
        this.isCheckAll = !this.isCheckAll;
        this.pendingTasks.push(() => {
          this.clickFocusBtn('dialog2', true);
          this.dialogIndex = 2;
        });
      } else {
        this.dialogFlag = false;
        this.pictureFlag = true;
        this.scrollHistory.push(this.pictureIndex);
        this.pendingTasks.push(() => {
          this.clickFocusBtn(this.focusPhotoStr, false);
          this.selectPhoto(this.pictureIndex);
        });
      }
    }
  }

  onDialogLeft(): void {
    const count = this.pictureChooseFlags.filter((item) => item).length;
    if (this.focusDialogStr === 'dialog2' && count === 0) {
      this.toastHistory.push('please_choose_photo');
      return;
    }
    if (this.dialogIndex !== 0) {
      const step = this.photoType === AlbumType.NAS_SESSION ? 2 : 1;
      this.dialogIndex -= step;
      this.clickFocusBtn(`dialog${this.dialogIndex}`, true);
    }
  }

  onDialogRight(): void {
    if (this.dialogIndex === this.dialogList.length - 1) {
      return;
    }
    const step = this.photoType === AlbumType.NAS_SESSION ? 2 : 1;
    this.dialogIndex += step;
    this.clickFocusBtn(`dialog${this.dialogIndex}`, true);
  }

  onDeleteConfirm(index: number): Promise<void> | void {
    this.deleteIndex = index;
    this.clickFocusBtn(`delete${index}`, true);
    if (this.deleteIndex === 0) {
      this.pendingTasks.push(() => {
        this.clickFocusBtn('dialog0', true);
        this.getDeleteBack();
      });
      return;
    }
    return this.getDeleteAssets(this.getPhotoUris());
  }

  onItemKeyEvent(event: KeyEventRecord, index: number): void {
    if (event.keyCode === KEYCODE_DPAD_LEFT && event.type === KEY_DOWN) {
      if (this.pictureIndex !== 0) {
        this.pictureIndex--;
        this.scrollHistory.push(this.pictureIndex);
        this.clickFocusBtn(`picture${this.pictureIndex}`, false);
      }
    }
    if (event.keyCode === KEYCODE_DPAD_RIGHT && event.type === KEY_DOWN) {
      if (this.pictureIndex !== this.photoList.length - 1) {
        this.pictureIndex++;
        this.scrollHistory.push(this.pictureIndex);
        this.clickFocusBtn(`picture${this.pictureIndex}`, false);
      }
    }
    if (event.keyCode === KEYCODE_DPAD_DOWN && event.type === KEY_DOWN) {
      if (this.pictureIndex + 6 <= this.photoList.length - 1) {
        this.pictureIndex += 6;
        this.scrollHistory.push(this.pictureIndex);
        this.clickFocusBtn(`picture${this.pictureIndex}`, false);
      }
    }
    if (event.keyCode === KEYCODE_DPAD_UP && event.type === KEY_DOWN) {
      if (this.pictureIndex >= 6) {
        this.pictureIndex -= 6;
        this.scrollHistory.push(this.pictureIndex);
        this.clickFocusBtn(`picture${this.pictureIndex}`, false);
      }
    }
    if ((event.keyCode === KEYCODE_DPAD_CENTER || event.keyCode === KEYCODE_ENTER) && event.type === KEY_DOWN) {
      if (this.pictureFlag) {
        this.selectPhoto(index);
      } else if (this.isPhotoModel(this.photoList[index])) {
        this.routeHistory.push(new RouteRecord('pages/PhotoWatch', index, undefined, this.photoList.length));
      } else {
        this.routeHistory.push(new RouteRecord('pages/PhotoWatch', index, this.photoTitle));
      }
    }
    if ((event.keyCode === KEYCODE_MENU || event.keyCode === KEYCODE_NUMPAD_1) && event.type === KEY_DOWN) {
      this.getMenuClick();
    }
    if (event.keyCode === KEYCODE_NUMPAD_2 && event.type === KEY_DOWN) {
      this.getPhotoBack();
    }
  }

  getFocusHistory(): string[] {
    return this.focusController.getFocusHistory().map((item) => item.focusId);
  }

  private isPhotoModel(model: PhotoDataModel): boolean {
    return Object.getOwnPropertyNames(model).includes('uri');
  }
}

function createLocalPhotos(count: number): PhotoModel[] {
  return TestDataFactory.createPhotoList(count);
}

function createNasFiles(count: number, host?: string): DirectoryEntry[] {
  return TestDataFactory.createDirectoryEntries(count, {
    host: host ?? '192.168.3.10'
  });
}

function createKeyEvent(keyCode: number): KeyEventRecord {
  return new KeyEventRecord(keyCode, KEY_DOWN);
}

const LOCAL_DELETE_SCENARIOS: LocalDeleteScenario[] = [
  new LocalDeleteScenario('local_delete_first_two', AlbumType.ALL, '全部', [true, true, false], 2, 'delete_success'),
  new LocalDeleteScenario('local_delete_middle_only', AlbumType.ALL, '全部', [false, true, false], 1, 'delete_success'),
  new LocalDeleteScenario('local_delete_last_only', AlbumType.ALL, '全部', [false, false, true], 1, 'delete_success')
];

const NAS_DELETE_SCENARIOS: NasDeleteScenario[] = [
  new NasDeleteScenario('nas_delete_first', [true, false, false], 1),
  new NasDeleteScenario('nas_delete_last_two', [false, true, true], 2)
];

const GRID_NAVIGATION_SCENARIOS: GridNavigationScenario[] = [
  new GridNavigationScenario('left_boundary', 0, KEYCODE_DPAD_LEFT, 0, false),
  new GridNavigationScenario('right_move', 0, KEYCODE_DPAD_RIGHT, 1, true),
  new GridNavigationScenario('up_boundary', 0, KEYCODE_DPAD_UP, 0, false),
  new GridNavigationScenario('down_move', 0, KEYCODE_DPAD_DOWN, 6, true),
  new GridNavigationScenario('right_boundary', 7, KEYCODE_DPAD_RIGHT, 7, false),
  new GridNavigationScenario('down_boundary', 7, KEYCODE_DPAD_DOWN, 7, false)
];

const WATCH_ROUTE_SCENARIOS: WatchRouteScenario[] = [
  new WatchRouteScenario('watch_local_center', KEYCODE_DPAD_CENTER, AlbumType.ALL, '全部', ''),
  new WatchRouteScenario('watch_local_enter', KEYCODE_ENTER, AlbumType.ALL, '全部', ''),
  new WatchRouteScenario('watch_nas_center', KEYCODE_DPAD_CENTER, AlbumType.NAS_SESSION, '192.168.3.10', '192.168.3.10'),
  new WatchRouteScenario('watch_nas_enter', KEYCODE_ENTER, AlbumType.NAS_SESSION, '192.168.3.10', '192.168.3.10')
];

const EDIT_TOGGLE_SCENARIOS: EditToggleScenario[] = [
  new EditToggleScenario('edit_enter_unselected', KEYCODE_ENTER, [false, false], [true, false]),
  new EditToggleScenario('edit_center_selected', KEYCODE_DPAD_CENTER, [true, false], [false, false]),
  new EditToggleScenario('edit_enter_second', KEYCODE_ENTER, [false, false], [false, true], 1)
];

const SHORTCUT_SCENARIOS: ShortcutScenario[] = [
  new ShortcutScenario('menu_key', KEYCODE_MENU, true, 2),
  new ShortcutScenario('numpad_1', KEYCODE_NUMPAD_1, true, 2)
];

const DELETE_DIALOG_SCENARIOS: DeleteDialogScenario[] = [
  new DeleteDialogScenario('dialog_cancel', 0, false, 1, 'dialog0'),
  new DeleteDialogScenario('dialog_confirm_local', 1, false, 1, 'delete1')
];

export default function photoListInteractionTest() {
  describe('PhotoListInteractionTest', () => {
    it('should register local photo observer and key subscriptions on page show', 0, () => {
      const photoManager = new MockPhotoManager();
      const inputConsumer = new MockInputConsumer();
      const harness = new PhotoListHarness(AlbumType.ALL, '全部', photoManager, undefined, inputConsumer);

      harness.onPageShow();

      expect(photoManager.loader.registerCount).assertEqual(1);
      expect(inputConsumer.getSubscriptionCount('key')).assertEqual(2);
    });

    it('should unregister local photo observer and key subscriptions on page hide', 0, () => {
      const photoManager = new MockPhotoManager();
      const inputConsumer = new MockInputConsumer();
      const harness = new PhotoListHarness(AlbumType.ALL, '全部', photoManager, undefined, inputConsumer);

      harness.onPageShow();
      harness.onPageHide();

      expect(photoManager.loader.unregisterCount).assertEqual(1);
      expect(inputConsumer.getSubscriptionCount('key')).assertEqual(0);
    });

    it('should register nas file observer on page show and unregister on hide', 0, () => {
      const nasManager = new MockNasSessionManager();
      const inputConsumer = new MockInputConsumer();
      const harness = new PhotoListHarness(AlbumType.NAS_SESSION, '192.168.3.10', undefined, nasManager, inputConsumer);

      harness.onPageShow();
      harness.onPageHide();

      expect(nasManager.registerFileHistory[0]).assertEqual('192.168.3.10');
      expect(nasManager.unregisterFileHistory[0]).assertEqual('192.168.3.10');
    });

    it('should update local list and choose flags through photo observer', 0, () => {
      const harness = new PhotoListHarness();
      const photos = createLocalPhotos(3);

      harness.photoObserver(photos, new AlbumModel(AlbumType.ALL, '全部'));

      expect(harness.photoListSize).assertEqual(3);
      expect(harness.pictureChooseFlags.length).assertEqual(3);
      expect(harness.pictureChooseFlags[1]).assertFalse();
    });

    it('should update nas list and choose flags through nas observer', 0, () => {
      const harness = new PhotoListHarness(AlbumType.NAS_SESSION, '192.168.3.10');
      const files = createNasFiles(4);

      harness.nasImageObserver(files);

      expect(harness.photoListSize).assertEqual(4);
      expect(harness.pictureChooseFlags.length).assertEqual(4);
    });

    it('should prioritize back handling from device to delete to dialog to picture state', 0, () => {
      const harness = new PhotoListHarness();
      harness.deviceFlag = true;
      expect(harness.allBackFun()).assertTrue();
      harness.flushPendingTasks();
      expect(harness.deviceFlag).assertFalse();

      harness.deleteFlag = true;
      expect(harness.allBackFun()).assertTrue();
      harness.flushPendingTasks();
      expect(harness.deleteFlag).assertFalse();

      harness.dialogFlag = true;
      expect(harness.allBackFun()).assertTrue();
      harness.flushPendingTasks();
      expect(harness.dialogFlag).assertFalse();

      harness.pictureFlag = true;
      expect(harness.allBackFun()).assertTrue();
      expect(harness.pictureFlag).assertFalse();
    });

    it('should ignore back request when no transient panel is open', 0, () => {
      const harness = new PhotoListHarness();

      expect(harness.allBackFun()).assertEqual(undefined);
    });

    it('should open menu with default choose focus and disabled actions when nothing is selected', 0, () => {
      const harness = new PhotoListHarness();
      harness.photoList = createLocalPhotos(2);
      harness.pictureChooseFlags = [false, false];

      harness.getMenuClick();
      harness.flushPendingTasks();

      expect(harness.dialogFlag).assertTrue();
      expect(harness.dialogIndex).assertEqual(2);
      expect(harness.focusDialogStr).assertEqual('dialog2');
      expect(harness.dialogList[0].uri).assertEqual('app.media.p_del_disabled');
    });

    it('should enable delete and share icons when selected photos exist', 0, () => {
      const harness = new PhotoListHarness();
      harness.photoList = createLocalPhotos(2);
      harness.pictureChooseFlags = [true, false];

      harness.getMenuClick();

      expect(harness.dialogList[0].uri).assertEqual('app.media.p_del_default');
      expect(harness.dialogList[1].uri).assertEqual('app.media.p_share_default');
    });

    it('should show cancel-all copy when all photos are already selected in edit mode', 0, () => {
      const harness = new PhotoListHarness();
      harness.photoList = createLocalPhotos(2);
      harness.pictureChooseFlags = [true, true];
      harness.pictureFlag = true;
      harness.isCheckAll = true;

      harness.getMenuClick();

      expect(harness.dialogList[2].name).assertEqual('cancel_all_select');
      expect(harness.dialogList[2].uri).assertEqual('app.media.p_check_all_default');
    });

    it('should enter edit mode and toggle current photo from choose action', 0, () => {
      const harness = new PhotoListHarness();
      harness.photoList = createLocalPhotos(3);
      harness.pictureChooseFlags = [false, false, false];
      harness.pictureIndex = 1;
      harness.focusPhotoStr = 'picture1';
      harness.dialogFlag = true;

      harness.onDialogClick(2);
      harness.flushPendingTasks();

      expect(harness.dialogFlag).assertFalse();
      expect(harness.pictureFlag).assertTrue();
      expect(harness.pictureChooseFlags[1]).assertTrue();
      expect(harness.focusPhotoStr).assertEqual('picture1');
    });

    it('should clear all selected photos when choose action is pressed while already all-selected', 0, () => {
      const harness = new PhotoListHarness();
      harness.photoList = createLocalPhotos(3);
      harness.pictureChooseFlags = [true, true, true];
      harness.pictureFlag = true;
      harness.isCheckAll = true;
      harness.focusDialogStr = 'dialog2';

      harness.onDialogClick(2);
      harness.flushPendingTasks();

      expect(harness.isCheckAll).assertFalse();
      expect(harness.pictureChooseFlags.every((item) => !item)).assertTrue();
      expect(harness.dialogList[2].name).assertEqual('select_all');
    });

    it('should enter delete confirm panel when delete dialog item is activated', 0, () => {
      const harness = new PhotoListHarness();
      harness.dialogFlag = true;
      harness.focusDialogStr = 'dialog0';

      harness.onDialogClick(0);
      harness.flushPendingTasks();

      expect(harness.deleteFlag).assertTrue();
      expect(harness.focusDialogStr).assertEqual('delete1');
    });

    it('should emit share toast when share dialog item is activated', 0, () => {
      const harness = new PhotoListHarness();
      harness.focusDialogStr = 'dialog1';

      harness.onDialogClick(1);

      expect(harness.toastHistory[harness.toastHistory.length - 1]).assertEqual('share');
    });

    it('should toggle select all state from dialog choose action while editing', 0, () => {
      const harness = new PhotoListHarness();
      harness.photoList = createLocalPhotos(3);
      harness.pictureChooseFlags = [true, false, true];
      harness.pictureFlag = true;
      harness.isCheckAll = false;
      harness.focusDialogStr = 'dialog2';

      harness.onDialogClick(2);
      harness.flushPendingTasks();

      expect(harness.isCheckAll).assertTrue();
      expect(harness.pictureChooseFlags.every((item) => item)).assertTrue();
      expect(harness.dialogList[2].name).assertEqual('cancel_all_select');
    });

    it('should move dialog focus right for local album actions', 0, () => {
      const harness = new PhotoListHarness();
      harness.dialogIndex = 0;
      harness.focusDialogStr = 'dialog0';

      harness.onDialogRight();

      expect(harness.dialogIndex).assertEqual(1);
      expect(harness.focusDialogStr).assertEqual('dialog1');
    });

    it('should skip hidden share action when moving right inside nas dialog', 0, () => {
      const harness = new PhotoListHarness(AlbumType.NAS_SESSION, '192.168.3.10');
      harness.dialogIndex = 0;
      harness.focusDialogStr = 'dialog0';

      harness.onDialogRight();

      expect(harness.dialogIndex).assertEqual(2);
      expect(harness.focusDialogStr).assertEqual('dialog2');
    });

    it('should stop dialog focus at the right boundary', 0, () => {
      const harness = new PhotoListHarness();
      harness.dialogIndex = 2;
      harness.focusDialogStr = 'dialog2';

      harness.onDialogRight();

      expect(harness.dialogIndex).assertEqual(2);
      expect(harness.focusDialogStr).assertEqual('dialog2');
    });

    it('should skip hidden share action for nas dialog navigation', 0, () => {
      const harness = new PhotoListHarness(AlbumType.NAS_SESSION, '192.168.3.10');
      harness.dialogIndex = 2;
      harness.focusDialogStr = 'dialog2';
      harness.pictureChooseFlags = [true];

      harness.onDialogLeft();

      expect(harness.dialogIndex).assertEqual(0);
      expect(harness.focusDialogStr).assertEqual('dialog0');
    });

    it('should prompt choose toast when moving left from choose without selections', 0, () => {
      const harness = new PhotoListHarness();
      harness.dialogIndex = 2;
      harness.focusDialogStr = 'dialog2';
      harness.pictureChooseFlags = [false, false];

      harness.onDialogLeft();

      expect(harness.toastHistory[harness.toastHistory.length - 1]).assertEqual('please_choose_photo');
    });

    it('should move dialog focus left for local album actions when items are selectable', 0, () => {
      const harness = new PhotoListHarness();
      harness.dialogIndex = 2;
      harness.focusDialogStr = 'dialog2';
      harness.pictureChooseFlags = [true, false];

      harness.onDialogLeft();

      expect(harness.dialogIndex).assertEqual(1);
      expect(harness.focusDialogStr).assertEqual('dialog1');
    });

    it('should ignore delete request when no photo uri is selected', 0, async () => {
      const photoManager = new MockPhotoManager();
      const harness = new PhotoListHarness(AlbumType.ALL, '全部', photoManager);

      await harness.getDeleteAssets([]);

      expect(photoManager.deleteHistory.length).assertEqual(0);
      expect(harness.toastHistory.length).assertEqual(0);
    });

    it('should delete selected local photos and reset edit states on success', 0, async () => {
      const photoManager = new MockPhotoManager();
      const harness = new PhotoListHarness(AlbumType.ALL, '全部', photoManager);
      harness.photoList = createLocalPhotos(3);
      harness.pictureChooseFlags = [true, true, false];
      harness.pictureFlag = true;
      harness.dialogFlag = true;
      harness.deleteFlag = true;

      await harness.getDeleteAssets(harness.getPhotoUris());
      harness.flushPendingTasks();

      expect(photoManager.deleteHistory.length).assertEqual(1);
      expect(photoManager.deleteHistory[0].count).assertEqual(2);
      expect(harness.pictureFlag).assertFalse();
      expect(harness.deleteFlag).assertFalse();
      expect(harness.toastHistory[harness.toastHistory.length - 1]).assertEqual('delete_success');
    });

    it('should delete selected nas files through nas session manager', 0, async () => {
      const nasManager = new MockNasSessionManager();
      const harness = new PhotoListHarness(AlbumType.NAS_SESSION, '192.168.3.10', undefined, nasManager);
      harness.photoList = createNasFiles(3, '192.168.3.10');
      harness.pictureChooseFlags = [true, false, true];
      harness.pictureFlag = true;
      harness.dialogFlag = true;
      harness.deleteFlag = true;

      await harness.getDeleteAssets(harness.getPhotoUris());
      harness.flushPendingTasks();

      expect(nasManager.deleteHistory.length).assertEqual(1);
      expect(nasManager.deleteHistory[0].host).assertEqual('192.168.3.10');
      expect(nasManager.deleteHistory[0].count).assertEqual(2);
      expect(harness.toastHistory[harness.toastHistory.length - 1]).assertEqual('delete_success');
    });

    it('should keep edit mode when delete fails', 0, async () => {
      const photoManager = new MockPhotoManager();
      photoManager.shouldDeleteFail = true;
      const harness = new PhotoListHarness(AlbumType.ALL, '全部', photoManager);
      harness.photoList = createLocalPhotos(2);
      harness.pictureChooseFlags = [true, false];
      harness.pictureFlag = true;
      harness.dialogFlag = true;
      harness.deleteFlag = true;

      await harness.getDeleteAssets(harness.getPhotoUris());

      expect(harness.pictureFlag).assertTrue();
      expect(harness.deleteFlag).assertTrue();
      expect(harness.toastHistory[harness.toastHistory.length - 1]).assertEqual('delete_error');
    });

    it('should keep nas delete dialog open when remote delete fails', 0, async () => {
      const nasManager = new MockNasSessionManager();
      nasManager.shouldDeleteFail = true;
      const harness = new PhotoListHarness(AlbumType.NAS_SESSION, '192.168.3.10', undefined, nasManager);
      harness.photoList = createNasFiles(2, '192.168.3.10');
      harness.pictureChooseFlags = [true, false];
      harness.pictureFlag = true;
      harness.dialogFlag = true;
      harness.deleteFlag = true;

      await harness.getDeleteAssets(harness.getPhotoUris());

      expect(harness.pictureFlag).assertTrue();
      expect(harness.deleteFlag).assertTrue();
      expect(harness.toastHistory[harness.toastHistory.length - 1]).assertEqual('delete_error');
    });

    it('should cancel delete confirmation and restore dialog focus when user chooses cancel', 0, () => {
      const harness = new PhotoListHarness();
      harness.deleteFlag = true;

      harness.onDeleteConfirm(0);
      harness.flushPendingTasks();

      expect(harness.deleteFlag).assertFalse();
      expect(harness.deleteIndex).assertEqual(1);
      expect(harness.focusDialogStr).assertEqual('dialog0');
    });

    it('should confirm delete through current selected local photo list', 0, async () => {
      const photoManager = new MockPhotoManager();
      const harness = new PhotoListHarness(AlbumType.ALL, '全部', photoManager);
      harness.photoList = createLocalPhotos(3);
      harness.pictureChooseFlags = [false, true, true];
      harness.pictureFlag = true;
      harness.dialogFlag = true;
      harness.deleteFlag = true;

      await harness.onDeleteConfirm(1);
      harness.flushPendingTasks();

      expect(photoManager.deleteHistory.length).assertEqual(1);
      expect(photoManager.deleteHistory[0].count).assertEqual(2);
      expect(harness.toastHistory[harness.toastHistory.length - 1]).assertEqual('delete_success');
    });

    it('should move picture focus across grid and update scroll history', 0, () => {
      const harness = new PhotoListHarness();
      harness.photoList = createLocalPhotos(8);

      harness.onItemKeyEvent(createKeyEvent(KEYCODE_DPAD_RIGHT), 0);
      harness.onItemKeyEvent(createKeyEvent(KEYCODE_DPAD_DOWN), 1);

      expect(harness.pictureIndex).assertEqual(7);
      expect(harness.focusPhotoStr).assertEqual('picture7');
      expect(harness.scrollHistory[0]).assertEqual(1);
      expect(harness.scrollHistory[1]).assertEqual(7);
    });

    it('should stop picture focus movement at all four grid boundaries', 0, () => {
      const harness = new PhotoListHarness();
      harness.photoList = createLocalPhotos(8);
      harness.focusPhotoStr = 'picture7';

      harness.onItemKeyEvent(createKeyEvent(KEYCODE_DPAD_LEFT), 0);
      harness.onItemKeyEvent(createKeyEvent(KEYCODE_DPAD_UP), 0);
      harness.pictureIndex = 7;
      harness.onItemKeyEvent(createKeyEvent(KEYCODE_DPAD_RIGHT), 7);
      harness.onItemKeyEvent(createKeyEvent(KEYCODE_DPAD_DOWN), 7);

      expect(harness.pictureIndex).assertEqual(7);
      expect(harness.scrollHistory.length).assertEqual(0);
      expect(harness.focusPhotoStr).assertEqual('picture7');
    });

    it('should open local photo watch page with current list payload', 0, () => {
      const harness = new PhotoListHarness();
      harness.photoList = createLocalPhotos(3);

      harness.onItemKeyEvent(createKeyEvent(KEYCODE_DPAD_CENTER), 1);

      expect(harness.routeHistory.length).assertEqual(1);
      expect(harness.routeHistory[0].url).assertEqual('pages/PhotoWatch');
      expect(harness.routeHistory[0].photoIndex).assertEqual(1);
      expect(harness.routeHistory[0].photoListLength).assertEqual(3);
    });

    it('should open nas photo watch page with host parameter', 0, () => {
      const harness = new PhotoListHarness(AlbumType.NAS_SESSION, '192.168.3.10');
      harness.photoList = createNasFiles(3, '192.168.3.10');

      harness.onItemKeyEvent(createKeyEvent(KEYCODE_DPAD_CENTER), 2);

      expect(harness.routeHistory.length).assertEqual(1);
      expect(harness.routeHistory[0].url).assertEqual('pages/PhotoWatch');
      expect(harness.routeHistory[0].photoIndex).assertEqual(2);
      expect(harness.routeHistory[0].nasHost).assertEqual('192.168.3.10');
    });

    it('should toggle selected flag instead of routing while editing', 0, () => {
      const harness = new PhotoListHarness();
      harness.photoList = createLocalPhotos(2);
      harness.pictureFlag = true;
      harness.pictureChooseFlags = [false, false];

      harness.onItemKeyEvent(createKeyEvent(KEYCODE_ENTER), 0);

      expect(harness.pictureChooseFlags[0]).assertTrue();
      expect(harness.routeHistory.length).assertEqual(0);
    });

    it('should toggle current selection when center key is pressed during edit mode', 0, () => {
      const harness = new PhotoListHarness();
      harness.photoList = createLocalPhotos(2);
      harness.pictureFlag = true;
      harness.pictureChooseFlags = [true, false];

      harness.onItemKeyEvent(createKeyEvent(KEYCODE_DPAD_CENTER), 0);

      expect(harness.pictureChooseFlags[0]).assertFalse();
      expect(harness.routeHistory.length).assertEqual(0);
    });

    it('should open menu from item menu key and back out of edit mode', 0, () => {
      const harness = new PhotoListHarness();
      harness.photoList = createLocalPhotos(2);
      harness.pictureFlag = true;
      harness.pictureChooseFlags = [true, false];

      harness.onItemKeyEvent(createKeyEvent(KEYCODE_MENU), 0);
      harness.flushPendingTasks();
      expect(harness.dialogFlag).assertTrue();

      harness.onItemKeyEvent(createKeyEvent(KEYCODE_NUMPAD_2), 0);

      expect(harness.pictureFlag).assertFalse();
      expect(harness.pictureChooseFlags[0]).assertFalse();
    });

    it('should also open menu from numpad-1 shortcut', 0, () => {
      const harness = new PhotoListHarness();
      harness.photoList = createLocalPhotos(2);
      harness.pictureChooseFlags = [false, false];

      harness.onItemKeyEvent(createKeyEvent(KEYCODE_NUMPAD_1), 1);
      harness.flushPendingTasks();

      expect(harness.dialogFlag).assertTrue();
      expect(harness.dialogIndex).assertEqual(2);
      expect(harness.focusDialogStr).assertEqual('dialog2');
    });

    it('should reset choose flags and dialog icons when leaving photo edit mode', 0, () => {
      const harness = new PhotoListHarness();
      harness.photoList = createLocalPhotos(3);
      harness.pictureFlag = true;
      harness.isCheckAll = true;
      harness.pictureChooseFlags = [true, true, true];
      harness.dialogList[0].uri = 'app.media.p_del_default';
      harness.dialogList[1].uri = 'app.media.p_share_default';
      harness.dialogList[2].name = 'cancel_all_select';
      harness.dialogList[2].uri = 'app.media.p_check_all_default';

      harness.getPhotoBack();

      expect(harness.pictureFlag).assertFalse();
      expect(harness.isCheckAll).assertFalse();
      expect(harness.pictureChooseFlags.every((item) => !item)).assertTrue();
      expect(harness.dialogList[0].uri).assertEqual('app.media.p_del_disabled');
      expect(harness.dialogList[1].uri).assertEqual('app.media.p_share_disabled');
      expect(harness.dialogList[2].name).assertEqual('choose');
    });

    LOCAL_DELETE_SCENARIOS.forEach((scenario: LocalDeleteScenario) => {
      it(`should delete selected local photos for ${scenario.name}`, 0, async () => {
        const photoManager = new MockPhotoManager();
        const harness = new PhotoListHarness(scenario.albumType, scenario.albumName, photoManager);
        harness.photoList = createLocalPhotos(3);
        harness.pictureChooseFlags = [...scenario.flags];
        harness.pictureFlag = true;
        harness.dialogFlag = true;
        harness.deleteFlag = true;

        await harness.onDeleteConfirm(1);
        harness.flushPendingTasks();

        expect(photoManager.deleteHistory.length).assertEqual(1);
        expect(photoManager.deleteHistory[0].count).assertEqual(scenario.expectedDeleteCount);
        expect(harness.toastHistory[harness.toastHistory.length - 1]).assertEqual(scenario.expectedToast);
      });
    });

    NAS_DELETE_SCENARIOS.forEach((scenario: NasDeleteScenario) => {
      it(`should delete selected nas photos for ${scenario.name}`, 0, async () => {
        const nasManager = new MockNasSessionManager();
        const harness = new PhotoListHarness(AlbumType.NAS_SESSION, '192.168.3.10', undefined, nasManager);
        harness.photoList = createNasFiles(3, '192.168.3.10');
        harness.pictureChooseFlags = [...scenario.flags];
        harness.pictureFlag = true;
        harness.dialogFlag = true;
        harness.deleteFlag = true;

        await harness.onDeleteConfirm(1);
        harness.flushPendingTasks();

        expect(nasManager.deleteHistory.length).assertEqual(1);
        expect(nasManager.deleteHistory[0].count).assertEqual(scenario.expectedDeleteCount);
        expect(harness.toastHistory[harness.toastHistory.length - 1]).assertEqual('delete_success');
      });
    });

    GRID_NAVIGATION_SCENARIOS.forEach((scenario: GridNavigationScenario) => {
      it(`should handle grid navigation for ${scenario.name}`, 0, () => {
        const harness = new PhotoListHarness();
        harness.photoList = createLocalPhotos(8);
        harness.pictureIndex = scenario.startIndex;
        harness.focusPhotoStr = `picture${scenario.startIndex}`;

        harness.onItemKeyEvent(createKeyEvent(scenario.keyCode), scenario.startIndex);

        expect(harness.pictureIndex).assertEqual(scenario.expectedIndex);
        expect(harness.focusPhotoStr).assertEqual(`picture${scenario.expectedIndex}`);
        if (scenario.expectScroll) {
          expect(harness.scrollHistory[harness.scrollHistory.length - 1]).assertEqual(scenario.expectedIndex);
        } else {
          expect(harness.scrollHistory.length).assertEqual(0);
        }
      });
    });

    WATCH_ROUTE_SCENARIOS.forEach((scenario: WatchRouteScenario) => {
      it(`should route watch page for ${scenario.name}`, 0, () => {
        const harness = new PhotoListHarness(scenario.albumType, scenario.albumName);
        harness.photoList = scenario.albumType === AlbumType.NAS_SESSION
          ? createNasFiles(3, '192.168.3.10')
          : createLocalPhotos(3);

        harness.onItemKeyEvent(createKeyEvent(scenario.keyCode), 1);

        expect(harness.routeHistory.length).assertEqual(1);
        expect(harness.routeHistory[0].url).assertEqual('pages/PhotoWatch');
        expect(harness.routeHistory[0].photoIndex).assertEqual(1);
        expect(harness.routeHistory[0].nasHost ?? '').assertEqual(scenario.expectedHost);
      });
    });

    EDIT_TOGGLE_SCENARIOS.forEach((scenario: EditToggleScenario) => {
      it(`should toggle edit selection for ${scenario.name}`, 0, () => {
        const harness = new PhotoListHarness();
        harness.photoList = createLocalPhotos(2);
        harness.pictureFlag = true;
        harness.pictureChooseFlags = [...scenario.initialFlags];

        harness.onItemKeyEvent(createKeyEvent(scenario.keyCode), scenario.itemIndex);

        scenario.expectedFlags.forEach((value, index) => {
          expect(harness.pictureChooseFlags[index]).assertEqual(value);
        });
        expect(harness.routeHistory.length).assertEqual(0);
      });
    });

    SHORTCUT_SCENARIOS.forEach((scenario: ShortcutScenario) => {
      it(`should open edit dialog from item shortcut ${scenario.name}`, 0, () => {
        const harness = new PhotoListHarness();
        harness.photoList = createLocalPhotos(2);
        harness.pictureChooseFlags = [false, false];
        harness.pictureFlag = true;

        harness.onItemKeyEvent(createKeyEvent(scenario.keyCode), 0);
        harness.flushPendingTasks();

        expect(harness.dialogFlag).assertEqual(scenario.expectedDialog);
        expect(harness.dialogIndex).assertEqual(scenario.expectedDialogIndex);
        expect(harness.focusDialogStr).assertEqual('dialog2');
      });
    });

    DELETE_DIALOG_SCENARIOS.forEach((scenario: DeleteDialogScenario) => {
      it(`should keep delete dialog state contract for ${scenario.name}`, 0, async () => {
        const photoManager = new MockPhotoManager();
        const harness = new PhotoListHarness(AlbumType.ALL, '全部', photoManager);
        harness.photoList = createLocalPhotos(2);
        harness.pictureChooseFlags = [true, false];
        harness.pictureFlag = true;
        harness.dialogFlag = true;
        harness.deleteFlag = true;

        await harness.onDeleteConfirm(scenario.index);
        harness.flushPendingTasks();

        expect(harness.deleteFlag).assertEqual(scenario.expectedDeleteFlag);
        expect(harness.deleteIndex).assertEqual(scenario.expectedDeleteIndex);
        expect(harness.focusDialogStr).assertEqual(scenario.expectedFocus);
      });
    });
  });
}
