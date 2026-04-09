import { AsyncCallback, Callback } from './@ohos.base'

/**
 * @namespace displaySetting
 * @syscap SystemCapability.Multimedia.TvService.Display
 * @atomicservice
 * @since 12
 */
declare namespace displaySetting {
  enum VideoAspect {
    VIDEO_ASPECT_16_9 = 0,
    VIDEO_ASPECT_14_9 = 1,
    VIDEO_ASPECT_4_3 = 2,
    VIDEO_ASPECT_FULL = 3,
    VIDEO_ASPECT_POINT_TO_POINT = 4,
    VIDEO_ASPECT_AUTO = 5,
    VIDEO_ASPECT_SUBTITLE = 6,
    VIDEO_ASPECT_PERSON = 7,
    VIDEO_ASPECT_CINEMA = 8,
    VIDEO_ASPECT_PANORAMA = 9,
    VIDEO_ASPECT_ZOOM = 10,
    VIDEO_ASPECT_ZOOM1 = 11,
    VIDEO_ASPECT_ZOOM2 = 12,
    VIDEO_ASPECT_TRUTH = 13,
    VIDEO_ASPECT_21_9 = 14,
    VIDEO_ASPECT_BUTT = 15,
  }

  interface ColorTempParam {
    redGain: number;
    greenGain: number;
    blueGain: number;
    redOffset: number;
    greenOffset: number;
    blueOffset: number;
  }

  enum ColorType {
    WHITE = 1, // 对应 #define WHITE 1
    WARMWHITE = 2, // 对应 #define WARMWHITE 2
    WARMYELLOW = 3 // 对应 #define WARMYELLOW 3
  }

  enum ColorTempMode {
    COLOR_TEMP_MODE_DEFAULT = 0,
    COLOR_TEMP_MODE_NATURAL_TONE = 1,
    COLOR_TEMP_MODE_EYE_PROTECT = 2,
    COLOR_TEMP_MODE_BUTT
  }

  enum CommonLevel {
    COMMON_LEVEL_OFF,
    COMMON_LEVEL_LOW,
    COMMON_LEVEL_MID,
    COMMON_LEVEL_HIGH,
    COMMON_LEVEL_AUTO,
    COMMON_LEVEL_BUTT
  }

  enum RandomNr {
    RANDOM_LEVEL_CLOSE = 0,
    RANDOM_LEVEL_LOW = 1,
    RANDOM_LEVEL_MEDIUM = 2,
    RANDOM_LEVEL_HIGH = 3,
    RANDOM_LEVEL_AUTO = 4
  }

  enum MPEGNr {
    MPEG_LEVEL_CLOSE = 0,
    MPEG_LEVEL_LOW = 1,
    MPEG_LEVEL_MEDIUM = 2,
    MPEG_LEVEL_HIGH = 3,
    MPEG_LEVEL_AUTO = 4
  }

  enum GammaType {
    GAMMA_TYPE_18 = 0,
    GAMMA_TYPE_19 = 1,
    GAMMA_TYPE_20 = 2,
    GAMMA_TYPE_21 = 3,
    GAMMA_TYPE_22 = 4,
    GAMMA_TYPE_23 = 5,
    GAMMA_TYPE_24 = 6,
    GAMMA_TYPE_25 = 7,
    GAMMA_TYPE_26 = 8
  }

  enum EyeProtectMode {
    WHITE = 6000,
    WARMYELLOW = 3000,
    WARMWHITE = 4500,
  }

  enum ColorTempPoint {
    COLOR_TEMP_5000K = 5000,
    COLOR_TEMP_5500K = 5500,
    COLOR_TEMP_6000K = 6000,
    COLOR_TEMP_6300K = 6300,
    COLOR_TEMP_6500K = 6500,
    COLOR_TEMP_7000K = 7000,
    COLOR_TEMP_7500K = 7500,
    COLOR_TEMP_8000K = 8000,
    COLOR_TEMP_8500K = 8500,
    COLOR_TEMP_9000K = 9000,
    COLOR_TEMP_9300K = 9300,
    COLOR_TEMP_9500K = 9500,
    COLOR_TEMP_10000K = 10000,
    COLOR_TEMP_10500K = 10500,
    COLOR_TEMP_11000K = 11000,
    COLOR_TEMP_11500K = 11500,
    COLOR_TEMP_12000K = 12000,
  }

  enum PictureMode {
    PICTURE_MODE_STANDARD = 0, 
    PICTURE_MODE_VIVID,
    PICTURE_MODE_MOVIE,
    PICTURE_MODE_SPORTS,
    PICTURE_MODE_PICTURE,
    PICTURE_MODE_GAME,
    PICTURE_MODE_PC,
    PICTURE_MODE_MASTER,
    PICTURE_MODE_AUTO,
    PICTURE_MODE_BUTT
  }

  enum HdcpType {
    HDCP_AUTO = 1,
    HDCP_14 = 2,
    HDCP_2X = 3,
  }

  enum InputSource {
    HDMI1 = 0,
    HDMI2 = 1,
    AV = 2
  }

