/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { display, window } from '@kit.ArkUI';
import { logger } from '../common/util/Logger';
import { GlobalContext} from '../common/util/GlobalUtil';
import { BreakpointConstants } from '../common/constants/BreakpointConstants';
import CommonConstants from '../common/constants/CommonConstants';

@Observed
export class XComponentSize {
  public width: number; // XComponent 宽度
  public height: number; // XComponent 高度
  public offsetX: number; // XComponent's X方向的偏移量
  public offsetY: number; // XComponent's Y方向的偏移量

  constructor() {
    this.width = 1080;
    this.height = 720;
    this.offsetX = 0;
    this.offsetY = 0;
  }
}

@Observed
export class DeviceStatus {
  public isLandscape: boolean;
  public orientation: display.Orientation;
  public foldStatus: display.FoldStatus; // 折叠状态

  constructor() {
    this.isLandscape = false;
    this.orientation = display.Orientation.PORTRAIT;
    this.foldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
  }
}

@Observed
export class ScanLayout {
  public topHeight: number;
  public windowHeight: number = 800; // 窗口高度
  public deviceHeight: number = 800; // 设备高度
  public marginD: number = 10;
  public hasMarginD: boolean = false;
  public splitScreen: boolean = false;

  constructor(navHeight: number) {
    this.topHeight = navHeight + CommonConstants.TOP_BUTTON_HEIGHT + CommonConstants.TITLE_MARGIN_TOP +
    CommonConstants.TITLE_MAIN_LINE_HEIGHT + CommonConstants.SCAN_LINE_MARGIN;
  }
}

@Observed
export class ScanSize {
  public navHeight: number;
  public xComponentSize: XComponentSize;
  public deviceStatus: DeviceStatus;
  public scanLayout: ScanLayout;

  constructor() {
    this.navHeight = CommonConstants.TABLET_NAV_HEIGHT;
    this.xComponentSize = new XComponentSize();
    this.deviceStatus = new DeviceStatus();
    this.scanLayout = new ScanLayout(this.navHeight);
  }

  private static instance: ScanSize | null = null;

  public static getInstance(): ScanSize {
    if (ScanSize.instance === null) {
      ScanSize.instance = new ScanSize();
    }
    return ScanSize.instance;
  }

  /**
   * 获取屏幕Display
   * @returns
   */
  public getDisplay(): display.Display | null {
    let displayClass: display.Display | null = null;
    try {
      displayClass = display.getDefaultDisplaySync();
    } catch (error) {
      logger.error(`Failed to getDefaultDisplaySync. Code: ` + error.code);
    }
    return displayClass;
  }

  /**
   * 返回当前窗口大小
   * @returns
   */
  public setWindowSize(): window.Size | null {
    logger.info('Start to set window size');
    let displayClass: display.Display | null = this.getDisplay();
    let windowSize: window.Size;
    if (displayClass !== null) {
      windowSize = {
        width: px2vp(displayClass.width),
        height: px2vp(displayClass.height)
      }
      return windowSize;
    }
    return null;
  }

  /**
   * 获取屏幕方向
   */
  public getOrientation() {
    let displayClass: display.Display | null = this.getDisplay();
    if (displayClass !== null) {
      this.deviceStatus.orientation = displayClass.orientation;
      if (this.deviceStatus.orientation === display.Orientation.LANDSCAPE ||
        this.deviceStatus.orientation === display.Orientation.LANDSCAPE_INVERTED) {
        this.deviceStatus.isLandscape = true;
      } else {
        this.deviceStatus.isLandscape = false;
      }
    }
    logger.info(`getOrientation scan orientation: ` + this.deviceStatus.orientation);
  }

  /**
   * 计算当前相机预览流显示大小和偏移位置
   * @param isSupportRotation
   * @param windowSize
   */
  public setScanXComponentSize(isSupportRotation: boolean, windowSize: window.Size): void {
    if (isSupportRotation) {
      this.getOrientation();
    }
    if (windowSize) {
      logger.info(`Start to set scan XComponent size. Width: ` + windowSize.width + `, height: ` + windowSize.height);
      this.updateBreakpoint(windowSize.width);
      let width: number = windowSize.width;
      let height: number = windowSize.height;
      let offsetY: number = 0;
      let offsetX: number = 0;
      let ratio = CommonConstants.NOT_FOLD_DEVICE_EXPAND_RATIO;
      if (GlobalContext.getContext().getProperty(CommonConstants.GLOBAL_SCAN_DEVICE_IS_FOLDING) &&
        display.getFoldStatus() !== display.FoldStatus.FOLD_STATUS_FOLDED) {
        ratio = CommonConstants.FOLD_DEVICE_EXPAND_RATIO;
      }
      //设备方向横竖需要不同的比例
      if (this.deviceStatus.orientation === display.Orientation.LANDSCAPE ||
        this.deviceStatus.orientation === display.Orientation.LANDSCAPE_INVERTED) {
        ratio = 1 / ratio;
      }
      if (height > 0) {
        if (ratio < width / height) {
          height = width / ratio;
          offsetY = (windowSize.height - height) / 2;
        } else {
          width = height * ratio;
          offsetX = (windowSize.width - width) / 2;
        }
        this.updateXComponentSize(width, height, offsetX, offsetY);
        logger.info(`setScanXComponentSize End. Width: ` + this.xComponentSize.width + `, height: ` + this.xComponentSize.height +
         `offsetX: ` + this.xComponentSize.offsetX + `, offsetY: ` + this.xComponentSize.offsetY);
      } else {
        logger.error(`height less than or equal to 0`);
      }
    }
  }

  /**
   * 更新XComponent
   * @param width
   * @param height
   * @param offsetX
   * @param offsetY
   */
  public updateXComponentSize(width: number, height: number, offsetX: number, offsetY: number): void {
    logger.info('Start to update XComponent size.');
    this.xComponentSize.width = width;
    this.xComponentSize.height = height;
    this.xComponentSize.offsetX = offsetX;
    this.xComponentSize.offsetY = offsetY;
  }

  /**
   * 更新BreakPoint
   * @param windowWidth
   */
  private updateBreakpoint(windowWidth: number): void {
    logger.info('Start to update breakpoint.');
    let newBp: string = '';
    if (windowWidth < BreakpointConstants.MIDDLE_DEVICE_WIDTH) {
      newBp = BreakpointConstants.BREAKPOINT_SM;
    } else if (windowWidth < BreakpointConstants.LARGE_DEVICE_WIDTH) {
      newBp = BreakpointConstants.BREAKPOINT_MD;
    } else {
      newBp = BreakpointConstants.BREAKPOINT_LG;
    }
    if (AppStorage.get('currentBreakpoint') !== newBp) {
      AppStorage.setOrCreate('currentBreakpoint', newBp);
      logger.info(`Succeeded in setting currentBreakpoint. CurrentBreakpoint: `+ newBp);
    }
  }
}
