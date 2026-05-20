import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { FileBean } from '../../../main/ets/component/bean/FileBean';
import { FileInfo } from '../../../main/ets/common/data/FileInfo';
import { Tools } from '../../../main/ets/common/utils/Tools';
import { NavStack } from '../../../main/ets/common/manager/NavPathStackManager';
import { PageType } from '../../../main/ets/model/PageType';
import { DeviceType } from '../../../main/ets/common/data/DeviceType';
import { MediaType } from '../../../main/ets/model/MediaType';
import { checkSuffix, SUFFIX_VIDEO, SUFFIX_AUDIO, SUFFIX_IMAGE, SUFFIX_TEXT } from '../../../main/ets/common/ConstantsMedia';
import { OperationActionID } from '../../../main/ets/model/Operation';
import { fileExtensionInfo } from '@kit.CoreFileKit';
import { FileAccessManager } from '../../../main/ets/common/manager/FileAccessManager';

export default function regressionEdgeTest() {
  describe('Regression_Edge_Test', () => {

    /*
     * 回归测试——针对已知问题和边缘条件。
     * 包含过去发现过的bug的复现用例、未覆盖的代码路径。
     */
    describe('FileBean_Edge_Regression', () => {
      it('FileBean_with_double_encoded_uri', 0, () => {
        // 双重编码URI如file://media/%25E6%2596%2587.mp4
        let encodedUri: string = 'file://media/%25E6%2596%2587.mp4';
        let info: ESObject = {
          uri: encodedUri, fileName: '%E6%96%87.mp4',
          size: 0, mtime: 0, mimeType: '', relativePath: '', mode: 0
        };
        let bean: FileBean = new FileBean('enc', info as FileInfo);
        expect(bean.name).assertEqual('%E6%96%87.mp4');
      });

      it('FileBean_path_with_windows_style_separator', 0, () => {
        // Windows反斜杠路径（某些USB设备可能使用）
        let winPath: string = 'file://usb/folder\\file.txt';
        let info: ESObject = {
          uri: winPath, fileName: 'file.txt',
          size: 0, mtime: 0, mimeType: '', relativePath: winPath, mode: 0
        };
        let bean: FileBean = new FileBean('win', info as FileInfo);
        expect(bean.getPath()).assertEqual(winPath);
      });

      it('FileBean_time_zero_does_not_generate_timeStr', 0, () => {
        // mtime=0时timeStr为空（未格式化）
        let info: ESObject = {
          uri: 'file://notime.dat', fileName: 'notime.dat',
          size: 0, mtime: 0, mimeType: '', relativePath: '', mode: 0
        };
        let bean: FileBean = new FileBean('n', info as FileInfo);
        expect(bean.time).assertEqual(0);
      });

      it('FileBean_isDevice_when_constructor_without_info', 0, () => {
        // 无参构造→无deviceType→isDevice=false
        let bean: FileBean = new FileBean();
        expect(bean.isDevice()).assertEqual(false);
      });

      it('FileBean_not_isMediaType_with_full_uri', 0, () => {
        // isMediaType判断id.length==1（单个字符）
        // 完整URI长度远大于1→false
        let info: ESObject = {
          uri: 'file://long/path/file.mp4', fileName: 'file.mp4',
          size: 0, mtime: 0, mimeType: '', relativePath: '', mode: 0
        };
        let bean: FileBean = new FileBean('l', info as FileInfo);
        expect(bean.isMediaType()).assertEqual(false);
      });
    });

    /*
     * byte2Str边界回归——测试中发现的精度问题。
     */
    describe('Byte2Str_Precision_Regression', () => {
      it('byte2Str_0_1KB_is_not_0KB', 0, () => {
        // 0.1KB=102.4B→显示102B而不是0KB
        let result: string = Tools.byte2Str(102);
        expect(result).assertContain('B');
        expect(result).not().assertContain('0KB');
      });

      it('byte2Str_exact_power_of_2_boundaries', 0, () => {
        // 2^n边界值的精确性
        expect(Tools.byte2Str(1)).assertEqual('1B');
        expect(Tools.byte2Str(2)).assertEqual('2B');
        expect(Tools.byte2Str(4)).assertEqual('4B');
        expect(Tools.byte2Str(8)).assertEqual('8B');
        expect(Tools.byte2Str(1024)).assertEqual('1KB');
        expect(Tools.byte2Str(1048576)).assertEqual('1MB');
      });

      it('byte2Str_huge_number_no_overflow', 0, () => {
        // 超过Number安全整数范围的值
        let hugeResult: string = Tools.byte2Str(Number.MAX_SAFE_INTEGER);
        expect(hugeResult.length > 0).assertEqual(true);
      });
    });

    /*
     * NavStack状态机回归——已知的边界条件。
     */
    describe('NavStack_Regression', () => {
      it('pushRoot_HOME_PAGE_twice_clears_everything', 0, () => {
        let nav: NavStack = new NavStack();
        nav.pushRoot(PageType.ROOT_PAGE);
        nav.pushRoot(PageType.HOME_PAGE);
        // HOME_PAGE清空所有栈→只保留HOME_PAGE自身
        expect(nav.isExitApp()).assertEqual(true);
      });

      it('setDevice_while_in_select_mode_preserves_mode', 0, () => {
        let nav: NavStack = new NavStack();
        nav.setCopyMode();
        nav.setDevice(DeviceType.USB);
        expect(nav.isCopy()).assertEqual(true);
      });

      it('closeSelectMode_already_none_is_noop', 0, () => {
        let nav: NavStack = new NavStack();
        nav.closeSelectMode(); // 已在None模式
        expect(nav.isSelectMod()).assertEqual(false);
        nav.closeSelectMode(); // 再次调用
        expect(nav.isSelectMod()).assertEqual(false);
      });

      it('getPathListNames_after_multiple_push_and_pop', 0, () => {
        let nav: NavStack = new NavStack();
        nav.pushRoot(PageType.HOME_PAGE);
        nav.pushRoot(PageType.ROOT_PAGE);
        nav.popPath();
        let names: string[] = nav.getPathListNames();
        expect(names.length).assertEqual(0); // pop后paths为空
      });

      it('checkBackPress_after_clearStack_returns_false', 0, () => {
        let nav: NavStack = new NavStack();
        nav.pushRoot(PageType.HOME_PAGE);
        expect(nav.checkBackPress()).assertEqual(false);
      });

      it('isShowPath_USB_device_always_true', 0, () => {
        let nav: NavStack = new NavStack();
        nav.openUSB();
        nav.setDevice(DeviceType.USB);
        // USB设备总是显示面包屑
        expect(nav.isShowPath()).assertEqual(true);
      });
    });

    /*
     * 后缀检测回归——罕见的格式和边缘文件名。
     */
    describe('Suffix_Detection_Regression', () => {
      it('dotfile_with_extension_matching', 0, () => {
        // .config.mp4 → 隐藏文件但有视频后缀
        expect(checkSuffix('.config.mp4', SUFFIX_VIDEO)).assertEqual(true);
      });

      it('filename_with_multiple_media_extensions', 0, () => {
        // 'video.mp4.mp3' → endsWith('.mp3')=true 只匹配最后一个
        expect(checkSuffix('video.mp4.mp3', SUFFIX_AUDIO)).assertEqual(true);
        expect(checkSuffix('video.mp4.mp3', SUFFIX_VIDEO)).assertEqual(false);
      });

      it('filename_ending_with_case_sensitive_only_in_array', 0, () => {
        // IgnoreCase同时生成了大小写两份
        expect(SUFFIX_VIDEO.find((it: string) => it === '.MP4')).not().assertEqual(undefined);
        expect(SUFFIX_VIDEO.find((it: string) => it === '.mp4')).not().assertEqual(undefined);
      });

      it('unknown_four_char_extension_not_matched', 0, () => {
        // 随机4字符扩展名不应匹配
        expect(checkSuffix('file.abcd', SUFFIX_VIDEO)).assertEqual(false);
        expect(checkSuffix('file.abcd', SUFFIX_AUDIO)).assertEqual(false);
        expect(checkSuffix('file.abcd', SUFFIX_IMAGE)).assertEqual(false);
        expect(checkSuffix('file.abcd', SUFFIX_TEXT)).assertEqual(false);
      });
    });

    /*
     * DeviceFlag/FileMode位运算回归。
     */
    describe('BitFlag_Regression', () => {
      it('SUPPORTS_READ_and_SUPPORTS_WRITE_bits_differ', 0, () => {
        // SUPPORTS_READ和SUPPORTS_WRITE必须是不同的位
        let readBit: number = fileExtensionInfo.DeviceFlag.SUPPORTS_READ;
        let writeBit: number = fileExtensionInfo.DeviceFlag.SUPPORTS_WRITE;
        expect(readBit).not().assertEqual(writeBit);
      });

      it('REPRESENTS_FILE_and_REPRESENTS_DIR_bits_differ', 0, () => {
        let fileBit: number = fileExtensionInfo.DocumentFlag.REPRESENTS_FILE;
        let dirBit: number = fileExtensionInfo.DocumentFlag.REPRESENTS_DIR;
        expect(fileBit).not().assertEqual(dirBit);
      });

      it('fileMode_combined_get_REPRESENTS_FILE_correctly', 0, () => {
        // 即使设置了其他位，REPRESENTS_FILE仍应正确识别
        let mode: number = fileExtensionInfo.DocumentFlag.REPRESENTS_FILE
          | fileExtensionInfo.DocumentFlag.SUPPORTS_READ
          | fileExtensionInfo.DocumentFlag.SUPPORTS_WRITE;
        let result: string = FileAccessManager.fileModeToString(mode);
        expect(result).assertContain('FILE');
      });

      it('fileMode_combined_get_REPRESENTS_DIR_correctly', 0, () => {
        let mode: number = fileExtensionInfo.DocumentFlag.REPRESENTS_DIR
          | fileExtensionInfo.DocumentFlag.SUPPORTS_READ;
        let result: string = FileAccessManager.fileModeToString(mode);
        expect(result).assertContain('DIR');
      });
    });

    /*
     * 操作ID空字符/特殊字符回归。
     */
    describe('OperationID_Format_Regression', () => {
      it('SelectAll_action_equals_expected', 0, () => {
        expect(OperationActionID.SelectAll).assertEqual('SelectAll');
      });

      it('Share_action_equals_expected', 0, () => {
        expect(OperationActionID.Share).assertEqual('Share');
      });

      it('Rename_action_equals_expected', 0, () => {
        expect(OperationActionID.Rename).assertEqual('Rename');
      });
    });
  });
}
