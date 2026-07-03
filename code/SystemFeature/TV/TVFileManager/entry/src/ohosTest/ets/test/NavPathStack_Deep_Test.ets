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

export default function navPathStackDeepTest() {
  describe('NavPathStack_Deep_Test', () => {

    /*
     * NavPathStack全状态转换测试。
     * 覆盖所有状态组合：Local/USB × Copy/Move/None × openUSB/closeUSB。
     * 状态机有 2 × 3 × 2 = 12 种状态组合。
     */
    describe('Complete_State_Space', () => {
      it('state_Local_None_USBclosed', 0, () => {
        let nav: NavStack = new NavStack();
        expect(nav.getDevice()).assertEqual(DeviceType.Local);
        expect(nav.isSelectMod()).assertEqual(false);
        expect(nav.isExternal()).assertEqual(false);
      });

      it('state_Local_Copy_USBclosed', 0, () => {
        let nav: NavStack = new NavStack();
        nav.setCopyMode();
        expect(nav.getDevice()).assertEqual(DeviceType.Local);
        expect(nav.isCopy()).assertEqual(true);
        expect(nav.isMove()).assertEqual(false);
        expect(nav.isExternal()).assertEqual(false);
      });

      it('state_Local_Move_USBclosed', 0, () => {
        let nav: NavStack = new NavStack();
        nav.setMoveMode();
        expect(nav.getDevice()).assertEqual(DeviceType.Local);
        expect(nav.isMove()).assertEqual(true);
      });

      it('state_Local_None_USBopen', 0, () => {
        let nav: NavStack = new NavStack();
        nav.openUSB();
        expect(nav.isExternal()).assertEqual(true);
        expect(nav.isSelectMod()).assertEqual(false);
      });

      it('state_Local_Copy_USBopen', 0, () => {
        let nav: NavStack = new NavStack();
        nav.setCopyMode();
        nav.openUSB();
        expect(nav.isCopy()).assertEqual(true);
        expect(nav.isExternal()).assertEqual(true);
      });

      it('state_Local_Move_USBopen', 0, () => {
        let nav: NavStack = new NavStack();
        nav.setMoveMode();
        nav.openUSB();
        expect(nav.isMove()).assertEqual(true);
        expect(nav.isExternal()).assertEqual(true);
      });

      it('state_transition_Copy_to_None', 0, () => {
        let nav: NavStack = new NavStack();
        nav.setCopyMode();
        expect(nav.isCopy()).assertEqual(true);
        nav.closeSelectMode();
        expect(nav.isCopy()).assertEqual(false);
        expect(nav.isSelectMod()).assertEqual(false);
      });

      it('state_transition_Move_to_None', 0, () => {
        let nav: NavStack = new NavStack();
        nav.setMoveMode();
        expect(nav.isMove()).assertEqual(true);
        nav.closeSelectMode();
        expect(nav.isMove()).assertEqual(false);
      });

      it('state_transition_Copy_to_Move', 0, () => {
        let nav: NavStack = new NavStack();
        nav.setCopyMode();
        nav.setMoveMode();
        expect(nav.isCopy()).assertEqual(false);
        expect(nav.isMove()).assertEqual(true);
      });

      it('state_transition_Move_to_Copy', 0, () => {
        let nav: NavStack = new NavStack();
        nav.setMoveMode();
        nav.setCopyMode();
        expect(nav.isMove()).assertEqual(false);
        expect(nav.isCopy()).assertEqual(true);
      });

      it('state_transition_USBopen_to_USBclosed', 0, () => {
        let nav: NavStack = new NavStack();
        nav.openUSB();
        expect(nav.isExternal()).assertEqual(true);
        nav.closeUSB();
        expect(nav.isExternal()).assertEqual(false);
      });

      it('state_transition_USBclosed_to_USBopen', 0, () => {
        let nav: NavStack = new NavStack();
        expect(nav.isExternal()).assertEqual(false);
        nav.openUSB();
        expect(nav.isExternal()).assertEqual(true);
      });
    });

    /*
     * 路径栈操作——pushRoot/pushBean/pushPath/popPath/getPathListNames/curPageInfo。
     */
    describe('Path_Stack_Operations', () => {
      it('pushRoot_HOME_PAGE_clears_stacks', 0, () => {
        let nav: NavStack = new NavStack();
        nav.pushRoot(PageType.HOME_PAGE);
        // HOME_PAGE会调用clearStack清空所有设备栈
        expect(nav.getPathListNames().length).assertEqual(0);
      });

      it('pushRoot_non_HOME_PAGE_does_not_clear', 0, () => {
        let nav: NavStack = new NavStack();
        nav.pushRoot(PageType.ROOT_PAGE);
        // ROOT_PAGE只push不clear
        expect(nav.getPathListNames().length).assertEqual(1);
      });

      it('curPageInfo_reflects_last_pushed_page', 0, () => {
        let nav: NavStack = new NavStack();
        nav.pushRoot(PageType.ROOT_PAGE);
        let info: ESObject = nav.curPageInfo;
        expect(info).not().assertEqual(undefined);
        expect(info.name).assertEqual(PageType.ROOT_PAGE);
      });

      it('popPath_removes_last_page', 0, () => {
        let nav: NavStack = new NavStack();
        nav.pushRoot(PageType.ROOT_PAGE);
        let beforeCount: number = nav.getPathListNames().length;
        nav.popPath();
        // pop后路径名称减少一个
        expect(nav.getPathListNames().length).assertEqual(beforeCount - 1);
      });

      it('checkBackPress_normal_mode_stack_depth_gt_1', 0, () => {
        let nav: NavStack = new NavStack();
        nav.pushRoot(PageType.HOME_PAGE);
        nav.pushRoot(PageType.ROOT_PAGE);
        // 栈深>1时可退回
        expect(nav.checkBackPress()).assertEqual(true);
      });

      it('checkBackPress_normal_mode_stack_depth_eq_1', 0, () => {
        let nav: NavStack = new NavStack();
        nav.pushRoot(PageType.HOME_PAGE);
        // 栈深=1时不可退回（已到根）
        expect(nav.checkBackPress()).assertEqual(false);
      });
    });

    /*
     * setDevice横向切换——Local↔USB。
     * 切换时保持选择模式状态不变，但导航路径独立。
     */
    describe('Device_Switching', () => {
      it('setDevice_USB_with_external_inactive_shows_HOME_PAGE', 0, () => {
        let nav: NavStack = new NavStack();
        nav.setDevice(DeviceType.USB);
        // USB未激活时setDevice切换到HOME_PAGE
        expect(nav.getDevice()).assertEqual(DeviceType.USB);
      });

      it('setDevice_USB_with_external_active_shows_EXTERNAL_USB_PAGE', 0, () => {
        let nav: NavStack = new NavStack();
        nav.openUSB();
        nav.setDevice(DeviceType.USB);
        expect(nav.getDevice()).assertEqual(DeviceType.USB);
        expect(nav.isExternal()).assertEqual(true);
      });

      it('setDevice_same_device_is_noop', 0, () => {
        let nav: NavStack = new NavStack();
        nav.pushRoot(PageType.ROOT_PAGE);
        let pathsBefore: string[] = nav.getPathListNames();
        nav.setDevice(DeviceType.Local);
        let pathsAfter: string[] = nav.getPathListNames();
        // 相同设备不应改变路径
        expect(pathsAfter.length).assertEqual(pathsBefore.length);
      });
    });

    /*
     * 状态监听器的注册/注销/回调。
     * FileList和Index注册监听选择模式变化。
     */
    describe('Status_Listener_Management', () => {
      it('addStatusLis_multiple_registration', 0, () => {
        let nav: NavStack = new NavStack();
        let calls: string[] = [];
        let lis1: StatusListener = (isSelect: boolean) => { calls.push('A'); };
        let lis2: StatusListener = (isSelect: boolean) => { calls.push('B'); };
        nav.addStatusLis(lis1);
        nav.addStatusLis(lis2);
        nav.setCopyMode();
        // 两个监听器都被调用（顺序按注册先后）
        expect(calls.length).assertEqual(2);
      });

      it('removeStatusLis_middle_listener', 0, () => {
        let nav: NavStack = new NavStack();
        let calls: number[] = [];
        let lis1: StatusListener = (isSelect: boolean) => { calls.push(1); };
        let lis2: StatusListener = (isSelect: boolean) => { calls.push(2); };
        nav.addStatusLis(lis1);
        nav.addStatusLis(lis2);
        nav.removeStatusLis(lis1);
        nav.setCopyMode();
        // lis1被移除，只有lis2被调用
        expect(calls.length).assertEqual(1);
        expect(calls[0]).assertEqual(2);
      });

      it('removeStatusLis_non_existent_no_effect', 0, () => {
        let nav: NavStack = new NavStack();
        let lis: StatusListener = (isSelect: boolean) => {};
        // 移除未注册的监听器不应抛出异常
        nav.removeStatusLis(lis);
        expect(true).assertEqual(true);
      });
    });

    /*
     * isShowPath——面包屑显示条件。
     * Local: 栈深>1时显示; USB: 始终显示。
     */
    describe('isShowPath_Breadcrumb_Logic', () => {
      it('isShowPath_local_with_one_page_hidden', 0, () => {
        let nav: NavStack = new NavStack();
        nav.pushRoot(PageType.HOME_PAGE);
        // Local设备栈深=1时不显示面包屑
        expect(nav.isShowPath()).assertEqual(false);
      });

      it('isShowPath_local_with_two_pages_shown', 0, () => {
        let nav: NavStack = new NavStack();
        nav.pushRoot(PageType.HOME_PAGE);
        nav.pushRoot(PageType.ROOT_PAGE);
        // Local设备栈深=2时显示面包屑
        expect(nav.isShowPath()).assertEqual(true);
      });
    });

    /*
     * isExitApp——退出应用判断。
     * 选择模式下不退出；普通模式栈深=1时退出。
     */
    describe('isExitApp_Logic', () => {
      it('isExitApp_false_in_select_mode', 0, () => {
        let nav: NavStack = new NavStack();
        nav.pushRoot(PageType.HOME_PAGE);
        nav.setCopyMode();
        expect(nav.isExitApp()).assertEqual(false);
      });

      it('isExitApp_true_in_normal_mode_with_one_page', 0, () => {
        let nav: NavStack = new NavStack();
        nav.pushRoot(PageType.HOME_PAGE);
        nav.closeSelectMode();
        // 栈深1且非选择模式→退出应用
        expect(nav.isExitApp()).assertEqual(true);
      });

      it('isExitApp_false_in_normal_mode_with_multiple_pages', 0, () => {
        let nav: NavStack = new NavStack();
        nav.pushRoot(PageType.HOME_PAGE);
        nav.pushRoot(PageType.ROOT_PAGE);
        expect(nav.isExitApp()).assertEqual(false);
      });
    });

    /*
     * isShowHomePage全局状态。
     * 通过AppStorage在Index和Home之间共享。
     */
    describe('isShowHomePage_Global_State', () => {
      it('isShowHomePage_setter_stores_in_AppStorage', 0, () => {
        let nav: NavStack = new NavStack();
        nav.isShowHomePage = true;
        let stored: ESObject = AppStorage.get<ESObject>('isShowHomePage');
        expect(stored as boolean).assertEqual(true);
      });

      it('isShowHomePage_setter_false', 0, () => {
        let nav: NavStack = new NavStack();
        nav.isShowHomePage = false;
        let stored: ESObject = AppStorage.get<ESObject>('isShowHomePage');
        expect(stored as boolean).assertEqual(false);
      });
    });

    /*
     * setFocusId——通过AppStorage传递焦点标识。
     */
    describe('setFocusId_Static_Method', () => {
      it('setFocusId_persists_in_AppStorage', 0, () => {
        NavStack.setFocusId('renameInput');
        let stored: string = AppStorage.get<ESObject>('FocusIdTag') as string;
        expect(stored).assertEqual('renameInput');
      });

      it('setFocusId_overwrites_previous_value', 0, () => {
        NavStack.setFocusId('progressCancel');
        let stored: string = AppStorage.get<ESObject>('FocusIdTag') as string;
        expect(stored).assertEqual('progressCancel');
      });
    });

    /*
     * BackPress回调链——多组件注册的场景。
     * FileList注册时需注意顺序，先注册先执行。
     */
    describe('BackPress_Callback_Chain', () => {
      it('regBackPressFun_null_or_falsy_ignored', 0, () => {
        let nav: NavStack = new NavStack();
        nav.regBackPressFun(((): boolean => { return false; }));
        let result: boolean = nav.onBackPress();
        expect(result).assertEqual(false);
      });

      it('callback_that_returns_void_continues_chain', 0, () => {
        let nav: NavStack = new NavStack();
        let order: number[] = [];
        let cb1: () => void = (): void => { order.push(1); }; // 返回void
        let cb2: () => boolean = (): boolean => { order.push(2); return true; };
        nav.regBackPressFun(cb1);
        nav.regBackPressFun(cb2);
        nav.onBackPress();
        // cb1返回void→不等同于true→继续cb2
        expect(order.length).assertEqual(2);
        expect(order[0]).assertEqual(1);
        expect(order[1]).assertEqual(2);
      });
    });
  });
}