  enum SourceType {
    SOURCE_MEDIA,
    SOURCE_HDMI1,
    SOURCE_HDMI2,
    SOURCE_HDMI3,
    SOURCE_HDMI4,
    SOURCE_CVBS1,
    SOURCE_DTMB,
    SOURCE_DVBC,
    SOURCE_DVBT,
    SOURCE_CAST,
    SOURCE_GRAPHIC,
    SOURCE_NETWORK,
    SOURCE_BUTT
  }

  enum HdmiRxEdidType {
    HDMIRX_EDID_TYPE_AUTO = 0,
    HDMIRX_EDID_TYPE_14 = 1,
    HDMIRX_EDID_TYPE_20 = 2,
    HDMIRX_EDID_TYPE_21 = 3,
    HDMIRX_EDID_TYPE_21_VRR_FSY = 4,
    HDMIRX_EDID_TYPE_BUTT = 5
  }

  enum SignalStatus {
    SIGNAL_SUPPORT = 0,
    SIGNAL_NOSIGNAL = 1,
    SIGNAL_UNSUPPORT = 2,
    SIGNAL_UNSTABLE = 3,
    SIGNAL_BUTT = 4,
  }

  enum CecDevMenuCommand {
    CEC_DEV_MENU_COMMAND_SELECT = 0,
    CEC_DEV_MENU_COMMAND_UP = 1,
    CEC_DEV_MENU_COMMAND_DOWN = 2,
    CEC_DEV_MENU_COMMAND_LEFT = 3,
    CEC_DEV_MENU_COMMAND_RIGHT = 4,
    CEC_DEV_MENU_COMMAND_EXIT = 5,
    CEC_DEV_MENU_COMMAND_ENTER = 6,
    CEC_DEV_MENU_COMMAND_PLAY = 7,
    CEC_DEV_MENU_COMMAND_VOLUP = 8,
    CEC_DEV_MENU_COMMAND_VOLDOWN = 9,
    CEC_DEV_MENU_COMMAND_MUTE = 10,
    CEC_DEV_MENU_COMMAND_STOP = 11,
    CEC_DEV_MENU_COMMAND_PAUSE = 12,
    CEC_DEV_MENU_COMMAND_REWIND = 13,
    CEC_DEV_MENU_COMMAND_FASTFORWARD = 14,
    CEC_DEV_MENU_COMMAND_FORWARD = 15,
    CEC_DEV_MENU_COMMAND_BACKWARD = 16,
    CEC_DEV_MENU_COMMAND_ROOTMENU = 17,
    CEC_DEV_MENU_COMMAND_SETUPMENU = 18,
    CEC_DEV_MENU_COMMAND_CONTENTSMENU = 19,
    CEC_DEV_MENU_COMMAND_FAVORITEMENU = 20,
    CEC_DEV_MENU_COMMAND_POWERTOGGLE = 21,
    CEC_DEV_MENU_COMMAND_POWERON = 22,
    CEC_DEV_MENU_COMMAND_POWEROFF = 23,

    CEC_DEV_MENU_COMMAND_NUMMODE = 24,
    CEC_DEV_MENU_COMMAND_NUM0 = 25,
    CEC_DEV_MENU_COMMAND_NUM1 = 26,
    CEC_DEV_MENU_COMMAND_NUM2 = 27,
    CEC_DEV_MENU_COMMAND_NUM3 = 28,
    CEC_DEV_MENU_COMMAND_NUM4 = 29,
    CEC_DEV_MENU_COMMAND_NUM5 = 30,
    CEC_DEV_MENU_COMMAND_NUM6 = 31,
    CEC_DEV_MENU_COMMAND_NUM7 = 32,
    CEC_DEV_MENU_COMMAND_NUM8 = 33,
    CEC_DEV_MENU_COMMAND_NUM9 = 34,
    CEC_DEV_MENU_COMMAND_NUM10 = 35,
    CEC_DEV_MENU_COMMAND_NUM11 = 36,
    CEC_DEV_MENU_COMMAND_NUM12 = 37,

    CEC_DEV_MENU_COMMAND_BUTT
  }

  enum CecUiMenu {
    CEC_UI_MENU_ENABLE = 0,
    CEC_UI_MENU_ONETCHPLY = 1,
    CEC_UI_MENU_STANDBY = 2,
    CEC_UI_MENU_DEVMENUCTRL = 3,
    CEC_UI_MENU_AMPLIFIER = 4,
    CEC_UI_MENU_ARC = 5,
    CEC_UI_MENU_BUTT = 6
  }

  interface CecDevMenuAndEnable {
    cecUiMenu: CecUiMenu;
    enable: boolean;
  }

  interface ScreenTiming {
    width: number;
    height: number;
    frameRate: number;
    interlace: boolean;
    formatHdmi: HdmiFormat;
    colorSpace: ColorSpaceType;
    mhl: boolean;
  }

  enum HdmiFormat {
    HDMI_FORMAT_HDMI = 0,
    HDMI_FORMAT_DVI = 1,
    HDMI_FORMAT_MHL = 2,
    HDMI_FORMAT_BUTT
  }

