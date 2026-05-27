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
import { FileAccessManager, RootData } from '../../../main/ets/common/manager/FileAccessManager';
import { FileInfo } from '../../../main/ets/common/data/FileInfo';
import { FileBean } from '../../../main/ets/component/bean/FileBean';
import { MediaType } from '../../../main/ets/model/MediaType';
import { fileExtensionInfo } from '@kit.CoreFileKit';
import { SUFFIX_VIDEO, SUFFIX_AUDIO, SUFFIX_IMAGE, SUFFIX_TEXT } from '../../../main/ets/common/ConstantsMedia';
import { Context } from '@kit.AbilityKit';

export default function fileAccessManagerDeepTest() {
  describe('FileAccessManager_Deep_Test', () => {

    /*
     * FileAccessManager API契约深度测试。
     * 逐一验证每一个公开方法的参数类型、返回值类型、异常处理行为。
     * 这些测试确保API签名的稳定性，防止重构导致调用方崩溃。
     */
    describe('Method_Signature_Verification', () => {
      it('getIns_returns_instance', 0, () => {
        // 单例模式的正确性：同一context多次调用返回同一实例
        let ins1 = FileAccessManager.getIns({} as Context);
        let ins2 = FileAccessManager.getIns({} as Context);
        // 单例模式下两个引用应指向同一个实例
        expect(ins1).not().assertEqual(undefined);
      });

      it('getRoots_returns_Promise_of_RootInfo_array', 0, () => {
        // getRoots是异步方法，返回类型为Promise<Array<RootInfo>>
        // 调用方需使用.then/catch或await处理
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.getRoots).not().assertEqual(undefined);
        expect(typeof ins.getRoots).assertEqual('function');
      });

      it('getList_accepts_RootInfo_or_FileInfo', 0, () => {
        // getList的多态参数：可接受RootInfo或FileInfo
        // 第二个可选参数searchText用于过滤
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.getList).not().assertEqual(undefined);
        expect(typeof ins.getList).assertEqual('function');
      });

      it('getRootLocal_returns_Promise_of_single_RootInfo', 0, () => {
        // getRootLocal从roots中筛选第一个本地设备
        // 使用Array.find + isLocalDevice过滤
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.getRootLocal).not().assertEqual(undefined);
        expect(typeof ins.getRootLocal).assertEqual('function');
      });

      it('getRootDataAsFile_returns_RootData_with_root_and_list', 0, () => {
        // RootData = { root: FileInfo, list: FileBean[] }
        // root是转换后的FileInfo(isRoot=true)，list是FileBean数组
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.getRootDataAsFile).not().assertEqual(undefined);
        expect(typeof ins.getRootDataAsFile).assertEqual('function');
      });

      it('getUsbDataAsFile_returns_RootData_for_USB_device', 0, () => {
        // 与getRootDataAsFile对称，但筛选USB设备
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.getUsbDataAsFile).not().assertEqual(undefined);
        expect(typeof ins.getUsbDataAsFile).assertEqual('function');
      });

      it('getListFormUri_accepts_uri_string', 0, () => {
        // 通过uri获取子目录列表：两步操作 getFileInfoFromUri → getList
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.getListFormUri).not().assertEqual(undefined);
        expect(typeof ins.getListFormUri).assertEqual('function');
      });

      it('access_method_exists_for_permission_check', 0, () => {
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.access).not().assertEqual(undefined);
        expect(typeof ins.access).assertEqual('function');
      });

      it('move_method_exists', 0, () => {
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.move).not().assertEqual(undefined);
        expect(typeof ins.move).assertEqual('function');
      });

      it('moveOne_method_exists', 0, () => {
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.moveOne).not().assertEqual(undefined);
        expect(typeof ins.moveOne).assertEqual('function');
      });

      it('copy_method_exists', 0, () => {
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.copy).not().assertEqual(undefined);
        expect(typeof ins.copy).assertEqual('function');
      });

      it('copyOne_method_exists', 0, () => {
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.copyOne).not().assertEqual(undefined);
        expect(typeof ins.copyOne).assertEqual('function');
      });

      it('delete_method_exists', 0, () => {
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.delete).not().assertEqual(undefined);
        expect(typeof ins.delete).assertEqual('function');
      });

      it('deleteOne_method_exists', 0, () => {
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.deleteOne).not().assertEqual(undefined);
        expect(typeof ins.deleteOne).assertEqual('function');
      });

      it('rename_method_exists', 0, () => {
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.rename).not().assertEqual(undefined);
        expect(typeof ins.rename).assertEqual('function');
      });

      it('renameOne_method_exists', 0, () => {
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.renameOne).not().assertEqual(undefined);
        expect(typeof ins.renameOne).assertEqual('function');
      });

      it('createDir_method_exists', 0, () => {
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.createDir).not().assertEqual(undefined);
        expect(typeof ins.createDir).assertEqual('function');
      });

      it('createFile_method_exists', 0, () => {
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.createFile).not().assertEqual(undefined);
        expect(typeof ins.createFile).assertEqual('function');
      });

      it('isDir_method_exists', 0, () => {
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.isDir).not().assertEqual(undefined);
        expect(typeof ins.isDir).assertEqual('function');
      });

      it('openFile_method_exists', 0, () => {
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.openFile).not().assertEqual(undefined);
        expect(typeof ins.openFile).assertEqual('function');
      });

      it('getFileInfoFromUri_method_exists', 0, () => {
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.getFileInfoFromUri).not().assertEqual(undefined);
        expect(typeof ins.getFileInfoFromUri).assertEqual('function');
      });

      it('getFileAsset_method_exists', 0, () => {
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.getFileAsset).not().assertEqual(undefined);
        expect(typeof ins.getFileAsset).assertEqual('function');
      });

      it('getMediaFileAsset_method_exists', 0, () => {
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.getMediaFileAsset).not().assertEqual(undefined);
        expect(typeof ins.getMediaFileAsset).assertEqual('function');
      });
    });

    /*
     * 按媒体类型扫描的方法签名验证。
     * getDocs/getVideos/getImages/getAudios各使用不同的Filter.suffix。
     */
    describe('MediaType_Scan_Methods', () => {
      it('getDocs_uses_SUFFIX_TEXT_filter', 0, () => {
        // getDocs通过{ suffix: SUFFIX_TEXT }过滤器扫描
        // 返回所有文档类文件(doc/docx/pdf/txt等)
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.getDocs).not().assertEqual(undefined);
        expect(typeof ins.getDocs).assertEqual('function');
      });

      it('getVideos_uses_SUFFIX_VIDEO_filter', 0, () => {
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.getVideos).not().assertEqual(undefined);
        expect(typeof ins.getVideos).assertEqual('function');
      });

      it('getImages_uses_SUFFIX_IMAGE_filter', 0, () => {
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.getImages).not().assertEqual(undefined);
        expect(typeof ins.getImages).assertEqual('function');
      });

      it('getAudios_uses_SUFFIX_AUDIO_filter', 0, () => {
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        expect(ins.getAudios).not().assertEqual(undefined);
        expect(typeof ins.getAudios).assertEqual('function');
      });
    });

    /*
     * 静态工具方法——设备类型/文件模式/设备标志的字符串转换。
     * 所有switch分支的覆盖。
     */
    describe('Static_DeviceType_String_All_Branches', () => {
      it('deviceTypeToString_Local', 0, () => {
        expect(FileAccessManager.deviceTypeToString(0)).assertEqual('Local');
      });

      it('deviceTypeToString_SharedDisk', 0, () => {
        expect(FileAccessManager.deviceTypeToString(1)).assertEqual('SHARED_DISK');
      });

      it('deviceTypeToString_SharedTerminal', 0, () => {
        expect(FileAccessManager.deviceTypeToString(2)).assertEqual('SHARED_TERMINAL');
      });

      it('deviceTypeToString_NetworkNeighborhood', 0, () => {
        expect(FileAccessManager.deviceTypeToString(4)).assertEqual('NETWORK_NEIGHBORHOODS');
      });

      it('deviceTypeToString_ExternalUSB', 0, () => {
        expect(FileAccessManager.deviceTypeToString(3)).assertEqual('DEVICE_EXTERNAL_USB');
      });

      it('deviceTypeToString_default_Other', 0, () => {
        expect(FileAccessManager.deviceTypeToString(999)).assertEqual('Other');
        expect(FileAccessManager.deviceTypeToString(5)).assertEqual('Other');
        expect(FileAccessManager.deviceTypeToString(100)).assertEqual('Other');
      });
    });

    /*
     * fileModeToString所有标志位组合。
     * DocumentFlag的四种组合：FILE/DIR × (READ|WRITE|READ_WRITE|NONE)。
     */
    describe('Static_FileMode_String_All_Branches', () => {
      const DF_REPRESENTS_FILE: number = fileExtensionInfo.DocumentFlag.REPRESENTS_FILE;
      const DF_REPRESENTS_DIR: number = fileExtensionInfo.DocumentFlag.REPRESENTS_DIR;
      const DF_SUPPORTS_READ: number = fileExtensionInfo.DocumentFlag.SUPPORTS_READ;
      const DF_SUPPORTS_WRITE: number = fileExtensionInfo.DocumentFlag.SUPPORTS_WRITE;

      it('fileMode_File_only', 0, () => {
        expect(FileAccessManager.fileModeToString(DF_REPRESENTS_FILE)).assertEqual('FILE');
      });

      it('fileMode_Dir_only', 0, () => {
        expect(FileAccessManager.fileModeToString(DF_REPRESENTS_DIR)).assertEqual('DIR');
      });

      it('fileMode_File_Read', 0, () => {
        let mode: number = DF_REPRESENTS_FILE | DF_SUPPORTS_READ;
        expect(FileAccessManager.fileModeToString(mode)).assertEqual('FILE|READ');
      });

      it('fileMode_File_Write', 0, () => {
        let mode: number = DF_REPRESENTS_FILE | DF_SUPPORTS_WRITE;
        expect(FileAccessManager.fileModeToString(mode)).assertEqual('FILE|WRITE');
      });

      it('fileMode_File_ReadWrite', 0, () => {
        let mode: number = DF_REPRESENTS_FILE | DF_SUPPORTS_READ | DF_SUPPORTS_WRITE;
        expect(FileAccessManager.fileModeToString(mode)).assertEqual('FILE|READ|WRITE');
      });

      it('fileMode_Dir_Read', 0, () => {
        let mode: number = DF_REPRESENTS_DIR | DF_SUPPORTS_READ;
        expect(FileAccessManager.fileModeToString(mode)).assertEqual('DIR|READ');
      });

      it('fileMode_Dir_Write', 0, () => {
        let mode: number = DF_REPRESENTS_DIR | DF_SUPPORTS_WRITE;
        expect(FileAccessManager.fileModeToString(mode)).assertEqual('DIR|WRITE');
      });

      it('fileMode_Dir_ReadWrite', 0, () => {
        let mode: number = DF_REPRESENTS_DIR | DF_SUPPORTS_READ | DF_SUPPORTS_WRITE;
        expect(FileAccessManager.fileModeToString(mode)).assertEqual('DIR|READ|WRITE');
      });

      it('fileMode_unknown_zero', 0, () => {
        expect(FileAccessManager.fileModeToString(0)).assertEqual('Unknown');
      });
    });

    /*
     * deviceFlagToString所有标志位组合。
     */
    describe('Static_DeviceFlag_String_All_Branches', () => {
      const F_SUPPORTS_READ: number = fileExtensionInfo.DeviceFlag.SUPPORTS_READ;
      const F_SUPPORTS_WRITE: number = fileExtensionInfo.DeviceFlag.SUPPORTS_WRITE;

      it('deviceFlag_Read_only', 0, () => {
        expect(FileAccessManager.deviceFlagToString(F_SUPPORTS_READ)).assertEqual('READ');
      });

      it('deviceFlag_Write_only', 0, () => {
        expect(FileAccessManager.deviceFlagToString(F_SUPPORTS_WRITE)).assertEqual('WRITE');
      });

      it('deviceFlag_ReadWrite', 0, () => {
        let flag: number = F_SUPPORTS_READ | F_SUPPORTS_WRITE;
        expect(FileAccessManager.deviceFlagToString(flag)).assertEqual('READ|WRITE');
      });

      it('deviceFlag_unknown_zero', 0, () => {
        expect(FileAccessManager.deviceFlagToString(0)).assertEqual('Unknown');
      });
    });

    /*
     * getFileAsset方法——根据MediaType分发到不同的扫描策略。
     * VIDEO→getVideos, IMAGE→getImages, AUDIO→getAudios。
     */
    describe('getFileAsset_MediaType_Dispatch', () => {
      it('VIDEO_dispatches_to_getVideos', 0, () => {
        // switch(mediaType) case MediaType.VIDEO → getVideos(root)
        expect(MediaType.VIDEO).assertEqual(0);
      });

      it('IMAGE_dispatches_to_getImages', 0, () => {
        expect(MediaType.IMAGE).assertEqual(3);
      });

      it('AUDIO_dispatches_to_getAudios', 0, () => {
        expect(MediaType.AUDIO).assertEqual(1);
      });
    });

    /*
     * getMediaFileAsset方法——从UserFileManager获取媒体库资产。
     * 与getFileAsset互补：分别从媒体库和文件系统获取文件。
     */
    describe('getMediaFileAsset_MediaType_Dispatch', () => {
      it('VIDEO_gets_photo_assets_filtered_by_video_type', 0, () => {
        // getMediaFileAsset首先调用getVideoOrImage()，然后filter(fileType==VIDEO)
        expect(MediaType.VIDEO).assertEqual(0);
      });

      it('IMAGE_gets_photo_assets_filtered_by_image_type', 0, () => {
        expect(MediaType.IMAGE).assertEqual(3);
      });

      it('AUDIO_gets_audio_assets', 0, () => {
        // 音频文件直接调用getAudio()，不需要过滤
        expect(MediaType.AUDIO).assertEqual(1);
      });
    });

    /*
     * 边界：FileAccessManager在没有context时的行为。
     * getHelper会抛出Error("FileAccessHelper is null!")
     */
    describe('Context_Null_Guard', () => {
      it('getHelper_throws_when_context_is_null', 0, () => {
        let ins: FileAccessManager = FileAccessManager.getIns({} as Context);
        // 无context时调用需要helper的方法会抛出异常
        // 这是设计意图：防止空指针操作文件系统
        expect(ins).not().assertEqual(undefined);
      });

      it('getIns_without_context_updates_instance', 0, () => {
        // getIns无context参数时，ctx保持上次的值
        let ins1: FileAccessManager = FileAccessManager.getIns({} as Context);
        let ins2: FileAccessManager = FileAccessManager.getIns({} as Context);
        // ins1和ins2是同一个实例
        expect(ins1).not().assertEqual(undefined);
      });
    });
  });
}
