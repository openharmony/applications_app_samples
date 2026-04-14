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
 

import AbilityManager from '../../../../../../../../../common/src/main/ets/default/abilitymanager/AbilityManager';
import { display } from '@kit.ArkUI';
import Log from '../../../../../../../../../common/src/main/ets/default/Log';
import ResourceUtil from '../../../../../../../../../common/src/main/ets/default/ResourceUtil';
import { deviceInfo } from '@kit.BasicServicesKit';

const TAG = 'NavBarConfiguration';
let directionNav;
let navbarPosition;
let statusbarPosition;
let navShortSideLength = '0';
let statusShortSideLength = '0';

let maxWidth;
let maxHeight;
let minHeight;
let realWidth;
let realHeight;
let xCoordinate = 0;
let yCoordinate = 0;
let direction = -1;

enum Position {
  NOT_CONFIGURED,
  LEFT_POSITION,
  TOP_POSITION,
  RIGHT_POSITION,
  BOTTOM_POSITION
}

/**
 * Get window size.
 */
class NavBarConfiguration {
  async initNavBarConfiguration() {
    Log.showDebug(TAG, 'initNavBarConfiguration');
    minHeight = 0;

    await display.getDefaultDisplay()
      .then(dis => {
        Log.showInfo(TAG, `initNavBarConfiguration dis ${JSON.stringify(dis)}`);
        maxWidth = dis.width;
        maxHeight = dis.height;
        Log.showInfo(TAG, `initNavBarConfiguration maxWidth ${maxWidth} maxHeight ${maxHeight} minHeight ${minHeight}`);
      })
    .catch((err) => {
      Log.showError(TAG, 'getDefaultDisplay err: ' + err);
    });
  }

  async getDirectionAndPosition() {
    await ResourceUtil.initResourceManager(AbilityManager.ABILITY_NAME_NAVIGATION_BAR);
    if (maxWidth > maxHeight) {
      direction = 1;
    } else {
      direction = 2;
    }

    if (direction == -1) {
      Log.showInfo(TAG, 'direction is -1');
      statusbarPosition = await ResourceUtil.getString($r("app.string.status_bar_position_landscape"))
      navbarPosition = await ResourceUtil.getString($r("app.string.nav_bar_position_landscape"))

      statusShortSideLength = await ResourceUtil.getString($r("app.string.status_bar_size_landscape"));
      navShortSideLength = await ResourceUtil.getString($r("app.string.nav_bar_size_landscape"));
    } else if (direction == 1) {
      Log.showInfo(TAG, 'direction is 1');
      statusbarPosition = await ResourceUtil.getString($r("app.string.status_bar_position_landscape"))
      navbarPosition = await ResourceUtil.getString($r("app.string.nav_bar_position_landscape"))

      statusShortSideLength = await ResourceUtil.getString($r("app.string.status_bar_size_landscape"));
      navShortSideLength = await ResourceUtil.getString($r("app.string.nav_bar_size_landscape"));
    } else {
      Log.showInfo(TAG, 'direction is 2');
      statusbarPosition = await ResourceUtil.getString($r("app.string.status_bar_position_portrait"))
      navbarPosition = await ResourceUtil.getString($r('app.string.nav_bar_position_portrait'))

      statusShortSideLength = await ResourceUtil.getString($r('app.string.status_bar_size_portrait'));
      navShortSideLength = await ResourceUtil.getString($r('app.string.nav_bar_size_portrait'));
    }
    statusShortSideLength = parseInt(statusShortSideLength) + '';
    navShortSideLength = parseInt(navShortSideLength) + '';
    Log.showDebug(TAG, 'statusShortSideLength = ' + statusShortSideLength + 'navShortSideLength = ' + navShortSideLength + 'direction = ' + direction + 'statusbarPosition = ' + statusbarPosition + 'NavbarPosition = ' + navbarPosition);
  }

