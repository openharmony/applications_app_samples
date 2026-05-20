export default class Constants {
  // static BUNDLE_NAME='com.ohos.powerdialog'
  static FULL_WIDTH = '100%';
  static FULL_HEIGHT = '100%';
  static DIALOG_WIDTH = 395;
  static DIALOG_HEIGHT = 117
  static DIALOG_BORDER_RADIUS = 32;
  static DIALOG_TITLE_FONT_SIZE = 16;
  static DIALOG_TITLE_FONT_WEIGHT = 400;
  static DIALOG_TITLE_OPACITY = 1;
  static DIALOG_TITLE_MARGIN_TOP = 24;
  static DIALOG_TITLE_MARGIN_BOTTOM = 16;
  static DIALOG_TITLE_LINE_HEIGHT = 22;
  static BUTTON_HEIGHT = 40;
  static BUTTON_WIDTH = 100;
  static BUTTON_MARGIN = 7;
  static BUTTON_TEXT_FONT_SIZE = 16;
  static BUTTON_TEXT_FONT_WEIGHT = 500;
  static SPLIT_FONT_SIZE = 24;
  static readonly DEFAULT_BG_COLOR = '#464a51';
  static WINDOW_BG_COLOR = '#00000000';
}

export enum PowerOperation {
  POWEROPERATION_SUSPEND = 0,
  POWEROPERATION_REBOOT,
  POWEROPERATION_SHUTDOWN
}