  enum ColorSpaceType {
    COLOR_SPACE_UNKNOWN = 0,
    COLOR_SPACE_BT601_YUV_LIMITED = 0x10,
    COLOR_SPACE_BT601_YUV_FULL = 0x11,
    COLOR_SPACE_BT601_RGB_LIMITED = 0x12,
    COLOR_SPACE_BT601_RGB_FULL = 0x13,
    COLOR_SPACE_NTSC1953 = 0x20,
    COLOR_SPACE_BT470_SYSTEM_M = 0x30,
    COLOR_SPACE_BT470_SYSTEM_BG = 0x31,
    COLOR_SPACE_BT709_YUV_LIMITED = 0x40,
    COLOR_SPACE_BT709_YUV_FULL = 0x41,
    COLOR_SPACE_BT709_RGB_LIMITED = 0x42,
    COLOR_SPACE_BT709_RGB_FULL = 0x43,
    COLOR_SPACE_BT2020_YUV_LIMITED = 0x44,
    COLOR_SPACE_BT2020_YUV_FULL = 0x45,
    COLOR_SPACE_BT2020_RGB_LIMITED = 0x46,
    COLOR_SPACE_BT2020_RGB_FULL = 0x47,
    COLOR_SPACE_REC709 = 0x50,
    COLOR_SPACE_SMPT170M = 0x60,
    COLOR_SPACE_SMPT240M = 0x61,
    COLOR_SPACE_BT878 = 0x70,
    COLOR_SPACE_XVYCC = 0x80,
    COLOR_SPACE_JPEG = 0x90,
    COLOR_SPACE_RGB = 0xa0,
    COLOR_SPACE_BUTT
  }

  enum PqModuleType {
    PQ_MODULE_FMD = 0,
    PQ_MODULE_NR = 1,
    PQ_MODULE_DB = 2,
    PQ_MODULE_DR = 3,
    PQ_MODULE_DS = 4,
    PQ_MODULE_HSHARPNESS = 5,
    PQ_MODULE_SHARPNESS = 6,
    PQ_MODULE_CCCL = 7,
    PQ_MODULE_COLOR_CORING = 8,
    PQ_MODULE_BLUE_STRETCH = 9,
    PQ_MODULE_GAMMA = 10,
    PQ_MODULE_DBC = 11,
    PQ_MODULE_DCI = 12,
    PQ_MODULE_COLOR = 13,
    PQ_MODULE_SR = 14,
    PQ_MODULE_WCG = 15,
    PQ_MODULE_HDR = 16,
    PQ_MODULE_IQTM = 17,
    PQ_MODULE_SDR2HDR = 18,
    PQ_MODULE_ALL = 19,
    PQ_MODULE_3DLUT = 20,
    PQ_MODULE_COLOR_TEMP = 21,
    PQ_MODULE_CLE_4K,
    PQ_MODULE_CACM,

    PQ_MODULE_BUTT,
  }

  enum HdrType {
    HDR_TYPE_SDR = 0,
    HDR_TYPE_HDR10 = 1,
    HDR_TYPE_HLG = 2,
    HDR_TYPE_CUVA = 3,

    HDR_TYPE_BUTT
  }

  enum UserHdrType {
    USER_HDR_TYPE_AUTO = 0,
    USER_HDR_TYPE_CUVA = 1,
    USER_HDR_TYPE_HDR10 = 2,
    USER_HDR_TYPE_HLG = 3,
    USER_HDR_TYPE_OFF = 4,
    USER_HDR_TYPE_BUTT = 5,
  }

  enum ColorManagementMode {
    COLOR_MANAGE_AUTO = 0,
    COLOR_MANAGE_HDR10 = 1,
    COLOR_MANAGE_HLG = 2,
    COLOR_MANAGE_HDTV = 3,
    COLOR_MANAGE_SRGB = 4,
    COLOR_MANAGE_P3_DCI = 5,
    COLOR_MANAGE_P3_D65 = 6,
    COLOR_MANAGE_P3_D50 = 7,
    COLOR_MANAGE_ADOBERGB = 8,
    COLOR_MANAGE_EBU = 9,
    COLOR_MANAGE_SMPTE_C = 10,
    COLOR_MANAGE_USER1 = 11,
    COLOR_MANAGE_USER2 = 12,
    COLOR_MANAGE_P3_PG = 13, // Display P3
    COLOR_MANAGE_CUVA = 14,
    COLOR_MANAGE_NATIVE = 15,
    COLOR_MANAGE_IDEA_NATIVE = 16,
    COLOR_MANAGE_BUTT = 17,
  }

  enum ColorGamutType {
    COLOR_GAMUT_AUTO = 0,
    COLOR_GAMUT_BT2020 = 1,
    COLOR_GAMUT_P3 = 2,
    COLOR_GAMUT_ADOBERGB = 3,
    COLOR_GAMUT_BT709 = 4,
    COLOR_GAMUT_BT601_EBU = 5,
    COLOR_GAMUT_BT601_SMPTE = 6,
    COLOR_GAMUT_NATIVE = 7,
    COLOR_GAMUT_BUTT = 8,
  }

  enum WhitePointType {
    WHITE_POINT_AUTO = 0,
    WHITE_POINT_D50,
    WHITE_POINT_D60,
    WHITE_POINT_D63,
    WHITE_POINT_D65,
    WHITE_POINT_D93,
    WHITE_POINT_NATIVE,

    WHITE_POINT_BUTT
  }