  /**
   * Get nav bar configuration
   */
  public async getConfiguration() {
    await this.initNavBarConfiguration();

    await this.getDirectionAndPosition();

    let showNavHorizontal = false;
    if (navbarPosition == Position.TOP_POSITION || navbarPosition == Position.BOTTOM_POSITION) {
      showNavHorizontal = true;
      minHeight = parseInt(navShortSideLength);
      if (statusbarPosition == Position.LEFT_POSITION || statusbarPosition == Position.RIGHT_POSITION) {
        realWidth = parseInt(maxWidth) - parseInt(statusShortSideLength);
      } else {
        realWidth = maxWidth;
      }
      realHeight = parseInt(navShortSideLength);
      if (statusbarPosition == Position.LEFT_POSITION) {
        xCoordinate = parseInt(statusShortSideLength);
      } else {
        xCoordinate = 0;
      }
      if (navbarPosition == Position.BOTTOM_POSITION) {
        yCoordinate = parseInt(maxHeight) - parseInt(navShortSideLength);
        Log.showDebug(TAG, 'BOTTOM_POSITION = ' + yCoordinate);
      }
    } else if (navbarPosition == Position.LEFT_POSITION || navbarPosition == Position.RIGHT_POSITION) {
      showNavHorizontal = false;
      minHeight = parseInt(navShortSideLength);
      if (statusbarPosition == Position.TOP_POSITION || statusbarPosition == Position.BOTTOM_POSITION) {
        realHeight = parseInt(maxHeight) - parseInt(statusShortSideLength);
      } else {
        realHeight = maxHeight;
      }
      realWidth = parseInt(navShortSideLength);
      if (statusbarPosition == Position.TOP_POSITION) {
        yCoordinate = parseInt(statusShortSideLength);
      } else {
        yCoordinate = 0;
      }
      if (navbarPosition == Position.RIGHT_POSITION) {
        xCoordinate = parseInt(maxWidth) - parseInt(navShortSideLength);
      }
    } else {
      realWidth = 0;
      realHeight = 0;
    }
    realHeight = 0;
    Log.showDebug(TAG, `initWindowManager xCoordinate ${xCoordinate} yCoordinate ${yCoordinate}, realWidth ${realWidth} realHeight ${realHeight}`);
    let configuration = {
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      minHeight: minHeight,
      showNavHorizontal: showNavHorizontal,
      direction: direction,
      realWidth: realWidth,
      realHeight: realHeight,
      xCoordinate: xCoordinate,
      yCoordinate: yCoordinate
    }
    return configuration;
  }

  /**
   * set nav bar custom configuration
   */
  public setCustomConfiguration(configInfo) {
    Log.showInfo(TAG, `deviceInfo.deviceType` + deviceInfo.deviceType);

    let screenFactor;
    if (deviceInfo.deviceType === 'tablet') {
      screenFactor = configInfo.direction === 1 ? 1280 : 800;
    } else {
      screenFactor = 360;
    }
    //导航栏水平布局
    if (configInfo.showNavHorizontal) {
      if (configInfo.realHeight == 0) {
        Log.showInfo(TAG, `hide navbar`);
      } else if (deviceInfo.deviceType === 'tablet') { // Pad、PC Mode
        configInfo.realHeight = 44 * configInfo.maxWidth / screenFactor;
      } else { // Phone Mode
        configInfo.realHeight = (configInfo.realHeight * (configInfo.maxHeight > configInfo.maxWidth 
           configInfo.maxWidth : configInfo.maxHeight)) / screenFactor;
      }
      configInfo.minHeight = configInfo.realHeight;
      if (configInfo.yCoordinate > 0) {
        configInfo.yCoordinate = configInfo.maxHeight - configInfo.realHeight;
      }
    } else {
      if (configInfo.realWidth == 0) {
        Log.showInfo(TAG, `hide navbar`);
      } else if (deviceInfo.deviceType === 'tablet') { // Pad、PC Mode
        configInfo.realWidth = 44 * configInfo.maxWidth / screenFactor;
      } else { // Phone Mode
        configInfo.realWidth = (configInfo.realWidth * 
        (configInfo.maxHeight > configInfo.maxWidth ? configInfo.maxWidth : configInfo.maxHeight)) / 
        screenFactor;
      }
      configInfo.minHeight = configInfo.realWidth;
      if (configInfo.xCoordinate > 0) {
        configInfo.xCoordinate = configInfo.maxWidth - configInfo.realWidth;
      }
    }
    return configInfo;
  }
}

let navBarConfiguration = new NavBarConfiguration();

export default navBarConfiguration;
