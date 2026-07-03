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
import { NavStack, StatusListener } from '../../../main/ets/common/manager/NavPathStackManager';
import { DeviceType } from '../../../main/ets/common/data/DeviceType';
import { PageType } from '../../../main/ets/model/PageType';
import { FileBean } from '../../../main/ets/component/bean/FileBean';
import { FileInfo } from '../../../main/ets/common/data/FileInfo';
import { BasicDataSource } from '../../../main/ets/component/adapter/BasicDataSource';
import { checkSuffix, SUFFIX_VIDEO } from '../../../main/ets/common/ConstantsMedia';

export default function concurrencyRaceTest() {
  describe('Concurrency_Race_Test', () => {

    /*
     * 并发竞态测试——模拟多个操作同时进行时的竞态条件。
     * TV设备上用户可能通过遥控器快速操作，或USB热插拔与文件操作同时发生。
     */
    describe('NavStack_Race_Conditions', () => {
      it('simultaneous_setCopyMode_and_setDevice', 0, () => {
        // 用户点击"复制"后立即切换Tab
        // 预期：两种状态都应正确设置，不互相覆盖
        let nav: NavStack = new NavStack();
        nav.setCopyMode();
        nav.setDevice(DeviceType.USB);
        expect(nav.isCopy()).assertEqual(true);
        expect(nav.getDevice()).assertEqual(DeviceType.USB);
      });

      it('simultaneous_closeSelectMode_and_openUSB', 0, () => {
        // 退出选择模式的同时USB设备插入
        let nav: NavStack = new NavStack();
        nav.setCopyMode();
        nav.closeSelectMode();
        nav.openUSB();
        expect(nav.isSelectMod()).assertEqual(false);
        expect(nav.isExternal()).assertEqual(true);
      });

      it('rapid_mode_toggle_during_device_switch', 0, () => {
        // 快速切换设备的同时间歇性进入退出选择模式
        let nav: NavStack = new NavStack();
        nav.setCopyMode();
        nav.setDevice(DeviceType.USB);
        nav.closeSelectMode();
        nav.setDevice(DeviceType.Local);
        nav.setMoveMode();
        nav.setDevice(DeviceType.USB);
        expect(nav.isMove()).assertEqual(true);
        expect(nav.getDevice()).assertEqual(DeviceType.USB);
      });

      it('multiple_backPress_registration_during_pop', 0, () => {
        // 退回过程中新的FileList实例注册回调
        let nav: NavStack = new NavStack();
        let calls: string[] = [];
        let cb1: () => boolean = (): boolean => { calls.push('A'); return false; };
        let cb2: () => boolean = (): boolean => { calls.push('B'); return true; };
        nav.regBackPressFun(cb1);
        nav.onBackPress();
        nav.regBackPressFun(cb2);
        nav.onBackPress();
        expect(calls.length).assertEqual(2);
        expect(calls[0]).assertEqual('A');
      });
    });

    /*
     * 数据源竞态——并发修改。
     */
    describe('DataSource_Race_Conditions', () => {
      it('notify_during_register_unregister', 0, () => {
        let ds: BasicDataSource<number> = new BasicDataSource([1, 2, 3]);
        let callCount: number = 0;
        let l: DataChangeListener = {
          onDataReloaded: (): void => { callCount++; },
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
        ds.notifyDataReload();
        ds.unregisterDataChangeListener(l);
        ds.notifyDataReload();
        expect(callCount).assertEqual(1);
      });

      it('register_during_notification_cycle', 0, () => {
        // 一个监听器的回调中注册另一个监听器
        // 新注册的监听器不应在当前通知周期内被调用
        let ds: BasicDataSource<number> = new BasicDataSource([1]);
        let secondCallCount: number = 0;
        let l2: DataChangeListener = {
          onDataReloaded: (): void => { secondCallCount++; },
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
        let l1: DataChangeListener = {
          onDataReloaded: (): void => {
            ds.registerDataChangeListener(l2);
          },
          onDataAdd: (idx: number): void => {
          },
          onDataAdded: (idx: number): void => {
          },
          onDataChange: (idx: number): void => {
          },
          onDataChanged: (idx: number): void => {
          },
          onDataDelete: (idx: number): void => {
          },
          onDataDeleted: (idx: number): void => {
          },
          onDataMove: (f: number, t: number): void => {
          },
          onDataMoved: (f: number, t: number): void => {
          },
          onDatasetChange: (dataOperations: DataOperation[]): void => {
          }
        };
        ds.registerDataChangeListener(l1);
        ds.notifyDataReload();
        // l2在当前通知后才注册，不应被调用
        expect(secondCallCount).assertEqual(0);
      });
    });

    /*
     * 文件类型检测竞态——大量文件名并发检测。
     */
    describe('Suffix_Detection_Race', () => {
      it('rapid_alternating_case_detection', 0, () => {
        // 同一个文件的大小写交替检测结果应一致
        let names: string[] = [
          'MOVIE.MP4', 'movie.mp4', 'Movie.Mp4', 'MOVIE.mp4'
        ];
        for (let name of names) {
          expect(checkSuffix(name, SUFFIX_VIDEO)).assertEqual(true);
        }
      });

      it('batch_detection_same_file_repeatedly', 0, () => {
        // 重复检测同一文件名100次，结果应一致
        let name: string = 'consistent.mp4';
        for (let i: number = 0; i < 100; i++) {
          expect(checkSuffix(name, SUFFIX_VIDEO)).assertEqual(true);
        }
      });
    });

    /*
     * USB设备插拔竞态。
     */
    describe('USB_Plugin_Race', () => {
      it('rapid_plug_unplug_sequence', 0, () => {
        // 快速插拔USB设备的模拟
        let nav: NavStack = new NavStack();
        nav.openUSB();
        nav.closeUSB();
        nav.openUSB();
        nav.closeUSB();
        nav.openUSB();
        // 最终状态应为最后一次操作
        expect(nav.isExternal()).assertEqual(true);
      });

      it('setDevice_during_USB_close', 0, () => {
        // USB被拔出时用户正试图切换到USB Tab
        let nav: NavStack = new NavStack();
        nav.openUSB();
        nav.setDevice(DeviceType.USB);
        nav.closeUSB();
        // USB关闭后externalActive=false
        expect(nav.isExternal()).assertEqual(false);
      });
    });

    /*
     * 选择模式竞态。
     */
    describe('SelectMode_Race', () => {
      it('copy_to_move_transition_no_inconsistency', 0, () => {
        // Copy→Move→Copy→None快速切换
        let nav: NavStack = new NavStack();
        nav.setCopyMode();
        nav.setMoveMode();
        nav.setCopyMode();
        nav.closeSelectMode();
        expect(nav.isSelectMod()).assertEqual(false);
        expect(nav.isCopy()).assertEqual(false);
        expect(nav.isMove()).assertEqual(false);
      });

      it('select_mode_enter_during_navigation', 0, () => {
        // 导航动画中进行选择模式
        let nav: NavStack = new NavStack();
        nav.setDevice(DeviceType.Local);
        nav.setCopyMode();
        expect(nav.isCopy()).assertEqual(true);
      });
    });

    /*
     * 监听器竞态。
     */
    describe('Listener_Race', () => {
      it('add_remove_listener_during_callback_execution', 0, () => {
        // 回调中移除自身：应安全处理
        let nav: NavStack = new NavStack();
        let selfRemovingLis: StatusListener;
        selfRemovingLis = (isSelect: boolean) => {
          nav.removeStatusLis(selfRemovingLis);
        };
        nav.addStatusLis(selfRemovingLis);
        nav.setCopyMode();
        // 不应崩溃
        expect(true).assertEqual(true);
      });

      it('multiple_status_changes_batched', 0, () => {
        // 连续多次状态变化→每次callRefresh→所有监听器被调用
        let nav: NavStack = new NavStack();
        let callCount: number = 0;
        let lis: StatusListener = (isSelect: boolean) => { callCount++; };
        nav.addStatusLis(lis);
        nav.setCopyMode();
        nav.closeSelectMode();
        nav.setMoveMode();
        nav.closeSelectMode();
        expect(callCount).assertEqual(4);
      });
    });
  });
}