  enum OetfType {
    OETF_AUTO = 0,
    OETF_BT709,
    OETF_SRGB,
    OETF_22,
    OETF_24,
    OETF_26,
    OETF_ST2084,
    OETF_HLG,
    OETF_NATIVE,
    OETF_BUTT,
  }

  interface ColorManage {
    colorGamut: ColorGamutType;
    whitePoint: WhitePointType;
    oetf: OetfType;
  }

  interface CecDeviceInfo {
    updated: number;
    logicAddr: number;
    physicalAddr: number;
    hdmiDevPort: number;
    devVendId: number;
    osdName: string;
  }

  interface SourceSignal {
    status: SignalStatus;
    source: SourceType;
  }

  enum GammaCaliPoint {
    GAMMA_CALIPOINT_1 = 0,
    GAMMA_CALIPOINT_2,
    GAMMA_CALIPOINT_3,
    GAMMA_CALIPOINT_4,
    GAMMA_CALIPOINT_5,
    GAMMA_CALIPOINT_6,
    GAMMA_CALIPOINT_7,
    GAMMA_CALIPOINT_8,
    GAMMA_CALIPOINT_9,
    GAMMA_CALIPOINT_10,
    GAMMA_CALIPOINT_BUTT,
  }

  interface GammaCaliParam {
    colorR: number;
    colorG: number;
    colorB: number;
  }


enum WakeupType {
    WAKEUP_TYPE_IR = 0,             // 被IR唤醒
    WAKEUP_TYPE_KEYLED = 1,         // 被前面板key唤醒
    WAKEUP_TYPE_TIMEOUT = 2,        // 被定时中断唤醒
    WAKEUP_TYPE_ETH = 3,            // 被网络终端唤醒
    WAKEUP_TYPE_USB = 4,            // 被USB鼠标键盘中断唤醒
    WAKEUP_TYPE_GPIO = 5,           // 被GPIO中断唤醒
    WAKEUP_TYPE_LSADC = 6,          // 被LowSpeedADC唤醒
    WAKEUP_TYPE_UART = 7,           // 被UART唤醒
    WAKEUP_TYPE_VGA = 8,            // 被VGA唤醒
    WAKEUP_TYPE_HDMI = 9,          // 被HDMI唤醒
    WAKEUP_TYPE_SCART = 10,         // 被SCART唤醒
    WAKEUP_TYPE_TIMEOUT_BG = 11,    // 被定时唤醒运行后台程序
    WAKEUP_TYPE_VOICE = 12,         // 被语音唤醒
    WAKEUP_TYPE_HDMIRX_CEC = 13,    // 被HDMIRX CEC唤醒
    WAKEUP_TYPE_HDMITX_CEC = 14,    // 被HDMITX CEC唤醒
    WAKEUP_TYPE_BUTT
}

enum StandByMode {
    STANDBY_STR,     // STR待机
	STANDBY_LIGHTSLEEP,   // 熄屏待机
    STANDBY_SHUTDOWN,      // 关机待机
    STANDBY_BUTT
}

enum PowerOnMode {
    POWER_ON = 0,  // 立即开机
    POWER_STANDBY = 1,  // 待机
    POWER_MEMORY = 2,  // 记忆状态开机
    POWER_ON_MODE_BUTT 
}

enum MemoryFlag {
    MEMORY_FLAG_RUN = 0,      // 正常运行标记
    MEMORY_FLAG_SUSPEND,     // 待机标记
    MEMORY_FLAG_BUTT,
}

  /**
   * 设置非线性参数
   * @param nlaItem -NlaItem: 枚举类型，具体值见定义.
   * @param nlaPoint –NlaPoint: 枚举类型，具体值见定义.
   * @return 设置成功返回true, 返回其他表示失败.
   */
  function setNlaPoint(nlaItem: NlaItem, nlaPoint: NlaPoint, callback: AsyncCallback<boolean>): void;
  /**
   * 设置画面比例
   * @param VideoAspect 类型, 取值范围 [0, 14]；
   * @return 设置成功返回true, 返回其他表示失败.
   */
  function setAspect(value: VideoAspect, callback: AsyncCallback<boolean>): void;

  /**
   * 设置画面比例
   * @param VideoAspect 类型, 取值范围 [0, 14]；
   * @return 设置成功返回true, 返回其他表示失败.
   */
  function setAspect(value: VideoAspect): Promise<boolean>;

  /**
   * 获取画面比例
   * @return VideoAspect 类型, 取值范围 [0, 14]；
   */
  function getAspect(callback: AsyncCallback<VideoAspect>): void;

  /**
   * 获取画面比例
   * @return VideoAspect 类型, 取值范围 [0, 14]；
   */
  function getAspect(): Promise<VideoAspect>;

  /**
   * 设置亮度
   * @param value –number: 亮度值，取值范围 [0, 100].
   * @return 设置成功返回true, 返回其他表示失败.
   */
  function setBrightness(value: number, callback: AsyncCallback<boolean>): void;

  /**
   * 设置亮度
   * @param value –number: 亮度值，取值范围 [0, 100].
   * @return 设置成功返回true, 返回其他表示失败.
   */
  function setBrightness(value: number): Promise<boolean>;

  /**
   * 获取亮度
   * @return Number 类型, 取值范围 [0, 100].
   */
  function getBrightness(): Promise<number>;


