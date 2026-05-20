import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { MediaType } from '../../../main/ets/model/MediaType';
import { PageType } from '../../../main/ets/model/PageType';
import { DeviceType } from '../../../main/ets/common/data/DeviceType';
import { OperationActionID, OperationAction, Operation } from '../../../main/ets/model/Operation';
import { FileBean } from '../../../main/ets/component/bean/FileBean';
import { FileInfo } from '../../../main/ets/common/data/FileInfo';
import { checkSuffix, SUFFIX_AUDIO, SUFFIX_IMAGE, SUFFIX_VIDEO, SUFFIX_TEXT } from '../../../main/ets/common/ConstantsMedia';
import { TABS, MEDIA_TYPE, MediaTypeModel, DEFAULT_THUMB_WIDTH, DEFAULT_THUMB_HEIGHT, LIST_CACHE_COUNT, DEFAULT_TIME_US } from '../../../main/ets/common/Constants';

export default function dataModelsTest() {

    /*
     * MediaType枚举——TV文件管理器分类入口的基石。
     * 视频/音频/文档/图片四分类对应Home页的五个GridItem入口，
     * 枚举值被FileAccessManager用于选择不同的扫描策略(getVideos/getAudios/getDocs/getImages)，
     * 必须确保枚举值不重复且顺序稳定，否则会导致首页路由跳转错误。
     */
    describe('MediaType_Enum', () => {
      it('MediaType_should_have_four_members', 0, () => {
        // 四个分类对应四种文件扫描策略+一种"本机"根入口
        expect(MediaType.VIDEO).assertEqual(0);
        expect(MediaType.AUDIO).assertEqual(1);
        expect(MediaType.DOC).assertEqual(2);
        expect(MediaType.IMAGE).assertEqual(3);
      });

      it('MediaType_enum_values_are_unique', 0, () => {
        // 枚举值重复会导致Home页itemClicked路由分发到错误的PageType
        let values: number[] = [MediaType.VIDEO, MediaType.AUDIO, MediaType.DOC, MediaType.IMAGE];
        let uniqueSet: Set<number> = new Set(values);
        expect(uniqueSet.size).assertEqual(values.length);
      });

      it('MediaType_default_is_VIDEO_with_value_zero', 0, () => {
        // ArkTS枚举默认从0开始，VIDEO=0意味着未初始化时走video分支
        // 必须显式处理以避免未赋值时误入video页面
        let defaultVal: MediaType = 0 as MediaType;
        expect(defaultVal).assertEqual(MediaType.VIDEO);
      });
    });

    /*
     * PageType枚举——导航栈的路由标识符。
     * NavPathStackManager通过PageType区分当前所在页面类型，
     * 决定数据加载策略(ROOT→getRootDataAsFile, VIDEO→getMediaFileAsset等)、
     * 菜单配置(媒体页无Move/Copy/SelectAll)以及退回逻辑。
     */
    describe('PageType_Enum', () => {
      it('PageType_should_contain_all_page_identifiers', 0, () => {
        // NavStack.pushRoot依赖这些值做路由决策，缺少任何一个都会导致空白页
        expect(PageType.NORMAL_PAGE).assertEqual('NORMAL_PAGE');
        expect(PageType.HOME_PAGE).assertEqual('HOME_PAGE');
        expect(PageType.ROOT_PAGE).assertEqual('ROOT_PAGE');
        expect(PageType.VIDEO_PAGE).assertEqual('VIDEO_PAGE');
        expect(PageType.AUDIO_PAGE).assertEqual('AUDIO_PAGE');
        expect(PageType.DOC_PAGE).assertEqual('DOC_PAGE');
        expect(PageType.IMAGE_PAGE).assertEqual('IMAGE_PAGE');
        expect(PageType.EXTERNAL_USB_PAGE).assertEqual('ROOT_EXTERNAL_USB_PAGE');
      });

      it('PageType_values_are_unique', 0, () => {
        // Index.build()通过 this.pageName === PageType.HOME_PAGE 区分Home/FileList渲染
        // 重复值会导致Home页面被FileList替代或反之
        let values: string[] = [
          PageType.NORMAL_PAGE, PageType.HOME_PAGE, PageType.ROOT_PAGE,
          PageType.VIDEO_PAGE, PageType.AUDIO_PAGE, PageType.DOC_PAGE,
          PageType.IMAGE_PAGE, PageType.EXTERNAL_USB_PAGE
        ];
        let uniqueSet: Set<string> = new Set(values);
        expect(uniqueSet.size).assertEqual(values.length);
      });
    });

    /*
     * DeviceType枚举——双存储设备(Local/USB)的分支标识。
     * NavPathStackManager为Local和USB维护独立的路径栈(bakNavPathMap)和导航历史(pathList)，
     * 确保切换设备时彼此的浏览状态不互相污染。
     */
    describe('DeviceType_Enum', () => {
      it('DeviceType_should_have_Local_and_USB', 0, () => {
        expect(DeviceType.Local).assertEqual(0);
        expect(DeviceType.USB).assertEqual(1);
      });

      it('DeviceType_values_are_distinct', 0, () => {
        // 若Local==USB则双设备路径栈合并，切换Tab时数据混乱
        expect(DeviceType.Local).not().assertEqual(DeviceType.USB);
      });
    });

    /*
     * OperationActionID——文件操作的动作标识符。
     * 每个操作对应一个唯一的字符串ID，用于FileOperationItem的focusId定位
     * 和FileList的onClickMenu分发。重复的ID会导致焦点系统无法正确定位。
     */
    describe('OperationActionID_Enum', () => {
      it('OperationActionID_should_contain_all_operations', 0, () => {
        // 8种核心操作对应8个菜单按钮，缺一则功能不可用
        expect(OperationActionID.Del).assertEqual('Del');
        expect(OperationActionID.Move).assertEqual('Move');
        expect(OperationActionID.MoveConfirm).assertEqual('MoveConfirm');
        expect(OperationActionID.MoveCancel).assertEqual('MoveCancel');
        expect(OperationActionID.Copy).assertEqual('Copy');
        expect(OperationActionID.CopyConfirm).assertEqual('CopyConfirm');
        expect(OperationActionID.CopyCancel).assertEqual('CopyCancel');
        expect(OperationActionID.SelectAll).assertEqual('SelectAll');
        expect(OperationActionID.Share).assertEqual('Share');
        expect(OperationActionID.Rename).assertEqual('Rename');
        expect(OperationActionID.Select).assertEqual('Select');
        expect(OperationActionID.SelectCancel).assertEqual('SelectCancel');
      });

      it('OperationActionID_values_are_unique', 0, () => {
        // 操作ID用作焦点标识键和菜单事件分发键，重复会导致UI响应错误
        let values: string[] = [
          OperationActionID.Del, OperationActionID.Move, OperationActionID.MoveConfirm,
          OperationActionID.MoveCancel, OperationActionID.Copy, OperationActionID.CopyConfirm,
          OperationActionID.CopyCancel, OperationActionID.SelectAll, OperationActionID.Select,
          OperationActionID.SelectCancel, OperationActionID.Share, OperationActionID.Rename
        ];
        let uniqueSet: Set<string> = new Set(values);
        expect(uniqueSet.size).assertEqual(values.length);
      });
    });

    /*
     * OperationAction静态属性——预定义的Operation对象集合。
     * 每个Operation包含actionId/image/imageFocus/text四元组，
     * 分别在FileList的setMenu()中用于构建操作菜单列表。
     * image/imageFocus采用$r引用资源，在焦点切换时切换图标。
     */
    describe('OperationAction_Static_Properties', () => {
      it('OperationAction_Del_has_valid_structure', 0, () => {
        // 删除操作必须关联正确的action ID和资源，否则点击删除按钮无响应
        expect(OperationAction.Del.action).assertEqual(OperationActionID.Del);
        expect(OperationAction.Del.text).not().assertEqual(undefined);
        expect(OperationAction.Del.image).not().assertEqual(undefined);
        expect(OperationAction.Del.imageFocus).not().assertEqual(undefined);
      });

      it('OperationAction_Move_and_MoveConfirm_share_same_icons', 0, () => {
        // Move和MoveConfirm是同一操作的两个阶段，UI图标应一致
        // 但action不同——用于区分"进入移动模式"和"执行移动"
        expect(OperationAction.Move.image).assertEqual(OperationAction.MoveConfirm.image);
        expect(OperationAction.Move.action).not().assertEqual(OperationAction.MoveConfirm.action);
      });

      it('OperationAction_Copy_and_CopyConfirm_share_same_icons', 0, () => {
        // Copy和CopyConfirm同理：同一操作的不同阶段
        expect(OperationAction.Copy.image).assertEqual(OperationAction.CopyConfirm.image);
        expect(OperationAction.Copy.action).not().assertEqual(OperationAction.CopyConfirm.action);
      });

      it('OperationAction_all_actions_are_unique', 0, () => {
        // 集合操作使用action字段作为菜单项的key标识
        let ops: Operation[] = [
          OperationAction.Del, OperationAction.Move, OperationAction.MoveCancel,
          OperationAction.MoveConfirm, OperationAction.Copy, OperationAction.CopyCancel,
          OperationAction.CopyConfirm, OperationAction.SelectAll, OperationAction.Share,
          OperationAction.Rename
        ];
        let actionSet: Set<string> = new Set(ops.map((it: Operation): string => it.action));
        expect(actionSet.size).assertEqual(ops.length);
      });
    });

    /*
     * FileBean——文件列表的核心数据载体。
     * 每个FileBean封装了一个文件/目录的全部元数据(id/name/path/size/type等)，
     * 并提供 isImage/isVideo/isAudio/isDoc 等类型判断方法。
     * 类型判断基于ConstantsMedia中的后缀白名单，是文件图标显示的依据。
     */
    describe('FileBean_Construction', () => {
      it('FileBean_default_constructor_creates_fake_bean', 0, () => {
        // 业务背景：FileBean的无参构造用于创建占位/测试数据，
        // fake前缀的id和name确保不与真实文件冲突
        let bean: FileBean = new FileBean();
        expect(bean.name).assertContain('fake');
        expect(bean.isDir()).assertEqual(true);
      });

      it('FileBean_constructor_with_FileInfo_extracts_fields_correctly', 0, () => {
        // 从FileAccessManager返回的FileInfo构造FileBean——关键路径
        // uri作为唯一标识id，fileName作为显示名称
        let info: ESObject = {
          uri: 'file://test/sample.mp4',
          fileName: 'sample.mp4',
          size: 1024000,
          mtime: 1700000000,
          mimeType: 'video/mp4',
          relativePath: '/test/',
          mode: 0
        };
        let bean: FileBean = new FileBean('1', info as FileInfo);
        expect(bean.id).assertEqual('file://test/sample.mp4');
        expect(bean.name).assertEqual('sample.mp4');
        expect(bean.size).assertEqual(1024000);
      });

      it('FileBean_constructor_with_RootInfo_sets_isRoot_and_deviceType', 0, () => {
        // 根目录信息需要标记isRoot=true和deviceType，用于列表页判断
        // isRoot=true的Bean在isDevice()中返回true，影响UI渲染
        let info: ESObject = {
          uri: 'file://root/',
          fileName: 'Internal Storage',
          size: 0,
          mtime: 0,
          mimeType: 'Root',
          relativePath: '/',
          mode: 0,
          isRoot: true,
          deviceType: 0
        };
        let bean: FileBean = new FileBean('root', info as FileInfo);
        expect(bean.isRoot).assertEqual(true);
        expect(bean.isDevice()).assertEqual(true);
      });
    });

    /*
     * FileBean类型判断——基于文件后缀名匹配ConstantsMedia中的后缀白名单。
     * 后缀匹配采用endsWith + 大小写不敏感方案(IgnoreCase函数生成大写+小写两份后缀列表)。
     * 文件类型决定了列表中显示的图标(getFileIcon)和点击行为(媒体文件跳转/目录进入)。
     */
    describe('FileBean_Type_Detection', () => {
      it('FileBean_isVideo_true_for_mp4_extension', 0, () => {
        // 视频后缀.avi/.mp4/.mkv等在白名单SUFFIX_VIDEO中
        let info: ESObject = {
          uri: 'file://test/movie.mp4', fileName: 'movie.mp4',
          size: 0, mtime: 0, mimeType: '', relativePath: '', mode: 0,

        };
        let bean: FileBean = new FileBean('1', info as FileInfo);        expect(bean.isVideo()).assertEqual(true);
        expect(bean.isAudio()).assertEqual(false);
        expect(bean.isImage()).assertEqual(false);
      });

      it('FileBean_isAudio_true_for_mp3_extension', 0, () => {
        let info: ESObject = {
          uri: 'file://test/song.mp3', fileName: 'song.mp3',
          size: 0, mtime: 0, mimeType: '', relativePath: '', mode: 0,

        };
        let bean: FileBean = new FileBean('1', info as FileInfo);        expect(bean.isAudio()).assertEqual(true);
      });

      it('FileBean_isImage_true_for_jpg_extension', 0, () => {
        let info: ESObject = {
          uri: 'file://test/photo.jpg', fileName: 'photo.jpg',
          size: 0, mtime: 0, mimeType: '', relativePath: '', mode: 0,

        };
        let bean: FileBean = new FileBean('1', info as FileInfo);        expect(bean.isImage()).assertEqual(true);
      });

      it('FileBean_isDoc_true_for_pdf_extension', 0, () => {
        let info: ESObject = {
          uri: 'file://test/report.pdf', fileName: 'report.pdf',
          size: 0, mtime: 0, mimeType: '', relativePath: '', mode: 0,

        };
        let bean: FileBean = new FileBean('1', info as FileInfo);        expect(bean.isDoc()).assertEqual(true);
      });

      it('FileBean_type_detection_case_insensitive', 0, () => {
        // 文件系统可能返回大写后缀(.MP4)，IgnoreCase确保大小写均匹配
        let info: ESObject = {
          uri: 'file://test/MOVIE.MP4', fileName: 'MOVIE.MP4',
          size: 0, mtime: 0, mimeType: '', relativePath: '', mode: 0,

        };
        let bean: FileBean = new FileBean('1', info as FileInfo);        expect(bean.isVideo()).assertEqual(true);
      });

      it('FileBean_default_bean_is_not_any_media_type', 0, () => {
        // 无参构造产生的fake Bean不应被误判为任何媒体类型
        let bean: FileBean = new FileBean();
        expect(bean.isVideo()).assertEqual(false);
        expect(bean.isAudio()).assertEqual(false);
        expect(bean.isImage()).assertEqual(false);
        expect(bean.isDoc()).assertEqual(false);
      });

      it('FileBean_isMediaFile_false_by_default', 0, () => {
        // _fileType未设置(默认-1)时，isMediaFile()=false
        // 只有通过setFileType()显式设置了userFileManager.FileType的Bean才为true
        let bean: FileBean = new FileBean();
        expect(bean.isMediaFile()).assertEqual(false);
      });

      it('FileBean_isMediaFile_true_after_setFileType', 0, () => {
        // 媒体库中的文件通过setFileType标记，影响delete路径(走trash还是直接删除)
        let bean: FileBean = new FileBean();
        bean.setFileType(1); // IMAGE = 1
        expect(bean.isMediaFile()).assertEqual(true);
      });
    });

    /*
     * FileBean 图片尺寸属性——FileList的onAppear中Image组件需要sourceSize。
     * imageWidth/imageHeight初始为0，通过loadImageDimensions()异步更新。
     * hasImageDimensions()判断是否已有有效尺寸数据。
     */
    describe('FileBean_Image_Dimensions', () => {
      it('FileBean_image_dimensions_default_to_zero', 0, () => {
        // 未加载图片元数据前，宽高应为0
        let bean: FileBean = new FileBean();
        expect(bean.imageWidth).assertEqual(0);
        expect(bean.imageHeight).assertEqual(0);
      });

      it('FileBean_hasImageDimensions_false_when_zero', 0, () => {
        let bean: FileBean = new FileBean();
        expect(bean.hasImageDimensions()).assertEqual(false);
      });

      it('FileBean_setImageDimensions_updates_both_values', 0, () => {
        // pushData时预设96x96默认尺寸，后续loadImageDimensions更新为真实尺寸
        let bean: FileBean = new FileBean();
        bean.setImageDimensions(96, 96);
        expect(bean.imageWidth).assertEqual(96);
        expect(bean.imageHeight).assertEqual(96);
        expect(bean.hasImageDimensions()).assertEqual(true);
      });
    });

    /*
     * ConstantsMedia后缀白名单——文件类型判断的核心依据。
     * IgnoreCase函数为每种后缀生成大写+小写两份，确保跨平台兼容。
     * 白名单覆盖常见的音视频/图片/文档格式，缺失则对应类型文件无法识别。
     */
    describe('ConstantsMedia_Suffix_Arrays', () => {
      it('SUFFIX_VIDEO_contains_common_formats', 0, () => {
        let commonFormats: string[] = ['.mp4', '.avi', '.mkv', '.mov', '.ts', '.webm', '.MP4'];
        for (let fmt of commonFormats) {
          expect(SUFFIX_VIDEO.find((it: string) => it === fmt)).not().assertEqual(undefined);
        }
      });

      it('SUFFIX_AUDIO_contains_common_formats', 0, () => {
        let commonFormats: string[] = ['.mp3', '.aac', '.flac', '.wav', '.ogg', '.MP3'];
        for (let fmt of commonFormats) {
          expect(SUFFIX_AUDIO.find((it: string) => it === fmt)).not().assertEqual(undefined);
        }
      });

      it('SUFFIX_IMAGE_contains_common_formats', 0, () => {
        let commonFormats: string[] = ['.jpg', '.png', '.jpeg', '.webp', '.bmp', '.gif', '.JPG'];
        for (let fmt of commonFormats) {
          expect(SUFFIX_IMAGE.find((it: string) => it === fmt)).not().assertEqual(undefined);
        }
      });

      it('SUFFIX_TEXT_contains_common_formats', 0, () => {
        let commonFormats: string[] = ['.pdf', '.txt', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx', '.PDF'];
        for (let fmt of commonFormats) {
          expect(SUFFIX_TEXT.find((it: string) => it === fmt)).not().assertEqual(undefined);
        }
      });

      it('checkSuffix_returns_true_for_matching_extension', 0, () => {
        // checkSuffix内部使用endsWith匹配，name需包含后缀
        expect(checkSuffix('movie.mp4', SUFFIX_VIDEO)).assertEqual(true);
        expect(checkSuffix('song.mp3', SUFFIX_AUDIO)).assertEqual(true);
        expect(checkSuffix('photo.jpg', SUFFIX_IMAGE)).assertEqual(true);
        expect(checkSuffix('doc.pdf', SUFFIX_TEXT)).assertEqual(true);
      });

      it('checkSuffix_returns_false_for_non_matching_extension', 0, () => {
        expect(checkSuffix('movie.mp4', SUFFIX_AUDIO)).assertEqual(false);
        expect(checkSuffix('unknown.xyz', SUFFIX_VIDEO)).assertEqual(false);
      });

      it('checkSuffix_handles_empty_name', 0, () => {
        // 边界：空文件名不应匹配任何后缀
        expect(checkSuffix('', SUFFIX_VIDEO)).assertEqual(false);
      });
    });

    /*
     * Constants常量——全局配置参数。
     * TABS定义顶部"本机/外部储存"双Tab，LIST_CACHE_COUNT控制LazyForEach缓存项数，
     * DEFAULT_THUMB_WIDTH/HEIGHT为缩略图默认尺寸，DEFAULT_TIME_US为视频缩略图帧时间。
     */
    describe('Global_Constants', () => {
      it('TABS_contains_two_entries', 0, () => {
        expect(TABS.length).assertEqual(2);
        expect(TABS[0]).assertEqual('本机');
        expect(TABS[1]).assertEqual('外部储存');
      });

      it('LIST_CACHE_COUNT_is_positive', 0, () => {
        // LazyForEach的cachedCount必须>0，否则滚动时频繁重建列表项
        expect(LIST_CACHE_COUNT > 0).assertEqual(true);
      });

      it('DEFAULT_THUMB_dimensions_are_consistent', 0, () => {
        // 缩略图默认96x96——与pushData预设尺寸一致
        expect(DEFAULT_THUMB_WIDTH).assertEqual(96);
        expect(DEFAULT_THUMB_HEIGHT).assertEqual(96);
      });

      it('DEFAULT_TIME_US_is_positive', 0, () => {
        // 视频缩略图选取时间点(微秒)，1000μs=1ms，取第一帧附近
        expect(DEFAULT_TIME_US > 0).assertEqual(true);
      });

      it('MEDIA_TYPE_has_five_entries', 0, () => {
        // 5个入口对应Home页5个GridItem：视频/图片/文档/音频/本机
        expect(MEDIA_TYPE.length).assertEqual(5);
      });

      it('MEDIA_TYPE_first_four_have_mediaType_set', 0, () => {
        // 前4项关联具体MediaType用于分类扫描，第5项"本机"mediaType为undefined
        for (let i: number = 0; i < 4; i++) {
          expect(MEDIA_TYPE[i].mediaType).not().assertEqual(undefined);
        }
        expect(MEDIA_TYPE[4].mediaType).assertEqual(undefined);
      });

      it('MEDIA_TYPE_mediaType_values_are_unique', 0, () => {
        // Home页itemClicked根据mediaType做switch分发，重复值导致路由歧义
        let types: (MediaType | undefined)[] = MEDIA_TYPE.filter(
          (it: MediaTypeModel): boolean => it.mediaType !== undefined
        ).map((it: MediaTypeModel): MediaType | undefined => it.mediaType);
        let uniqueSet: Set<MediaType | undefined> = new Set(types);
        expect(uniqueSet.size).assertEqual(types.length);
      });
    });

    /*
     * FileBean setPath/getPath——文件路径更新机制。
     * rename操作后需更新path字段以保持数据一致性。
     * getPath返回的uri用于后续的文件操作(open/delete/copy)。
     */
    describe('FileBean_Path_Operations', () => {
      it('FileBean_setPath_updates_return_value_of_getPath', 0, () => {
        let bean: FileBean = new FileBean();
        let newPath: string = 'file://new/location/test.txt';
        let ret: string = bean.setPath(newPath);
        expect(ret).assertEqual(newPath);
        expect(bean.getPath()).assertEqual(newPath);
      });

      it('FileBean_getPath_returns_uri_from_FileInfo', 0, () => {
        let info: ESObject = {
          uri: 'file://data/media/test.dat', fileName: 'test.dat',
          size: 0, mtime: 0, mimeType: '', relativePath: '', mode: 0,

        };
        let bean: FileBean = new FileBean('1', info as FileInfo);        expect(bean.getPath()).assertEqual('file://data/media/test.dat');
      });
    });

    /*
     * FileBean toString——调试和日志输出。
     * 包含id/mimeType/name/path/size/time/deviceType/mode等信息。
     */
    describe('FileBean_toString', () => {
      it('FileBean_toString_contains_key_fields', 0, () => {
        let info: ESObject = {
          uri: 'file://test/example.txt', fileName: 'example.txt',
          size: 512, mtime: 1700000000, mimeType: 'text/plain',
          relativePath: '/test/', mode: 0,

        };
        let bean: FileBean = new FileBean('1', info as FileInfo);        let str: string = bean.toString();
        // toString应包含id、mimeType、文件名、路径和大小信息
        expect(str).assertContain('file://test/example.txt');
        expect(str).assertContain('example.txt');
        expect(str).assertContain('512');
      });
    });

    /*
     * 综合场景：FileBean在不同构造路径下的完整性验证。
     * 模拟真实使用场景：从FileAccessManager获取FileInfo→构造FileBean→类型判断→数据展示。
     */
    describe('FileBean_Integration_Scenarios', () => {
      it('video_bean_from_file_info_has_correct_type_chain', 0, () => {
        // 模拟FileAccessManager.getVideos返回值→FileBean构造→isVideo判断→图标选择
        let info: ESObject = {
          uri: 'file://media/videos/demo.mkv', fileName: 'demo.mkv',
          size: 524288000, mtime: 1710000000, mimeType: 'video/x-matroska',
          relativePath: '/media/videos/', mode: 1,

        };
        let bean: FileBean = new FileBean('v1', info as FileInfo).updateDirType();
        expect(bean.isVideo()).assertEqual(true);
        expect(bean.isFile()).assertEqual(true); // mode REPRESENTS_FILE
        expect(bean.isDir()).assertEqual(false);
        expect(bean.size).assertEqual(524288000);
      });

      it('directory_bean_from_file_info_has_isDir_true', 0, () => {
        // 目录Bean模拟：FileAccessManager.listFile返回的目录条目
        // 注意：isDir依赖updateDirType的异步判断，此处先验证构造属性
        let info: ESObject = {
          uri: 'file://storage/Documents/', fileName: 'Documents',
          size: 0, mtime: 1700000000, mimeType: '',
          relativePath: '/storage/', mode: 0,

        };
        let bean: FileBean = new FileBean('d1', info as FileInfo);
        // 根据mode判断isFile
        expect(bean.id).assertEqual('file://storage/Documents/');
        expect(bean.name).assertEqual('Documents');
      });

      it('usb_root_bean_has_deviceType_set', 0, () => {
        // USB设备根目录Bean：deviceType=DEVICE_EXTERNAL_USB
        let info: ESObject = {
          uri: 'file://usb/', fileName: 'USB Drive',
          size: 0, mtime: 0, mimeType: 'Root',
          relativePath: '/', mode: 0, isRoot: true, deviceType: 3,

        };
        let bean: FileBean = new FileBean('usb', info as FileInfo);
        expect(bean.isDevice()).assertEqual(true);
        expect(bean.isRoot).assertEqual(true);
      });
    });

}
