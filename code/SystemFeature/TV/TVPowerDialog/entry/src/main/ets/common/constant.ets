export default class Constants {
  // static BUNDLE_NAME='com.ohos.powerdialog'
  public static FULL_WIDTH = '100%';
  public static FULL_HEIGHT = '100%';
  public static DIALOG_WIDTH = 395;
  public static DIALOG_HEIGHT = 117
  public static DIALOG_BORDER_RADIUS = 32;
  public static DIALOG_TITLE_FONT_SIZE = 16;
  public static DIALOG_TITLE_FONT_WEIGHT = 400;
  public static DIALOG_TITLE_OPACITY = 1;
  public static DIALOG_TITLE_MARGIN_TOP = 24;
  public static DIALOG_TITLE_MARGIN_BOTTOM = 16;
  public static DIALOG_TITLE_LINE_HEIGHT = 22;
  public static BUTTON_HEIGHT = 40;
  public static BUTTON_WIDTH = 100;
  public static BUTTON_MARGIN = 7;
  public static BUTTON_TEXT_FONT_SIZE = 16;
  public static BUTTON_TEXT_FONT_WEIGHT = 500;
  public static SPLIT_FONT_SIZE = 24;
  public static readonly DEFAULT_BG_COLOR = '#464a51';
  public static WINDOW_BG_COLOR = '#00000000';
}

export enum PowerOperation {
  POWEROPERATION_SUSPEND = 0,
  POWEROPERATION_REBOOT,
  POWEROPERATION_SHUTDOWN
}