  /**
   * 设置背光亮度值
   * @return Number 类型, 取值范围 [1, 4]；
   */
  function setBacklight(type: number): Promise<boolean>;

  /**
   * 设置背光亮度值
   * @return Number 类型, 取值范围 [1, 4]；
   */
  function setBacklight(type: number, callback: AsyncCallback<boolean>): void;

  /**
   * 获取背光亮度值
   * @return Number 类型, 取值范围 [1, 4]；
   */
  function getBacklight(): Promise<number>;

  /**
   * 获取背光亮度值
   * @return Number 类型, 取值范围 [1, 4]；
   */
  function getBacklight(callback: AsyncCallback<number>): void;

  /**
   * 设置锐利度
   * @param value –number: 锐利度，取值范围 [0, 100]。
   * @return 设置成功返回true, 返回其他表示失败.
   */
  function setSharpness(value: number, callback: AsyncCallback<boolean>): void;

  /**
   * 设置锐利度
   * @param value –number: 锐利度，取值范围 [0, 100]。
   * @return 设置成功返回true, 返回其他表示失败.
   */
  function setSharpness(value: number): Promise<boolean>;

  /**
   * 获取锐利度的值
   * @return Number 类型, 取值范围 [0, 100]。
   */
  function getSharpness(): Promise<number>;

  /**
   * 打开动态背光
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function enableDynamicBacklight(callback: AsyncCallback<boolean>): void;

  /**
   * 打开动态背光
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function enableDynamicBacklight(): Promise<boolean>;

  /**
   * 关闭动态背光
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function disableDynamicBacklight(callback: AsyncCallback<boolean>): void;

  /**
   * 关闭动态背光
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function disableDynamicBacklight(): Promise<boolean>;

  /**
   * 获取动态背光状态
   * @return boolean 类型
   */
  function isDynamicBacklight(): Promise<number>;

  /**
   * 是否支持动态背光
   * @return boolean 类型
   */
  function isDynamicBacklightSupport(): Promise<boolean>;

  /**
   * 色温精细调节
   * @param point -ColorTempPoint: 枚举类型，具体值见定义。 param -ColorTempParam：结构体，包含多个参数，具体见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setColorTempParamStep(point: ColorTempPoint, param: ColorTempParam, callback: AsyncCallback<boolean>): void;

  /**
   * 色温精细调节
   * @param point -ColorTempPoint: 枚举类型，具体值见定义。 param -ColorTempParam：结构体，包含多个参数，具体见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setColorTempParamStep(point: ColorTempPoint, param: ColorTempParam): Promise<boolean>;

  /**
   * 获取色温参数
   * @return ColorTempParam 结构体。
   */
  function getColorTempParam(): Promise<ColorTempParam>;

  /**
   * Enables the Eye function of the Picture.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function enableEyeProtected(callback: AsyncCallback<boolean>): void;

  /**
   * Enables the Eye function of the Picture.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function enableEyeProtected(): Promise<boolean>;

  /**
   * Disables the Eye function of the Picture.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function disableEyeProtected(callback: AsyncCallback<boolean>): void;

  /**
   * Disables the Eye function of the Picture.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function disableEyeProtected(): Promise<boolean>;


  /**
   * 设置MEMC等级
   * @param value -CommonLevel: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setMemcLevel(value: CommonLevel, callback: AsyncCallback<boolean>): void;

  /**
   * 设置MEMC等级
   * @param value -CommonLevel: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setMemcLevel(value: CommonLevel): Promise<boolean>;

  /**
   * 获取MEMC等级
   * @param value -CommonLevel: 枚举类型，具体值见定义。
   * @return 获取成功返回true, 返回其他表示失败。
   */
  function getMemcLevel(): Promise<CommonLevel>;


  /**
   * 设置十点伽马校准-大师模式
   * @param value -CommonLevel: 枚举类型，具体值见定义。
   * @return 获取成功返回true, 返回其他表示失败。
   */
  function set10PointGamma(value: GammaCaliPoint, parm: GammaCaliParam, callback: AsyncCallback<boolean>): void;

  function set10PointGamma(value: GammaCaliPoint, parm: GammaCaliParam): Promise<boolean>;

  /**
   * 获取十点伽马校准-大师模式
   * @return Array<GammaCaliParam>
   */
  function get10PointGamma(callback: AsyncCallback<Array<GammaCaliParam>>): void;

  function get10PointGamma(): Promise<Array<GammaCaliParam>>;

  /**
   * 恢复十点伽马校准-大师模式
   * @return 获取成功返回true, 返回其他表示失败。
   */
  function restore10PointGamma(callback: AsyncCallback<boolean>): void;

  function restore10PointGamma(): Promise<boolean>;


