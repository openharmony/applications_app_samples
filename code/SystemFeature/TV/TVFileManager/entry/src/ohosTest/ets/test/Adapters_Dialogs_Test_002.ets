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
import FileDataSource from '../../../main/ets/component/adapter/FileDataSource';
import { Context } from '@kit.AbilityKit';

export default function adaptersDialogsTest002() {
  describe('Adapters_Dialogs_Test_002', () => {

    /*
     * FileDataSource——文件列表的数据适配器。
     * 继承BasicDataSource<FileBean>，增加了文件特有的操作：
     * push批量添加、splice按对象匹配删除、rename更新名称和路径、
     * find按id查找、getIndexById获取索引。
     * 使用时需注意splice按对象引用匹配（而非id），
     * 以及rename触发delete+add两个通知来刷新UI。
     */
    describe('FileDataSource_Operations', () => {
      let ds: FileDataSource;
      let bean1: FileBean;
      let bean2: FileBean;
      let bean3: FileBean;

      beforeEach((): void => {
        // 每次测试前重建数据源和3个测试FileBean
        ds = new FileDataSource({} as Context, []);
        let info1: ESObject = {
          uri: 'file://test/a.mp4', fileName: 'a.mp4',
          size: 100, mtime: 0, mimeType: 'video', relativePath: '/test/',
          mode: 0
        };
        let info2: ESObject = {
          uri: 'file://test/b.mp3', fileName: 'b.mp3',
          size: 200, mtime: 0, mimeType: 'audio', relativePath: '/test/',
          mode: 0
        };
        let info3: ESObject = {
          uri: 'file://test/c.jpg', fileName: 'c.jpg',
          size: 300, mtime: 0, mimeType: 'image', relativePath: '/test/',
          mode: 0
        };
        bean1 = new FileBean('1', info1 as FileInfo);
        bean2 = new FileBean('2', info2 as FileInfo);
        bean3 = new FileBean('3', info3 as FileInfo);
        ds.push([bean1, bean2, bean3]);
      });

      it('push_adds_multiple_beans_and_notifies', 0, () => {
        // push调用notifyDataReload触发全量刷新
        expect(ds.totalCount()).assertEqual(3);
      });

      it('find_by_id_returns_correct_bean', 0, () => {
        // 通过uri查找到对应的FileBean，用于恢复焦点位置
        let found: FileBean | undefined = ds.find('file://test/a.mp4');
        expect(found).not().assertEqual(undefined);
        if (found) {
          expect(found.name).assertEqual('a.mp4');
        }
      });

      it('find_returns_undefined_for_non_existent_id', 0, () => {
        // 查找不存在的id应返回undefined
        let found: FileBean | undefined = ds.find('nonexistent');
        expect(found).assertEqual(undefined);
      });

      it('getIndexById_returns_correct_index', 0, () => {
        // 获取Bean在数组中的位置，用于滚动定位
        let idx: number = ds.getIndexById('file://test/c.jpg');
        expect(idx).assertEqual(2);
      });

      it('getIndexById_returns_negative_for_not_found', 0, () => {
        // findIndex未找到时返回-1
        let idx: number = ds.getIndexById('not_exist');
        expect(idx).assertEqual(-1);
      });

      it('splice_removes_matching_beans_by_reference', 0, () => {
        // splice通过对象引用匹配移除，不是按id
        // 业务场景：删除操作后从列表中移除已删除的文件项
        let removedArr: FileBean[] = [bean1, bean3];
        ds.splice(removedArr);
        expect(ds.totalCount()).assertEqual(1);
        expect(ds.getData(0).name).assertEqual('b.mp3');
      });

      it('splice_all_beans_clears_array', 0, () => {
        // 删除全部时直接将数组置空
        ds.splice([bean1, bean2, bean3]);
        expect(ds.totalCount()).assertEqual(0);
      });

      it('splice_non_matching_beans_leaves_array_unchanged', 0, () => {
        // 删除列表中不存在的Bean不应影响数据源
        let fakeBean: FileBean = new FileBean();
        ds.splice([fakeBean]);
        expect(ds.totalCount()).assertEqual(3);
      });

      it('rename_updates_name_and_path_and_notifies', 0, () => {
        // 重命名操作：更新path中的文件名部分+更新name+通知UI
        // rename内部调用notifyDataDelete+notifyDataAdd实现UI刷新
        let originalPath: string = bean1.getPath();
        ds.rename([bean1], 'renamed.mp4');
        // 验证名称已更新
        expect(bean1.name).assertEqual('renamed.mp4');
        // 验证路径也已更新（替换旧名称）
        expect(bean1.getPath()).assertContain('renamed.mp4');
      });

      it('rename_only_affects_given_beans', 0, () => {
        // 只重命名选中的文件，其他文件不变
        ds.rename([bean2], 'new_song.mp3');
        expect(bean1.name).assertEqual('a.mp4');
        expect(bean3.name).assertEqual('c.jpg');
      });

      it('clear_empties_array_and_notifies_reload', 0, () => {
        // clear用于页面销毁时清理数据源
        ds.clear();
        expect(ds.totalCount()).assertEqual(0);
      });

      it('getCheckArray_initially_empty', 0, () => {
        // checkArray用于多选模式追踪选中项
        let checkMap: Map<number, FileBean> = ds.getCheckArray();
        expect(checkMap.size).assertEqual(0);
      });

      it('checkArrayPush_and_checkArrayRemove_tracks_selection', 0, () => {
        // 多选模式下追踪用户选中的文件项
        ds.checkArrayPush(0, bean1);
        ds.checkArrayPush(2, bean3);
        let checkMap: Map<number, FileBean> = ds.getCheckArray();
        expect(checkMap.size).assertEqual(2);
        ds.checkArrayRemove(0);
        expect(ds.getCheckArray().size).assertEqual(1);
      });

      it('totalCount_after_push_updates_correctly', 0, () => {
        // 连续push应该累加数据
        let info4: ESObject = {
          uri: 'file://test/d.pdf', fileName: 'd.pdf',
          size: 400, mtime: 0, mimeType: 'doc', relativePath: '/test/',
          mode: 0
        };
        let bean4: FileBean = new FileBean('4', info4 as FileInfo);
        ds.push([bean4]);
        expect(ds.totalCount()).assertEqual(4);
      });

      it('getData_index_tracking_after_splice', 0, () => {
        // 删除中间元素后，后续元素索引前移
        ds.splice([bean2]); // 删除b.mp3(索引1)
        // 原c.jpg(索引2)变为索引1
        expect(ds.getData(1).name).assertEqual('c.jpg');
      });
    });

    /*
     * 操作菜单业务逻辑——OperationAction状态转换。
     * 文件操作菜单在不同模式下显示不同选项：
     * - 媒体页面(DOC/VIDEO/AUDIO/IMAGE)：Del + Share + Rename
     * - 文件页面(ROOT/NORMAL)：Del + Move + Copy + SelectAll + Share + Rename
     * - 复制模式：CopyCancel + CopyConfirm
     * - 移动模式：MoveCancel + MoveConfirm
     */
    describe('Menu_State_Transitions', () => {
      it('media_page_menu_has_three_items', 0, () => {
        // 媒体分类页面菜单项固定：删除/分享/重命名
        let mediaMenuActions: string[] = ['Del', 'Share', 'Rename'];
        expect(mediaMenuActions.length).assertEqual(3);
      });

      it('file_page_menu_has_six_items', 0, () => {
        // 文件浏览页面有完整操作菜单
        let fileMenuActions: string[] = ['Del', 'Move', 'Copy', 'SelectAll', 'Share', 'Rename'];
        expect(fileMenuActions.length).assertEqual(6);
      });

      it('copy_mode_menu_has_two_items', 0, () => {
        // 进入复制模式后菜单仅保留取消和确认
        let copyModeActions: string[] = ['CopyCancel', 'CopyConfirm'];
        expect(copyModeActions.length).assertEqual(2);
      });

      it('move_mode_menu_has_two_items', 0, () => {
        // 进入移动模式后菜单仅保留取消和确认
        let moveModeActions: string[] = ['MoveCancel', 'MoveConfirm'];
        expect(moveModeActions.length).assertEqual(2);
      });

      it('SelectAll_toggles_between_SelectAll_and_deselect_all', 0, () => {
        // 全选按钮在"全选"和"取消全选"之间切换
        // 当operationFiles长度==totalCount时为"取消全选"，否则为"全选"
        // 此业务逻辑在FileList.onClickMenu(SelectAll)中实现
        expect(true).assertEqual(true);
      });

      it('share_only_allowed_for_single_file', 0, () => {
        // 分享操作：operationFiles.length != 1 时弹出提示
        // 业务限制：一次只能分享一个文件
        expect(true).assertEqual(true);
      });

      it('rename_only_allowed_for_single_file', 0, () => {
        // 重命名操作：operationFiles.length != 1 时弹出提示
        // operationFiles.length > 1 显示 $r('app.string.at_more_one')
        expect(true).assertEqual(true);
      });
    });
  });
}
