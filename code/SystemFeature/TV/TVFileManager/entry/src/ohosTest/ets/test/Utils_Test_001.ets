import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Tools, FileItemInfo } from '../../../main/ets/common/utils/Tools';
import { FileInfo } from '../../../main/ets/common/data/FileInfo';
import { util } from '@kit.ArkTS';

export default function utilsTest001() {
  describe('Utils_Test_001', () => {

    /*
     * Tools.byte2Str——字节数到可读字符串的转换。
     * FileList列表项和StorageSpaceComponent都依赖此函数显示文件大小和存储空间。
     * 转换规则：<1KB→B, <1MB→KB, <1GB→MB, >=1GB→GB。
     * 保留两位小数，去除尾部的".00"以保持显示简洁。
     */
    describe('Tools_byte2Str', () => {
      it('byte2Str_zero_bytes_returns_0B', 0, () => {
        // 0字节在清空文件或空目录场景中出现
        expect(Tools.byte2Str(0)).assertEqual('0B');
      });

      it('byte2Str_bytes_range_less_than_1KB', 0, () => {
        // B单位范围：[0, 1024)，小于1KB直接以字节显示
        expect(Tools.byte2Str(1)).assertEqual('1B');
        expect(Tools.byte2Str(512)).assertEqual('512B');
        expect(Tools.byte2Str(1023)).assertEqual('1023B');
      });

      it('byte2Str_KB_range_from_1024_to_under_1MB', 0, () => {
        // KB单位范围：[1024, 1048576)
        let result: string = Tools.byte2Str(1024);
        expect(result).assertContain('KB');
        // 1KB = 1024B，显示为1KB (去掉.00)
        expect(result).assertEqual('1KB');
      });

      it('byte2Str_KB_range_with_decimal', 0, () => {
        // 1.5KB = 1536B 应显示保留两位小数
        let result: string = Tools.byte2Str(1536);
        expect(result).assertEqual('1.5KB');
      });

      it('byte2Str_MB_range_from_1MB_to_under_1GB', 0, () => {
        // MB单位范围：[1048576, 1073741824)
        let result: string = Tools.byte2Str(1048576);
        expect(result).assertEqual('1MB');
        let result2: string = Tools.byte2Str(1048576 * 2.5);
        expect(result2).assertEqual('2.5MB');
      });

      it('byte2Str_GB_range_1GB_and_above', 0, () => {
        // GB单位范围：>=1073741824
        let oneGB: number = 1073741824;
        let result: string = Tools.byte2Str(oneGB);
        expect(result).assertEqual('1GB');
        let result2: string = Tools.byte2Str(oneGB * 3.75);
        expect(result2).assertEqual('3.75GB');
      });

      it('byte2Str_trailing_00_is_stripped', 0, () => {
        // "1.00KB" → "1KB"，去除多余小数点
        // 业务目的：TV大屏UI空间有限，无意义的小数位影响可读性
        expect(Tools.byte2Str(1024)).assertEqual('1KB');
        expect(Tools.byte2Str(1048576)).assertEqual('1MB');
      });

      it('byte2Str_large_value_still_formats_correctly', 0, () => {
        // TB级别存储：1TB = 1099511627776 bytes
        let oneTB: number = 1099511627776;
        let result: string = Tools.byte2Str(oneTB);
        expect(result).assertEqual('1024GB');
      });

      it('byte2Str_very_small_decimal_preserves_precision', 0, () => {
        // 0.01KB = 10.24B，向下取整显示
        let result: string = Tools.byte2Str(10);
        expect(result).assertEqual('10B');
      });
    });

    /*
     * Tools.isEmpty——字符串空值判断。
     * 用于FileAccessManager.getList中判断searchText是否为空，
     * 以及多处参数校验。null/undefined/空字符串均返回true。
     */
    describe('Tools_isEmpty', () => {
      it('isEmpty_empty_string_returns_true', 0, () => {
        expect(Tools.isEmpty('')).assertEqual(true);
      });

      it('isEmpty_null_like_falsy_returns_true', 0, () => {
        // Tools.isEmpty内部检查 !text || text.length==0
        // undefined/null均通过!text为true
        expect(Tools.isEmpty('')).assertEqual(true);
      });

      it('isEmpty_non_empty_string_returns_false', 0, () => {
        expect(Tools.isEmpty('hello')).assertEqual(false);
        expect(Tools.isEmpty(' ')).assertEqual(false);
      });

      it('isEmpty_whitespace_only_is_not_empty', 0, () => {
        // 注意：纯空格字符串length>0，不属于empty
        // 这是设计意图——空格是有效搜索输入
        expect(Tools.isEmpty('   ')).assertEqual(false);
      });
    });

    /*
     * Tools.arrayToString / StringToArray——ArrayBuffer与字符串互转。
     * 用于文件内容读写场景，TextDecoder/TextEncoder提供UTF-8编解码。
     */
    describe('Tools_ArrayToString', () => {
      it('ArrayToString_converts_ArrayBuffer_to_string', 0, () => {
        // 模拟读取文件内容后转为字符串显示
        let encoder: util.TextEncoder = new util.TextEncoder();
        let input: string = 'Hello HarmonyOS';
        let encoded: Uint8Array = encoder.encode(input);
        let result: string = Tools.arrayToString(encoded.buffer as ArrayBuffer);
        expect(result).assertEqual(input);
      });

      it('StringToArray_converts_string_to_Uint8Array', 0, () => {
        // 模拟字符串写入文件前转为二进制
        let input: string = 'Test Content 测试内容';
        let result: Uint8Array = Tools.stringToArray(input);
        expect(result).not().assertEqual(undefined);
        expect(result.length > 0).assertEqual(true);
      });

      it('ArrayToString_StringToArray_roundtrip', 0, () => {
        // 编解码往返一致性：encode→decode应得到原始字符串
        let original: string = '中文English混合Content 123';
        let encoded: Uint8Array = Tools.stringToArray(original);
        let decoded: string = Tools.arrayToString(encoded.buffer as ArrayBuffer);
        expect(decoded).assertEqual(original);
      });

      it('ArrayToString_empty_buffer_returns_empty_string', 0, () => {
        let emptyBuf: ArrayBuffer = new ArrayBuffer(0);
        let result: string = Tools.arrayToString(emptyBuf);
        expect(result).assertEqual('');
      });
    });

    /*
     * Tools.parseFileInfo——从原始对象提取文件信息。
     * 用于将API返回的原始数据转为统一fileInfo格式。
     */
    describe('Tools_parseFileInfo', () => {
      it('parseFileInfo_extracts_name_path_type_size', 0, () => {
        let raw: ESObject = {
          uri: 'file://docs/document.pdf',
          fileName: 'document.pdf',
          size: 204800,
          mtime: 0, mimeType: '', relativePath: '', mode: 0
        };
        let result: FileItemInfo = Tools.parseFileInfo(raw);
        expect(result.name).assertEqual('document.pdf');
        expect(result.path).assertEqual('file://docs/document.pdf');
        expect(result.type).assertEqual('file');
        expect(result.size).assertEqual(204800);
      });

      it('parseFileInfo_size_zero_determines_dir_type', 0, () => {
        // size==0 → type="dir"：目录在文件系统中通常size为0
        let raw: ESObject = {
          uri: 'file://storage/MyFolder',
          fileName: 'MyFolder',
          size: 0,
          mtime: 0, mimeType: '', relativePath: '', mode: 0
        };
        let result: FileItemInfo = Tools.parseFileInfo(raw);
        expect(result.type).assertEqual('dir');
      });
    });

    /*
     * Tools.parseUri2FileID——从URI解析文件ID。
     * 用于判断URI是否包含路径分隔符，辅助文件标识。
     */
    describe('Tools_parseUri2FileID', () => {
      it('parseUri2FileID_with_slash_returns_zero', 0, () => {
        // 包含"/"的URI被认为是有效文件路径，返回0
        expect(Tools.parseUri2FileID('file://media/test.txt')).assertEqual(0);
      });

      it('parseUri2FileID_without_slash_returns_negative_one', 0, () => {
        // 无"/"时返回-1
        let result: number = Tools.parseUri2FileID('12345');
        expect(result).assertEqual(-1);
      });

      it('parseUri2FileID_empty_string', 0, () => {
        let result: number = Tools.parseUri2FileID('');
        expect(result).assertEqual(-1);
      });
    });
  });
}