  /**
   * 获取支持图像模式列表
   * @param mode -PictureMode: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function getSupportPictureModeList(callback: AsyncCallback<Array<Number>>): void;

  function getSupportPictureModeList(): Promise<Array<Number>>;

  /**
   * 恢复当前图像模式默认数值
   *
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function restoreCurrentPictureMode(callback: AsyncCallback<boolean>): void;

  function restoreCurrentPictureMode(): Promise<boolean>;

  /**
   * 设置伽马类型
   * @param type -GammaType: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setGammaType(type: GammaType, callback: AsyncCallback<boolean>): void;

  /**
   * 设置伽马类型
   * @param type -GammaType: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setGammaType(type: GammaType): Promise<boolean>;

  /**
   * 获取伽马类型
   * @param type -GammaType: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function getGammaType(): Promise<number>;

  /**
   * 设置Hdr处理类型
   * @param type -UserHdrType: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setUserHdrType(type: UserHdrType, callback: AsyncCallback<boolean>): void;

  /**
   * 设置Hdr处理类型
   * @param type -UserHdrType: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setUserHdrType(type: UserHdrType): Promise<boolean>;

  /**
   * 获取Hdr处理类型
   * @param type -UserHdrType: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function getUserHdrType(): Promise<UserHdrType>;

  /**
   * 设置色彩空间模式​​
   * @param mode -ColorManagementMode: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setColorManageMode(mode: ColorManagementMode, callback: AsyncCallback<boolean>): void;

  /**
   * 设置色彩空间模式​​
   * @param mode -ColorManagementMode: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setColorManageMode(mode: ColorManagementMode): Promise<boolean>;

  /**
   * 获取色彩空间模式​​
   * @param mode -ColorManagementMode: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function getColorManageMode(): Promise<ColorManagementMode>;

  /*设置CEC状态*/
  function setColorTempCali(type: ColorTempParam, callback: AsyncCallback<boolean>): void;

  function setColorTempCali(type: ColorTempParam): Promise<boolean>;

  function getColorTempCali(): Promise<ColorTempParam>;

  /**
   * 色温精细调节
   * @param point -ColorTempPoint: 枚举类型，具体值见定义。 param -ColorTempParam：结构体，包含多个参数，具体见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setColorTempParamStep(point: ColorTempPoint, callback: AsyncCallback<boolean>): void;

  /**
   * 色温精细调节
   * @param point -ColorTempPoint: 枚举类型，具体值见定义。 param -ColorTempParam：结构体，包含多个参数，具体见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setColorTempParamStep(point: ColorTempPoint): Promise<boolean>;

  /**
   * 获取色温参数
   * @return ColorTempParam 结构体。
   */
  function getColorTempParamStep(): Promise<ColorTempPoint>;

  /**
   * 设置色温
   * @param colorTemp -ColorTempMode: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setColorTempType(colorTemp: ColorTempMode, callback: AsyncCallback<boolean>): void;

  /**
   * 设置色温
   * @param colorTemp -ColorTempPoint: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setColorTempType(colorTemp: ColorTempMode): Promise<boolean>;

  function getColorTempType(): Promise<ColorTempMode>;

  /**
   * 设置饱和度
   * Sets the saturation (chrominance) of the video output. This setting does not apply to a single video output unit.
   * It takes effect for all video output units at the same time.
   * @devices tv, phone, tablet, wearable
   * @param value –number: Indicates the saturation (chrominance). The value ranges from 0 to 100 in ascending order.
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function setSaturation(value: number, callback: AsyncCallback<boolean>): void;

  /**
   * Sets the saturation (chrominance) of the video output. This setting does not apply to a single video output unit.
   * It takes effect for all video output units at the same time.
   * @devices tv, phone, tablet, wearable
   * @param value –number: Indicates the saturation (chrominance). The value ranges from 0 to 100 in ascending order.
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function setSaturation(value: number): Promise<boolean>;

  /**
   * Obtains the saturation (chrominance) of the video output.
   * @devices tv, phone, tablet, wearable
   * @return Number type, indicating the saturation (chrominance) of the video output. The value ranges from 0 to 100 in ascending order.
   */
  function getSaturation(): Promise<number>;

  /**
   * Sets the contrast of the video output. This setting does not apply to a single video output unit.
   * It takes effect for all video output units at the same time.
   * @devices tv, phone, tablet, wearable
   * @param value –number: indicates the contrast of the video output. The value ranges from 0 to 100 in ascending order.
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function setContrast(value: number, callback: AsyncCallback<boolean>): void;

  /**
   * Sets the contrast of the video output. This setting does not apply to a single video output unit.
   * It takes effect for all video output units at the same time.
   * @devices tv, phone, tablet, wearable
   * @param value –number: indicates the contrast of the video output. The value ranges from 0 to 100 in ascending order.
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function setContrast(value: number): Promise<boolean>;

  /**
   * Obtains the contrast of the video output.
   * @devices tv, phone, tablet, wearable
   * @return Number type, indicating the contrast of the video output. The value ranges from 0 to 100 in ascending order.
   */
  function getContrast(): Promise<number>;

  /**
   * Sets the hue of the video output. This setting does not apply to a single video output unit.
   * It takes effect for all video output units at the same time.
   * @devices tv, phone, tablet, wearable
   * @param value –number: indicates the hue of the video output. The value ranges from 0 to 100 in ascending order.
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function setDisplayHue(value: number, callback: AsyncCallback<boolean>): void;

  /**
   * Sets the hue of the video output. This setting does not apply to a single video output unit.
   * It takes effect for all video output units at the same time.
   * @devices tv, phone, tablet, wearable
   * @param value –number: indicates the hue of the video output. The value ranges from 0 to 100 in ascending order.
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function setDisplayHue(value: number): Promise<boolean>;

  /**
   * Obtains the hue of the video output.
   * @devices tv, phone, tablet, wearable
   * @return Number type, indicating the hue of the video output. The value ranges from 0 to 100 in ascending order.
   */
  function getDisplayHue(): Promise<number>;

