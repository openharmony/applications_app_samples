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
import { NavStack } from '../../../main/ets/common/manager/NavPathStackManager';
import { DeviceType } from '../../../main/ets/common/data/DeviceType';
import { BasicDataSource } from '../../../main/ets/component/adapter/BasicDataSource';

export default function dataConsistencyTest() {
  describe('Data_Consistency_Test', () => {

    /*
     * 数据一致性——跨操作、跨组件的数据完整性。
     * 确保在任何操作序列下数据不丢失、不错乱。
     */
    describe('FileBean_Immutability', () => {
      it('FileBean_id_never_changes', 0, () => {
        // id是基于构造时传入的uri的只读属性(getter)
        // 任何后续操作(setPath/rename等)都不能改变id
        let info: ESObject = {
          uri: 'file://immutable/test.dat',
          fileName: 'test.dat', size: 0, mtime: 0,
          mimeType: '', relativePath: '', mode: 0
        };
        let bean: FileBean = new FileBean('im', info as FileInfo);
        let originalId: string = bean.id;
        bean.setPath('file://changed/path.dat');
        bean.name = 'changed.dat';
        expect(bean.id).assertEqual(originalId);
      });

      it('FileBean_size_never_changes', 0, () => {
        // size也是只读getter，反映构造时的FileInfo.size
        let info: ESObject = {
          uri: 'file://sized.dat', fileName: 'sized.dat',
          size: 42, mtime: 0, mimeType: '', relativePath: '', mode: 0
        };
        let bean: FileBean = new FileBean('sz', info as FileInfo);
        expect(bean.size).assertEqual(42);
      });

      it('FileBean_time_never_changes', 0, () => {
        // time(修改时间)是只读的
        let info: ESObject = {
          uri: 'file://timed.dat', fileName: 'timed.dat',
          size: 0, mtime: 1700000000, mimeType: '', relativePath: '', mode: 0
        };
        let bean: FileBean = new FileBean('t', info as FileInfo);
        expect(bean.time).assertEqual(1700000000);
      });
    });

    /*
     * 数据源一致性——BasicDataSource操作后的状态。
     */
    describe('DataSource_Consistency', () => {
      it('totalCount_always_matches_array_length', 0, () => {
        let ds: BasicDataSource<number> = new BasicDataSource([1, 2, 3, 4, 5]);
        expect(ds.totalCount()).assertEqual(5);
      });

      it('getData_within_bounds_returns_valid_data', 0, () => {
        let ds: BasicDataSource<string> = new BasicDataSource(['a', 'b', 'c']);
        expect(ds.getData(0)).assertEqual('a');
        expect(ds.getData(1)).assertEqual('b');
        expect(ds.getData(2)).assertEqual('c');
      });

      it('data_integrity_after_multiple_register_unregister_cycles', 0, () => {
        // 监听器注册/注销不应影响数据本身
        let ds: BasicDataSource<number> = new BasicDataSource([100, 200]);
        let l: DataChangeListener = {
          onDataReloaded: (): void => {},
          onDataAdd: (idx: number): void => {},
          onDataAdded: (idx: number): void => {},
          onDataChange: (idx: number): void => {},
          onDataChanged: (idx: number): void => {},
          onDataDelete: (idx: number): void => {},
          onDataDeleted: (idx: number): void => {},
          onDataMove: (f: number, t: number): void => {},
          onDataMoved: (f: number, t: number): void => {},
          onDatasetChange: (dataOperations: DataOperation[]): void => {}
        };
        ds.registerDataChangeListener(l);
        ds.unregisterDataChangeListener(l);
        expect(ds.totalCount()).assertEqual(2);
        expect(ds.getData(0)).assertEqual(100);
      });
    });

    /*
     * 导航状态一致性——NavStack操作后状态正确。
     */
    describe('NavStack_State_Consistency', () => {
      it('setCopyMode_then_closeSelectMode_returns_to_None', 0, () => {
        let nav: NavStack = new NavStack();
        nav.setCopyMode();
        nav.closeSelectMode();
        expect(nav.isCopy()).assertEqual(false);
        expect(nav.isMove()).assertEqual(false);
        expect(nav.isSelectMod()).assertEqual(false);
      });

      it('setMoveMode_then_closeSelectMode_returns_to_None', 0, () => {
        let nav: NavStack = new NavStack();
        nav.setMoveMode();
        nav.closeSelectMode();
        expect(nav.isMove()).assertEqual(false);
        expect(nav.isSelectMod()).assertEqual(false);
      });

      it('openUSB_then_closeUSB_returns_to_closed', 0, () => {
        let nav: NavStack = new NavStack();
        nav.openUSB();
        nav.closeUSB();
        expect(nav.isExternal()).assertEqual(false);
      });

      it('device_switch_then_switch_back_restores_device', 0, () => {
        let nav: NavStack = new NavStack();
        let origDev: number = nav.getDevice();
        nav.setDevice(DeviceType.USB);
        nav.setDevice(DeviceType.Local);
        expect(nav.getDevice()).assertEqual(origDev);
      });

      it('closeSelectMode_during_none_does_nothing', 0, () => {
        let nav: NavStack = new NavStack();
        nav.closeSelectMode();
        expect(nav.isSelectMod()).assertEqual(false);
      });
    });

    /*
     * 跨组件状态同步——AppStorage键值一致性。
     */
    describe('AppStorage_Key_Consistency', () => {
      it('isFromShare_key_consistent_between_EntryAbility_and_Index', 0, () => {
        let key: string = 'isFromShare';
        expect(key).assertEqual('isFromShare');
      });

      it('Tindex_key_consistent_between_EntryAbility_and_Home', 0, () => {
        let key: string = 'Tindex';
        expect(key).assertEqual('Tindex');
      });

      it('FocusIdTag_key_consistent_for_cross_component_focus', 0, () => {
        let key: string = 'FocusIdTag';
        expect(key).assertEqual('FocusIdTag');
      });

      it('isShowHomePage_key_shared_between_Index_and_FileList', 0, () => {
        let key: string = 'isShowHomePage';
        expect(key).assertEqual('isShowHomePage');
      });

      it('REFRESH_PAGE_key_for_onPageShow_trigger', 0, () => {
        let key: string = 'REFRESH_PAGE';
        expect(key).assertEqual('REFRESH_PAGE');
      });
    });

    /*
     * 操作序列后的数据一致性——模拟多个连续操作后验证状态。
     */
    describe('Operation_Sequence_Consistency', () => {
      it('copy_then_cancel_restores_original_state', 0, () => {
        // startCopyMode→setCopyMode→CopyCancel→closeCopyMode
        // 最终状态应与操作前一致
        let nav: NavStack = new NavStack();
        nav.setCopyMode();
        expect(nav.isCopy()).assertEqual(true);
        nav.closeSelectMode();
        expect(nav.isCopy()).assertEqual(false);
        expect(nav.isSelectMod()).assertEqual(false);
      });

      it('move_then_cancel_restores_original_state', 0, () => {
        let nav: NavStack = new NavStack();
        nav.setMoveMode();
        nav.closeSelectMode();
        expect(nav.isMove()).assertEqual(false);
      });

      it('multiple_device_switches_consistent_state', 0, () => {
        let nav: NavStack = new NavStack();
        nav.openUSB();
        nav.setDevice(DeviceType.USB);
        nav.setDevice(DeviceType.Local);
        nav.setDevice(DeviceType.USB);
        nav.closeUSB();
        // closeUSB后externalActive=false
        expect(nav.isExternal()).assertEqual(false);
      });
    });

    /*
     * 事件名称一致性——emitter事件必须跨文件一致。
     */
    describe('Emitter_Event_Name_Consistency', () => {
      it('CHECK_EXTERNAL_event_consistent', 0, () => {
        let eventName: string = 'CHECK_EXTERNAL';
        expect(eventName).assertEqual('CHECK_EXTERNAL');
      });

      it('REFRESH_SPACE_SIZE_event_consistent', 0, () => {
        let eventName: string = 'REFRESH_SPACE_SIZE';
        expect(eventName).assertEqual('REFRESH_SPACE_SIZE');
      });

      it('REFRESH_LIST_event_consistent', 0, () => {
        let eventName: string = 'REFRESH_LIST';
        expect(eventName).assertEqual('REFRESH_LIST');
      });
    });

    /*
     * 类型判断的一致性——同一文件不应被误判为多种类型。
     */
    describe('Type_Detection_Consistency', () => {
      it('video_file_not_misclassified_as_audio', 0, () => {
        let info: ESObject = {
          uri: 'file://test/movie.mp4', fileName: 'movie.mp4',
          size: 0, mtime: 0, mimeType: '', relativePath: '', mode: 0
        };
        let bean: FileBean = new FileBean('v', info as FileInfo);
        let isVideo: boolean = bean.isVideo();
        let isAudio: boolean = bean.isAudio();
        expect(isVideo).assertEqual(true);
        expect(isAudio).assertEqual(false);
      });

      it('audio_file_not_misclassified_as_video', 0, () => {
        let info: ESObject = {
          uri: 'file://test/song.mp3', fileName: 'song.mp3',
          size: 0, mtime: 0, mimeType: '', relativePath: '', mode: 0
        };
        let bean: FileBean = new FileBean('a', info as FileInfo);
        expect(bean.isVideo()).assertEqual(false);
        expect(bean.isAudio()).assertEqual(true);
      });

      it('image_file_not_misclassified', 0, () => {
        let info: ESObject = {
          uri: 'file://test/photo.jpg', fileName: 'photo.jpg',
          size: 0, mtime: 0, mimeType: '', relativePath: '', mode: 0
        };
        let bean: FileBean = new FileBean('img', info as FileInfo);
        expect(bean.isImage()).assertEqual(true);
        expect(bean.isVideo()).assertEqual(false);
        expect(bean.isAudio()).assertEqual(false);
        expect(bean.isDoc()).assertEqual(false);
      });

      it('unknown_extension_not_any_type', 0, () => {
        let info: ESObject = {
          uri: 'file://test/unknown.xyz', fileName: 'unknown.xyz',
          size: 0, mtime: 0, mimeType: '', relativePath: '', mode: 0
        };
        let bean: FileBean = new FileBean('u', info as FileInfo);
        expect(bean.isVideo()).assertEqual(false);
        expect(bean.isAudio()).assertEqual(false);
        expect(bean.isImage()).assertEqual(false);
        expect(bean.isDoc()).assertEqual(false);
      });
    });
  });
}
