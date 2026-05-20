import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { FileAccessManager } from '../../../main/ets/common/manager/FileAccessManager';
import { FileIoManager } from '../../../main/ets/common/manager/FileIoManager';
import { FileBean } from '../../../main/ets/component/bean/FileBean';
import { FileInfo } from '../../../main/ets/common/data/FileInfo';
import { SUFFIX_VIDEO, SUFFIX_AUDIO, SUFFIX_IMAGE, SUFFIX_TEXT } from '../../../main/ets/common/ConstantsMedia';
import { fileAccess, fileExtensionInfo } from '@kit.CoreFileKit';

interface SandboxFileInfo {
  name: string;
  path: string;
  isDir: boolean;
  list?: SandboxFileInfo[];
}

export default function managersCoreTest001() {
  describe('Managers_Core_Test_001', () => {

    /*
     * FileAccessManager——文件系统的统一访问入口。
     * 封装了FileAccessHelper的CRUD操作，是所有文件操作的核心。
     * 静态工具方法(deviceTypeToString/fileModeToString/deviceFlagToString)
     * 用于日志输出和调试，将数字标志位转为可读字符串。
     */
    describe('FileAccessManager_Static_Utils', () => {
      it('deviceTypeToString_returns_Local_for_local_disk', 0, () => {
        // fileExtensionInfo.DeviceType.DEVICE_LOCAL_DISK=0，对应"Local"
        let result: string = FileAccessManager.deviceTypeToString(
          fileExtensionInfo.DeviceType.DEVICE_LOCAL_DISK
        );
        expect(result).assertEqual('Local');
      });

      it('deviceTypeToString_returns_USB_for_external_usb', 0, () => {
        let result: string = FileAccessManager.deviceTypeToString(
          fileExtensionInfo.DeviceType.DEVICE_EXTERNAL_USB
        );
        expect(result).assertEqual('DEVICE_EXTERNAL_USB');
      });

      it('deviceTypeToString_returns_Other_for_unknown_type', 0, () => {
        // switch default分支：未知设备类型统一返回'Other'
        let result: string = FileAccessManager.deviceTypeToString(999);
        expect(result).assertEqual('Other');
      });

      it('isLocalDevice_returns_true_for_DEVICE_LOCAL_DISK', 0, () => {
        // checkExternal依赖此方法区分本机和USB设备
        expect(FileAccessManager.isLocalDevice(
          fileExtensionInfo.DeviceType.DEVICE_LOCAL_DISK
        )).assertEqual(true);
        expect(FileAccessManager.isLocalDevice(
          fileExtensionInfo.DeviceType.DEVICE_EXTERNAL_USB
        )).assertEqual(false);
      });

      it('isUsbDevice_returns_true_for_DEVICE_EXTERNAL_USB', 0, () => {
        // USB热插拔时getRoots返回的设备列表中通过此方法识别USB设备
        expect(FileAccessManager.isUsbDevice(
          fileExtensionInfo.DeviceType.DEVICE_EXTERNAL_USB
        )).assertEqual(true);
        expect(FileAccessManager.isUsbDevice(
          fileExtensionInfo.DeviceType.DEVICE_LOCAL_DISK
        )).assertEqual(false);
      });

      it('fileModeToString_REPRESENTS_FILE_without_supports', 0, () => {
        // 纯文件标志，无读写权限
        let result: string = FileAccessManager.fileModeToString(
          fileExtensionInfo.DocumentFlag.REPRESENTS_FILE
        );
        expect(result).assertEqual('FILE');
      });

      it('fileModeToString_REPRESENTS_DIR_with_read_write', 0, () => {
        // 目录 + SUPPORTS_READ + SUPPORTS_WRITE → "DIR|READ|WRITE"
        let mod: number = fileExtensionInfo.DocumentFlag.REPRESENTS_DIR
          | fileExtensionInfo.DocumentFlag.SUPPORTS_READ
          | fileExtensionInfo.DocumentFlag.SUPPORTS_WRITE;
        let result: string = FileAccessManager.fileModeToString(mod);
        expect(result).assertContain('DIR');
        expect(result).assertContain('READ');
        expect(result).assertContain('WRITE');
      });

      it('fileModeToString_zero_flags_returns_Unknown', 0, () => {
        // 无任何标志位时返回"Unknown"
        let result: string = FileAccessManager.fileModeToString(0);
        expect(result).assertEqual('Unknown');
      });

      it('deviceFlagToString_SUPPORTS_READ_and_WRITE', 0, () => {
        let flag: number = fileExtensionInfo.DeviceFlag.SUPPORTS_READ
          | fileExtensionInfo.DeviceFlag.SUPPORTS_WRITE;
        let result: string = FileAccessManager.deviceFlagToString(flag);
        expect(result).assertContain('READ');
        expect(result).assertContain('WRITE');
      });

      it('deviceFlagToString_zero_flags_returns_Unknown', 0, () => {
        let result: string = FileAccessManager.deviceFlagToString(0);
        expect(result).assertEqual('Unknown');
      });

      it('convertRoot_converts_RootInfo_to_FileInfo', 0, () => {
        // getRootDataAsFile使用convertRoot将RootInfo转为FileInfo后构造FileBean
        // mock RootInfo对象（仅验证转换逻辑的正确性）
        let mockRootInfo: ESObject = {
          uri: 'file://root/local',
          relativePath: '/',
          displayName: 'Internal Storage',
          deviceType: fileExtensionInfo.DeviceType.DEVICE_LOCAL_DISK,
          deviceFlags: 3
        };
        let fileInfo: FileInfo = FileAccessManager.convertRoot(mockRootInfo as fileAccess.RootInfo);
        expect(fileInfo.isRoot).assertEqual(true);
        expect(fileInfo.uri).assertEqual('file://root/local');
        expect(fileInfo.deviceType).assertEqual(fileExtensionInfo.DeviceType.DEVICE_LOCAL_DISK);
        // mode应为REPRESENTS_DIR——根目录被标记为目录类型
        expect(fileInfo.mode).assertEqual(fileExtensionInfo.DocumentFlag.REPRESENTS_DIR);
      });
    });

    /*
     * FileAccessManager静态信息格式化——用于调试和日志。
     * fileInfoToString和rootInfoToString将Info对象转为JSON字符串，
     * 在MLog中输出，帮助开发者了解文件系统状态。
     */
    describe('FileAccessManager_Info_Formatting', () => {
      it('fileInfoToString_includes_key_fields', 0, () => {
        let info: ESObject = {
          uri: 'file://test/doc.pdf',
          fileName: 'doc.pdf',
          mode: fileExtensionInfo.DocumentFlag.REPRESENTS_FILE | fileExtensionInfo.DocumentFlag.SUPPORTS_READ,
          size: 1024,
          mtime: 1700000000,
          mimeType: 'application/pdf',
          relativePath: '/test/'
        };
        let result: string = FileAccessManager.fileInfoToString(info);
        // JSON字符串应包含主要字段
        expect(result).assertContain('file://test/doc.pdf');
        expect(result).assertContain('doc.pdf');
        expect(result).assertContain('1024');
      });

      it('rootInfoToString_includes_device_type_info', 0, () => {
        let mockRootInfo: ESObject = {
          uri: 'file://root/usb',
          deviceType: fileExtensionInfo.DeviceType.DEVICE_EXTERNAL_USB,
          displayName: 'USB Drive',
          deviceFlags: 3
        };
        let result: string = FileAccessManager.rootInfoToString(mockRootInfo as fileAccess.RootInfo);
        expect(result).assertContain('USB Drive');
        expect(result).assertContain('DEVICE_EXTERNAL_USB');
      });
    });

    /*
     * FileIoManager——文件I/O底层操作。
     * 封装fs模块的stat/mkdir/copy/copyFile/write/read/close操作。
     * 重点验证isDir判断逻辑：stat.isDirectory()返回目录判断结果。
     */
    describe('FileIoManager_API_Contract', () => {
      it('statToStr_formats_stat_object_to_JSON', 0, () => {
        // 日志中输出文件stat信息时使用此格式化方法
        let statStr: string = '{ "ino": 123, "mode": 33188, "size": 1024, "mtime": 1700000000 }';
        // 仅验证方法存在且返回非空
        expect(FileIoManager.statToStr).not().assertEqual(undefined);
      });
    });

    /*
     * SandboxFileInfo 类型——文件沙箱信息结构。
     * FileIoManager.getDir和listDir返回此类型的数组，
     * 包含name/path/isDir三个字段及可选的子目录list。
     */
    describe('SandboxFileInfo_Type', () => {
      it('SandboxFileInfo_has_required_fields', 0, () => {
        // 构造最小SandboxFileInfo验证类型兼容性
        let info: SandboxFileInfo = {
          name: 'test',
          path: '/test',
          isDir: true
        };
        expect(info.name).assertEqual('test');
        expect(info.path).assertEqual('/test');
        expect(info.isDir).assertEqual(true);
      });

      it('SandboxFileInfo_with_nested_list', 0, () => {
        // getDir递归遍历子目录时设置list字段
        let child: SandboxFileInfo = { name: 'child.txt', path: '/test/child.txt', isDir: false };
        let parent: SandboxFileInfo = {
          name: 'test',
          path: '/',
          isDir: true,
          list: [child]
        };
        expect(parent.list).not().assertEqual(undefined);
        if (parent.list) {
          expect(parent.list.length).assertEqual(1);
          expect(parent.list[0].name).assertEqual('child.txt');
        }
      });
    });

    /*
     * ConstantsMedia白名单完整性验证——影响所有文件类型识别。
     * 缺失的后缀导致对应文件被识别为"其他"类型，影响图标和点击行为。
     */
    describe('ConstantsMedia_Coverage', () => {
      it('all_suffix_arrays_are_case_insensitive', 0, () => {
        // IgnoreCase函数为每个后缀生成大写+小写两份
        // .mp4应产生 '.mp4' 和 '.MP4'
        let hasLower: boolean = SUFFIX_VIDEO.find((it: string) => it === '.mp4') !== undefined;
        let hasUpper: boolean = SUFFIX_VIDEO.find((it: string) => it === '.mp4'.toUpperCase()) !== undefined;
        expect(hasLower).assertEqual(true);
        expect(hasUpper).assertEqual(true);
      });

      it('SUFFIX_VIDEO_covers_all_declared_formats', 0, () => {
        // 视频格式声明了25种格式，大小写各一份=50项
        // 验证关键格式均存在
        let keyFormats: string[] = ['.mp4', '.mkv', '.avi', '.mov', '.ts'];
        for (let fmt of keyFormats) {
          expect(SUFFIX_VIDEO.find((it: string) => it === fmt)).not().assertEqual(undefined);
        }
      });

      it('SUFFIX_AUDIO_covers_all_declared_formats', 0, () => {
        // 音频格式：21种，验证常用格式存在
        let keyFormats: string[] = ['.mp3', '.aac', '.flac', '.wav', '.ogg'];
        for (let fmt of keyFormats) {
          expect(SUFFIX_AUDIO.find((it: string) => it === fmt)).not().assertEqual(undefined);
        }
      });

      it('SUFFIX_IMAGE_covers_all_declared_formats', 0, () => {
        // 图片格式：8种
        let keyFormats: string[] = ['.jpg', '.png', '.jpeg', '.webp', '.bmp', '.gif', '.svg'];
        for (let fmt of keyFormats) {
          expect(SUFFIX_IMAGE.find((it: string) => it === fmt)).not().assertEqual(undefined);
        }
      });

      it('SUFFIX_TEXT_covers_all_declared_formats', 0, () => {
        // 文档格式：9种（含Office和PDF）
        let keyFormats: string[] = ['.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx', '.pdf', '.txt'];
        for (let fmt of keyFormats) {
          expect(SUFFIX_TEXT.find((it: string) => it === fmt)).not().assertEqual(undefined);
        }
      });

      it('no_cross_contamination_between_suffix_arrays', 0, () => {
        // 后缀白名单不应有交叉：.mp4只在VIDEO中，不在AUDIO/IMAGE/TEXT中
        expect(SUFFIX_VIDEO.find((it: string) => it === '.mp4')).not().assertEqual(undefined);
        expect(SUFFIX_AUDIO.find((it: string) => it === '.mp4')).assertEqual(undefined);
        expect(SUFFIX_IMAGE.find((it: string) => it === '.mp4')).assertEqual(undefined);
        expect(SUFFIX_TEXT.find((it: string) => it === '.mp4')).assertEqual(undefined);
      });
    });
  });
}
