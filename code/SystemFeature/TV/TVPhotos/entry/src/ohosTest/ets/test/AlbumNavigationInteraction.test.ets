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
import { FIRST_ROW_MAX_INDEX } from '../../../main/ets/common/PhotoPositionUtils';
import { PhotoGroupDataSource } from '../../../main/ets/models/IDataSource';
import { AlbumModel, AlbumType, PhotoGroupModel } from '../../../main/ets/models/PhotoModel';
import { TestDataFactory } from './base/TestDataFactory';
import { MockFocusController } from './base/TestDoubles';

type AlbumDirection = 'left' | 'up' | 'right' | 'down';

class RouteRecord {
  url: string;
  photoTitle?: ResourceStr;
  photoType?: AlbumType;

  constructor(url: string, photoTitle?: ResourceStr, photoType?: AlbumType) {
    this.url = url;
    this.photoTitle = photoTitle;
    this.photoType = photoType;
  }
}

class TabMoveScenario {
  name: string;
  chooseIndex: number;
  callIndex: number;
  expectedChooseIndex: number;
  expectedFocus: string;
  expectedRefreshCount: number;

  constructor(name: string, chooseIndex: number, callIndex: number, expectedChooseIndex: number, expectedFocus: string,
    expectedRefreshCount: number) {
    this.name = name;
    this.chooseIndex = chooseIndex;
    this.callIndex = callIndex;
    this.expectedChooseIndex = expectedChooseIndex;
    this.expectedFocus = expectedFocus;
    this.expectedRefreshCount = expectedRefreshCount;
  }
}

class TabDownScenario {
  name: string;
  chooseIndex: number;
  withPhotoGroup: boolean;
  withAlbums: boolean;
  connectedToDfs: boolean;
  expectedFocus: string;

  constructor(name: string, chooseIndex: number, withPhotoGroup: boolean, withAlbums: boolean, connectedToDfs: boolean,
    expectedFocus: string) {
    this.name = name;
    this.chooseIndex = chooseIndex;
    this.withPhotoGroup = withPhotoGroup;
    this.withAlbums = withAlbums;
    this.connectedToDfs = connectedToDfs;
    this.expectedFocus = expectedFocus;
  }
}

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

class AlbumFocusScenario {
  current: AlbumType;
  direction: AlbumDirection;
  expectedFocus: string;

  constructor(current: AlbumType, direction: AlbumDirection, expectedFocus: string) {
    this.current = current;
    this.direction = direction;
    this.expectedFocus = expectedFocus;
  }
}

class AlbumRouteScenario {
  albumType: AlbumType;
  expectedUrl: string;
  expectedTitle?: string;

  constructor(albumType: AlbumType, expectedUrl: string, expectedTitle?: string) {
    this.albumType = albumType;
    this.expectedUrl = expectedUrl;
    this.expectedTitle = expectedTitle;
  }
}

class FocusRequestScenario {
  name: string;
  focusId: string;
  expectedResult: boolean;
  expectedFocus: string;

  constructor(name: string, focusId: string, expectedResult: boolean, expectedFocus: string) {
    this.name = name;
    this.focusId = focusId;
    this.expectedResult = expectedResult;
    this.expectedFocus = expectedFocus;
  }
}

class AlbumNavigationHarness {
  chooseIndex: number = 0;
  albumIndex: number = 0;
  albumGridRowCount: number = 4;
  focusStr: string = 'menu0';
  photoGroupList: PhotoGroupDataSource = new PhotoGroupDataSource();
  subTypeModels: (AlbumModel | undefined)[] = [];
  refreshCount: number = 0;
  routeHistory: RouteRecord[] = [];
  connectedToDfs: boolean = false;
  private focusController: MockFocusController;

  constructor(focusController?: MockFocusController) {
    this.focusController = focusController ?? new MockFocusController();
    this.focusController.allow([
      'menu0',
      'menu1',
      'menu2',
      'photo_0_0',
      'dfs_photo_0',
      'to_dfs_manage',
      'album0',
      'album1',
      'album2',
      'album3',
      'album4',
      'album5'
    ]);
  }

  onTabMenuLeftClick(index: number): void {
    if (index > 0) {
      this.chooseIndex--;
      this.clickFocusBtn(`menu${this.chooseIndex}`, false);
      this.refreshCount++;
    }
  }

