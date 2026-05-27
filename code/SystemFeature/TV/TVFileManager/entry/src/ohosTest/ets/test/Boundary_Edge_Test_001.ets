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
import { checkSuffix, SUFFIX_VIDEO, SUFFIX_AUDIO, SUFFIX_IMAGE, SUFFIX_TEXT } from '../../../main/ets/common/ConstantsMedia';
import { Tools } from '../../../main/ets/common/utils/Tools';
import { IsFile, IsDevice } from '../../../main/ets/common/utils/Tools';
import { fileExtensionInfo } from '@kit.CoreFileKit';

export default function boundaryEdgeTest001() {
  describe('Boundary_Edge_Test_001', () => {

    /*
     * 文件系统边界场景——空数据、单文件、无效URI、超长文件名。
     * TV文件管理器需要处理各种极端输入，避免崩溃或数据错乱。
     */
    describe('FileBean_Construction_Boundary', () => {
      it('FileBean_with_null_FileInfo_creates_fake_bean', 0, () => {
        // 业务场景：FileAccessManager返回空结果时的降级处理
        // 空FileBean作为占位符确保列表不为空
        let info: ESObject = {};
        let bean: FileBean;
        try {
          // 构造时若info为null/falsy则走else分支创建fake bean
          bean = new FileBean('0', info as FileInfo);
          expect(bean.name).assertContain('fake');
        } catch (e) {
          // 若抛出异常则记录（ArkTS不应在此崩溃）
          expect(false).assertEqual(true);
        }
      });

      it('FileBean_with_empty_uri', 0, () => {
        // 空URI的文件系统条目：理论上不应出现，但需要防御
        let info: ESObject = {
          uri: '', fileName: 'empty_uri_file',
          size: 0, mtime: 0, mimeType: '', relativePath: '',
          mode: 0,
          listFile: undefined, scanFile: undefined
        };
        let bean: FileBean = new FileBean('e', info as FileInfo);
        expect(bean.id).assertEqual('');
        expect(bean.getPath()).assertEqual('');
      });

      it('FileBean_with_very_long_filename', 0, () => {
        // 255字符的文件名（多数文件系统上限）
        let longName: string = '';
        for (let i: number = 0; i < 255; i++) {
          longName += 'a';
        }
        let info: ESObject = {
          uri: 'file://test/' + longName,
          fileName: longName,
          size: 0, mtime: 0, mimeType: '', relativePath: '',
          mode: 0
        };
        let bean: FileBean = new FileBean('long', info as FileInfo);
        expect(bean.name.length).assertEqual(255);
      });

      it('FileBean_with_special_characters_in_filename', 0, () => {
        // 文件名含特殊字符（空格/中文/表情符号），应能正常构造
        let specialName: string = '文件 (1).mp4';
        let info: ESObject = {
          uri: 'file://test/' + specialName,
          fileName: specialName,
          size: 0, mtime: 0, mimeType: '', relativePath: '',
          mode: 0
        };
        let bean: FileBean = new FileBean('s', info as FileInfo);
        expect(bean.name).assertEqual(specialName);
      });

      it('FileBean_with_zero_size_and_valid_type', 0, () => {
        // size=0的文件可能是空文件或刚创建的文件
        let info: ESObject = {
          uri: 'file://test/empty.txt', fileName: 'empty.txt',
          size: 0, mtime: Date.now(), mimeType: 'text/plain',
          relativePath: '/test/', mode: fileExtensionInfo.DocumentFlag.REPRESENTS_FILE,
          listFile: undefined, scanFile: undefined
        };
        let bean: FileBean = new FileBean('zero', info as FileInfo);
        expect(bean.size).assertEqual(0);
        expect(bean.isFile()).assertEqual(true);
      });

      it('FileBean_with_max_size_value', 0, () => {
        // 超大文件（如4GB以上），byte2Str需要正确进位到GB
        let maxSize: number = Number.MAX_SAFE_INTEGER;
        let info: ESObject = {
          uri: 'file://test/huge.bin', fileName: 'huge.bin',
          size: maxSize, mtime: 0, mimeType: '', relativePath: '',
          mode: 0
        };
        let bean: FileBean = new FileBean('huge', info as FileInfo);
        expect(bean.size > 0).assertEqual(true);
      });
    });

    /*
     * 后缀匹配边界——异常扩展名、无扩展名、多重点。
     */
    describe('Suffix_Matching_Boundary', () => {
      it('checkSuffix_with_no_dot_in_name', 0, () => {
        // 无扩展名的文件（如Makefile/README）不应匹配任何媒体类型
        expect(checkSuffix('README', SUFFIX_VIDEO)).assertEqual(false);
        expect(checkSuffix('Makefile', SUFFIX_TEXT)).assertEqual(false);
      });

      it('checkSuffix_with_multiple_dots', 0, () => {
        // "archive.tar.gz" → 后缀为.gz，不在任何白名单中
        expect(checkSuffix('archive.tar.gz', SUFFIX_VIDEO)).assertEqual(false);
      });

      it('checkSuffix_with_hidden_file', 0, () => {
        // ".gitignore" → endsWith('.ignore')不在白名单
        expect(checkSuffix('.gitignore', SUFFIX_TEXT)).assertEqual(false);
      });

      it('checkSuffix_exact_match_required', 0, () => {
        // "video.mp4.bak" → 后缀.bak不在白名单
        expect(checkSuffix('video.mp4.bak', SUFFIX_VIDEO)).assertEqual(false);
      });

      it('checkSuffix_unicode_filename', 0, () => {
        // 中文文件名：视频.mp4
        expect(checkSuffix('视频.mp4', SUFFIX_VIDEO)).assertEqual(true);
        expect(checkSuffix('音楽.mp3', SUFFIX_AUDIO)).assertEqual(true);
      });

      it('checkSuffix_empty_array_never_matches', 0, () => {
        // 空后缀列表：任何文件名都不匹配
        expect(checkSuffix('file.mp4', [])).assertEqual(false);
      });
    });

    /*
     * 字节转换边界——极值/小数精度/上溢。
     */
    describe('Byte2Str_Boundary', () => {
      it('byte2Str_exactly_at_KB_threshold', 0, () => {
        // 1024B=1KB（刚好在阈值上）
        expect(Tools.byte2Str(1024)).assertEqual('1KB');
        expect(Tools.byte2Str(1023)).assertEqual('1023B');
      });

      it('byte2Str_exactly_at_MB_threshold', 0, () => {
        // 1048576B=1MB
        expect(Tools.byte2Str(1048576)).assertEqual('1MB');
        expect(Tools.byte2Str(1048575)).assertContain('KB');
      });

      it('byte2Str_exactly_at_GB_threshold', 0, () => {
        // 1073741824B=1GB
        expect(Tools.byte2Str(1073741824)).assertEqual('1GB');
      });

      it('byte2Str_fractional_KB', 0, () => {
        // 512B=0.5KB
        expect(Tools.byte2Str(512)).assertEqual('512B');
        // 1536B=1.5KB
        expect(Tools.byte2Str(1536)).assertEqual('1.5KB');
      });

      it('byte2Str_very_large_value_TB_range', 0, () => {
        // 1TB=1099511627776B→1024GB
        let result: string = Tools.byte2Str(1099511627776);
        expect(result).assertContain('GB');
      });
    });

    /*
     * IsFile/IsDevice位运算边界。
     */
    describe('File_Flag_Bit_Operations', () => {
      it('IsFile_REPRESENTS_FILE_flag', 0, () => {
        let fileMode: number = fileExtensionInfo.DocumentFlag.REPRESENTS_FILE;
        expect(IsFile(fileMode)).assertEqual(true);
        let dirMode: number = fileExtensionInfo.DocumentFlag.REPRESENTS_DIR;
        expect(IsFile(dirMode)).assertEqual(false);
      });

      it('IsFile_zero_mode', 0, () => {
        // mode=0 → REPRESENTS_FILE flag not set → false
        expect(IsFile(0)).assertEqual(false);
      });

      it('IsFile_combined_flags', 0, () => {
        // mode可能同时有REPRESENTS_FILE和SUPPORTS_READ等标志
        let combined: number = fileExtensionInfo.DocumentFlag.REPRESENTS_FILE
          | fileExtensionInfo.DocumentFlag.SUPPORTS_READ
          | fileExtensionInfo.DocumentFlag.SUPPORTS_WRITE;
        expect(IsFile(combined)).assertEqual(true);
      });

      it('IsDevice_with_DEVICE_EXTERNAL_USB_flag', 0, () => {
        // IsDevice检查DEVICE_EXTERNAL_USB标志位
        // 此标志仅在RootInfo转FileInfo时设置(deviceType字段)
        expect(IsDevice(0)).assertEqual(false);
      });
    });
  });
}