  /**
   * 设置HDCP类型
   * @param type -HdcpType: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setHDMIHDCP(type: HdcpType, callback: AsyncCallback<boolean>): void;

  /**
   * 设置HDCP类型
   * @param type -HdcpType: 枚举类型，具体值见定义。
   * @return 设置成功返回true, 返回其他表示失败。
   */
  function setHDMIHDCP(type: HdcpType): Promise<boolean>;

  function getHDMIHDCP(): Promise<HdcpType>;

  /**
   * Enables the CEC function of the HDMI.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function enableHDMICEC(callback: AsyncCallback<boolean>): void;

  /**
   * Enables the CEC function of the HDMI.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function enableHDMICEC(): Promise<boolean>;

  /**
   * Disables the CEC function of the HDMI.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function disableHDMICEC(callback: AsyncCallback<boolean>): void;

  /**
   * Disables the CEC function of the HDMI.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the setting is successful,returns false otherwise.
   */
  function disableHDMICEC(): Promise<boolean>;

  /**
   * Check whether the HDMI status is CEC.
   * @devices tv, phone, tablet, wearable
   * @return Returns true if the status is CEC,returns false otherwise.
   */
  function isHDMICEC(): Promise<boolean>;

  /*选择源*/
  function selectSource(source: SourceType, callback: AsyncCallback<boolean>): void;

  function selectSource(source: SourceType): Promise<boolean>;

  /*取消源*/
  function deselectSource(source: SourceType, callback: AsyncCallback<boolean>): void;

  function deselectSource(source: SourceType): Promise<boolean>;

  /*设定默认源*/
  function SetDefultSource(source: SourceType, callback: AsyncCallback<boolean>): void;

  function SetDefultSource(source: SourceType): Promise<boolean>;

  /*获取默认源*/
  function GetDefultSource(callback: AsyncCallback<SourceType>): void;

  function GetDefultSource(): Promise<SourceType>;

  /*获取可用源列表*/
  function GetAvailSourceList(callback: AsyncCallback<Array<SourceType>>): void;

  function GetAvailSourceList(): Promise<Array<SourceType>>;

  /*获取支持源列表*/
  function GetSupportSourceList(callback: AsyncCallback<Array<SourceType>>): void;

  function GetSupportSourceList(): Promise<Array<SourceType>>;

  /*获取当前源*/
  function getCurSource(callback: AsyncCallback<SourceType>): void;

  function getCurSource(): Promise<SourceType>;

  /*获取信号状态*/
  function getSignalStatus(callback: AsyncCallback<SignalStatus>): void;

  function getSignalStatus(): Promise<SignalStatus>;

  /*获取edid类型*/
  function getHdmiEdidType(callback: AsyncCallback<HdmiRxEdidType>): void;

  function getHdmiEdidType(): Promise<HdmiRxEdidType>;

  /*设置edid类型*/
  function setHdmiEdidType(edidtype: HdmiRxEdidType, callback: AsyncCallback<boolean>): void;

  function setHdmiEdidType(edidtype: HdmiRxEdidType): Promise<boolean>;

  /*设置menu cmd*/
  function SetCecMenuCtrlCmd(cmd: CecDevMenuCommand, callback: AsyncCallback<boolean>): void;

  function SetCecMenuCtrlCmd(cmd: CecDevMenuCommand): Promise<boolean>;

  /*获取Timing*/
  function GetTiming(callback: AsyncCallback<ScreenTiming>): void;

  function GetTiming(): Promise<ScreenTiming>;

  /*获取cec device list*/
  function GetDeviceList(callback: AsyncCallback<Array<CecDeviceInfo>>): void;

  function GetDeviceList(): Promise<Array<CecDeviceInfo>>;

  /*基于HdmiRxEdidType获取输入源列表（getSourceListByHdmirxEdidType）*/
  function GetSourceListByHdmiVersion(edidType: HdmiRxEdidType, callback: AsyncCallback<Array<SourceType>>): void;

  function GetSourceListByHdmiVersion(edidType: HdmiRxEdidType): Promise<Array<SourceType>>;

  /*设置系统电源状态*/
  function SetSystemPowerStatus(powerStatus: number, callback: AsyncCallback<boolean>): void;

  function SetSystemPowerStatus(powerStatus: number): Promise<boolean>;

  /*切换输入源 0/1*/
  function ChangeSourceToTv(status: number, callback: AsyncCallback<boolean>): void;

  function ChangeSourceToTv(status: number): Promise<boolean>;

  /*设置cec语言*/
  function SetIso3MenuLanguage(menuLang: string, callback: AsyncCallback<boolean>): void;

  function SetIso3MenuLanguage(menuLang: string): Promise<boolean>;

  /*获取cec语言*/
  function GetIso3MenuLanguage(callback: AsyncCallback<string>): void;

  function GetIso3MenuLanguage(): Promise<string>;