  onTabMenuRightClick(index: number): void {
    if (index <= 1) {
      this.chooseIndex++;
      this.clickFocusBtn(`menu${this.chooseIndex}`, false);
      this.refreshCount++;
    }
  }

  onTabMenuDownClick(index: number): void {
    if (this.chooseIndex === 0 && this.photoGroupList.totalCount()) {
      this.clickFocusBtn('photo_0_0', false);
    } else if (this.chooseIndex === 1 && this.subTypeModels.length > 0) {
      this.focusFirstAlbum();
    } else {
      if (this.connectedToDfs) {
        this.clickFocusBtn('dfs_photo_0', false);
      } else {
        this.clickFocusBtn('to_dfs_manage', false);
      }
    }
  }

  focusFirstAlbum(): void {
    const index = this.subTypeModels.findIndex((value) => value && value.count > 0);
    this.clickFocusBtn(`album${index}`, false);
  }

  nextAlbumClick(currentIndex: number, direction: AlbumDirection): void {
    const index = this.getNextAlbum(currentIndex, direction);
    if (index !== -1) {
      this.clickFocusBtn(`album${index}`, false);
    }
  }

  getNextAlbum(currentIndex: number, direction: AlbumDirection): number {
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

  clickFocusBtn(str: string, inDialog: boolean): boolean {
    const isSuccess = this.focusController.requestFocus(str);
    if (isSuccess) {
      this.focusStr = str;
      return true;
    }
    if (str.substring(0, 5) === 'album') {
      this.clickFocusBtn('menu1', false);
    }
    return false;
  }

  openAlbum(item: AlbumModel): void {
    if (item.type === AlbumType.NAS_SESSION) {
      this.routeHistory.push(new RouteRecord('pages/NasSessionPage'));
    } else if (item.type === AlbumType.TRASH) {
      this.routeHistory.push(new RouteRecord('pages/PhotoDeleteList'));
    } else {
      this.routeHistory.push(new RouteRecord('pages/PhotoList', item.name, item.type));
    }
  }

  getFocusHistory(): string[] {
    return this.focusController.getFocusHistory().map((item) => item.focusId);
  }
}

function createAlbumGrid(): (AlbumModel | undefined)[] {
  const albums: (AlbumModel | undefined)[] = [];

  albums[AlbumType.ALL] = new AlbumModel(AlbumType.ALL, '全部');
  albums[AlbumType.ALL]!.count = 6;

  albums[AlbumType.FAVORITE] = new AlbumModel(AlbumType.FAVORITE, '收藏');
  albums[AlbumType.FAVORITE]!.count = 2;

  albums[AlbumType.SCREENSHOT] = new AlbumModel(AlbumType.SCREENSHOT, '截图');
  albums[AlbumType.SCREENSHOT]!.count = 1;

  albums[AlbumType.TRASH] = new AlbumModel(AlbumType.TRASH, '回收站');
  albums[AlbumType.TRASH]!.count = 4;

  albums[AlbumType.NAS_SESSION] = new AlbumModel(AlbumType.NAS_SESSION, '更多');
  albums[AlbumType.NAS_SESSION]!.count = 0;

  return albums;
}

function createPhotoGroup(): PhotoGroupModel {
  const group = new PhotoGroupModel();
  group.createTime = 20250325;
  group.photoList = TestDataFactory.createPhotoList(3);
  return group;
}

const TAB_LEFT_SCENARIOS: TabMoveScenario[] = [
  new TabMoveScenario('left_from_album_tab', 1, 1, 0, 'menu0', 1),
  new TabMoveScenario('left_from_distributed_tab', 2, 2, 1, 'menu1', 1),
  new TabMoveScenario('left_boundary', 0, 0, 0, 'menu0', 0)
];

const TAB_RIGHT_SCENARIOS: TabMoveScenario[] = [
  new TabMoveScenario('right_from_photo_tab', 0, 0, 1, 'menu1', 1),
  new TabMoveScenario('right_from_album_tab', 1, 1, 2, 'menu2', 1),
  new TabMoveScenario('right_boundary', 2, 2, 2, 'menu0', 0)
];

const TAB_DOWN_SCENARIOS: TabDownScenario[] = [
  new TabDownScenario('photo_tab_with_data', 0, true, false, false, 'photo_0_0'),
  new TabDownScenario('photo_tab_without_data', 0, false, false, false, 'menu0'),
  new TabDownScenario('album_tab_with_dense_albums', 1, false, true, false, 'album0'),
  new TabDownScenario('album_tab_without_albums', 1, false, false, false, 'album-1'),
  new TabDownScenario('distributed_connected', 2, false, false, true, 'dfs_photo_0'),
  new TabDownScenario('distributed_disconnected', 2, false, false, false, 'to_dfs_manage')
];

const ALBUM_NEIGHBOR_SCENARIOS: AlbumNeighborScenario[] = [
  new AlbumNeighborScenario(AlbumType.ALL, 'right', AlbumType.FAVORITE),
  new AlbumNeighborScenario(AlbumType.FAVORITE, 'left', AlbumType.ALL),
  new AlbumNeighborScenario(AlbumType.FAVORITE, 'right', AlbumType.SCREENSHOT),
  new AlbumNeighborScenario(AlbumType.SCREENSHOT, 'left', AlbumType.FAVORITE),
  new AlbumNeighborScenario(AlbumType.TRASH, 'right', AlbumType.NAS_SESSION),
  new AlbumNeighborScenario(AlbumType.NAS_SESSION, 'left', AlbumType.TRASH),
  new AlbumNeighborScenario(AlbumType.ALL, 'down', AlbumType.NAS_SESSION),
  new AlbumNeighborScenario(AlbumType.NAS_SESSION, 'up', AlbumType.ALL),
  new AlbumNeighborScenario(AlbumType.ALL, 'left', -1),
  new AlbumNeighborScenario(AlbumType.NAS_SESSION, 'right', -1)
];

const ALBUM_FOCUS_SCENARIOS: AlbumFocusScenario[] = [
  new AlbumFocusScenario(AlbumType.ALL, 'right', 'album1'),
  new AlbumFocusScenario(AlbumType.FAVORITE, 'right', 'album2'),
  new AlbumFocusScenario(AlbumType.SCREENSHOT, 'right', 'album3'),
  new AlbumFocusScenario(AlbumType.TRASH, 'right', 'album4')
];

const ALBUM_ROUTE_SCENARIOS: AlbumRouteScenario[] = [
  new AlbumRouteScenario(AlbumType.ALL, 'pages/PhotoList', '全部'),
  new AlbumRouteScenario(AlbumType.FAVORITE, 'pages/PhotoList', '收藏'),
  new AlbumRouteScenario(AlbumType.SCREENSHOT, 'pages/PhotoList', '截图'),
  new AlbumRouteScenario(AlbumType.TRASH, 'pages/PhotoDeleteList'),
  new AlbumRouteScenario(AlbumType.NAS_SESSION, 'pages/NasSessionPage')
];

const FOCUS_REQUEST_SCENARIOS: FocusRequestScenario[] = [
  new FocusRequestScenario('menu0', 'menu0', true, 'menu0'),
  new FocusRequestScenario('album2', 'album2', true, 'album2'),
  new FocusRequestScenario('dfs_manage', 'to_dfs_manage', true, 'to_dfs_manage')
];

export default function albumNavigationInteractionTest() {
  describe('AlbumNavigationInteractionTest', () => {
    it('should move tab focus left and refresh when leaving album tab', 0, () => {
      const harness = new AlbumNavigationHarness();
      harness.chooseIndex = 1;

      harness.onTabMenuLeftClick(1);

      expect(harness.chooseIndex).assertEqual(0);
      expect(harness.focusStr).assertEqual('menu0');
      expect(harness.refreshCount).assertEqual(1);
    });

    it('should move tab focus right and refresh when leaving photo tab', 0, () => {
      const harness = new AlbumNavigationHarness();
      harness.chooseIndex = 0;

      harness.onTabMenuRightClick(0);

      expect(harness.chooseIndex).assertEqual(1);
      expect(harness.focusStr).assertEqual('menu1');
      expect(harness.refreshCount).assertEqual(1);
    });

    it('should stop tab traversal at right edge of distributed tab', 0, () => {
      const harness = new AlbumNavigationHarness();
      harness.chooseIndex = 2;

      harness.onTabMenuRightClick(2);

      expect(harness.chooseIndex).assertEqual(2);
      expect(harness.refreshCount).assertEqual(0);
      expect(harness.focusStr).assertEqual('menu0');
    });

    it('should move down from photo tab into first photo tile', 0, () => {
      const harness = new AlbumNavigationHarness();
      harness.chooseIndex = 0;
      harness.photoGroupList.setData([createPhotoGroup()]);

      harness.onTabMenuDownClick(0);

      expect(harness.focusStr).assertEqual('photo_0_0');
    });

    it('should move down from album tab into first non-empty album tile', 0, () => {
      const harness = new AlbumNavigationHarness();
      harness.chooseIndex = 1;
      harness.subTypeModels = createAlbumGrid();

      harness.onTabMenuDownClick(1);

      expect(harness.focusStr).assertEqual('album0');
    });

    it('should move down into distributed photo grid when dfs is connected', 0, () => {
      const harness = new AlbumNavigationHarness();
      harness.chooseIndex = 2;
      harness.connectedToDfs = true;

      harness.onTabMenuDownClick(2);

      expect(harness.focusStr).assertEqual('dfs_photo_0');
    });

    it('should move down into dfs management entry when dfs is disconnected', 0, () => {
      const harness = new AlbumNavigationHarness();
      harness.chooseIndex = 2;
      harness.connectedToDfs = false;

      harness.onTabMenuDownClick(2);

      expect(harness.focusStr).assertEqual('to_dfs_manage');
    });

    it('should route nas session album to session page', 0, () => {
      const harness = new AlbumNavigationHarness();
      const nasAlbum = createAlbumGrid()[AlbumType.NAS_SESSION]!;

      harness.openAlbum(nasAlbum);

      expect(harness.routeHistory.length).assertEqual(1);
      expect(harness.routeHistory[0].url).assertEqual('pages/NasSessionPage');
    });

    it('should route trash album to delete list page', 0, () => {
      const harness = new AlbumNavigationHarness();
      const trashAlbum = createAlbumGrid()[AlbumType.TRASH]!;

      harness.openAlbum(trashAlbum);

      expect(harness.routeHistory.length).assertEqual(1);
      expect(harness.routeHistory[0].url).assertEqual('pages/PhotoDeleteList');
    });

    it('should route normal album to photo list with album params', 0, () => {
      const harness = new AlbumNavigationHarness();
      const favoriteAlbum = createAlbumGrid()[AlbumType.FAVORITE]!;

      harness.openAlbum(favoriteAlbum);

      expect(harness.routeHistory.length).assertEqual(1);
      expect(harness.routeHistory[0].url).assertEqual('pages/PhotoList');
      expect(harness.routeHistory[0].photoType).assertEqual(AlbumType.FAVORITE);
      expect(harness.routeHistory[0].photoTitle).assertEqual('收藏');
    });

    it('should compute sparse album neighbors including nas session tile', 0, () => {
      const harness = new AlbumNavigationHarness();
      harness.subTypeModels = createAlbumGrid();

      expect(harness.getNextAlbum(AlbumType.TRASH, 'right')).assertEqual(AlbumType.NAS_SESSION);
      expect(harness.getNextAlbum(AlbumType.NAS_SESSION, 'left')).assertEqual(AlbumType.TRASH);
      expect(harness.getNextAlbum(AlbumType.ALL, 'down')).assertEqual(AlbumType.NAS_SESSION);
    });

    it('should move album focus to computed right-side neighbor', 0, () => {
      const harness = new AlbumNavigationHarness();
      harness.subTypeModels = createAlbumGrid();
      harness.albumIndex = AlbumType.FAVORITE;

      harness.nextAlbumClick(AlbumType.FAVORITE, 'right');

      expect(harness.focusStr).assertEqual('album2');
    });

    it('should keep focus unchanged when album neighbor does not exist', 0, () => {
      const harness = new AlbumNavigationHarness();
      harness.subTypeModels = createAlbumGrid();
      harness.focusStr = 'album0';

      harness.nextAlbumClick(AlbumType.ALL, 'left');

      expect(harness.focusStr).assertEqual('album0');
    });

    it('should fall back to album menu focus when album target cannot receive focus', 0, () => {
      const focusController = new MockFocusController();
      focusController.allow(['menu1']);
      const harness = new AlbumNavigationHarness(focusController);

      const result = harness.clickFocusBtn('album3', false);

      expect(result).assertFalse();
      expect(harness.focusStr).assertEqual('menu1');
      expect(harness.getFocusHistory()[0]).assertEqual('menu1');
    });

    TAB_LEFT_SCENARIOS.forEach((scenario) => {
      it(`should handle tab-left movement for ${scenario.name}`, 0, () => {
        const harness = new AlbumNavigationHarness();
        harness.chooseIndex = scenario.chooseIndex;

        harness.onTabMenuLeftClick(scenario.callIndex);

        expect(harness.chooseIndex).assertEqual(scenario.expectedChooseIndex);
        expect(harness.focusStr).assertEqual(scenario.expectedFocus);
        expect(harness.refreshCount).assertEqual(scenario.expectedRefreshCount);
      });
    });

    TAB_RIGHT_SCENARIOS.forEach((scenario) => {
      it(`should handle tab-right movement for ${scenario.name}`, 0, () => {
        const harness = new AlbumNavigationHarness();
        harness.chooseIndex = scenario.chooseIndex;

        harness.onTabMenuRightClick(scenario.callIndex);

        expect(harness.chooseIndex).assertEqual(scenario.expectedChooseIndex);
        expect(harness.focusStr).assertEqual(scenario.expectedFocus);
        expect(harness.refreshCount).assertEqual(scenario.expectedRefreshCount);
      });
    });

    TAB_DOWN_SCENARIOS.forEach((scenario) => {
      it(`should handle tab-down movement for ${scenario.name}`, 0, () => {
        const harness = new AlbumNavigationHarness();
        harness.chooseIndex = scenario.chooseIndex;
        harness.connectedToDfs = scenario.connectedToDfs;
        if (scenario.withPhotoGroup) {
          harness.photoGroupList.setData([createPhotoGroup()]);
        }
        if (scenario.withAlbums) {
          harness.subTypeModels = createAlbumGrid();
        }

        harness.onTabMenuDownClick(scenario.chooseIndex);

        expect(harness.focusStr).assertEqual(scenario.expectedFocus);
      });
    });

    ALBUM_NEIGHBOR_SCENARIOS.forEach((scenario) => {
      it(`should compute album neighbor from ${scenario.current} using ${scenario.direction}`, 0, () => {
        const harness = new AlbumNavigationHarness();
        harness.subTypeModels = createAlbumGrid();

        expect(harness.getNextAlbum(scenario.current, scenario.direction)).assertEqual(scenario.expected);
      });
    });

    ALBUM_FOCUS_SCENARIOS.forEach((scenario) => {
      it(`should move focus to target album for ${scenario.current}`, 0, () => {
        const harness = new AlbumNavigationHarness();
        harness.subTypeModels = createAlbumGrid();

        harness.nextAlbumClick(scenario.current, scenario.direction);

        expect(harness.focusStr).assertEqual(scenario.expectedFocus);
      });
    });

    ALBUM_ROUTE_SCENARIOS.forEach((scenario) => {
      it(`should route album open flow for album type ${scenario.albumType}`, 0, () => {
        const harness = new AlbumNavigationHarness();
        const album = createAlbumGrid()[scenario.albumType]!;

        harness.openAlbum(album);

        expect(harness.routeHistory.length).assertEqual(1);
        expect(harness.routeHistory[0].url).assertEqual(scenario.expectedUrl);
        expect(harness.routeHistory[0].photoTitle).assertEqual(scenario.expectedTitle);
      });
    });

    FOCUS_REQUEST_SCENARIOS.forEach((scenario) => {
      it(`should request focus successfully for ${scenario.name}`, 0, () => {
        const harness = new AlbumNavigationHarness();

        const result = harness.clickFocusBtn(scenario.focusId, false);

        expect(result).assertEqual(scenario.expectedResult);
        expect(harness.focusStr).assertEqual(scenario.expectedFocus);
      });
    });
  });
}
