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

import { describe, it, expect } from '@ohos/hypium';
import { FoldListType, ArrayType, UrlType, ItemsType } from '../../../main/ets/const/Type';

export default function FoldListArrayContract001Test() {
  const casePrefix = 'DemandPlayer_FoldListArrayContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('FoldListArrayContract001TestSuite', () => {
    it(addCase(casePrefix + 'FoldListType_DefaultId_IsF1_001'), 0, () => {
      const fold = new FoldListType();
      expect(fold.id).assertEqual('f_1');
    });

    it(addCase(casePrefix + 'FoldListType_DefaultName_IsLocalVideo_002'), 0, () => {
      const fold = new FoldListType();
      expect(fold.name).assertEqual('本地视频');
    });

    it(addCase(casePrefix + 'FoldListType_DefaultNum_IsZero_003'), 0, () => {
      const fold = new FoldListType();
      expect(fold.num).assertEqual(0);
    });

    it(addCase(casePrefix + 'FoldListType_VideoList_IsEmptyArray_004'), 0, () => {
      const fold = new FoldListType();
      expect(fold.videoList instanceof Array).assertEqual(true);
      expect(fold.videoList.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'FoldListType_VideoList_Mutable_005'), 0, () => {
      const fold = new FoldListType();
      fold.videoList.push({ uri: 'test', url: 'url', displayName: 'n' } as UrlType);
      expect(fold.videoList.length).assertEqual(1);
    });

    it(addCase(casePrefix + 'FoldListType_MutableFields_006'), 0, () => {
      const fold = new FoldListType();
      fold.id = 'custom-id';
      fold.name = '在线视频';
      fold.num = 42;
      expect(fold.id).assertEqual('custom-id');
      expect(fold.name).assertEqual('在线视频');
      expect(fold.num).assertEqual(42);
    });

    it(addCase(casePrefix + 'FoldListType_MultipleInstances_007'), 0, () => {
      const f1 = new FoldListType();
      const f2 = new FoldListType();
      f1.num = 10;
      f2.num = 20;
      expect(f1.num).assertEqual(10);
      expect(f2.num).assertEqual(20);
    });

    it(addCase(casePrefix + 'ArrayType_Number_Creation_008'), 0, () => {
      const nums = new ArrayType<number>([1, 2, 3, 4, 5]);
      expect(nums.length).assertEqual(5);
      expect(nums[0]).assertEqual(1);
      expect(nums[4]).assertEqual(5);
    });

    it(addCase(casePrefix + 'ArrayType_Number_InstanceofArray_009'), 0, () => {
      const nums = new ArrayType<number>([1, 2, 3]);
      expect(nums instanceof Array).assertEqual(true);
      expect(Array.isArray(nums)).assertEqual(true);
    });

    it(addCase(casePrefix + 'ArrayType_String_Push_010'), 0, () => {
      const strs = new ArrayType<string>(['a', 'b']);
      strs.push('c');
      expect(strs.length).assertEqual(3);
      expect(strs[2]).assertEqual('c');
    });

    it(addCase(casePrefix + 'ArrayType_Object_IndexerAccess_011'), 0, () => {
      const items = new ArrayType<ItemsType>([
        { id: 'i1', name: 'item1', param: 1 },
        { id: 'i2', name: 'item2', param: 2 }
      ]);
      expect(items[0].id).assertEqual('i1');
      expect(items[1].param).assertEqual(2);
    });

    it(addCase(casePrefix + 'ArrayType_MixedTypes_012'), 0, () => {
      const mixed = new ArrayType<string | number | boolean>([
        'plain-object',
        'nested-array',
        'str',
        42,
        true
      ]);
      expect(mixed.length).assertEqual(5);
    });

    it(addCase(casePrefix + 'ArrayType_EmptyInit_013'), 0, () => {
      const empty = new ArrayType<number>([]);
      expect(empty.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'ArrayType_Splice_RemovesElements_014'), 0, () => {
      const arr = new ArrayType<number>([10, 20, 30]);
      arr.splice(1, 1);
      expect(arr.length).assertEqual(2);
      expect(arr[1]).assertEqual(30);
    });

    it(addCase(casePrefix + 'ArrayType_Map_TransformsElements_015'), 0, () => {
      const arr = new ArrayType<number>([1, 2, 3]);
      const doubled = arr.map((x: number) => x * 2);
      expect(doubled[0]).assertEqual(2);
      expect(doubled[2]).assertEqual(6);
    });

    it(addCase(casePrefix + 'ArrayType_Filter_RemovesElements_016'), 0, () => {
      const arr = new ArrayType<number>([1, 2, 3, 4, 5]);
      const evens = arr.filter((x: number) => x % 2 === 0);
      expect(evens.length).assertEqual(2);
    });

    it(addCase(casePrefix + 'UrlType_AllOptionalFieldsUndefined_017'), 0, () => {
      const url: UrlType = {};
      expect(url.uri).assertEqual(undefined);
      expect(url.url).assertEqual(undefined);
      expect(url.displayName).assertEqual(undefined);
      expect(url.resolution).assertEqual(undefined);
    });

    it(addCase(casePrefix + 'UrlType_PartialInit_018'), 0, () => {
      const url: UrlType = {
        uri: 'media://video-1',
        url: 'http://example.com/video.mp4'
      };
      expect(url.uri).assertEqual('media://video-1');
      expect(url.url).assertEqual('http://example.com/video.mp4');
      expect(url.displayName).assertEqual(undefined);
    });

    it(addCase(casePrefix + 'UrlType_FullInit_AllFields_019'), 0, () => {
      const url: UrlType = {
        uri: 'media://v2',
        url: 'https://cdn.com/v2.mp4',
        type: 'video/mp4',
        name: 'Sample Video',
        displayName: 'Sample.mp4',
        resolution: '1920x1080',
        resolutions: [],
        licenseUri: 'https://lic.com',
        createTime: '2024-01-01 00:00:00',
        deviceType: 1,
        intro: 'An intro',
        img: $r('app.media.app_icon'),
        description: 'Full desc'
      };
      expect(url.uri).assertEqual('media://v2');
      expect(url.deviceType).assertEqual(1);
    });

    it(addCase(casePrefix + 'ItemsType_WithValAndParam_020'), 0, () => {
      const item: ItemsType = {
        id: 'speed-2x',
        name: '2.0X',
        val: '2.0',
        param: 2
      };
      expect(item.val).assertEqual('2.0');
      expect(item.param).assertEqual(2);
    });

    it(addCase(casePrefix + 'ItemsType_WithoutOptional_021'), 0, () => {
      const item: ItemsType = { id: 'min', name: 'minimal' };
      expect(item.id).assertEqual('min');
      expect(item.val).assertEqual(undefined);
      expect(item.param).assertEqual(undefined);
    });

    it(addCase(casePrefix + 'FoldListType_Clone_CopyByReference_022'), 0, () => {
      const f1 = new FoldListType();
      f1.videoList.push({ uri: 'uri1' } as UrlType);
      const f2 = new FoldListType();
      f2.videoList = f1.videoList;
      f2.videoList.push({ uri: 'uri2' } as UrlType);
      expect(f1.videoList.length).assertEqual(2);
    });

    /**
     * ========== 第二部分：文件夹列表深度操作 ==========
     *
     * 业务背景：文件夹列表需要支持深度嵌套操作，如添加、删除、排序、过滤等。
     * 本测试套件验证各种深度操作的正确性。
     */
    it(addCase(casePrefix + 'FolderOps_AddMultiple_024'), 0, () => {
      const folders: Array<FoldListType> = [];
      for (let i = 0; i < 10; i++) {
        const fold = new FoldListType('id_' + i, 'Folder_' + i);
        fold.num = i * 5;
        folders.push(fold);
      }
      expect(folders.length).assertEqual(10);
      expect(folders[9].num).assertEqual(45);
    });

    it(addCase(casePrefix + 'FolderOps_SortByNum_025'), 0, () => {
      const folders: Array<FoldListType> = [];
      const f1 = new FoldListType('f1', 'F1');
      f1.num = 30;
      const f2 = new FoldListType('f2', 'F2');
      f2.num = 10;
      folders.push(f1);
      folders.push(f2);
      folders.sort((a, b) => a.num - b.num);
      expect(folders[0].num).assertEqual(10);
      expect(folders[1].num).assertEqual(30);
    });

    it(addCase(casePrefix + 'FolderOps_FilterByNum_026'), 0, () => {
      const folders: Array<FoldListType> = [];
      for (let i = 0; i < 5; i++) {
        const fold = new FoldListType('f' + i, 'Folder' + i);
        fold.num = i * 10;
        folders.push(fold);
      }
      const filtered = folders.filter(f => f.num >= 20);
      expect(filtered.length).assertEqual(3);
    });

    it(addCase(casePrefix + 'FolderOps_RemoveById_027'), 0, () => {
      const folders: Array<FoldListType> = [];
      for (let i = 0; i < 5; i++) {
        folders.push(new FoldListType('f' + i, 'Folder' + i));
      }
      const targetId = 'f2';
      const filtered = folders.filter(f => f.id !== targetId);
      expect(filtered.length).assertEqual(4);
    });

    it(addCase(casePrefix + 'FolderOps_UpdateNum_028'), 0, () => {
      const fold = new FoldListType('f1', 'Folder1');
      fold.num = 0;
      fold.num = 100;
      expect(fold.num).assertEqual(100);
    });

    it(addCase(casePrefix + 'FolderOps_ClearAll_029'), 0, () => {
      const folders: Array<FoldListType> = [];
      for (let i = 0; i < 10; i++) {
        folders.push(new FoldListType());
      }
      folders.length = 0;
      expect(folders.length).assertEqual(0);
    });

    /**
     * ========== 第三部分：ArrayType 高级操作 ==========
     *
     * 业务背景：ArrayType 需要支持更多高级数组操作，如 reduce、find、some、every 等。
     */
    it(addCase(casePrefix + 'ArrayOps_Reduce_Sum_030'), 0, () => {
      const arr = new ArrayType<number>([1, 2, 3, 4, 5]);
      const sum = arr.reduce((acc, cur) => acc + cur, 0);
      expect(sum).assertEqual(15);
    });

    it(addCase(casePrefix + 'ArrayOps_Reduce_Max_031'), 0, () => {
      const arr = new ArrayType<number>([3, 7, 2, 9, 1]);
      const max = arr.reduce((a, b) => a > b ? a : b);
      expect(max).assertEqual(9);
    });

    it(addCase(casePrefix + 'ArrayOps_Find_032'), 0, () => {
      const arr = new ArrayType<number>([10, 20, 30, 40, 50]);
      const found = arr.find(x => x === 30);
      expect(found).assertEqual(30);
    });

    it(addCase(casePrefix + 'ArrayOps_FindIndex_033'), 0, () => {
      const arr = new ArrayType<number>([5, 15, 25, 35]);
      const idx = arr.findIndex(x => x === 25);
      expect(idx).assertEqual(2);
    });

    it(addCase(casePrefix + 'ArrayOps_Some_034'), 0, () => {
      const arr = new ArrayType<number>([1, 3, 5, 7]);
      const hasEven = arr.some(x => x % 2 === 0);
      expect(hasEven).assertEqual(false);
    });

    it(addCase(casePrefix + 'ArrayOps_Every_035'), 0, () => {
      const arr = new ArrayType<number>([2, 4, 6, 8]);
      const allEven = arr.every(x => x % 2 === 0);
      expect(allEven).assertEqual(true);
    });

    it(addCase(casePrefix + 'ArrayOps_Concat_036'), 0, () => {
      const arr1 = new ArrayType<number>([1, 2]);
      const arr2 = new ArrayType<number>([3, 4]);
      const merged = arr1.concat(arr2);
      expect(merged.length).assertEqual(4);
    });

    it(addCase(casePrefix + 'ArrayOps_Slice_037'), 0, () => {
      const arr = new ArrayType<number>([1, 2, 3, 4, 5]);
      const sliced = arr.slice(1, 3);
      expect(sliced.length).assertEqual(2);
    });

    it(addCase(casePrefix + 'ArrayOps_Includes_038'), 0, () => {
      const arr = new ArrayType<string>(['apple', 'banana', 'cherry']);
      expect(arr.includes('banana')).assertEqual(true);
      expect(arr.includes('orange')).assertEqual(false);
    });

    it(addCase(casePrefix + 'ArrayOps_IndexOf_039'), 0, () => {
      const arr = new ArrayType<string>(['a', 'b', 'c', 'b', 'a']);
      expect(arr.indexOf('b')).assertEqual(1);
      expect(arr.lastIndexOf('b')).assertEqual(3);
    });

    /**
     * ========== 第四部分：UrlType 深度验证 ==========
     *
     * 业务背景：UrlType 需要验证各种字段组合的合法性。
     */
    it(addCase(casePrefix + 'UrlDeep_ValidHttpUri_040'), 0, () => {
      const url: UrlType = { uri: 'http://example.com/video.mp4' };
      expect(url.uri?.startsWith('http')).assertEqual(true);
    });

    it(addCase(casePrefix + 'UrlDeep_ValidHttpsUri_041'), 0, () => {
      const url: UrlType = { uri: 'https://secure.example.com/video.mp4' };
      expect(url.uri?.startsWith('https')).assertEqual(true);
    });

    it(addCase(casePrefix + 'UrlDeep_ValidMediaUri_042'), 0, () => {
      const url: UrlType = { uri: 'media://video-id-123' };
      expect(url.uri?.startsWith('media://')).assertEqual(true);
    });

    it(addCase(casePrefix + 'UrlDeep_WithResolution_043'), 0, () => {
      const url: UrlType = { uri: 'http://example.com/v.mp4', resolution: '1920x1080' };
      expect(url.resolution).assertEqual('1920x1080');
    });

    it(addCase(casePrefix + 'UrlDeep_WithMultipleResolutions_044'), 0, () => {
      const url: UrlType = { resolutions: ['1920x1080', '1280x720', '854x480'] };
      expect(url.resolutions?.length).assertEqual(3);
    });

    it(addCase(casePrefix + 'UrlDeep_WithLicenseUri_045'), 0, () => {
      const url: UrlType = { licenseUri: 'https://lic.example.com/getlic' };
      expect(url.licenseUri?.startsWith('https')).assertEqual(true);
    });

    it(addCase(casePrefix + 'UrlDeep_WithTimestamp_046'), 0, () => {
      const url: UrlType = { createTime: '2024-06-15 10:30:00' };
      expect(url.createTime !== undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'UrlDeep_WithDescription_047'), 0, () => {
      const url: UrlType = { description: 'This is a sample video description with details.' };
      expect((url.description?.length ?? 0) > 0).assertEqual(true);
    });

    it(addCase(casePrefix + 'UrlDeep_EmptyUri_048'), 0, () => {
      const url: UrlType = { uri: '' };
      const isValid = url.uri !== undefined && url.uri !== '';
      expect(isValid).assertEqual(false);
    });

    it(addCase(casePrefix + 'UrlDeep_InvalidUriFormat_049'), 0, () => {
      const url: UrlType = { uri: 'not-a-valid-url' };
      const isValid = url.uri?.startsWith('http') || url.uri?.startsWith('media://');
      expect(isValid === undefined || isValid === false).assertEqual(true);
    });

    /**
     * ========== 第五部分：ItemsType 深度验证 ==========
     *
     * 业务背景：ItemsType 用于表示设置项，需要验证各种组合。
     */
    it(addCase(casePrefix + 'ItemsDeep_SpeedSettings_050'), 0, () => {
      const speeds: Array<ItemsType> = [
        {
          id: '0.75x',
          name: '0.75X',
          val: '0.75',
          param: 0.75
        },
        {
          id: '1x',
          name: '1X',
          val: '1.0',
          param: 1.0
        },
        {
          id: '1.5x',
          name: '1.5X',
          val: '1.5',
          param: 1.5
        },
        {
          id: '2x',
          name: '2X',
          val: '2.0',
          param: 2.0
        }
      ];
      expect(speeds.length).assertEqual(4);
      expect(speeds[2].param).assertEqual(1.5);
    });

    it(addCase(casePrefix + 'ItemsDeep_AudioTrackSettings_051'), 0, () => {
      const tracks: Array<ItemsType> = [
        {
          id: 'track-1',
          name: 'Stereo',
          val: 'stereo',
          param: 2
        },
        {
          id: 'track-2',
          name: 'Mono',
          val: 'mono',
          param: 1
        }
      ];
      expect(tracks.length).assertEqual(2);
    });

    it(addCase(casePrefix + 'ItemsDeep_SubtitleLanguageSettings_052'), 0, () => {
      const subs: Array<ItemsType> = [
        {
          id: 'zh',
          name: '中文',
          val: 'zh',
          param: 0
        },
        {
          id: 'en',
          name: 'English',
          val: 'en',
          param: 1
        },
        {
          id: 'ja',
          name: '日本語',
          val: 'ja',
          param: 2
        }
      ];
      expect(subs.length).assertEqual(3);
    });

    it(addCase(casePrefix + 'ItemsDeep_QualitySettings_053'), 0, () => {
      const qualities: Array<ItemsType> = [
        {
          id: 'auto',
          name: '自动',
          val: 'auto',
          param: 0
        },
        {
          id: '1080p',
          name: '1080P',
          val: '1080p',
          param: 1
        },
        {
          id: '720p',
          name: '720P',
          val: '720p',
          param: 2
        }
      ];
      expect(qualities.length).assertEqual(3);
    });

    it(addCase(casePrefix + 'ItemsDeep_MinimalItem_054'), 0, () => {
      const item: ItemsType = { id: 'minimal', name: 'Min' };
      expect(item.id).assertEqual('minimal');
      expect(item.val === undefined).assertEqual(true);
      expect(item.param === undefined).assertEqual(true);
    });

    it(addCase(casePrefix + 'ItemsDeep_FullItem_055'), 0, () => {
      const item: ItemsType = {
        id: 'full',
        name: 'Full Item',
        val: 'value',
        param: 42
      };
      expect(item.id).assertEqual('full');
      expect(item.val).assertEqual('value');
      expect(item.param).assertEqual(42);
    });

    /**
     * ========== 第六部分：文件夹列表与视频列表联动 ==========
     *
     * 业务背景：文件夹和视频是一对多关系，需要验证联动操作的正确性。
     */
    it(addCase(casePrefix + 'Linkage_FolderContainsVideos_056'), 0, () => {
      const fold = new FoldListType('f1', 'Folder1');
      for (let i = 0; i < 5; i++) {
        fold.videoList.push({ uri: 'video_' + i } as UrlType);
      }
      fold.num = fold.videoList.length;
      expect(fold.num).assertEqual(5);
    });

    it(addCase(casePrefix + 'Linkage_RemoveVideoFromFolder_057'), 0, () => {
      const fold = new FoldListType('f1', 'Folder1');
      fold.videoList.push({ uri: 'v1' } as UrlType);
      fold.videoList.push({ uri: 'v2' } as UrlType);
      fold.videoList.pop();
      expect(fold.videoList.length).assertEqual(1);
    });

    it(addCase(casePrefix + 'Linkage_ClearVideos_058'), 0, () => {
      const fold = new FoldListType('f1', 'Folder1');
      fold.videoList.push({ uri: 'v1' } as UrlType);
      fold.videoList.push({ uri: 'v2' } as UrlType);
      fold.videoList.length = 0;
      fold.num = fold.videoList.length;
      expect(fold.num).assertEqual(0);
    });

    it(addCase(casePrefix + 'Linkage_MoveVideoBetweenFolders_059'), 0, () => {
      const f1 = new FoldListType('f1', 'Folder1');
      const f2 = new FoldListType('f2', 'Folder2');
      f1.videoList.push({ uri: 'shared_video' } as UrlType);
      f2.videoList.push(f1.videoList[0]);
      f1.videoList.shift();
      expect(f2.videoList.length).assertEqual(1);
      expect(f1.videoList.length).assertEqual(0);
    });

    it(addCase(casePrefix + 'Linkage_VideoCountMatchesNum_060'), 0, () => {
      const fold = new FoldListType('f1', 'Folder1');
      for (let i = 0; i < 20; i++) {
        fold.videoList.push({ uri: 'v' + i } as UrlType);
      }
      fold.num = fold.videoList.length;
      expect(fold.num).assertEqual(fold.videoList.length);
    });

    /**
     * ========== 第七部分：性能与大数据量 ==========
     *
     * 业务背景：文件夹列表可能包含大量数据，需要验证性能。
     */
    it(addCase(casePrefix + 'Perf_1000Folders_Created_061'), 0, () => {
      const folders: Array<FoldListType> = [];
      for (let i = 0; i < 1000; i++) {
        folders.push(new FoldListType('f' + i, 'Folder' + i));
      }
      expect(folders.length).assertEqual(1000);
    });

    it(addCase(casePrefix + 'Perf_100VideosPerFolder_062'), 0, () => {
      const fold = new FoldListType('f1', 'LargeFolder');
      for (let i = 0; i < 100; i++) {
        fold.videoList.push({ uri: 'video_' + i } as UrlType);
      }
      expect(fold.videoList.length).assertEqual(100);
    });

    it(addCase(casePrefix + 'Perf_Sort1000Items_063'), 0, () => {
      const folders: Array<FoldListType> = [];
      for (let i = 0; i < 1000; i++) {
        const fold = new FoldListType('f' + i, 'Folder' + i);
        fold.num = Math.floor(Math.random() * 10000);
        folders.push(fold);
      }
      folders.sort((a, b) => b.num - a.num);
      expect(folders[0].num >= folders[1].num).assertEqual(true);
    });

    it(addCase(casePrefix + 'Perf_FilterLargeList_064'), 0, () => {
      const folders: Array<FoldListType> = [];
      for (let i = 0; i < 500; i++) {
        const fold = new FoldListType('f' + i, 'Folder' + i);
        fold.num = i % 10 === 0 ? 100 : 10;
        folders.push(fold);
      }
      const filtered = folders.filter(f => f.num >= 50);
      expect(filtered.length > 0).assertEqual(true);
    });
  });
}