  /*插拔状态改变*/
  function off(type: 'sourcePlugIn', callback?: Callback<number[]>): void;

  function on(type: 'sourcePlugIn', callback: Callback<number[]>): void;

  function off(type: 'sourcePlugOut', callback?: Callback<number[]>): void;

  function on(type: 'sourcePlugOut', callback: Callback<number[]>): void;

  /*源改变*/
  function off(type: 'sourceChange', callback?: Callback<SourceType>): void;

  function on(type: 'sourceChange', callback: Callback<SourceType>): void;

  /*状态改变*/
  function off(type: 'signalStatusChange', callback?: Callback<SourceSignal>): void;

  function on(type: 'signalStatusChange', callback: Callback<SourceSignal>): void;

  /*timing改变*/
  function off(type: 'timingChange', callback?: Callback<ScreenTiming>): void;

  function on(type: 'timingChange', callback: Callback<ScreenTiming>): void;

  /*设备待机*/
  function off(type: 'cecStandby', callback?: Callback<boolean>): void;

  function on(type: 'cecStandby', callback: Callback<boolean>): void;

  /*arc静音状态改变*/
  function off(type: 'arcMuteChanged', callback?: Callback<boolean>): void;

  function on(type: 'arcMuteChanged', callback: Callback<boolean>): void;

  /*arc音量改变*/
  function off(type: 'arcVolumeChanged', callback?: Callback<number>): void;

  function on(type: 'arcVolumeChanged', callback: Callback<number>): void;

  /*cec device menu 改变*/
  function off(type: 'cecDeviceMenuStateChange', callback?: Callback<number>): void;

  function on(type: 'cecDeviceMenuStateChange', callback: Callback<number>): void;

  /*hdmi源状态改变（isSoundbar）*/
  function off(type: 'hdmiSourceChanged', callback?: Callback<boolean>): void;

  function on(type: 'hdmiSourceChanged', callback: Callback<boolean>): void;


  function setEyeProtectType(value: EyeProtectMode, callback: AsyncCallback<boolean>): void;

  function setEyeProtectType(value: EyeProtectMode): Promise<boolean>;

  function getEyeProtectType(): Promise<EyeProtectMode>;

  function setDciLevel(value: CommonLevel, callback: AsyncCallback<boolean>): void;

  function setDciLevel(value: CommonLevel): Promise<boolean>;

  function getDciLevel(): Promise<CommonLevel>;


  function setBoostPeakLevel(value: CommonLevel, callback: AsyncCallback<boolean>): void;

  function setBoostPeakLevel(value: CommonLevel): Promise<boolean>;

  function getBoostPeakLevel(callback: AsyncCallback<CommonLevel>): void;

  function getBoostPeakLevel(): Promise<CommonLevel>;


  function setNR(value: CommonLevel, callback: AsyncCallback<boolean>): void;

  function setNR(value: CommonLevel): Promise<boolean>;

  function getNR(): Promise<CommonLevel>;

  function setMpegNR(value: CommonLevel, callback: AsyncCallback<boolean>): void;

  function setMpegNR(value: CommonLevel): Promise<boolean>;

  function getMpegNR(): Promise<CommonLevel>;

  function setPictureMode(mode: PictureMode, callback: AsyncCallback<boolean>): void;

  function setPictureMode(mode: PictureMode): Promise<boolean>;

  function getPictureMode(): Promise<PictureMode>;


  function setColorManageUser(user: ColorManagementMode, color: ColorManage, callback: AsyncCallback<boolean>): void;

  function setColorManageUser(user: ColorManagementMode, color: ColorManage): Promise<boolean>;

  function getColorManageUser(user: ColorManagementMode): Promise<ColorManage>;

  function setHDRType(value: HdrType, callback: AsyncCallback<number>): void;

  function setHDRType(value: HdrType): Promise<number>;

  function getHDRType(): HdrType;

  /*获取SN地址*/
  function getSN(callback: AsyncCallback<string>): void;
  function getSN(): Promise<string>;


  /* HDMIRX使能 */
  function HDMIRXEnable(source: SourceType, enable: boolean, callback: AsyncCallback<boolean>): void;
  function HDMIRXEnable(source: SourceType, enable: boolean): Promise<boolean>;

  /* HDMIRX使能 */
  function IsHDMIRXEnable(source: SourceType, callback: AsyncCallback<boolean>): void;
  function IsHDMIRXEnable(source: SourceType): Promise<boolean>;

  /*获取Rotation*/
  function GetScreenRotation(callback: AsyncCallback<number>): void;
  function GetScreenRotation(): Promise<number>;

  /*设置Rotation*/
  function SetScreenRotation(displayFormat:number, callback: AsyncCallback<boolean>): void;
  function SetScreenRotation(displayFormat:number): Promise<boolean>;

  function setMemoryStandby(flag: number): Promise<boolean>;
  function setMemoryStandby(flag: number, callback: AsyncCallback<boolean>):void;
  function setPowerOnMode(mode: number): Promise<boolean>;
  function setPowerOnMode(mode: number, callback: AsyncCallback<boolean>): void;
  function getPowerOnMode(): Promise<number>;
  function getPowerOnMode(callback: AsyncCallback<number>): void;
}

export default displaySetting;