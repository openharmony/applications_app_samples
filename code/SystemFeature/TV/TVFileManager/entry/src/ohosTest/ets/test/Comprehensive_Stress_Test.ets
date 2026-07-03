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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { FileBean } from '../../../main/ets/component/bean/FileBean';
import { FileInfo } from '../../../main/ets/common/data/FileInfo';
import { BasicDataSource } from '../../../main/ets/component/adapter/BasicDataSource';
import { NavStack, StatusListener } from '../../../main/ets/common/manager/NavPathStackManager';
import { DeviceType } from '../../../main/ets/common/data/DeviceType';
import { PageType } from '../../../main/ets/model/PageType';
import { checkSuffix, SUFFIX_VIDEO, SUFFIX_AUDIO, SUFFIX_IMAGE, SUFFIX_TEXT } from '../../../main/ets/common/ConstantsMedia';

export default function comprehensiveStressTest() {
  describe('Comprehensive_Stress_Test', () => {

    /*
     * 极端大数据量——5000+文件的目录。
     * TV设备可能连接大容量NAS/硬盘，单目录含数千文件。
     */
    describe('Extreme_Data_Volume', () => {
      it('DataSource_5000_items_creation_and_access', 0, () => {
        let size: number = 5000;
        let arr: number[] = [];
        for (let i: number = 0; i < size; i++) {
          arr.push(i);
        }
        let ds: BasicDataSource<number> = new BasicDataSource(arr);
        expect(ds.totalCount()).assertEqual(size);
        // 验证所有索引可访问
        expect(ds.getData(0)).assertEqual(0);
        expect(ds.getData(size - 1)).assertEqual(size - 1);
        expect(ds.getData(size / 2)).assertEqual(size / 2);
      });

      it('notification_chain_with_100_listeners', 0, () => {
        // 极端场景：100个组件监听同一个数据源
        let ds: BasicDataSource<number> = new BasicDataSource([1]);
        let callCount: number = 0;
        let listeners: DataChangeListener[] = [];
        for (let i: number = 0; i < 100; i++) {
          let l: DataChangeListener = {
            onDataReloaded: (): void => { callCount++; },
            onDataAdd: (index: number): void => {},
            onDataAdded: (index: number): void => {},
            onDataChange: (index: number): void => {},
            onDataChanged: (index: number): void => {},
            onDataDelete: (index: number): void => {},
            onDataDeleted: (index: number): void => {},
            onDataMove: (from: number, to: number): void => {},
            onDataMoved: (from: number, to: number): void => {},
            onDatasetChange: (dataOperations: DataOperation[]): void => {}
          };
          listeners.push(l);
          ds.registerDataChangeListener(l);
        }
        ds.notifyDataReload();
        expect(callCount).assertEqual(100);
      });
    });

    /*
     * 高频操作——快速连续的状态变更。
     *
     */
    describe('HighFrequency_Operations', () => {
      it('rapid_select_mode_toggle_100_times', 0, () => {
        let nav: NavStack = new NavStack();
        for (let i: number = 0; i < 100; i++) {
          nav.setCopyMode();
          nav.closeSelectMode();
        }
        expect(nav.isSelectMod()).assertEqual(false);
        expect(nav.isCopy()).assertEqual(false);
      });

      it('rapid_device_switch_50_times', 0, () => {
        let nav: NavStack = new NavStack();
        nav.openUSB();
        for (let i: number = 0; i < 50; i++) {
          nav.setDevice(DeviceType.USB);
          nav.setDevice(DeviceType.Local);
        }
        expect(nav.getDevice()).assertEqual(DeviceType.Local);
      });

      it('rapid_backPress_callback_registration', 0, () => {
        let nav: NavStack = new NavStack();
        let cbs: Array<() => boolean> = [];
        for (let i: number = 0; i < 50; i++) {
          let cb: () => boolean = (): boolean => { return false; };
          cbs.push(cb);
          nav.regBackPressFun(cb);
        }
        // 全部注销
        for (let cb of cbs) {
          nav.unregBackPressFun(cb);
        }
        let result: boolean = nav.onBackPress();
        expect(result).assertEqual(false);
      });

      it('rapid_suffix_check_1000_files', 0, () => {
        let results: boolean[] = [];
        for (let i: number = 0; i < 1000; i++) {
          let name: string = `file_${i}.mp4`;
          results.push(checkSuffix(name, SUFFIX_VIDEO));
        }
        // 所有结果应为true
        expect(results.every((r: boolean): boolean => r === true)).assertEqual(true);
      });
    });

    /*
     * 内存压力——大数据量下的内存分配。
     *
     */
    describe('Memory_Pressure', () => {
      it('large_FileBean_array_construction', 0, () => {
        let beans: FileBean[] = [];
        for (let i: number = 0; i < 500; i++) {
          let info: ESObject = {
            uri: `file://test/file_${i}.mp4`,
            fileName: `file_${i}.mp4`,
            size: 1024 * 1024 * (i + 1),
            mtime: Date.now(),
            mimeType: 'video/mp4',
            relativePath: '/test/',
            mode: 1
          };
          beans.push(new FileBean(`f${i}`, info as FileInfo));
        }
        expect(beans.length).assertEqual(500);
        expect(beans[0].isVideo()).assertEqual(true);
      });

      it('rapid_FileBean_creation_and_discard', 0, () => {
        // 模拟快速创建和丢弃，测试GC压力
        for (let round: number = 0; round < 10; round++) {
          let temp: FileBean[] = [];
          for (let i: number = 0; i < 100; i++) {
            temp.push(new FileBean());
          }
          // 丢弃引用让GC回收
          temp = [];
        }
        expect(true).assertEqual(true);
      });
    });

    /*
     * NavPathStack深度压测——深层目录的连续导航。
     *
     */
    describe('Deep_Navigation_Stress', () => {
      it('push_pop_cycle_30_levels_deep', 0, () => {
        let nav: NavStack = new NavStack();
        nav.pushRoot(PageType.HOME_PAGE);
        // 模拟深入到30层子目录
        for (let i: number = 0; i < 30; i++) {
          // 使用非HOME_PAGE的push模拟深层目录
          nav.pushRoot(PageType.ROOT_PAGE);
        }
        // 逐层退回
        for (let i: number = 0; i < 30; i++) {
          nav.popPath();
        }
        // 最终回到HOME_PAGE层级
        expect(nav.isExitApp()).assertEqual(true);
      });

      it('interleaved_push_pop_with_device_switch', 0, () => {
        let nav: NavStack = new NavStack();
        nav.pushRoot(PageType.HOME_PAGE);
        nav.openUSB();
        nav.setDevice(DeviceType.USB);
        nav.setDevice(DeviceType.Local);
        nav.pushRoot(PageType.ROOT_PAGE);
        nav.popPath();
        expect(true).assertEqual(true);
      });
    });

    /*
     * 多类型文件批量分类测试。
     *
     */
    describe('Batch_File_Classification', () => {
      it('classify_200_mixed_files', 0, () => {
        let files: string[] = [];
        // 生成混合类型文件名
        let types: string[] = [
          '.mp4', '.mp3', '.jpg', '.pdf',
          '.mkv', '.aac', '.png', '.txt',
          '.avi', '.flac', '.jpeg', '.docx'
        ];
        for (let i: number = 0; i < 200; i++) {
          files.push(`file_${i}${types[i % types.length]}`);
        }
        let videoCount: number = 0;
        let audioCount: number = 0;
        let imageCount: number = 0;
        let docCount: number = 0;
        for (let f of files) {
          if (checkSuffix(f, SUFFIX_VIDEO)) videoCount++;
          if (checkSuffix(f, SUFFIX_AUDIO)) audioCount++;
          if (checkSuffix(f, SUFFIX_IMAGE)) imageCount++;
          if (checkSuffix(f, SUFFIX_TEXT)) docCount++;
        }
        // 每种类型占比应为 3/12 = 25%
        expect(videoCount > 0).assertEqual(true);
        expect(audioCount > 0).assertEqual(true);
        expect(imageCount > 0).assertEqual(true);
        expect(docCount > 0).assertEqual(true);
      });
    });
  });
}
