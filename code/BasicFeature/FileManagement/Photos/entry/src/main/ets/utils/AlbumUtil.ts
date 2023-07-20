/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import { Log } from './Log';
import { screenManager } from '../common/ScreenManager'
import { Constants } from '../constants/Constants'

const TAG = 'UiUtil';

export class UiUtil {
  public static getAlbumGridCount(horizontal: boolean): number {
    Log.info(TAG, 'get screen width is : ' + screenManager.getWinWidth());
    Log.info(TAG, 'get screen height is : ' + screenManager.getWinHeight());
    let sideBarWidth = horizontal ? Constants.TAB_BAR_WIDTH : 0;
    let contentWidth = screenManager.getWinWidth() - sideBarWidth;

    let maxCardWidth = Constants.ALBUM_SET_COVER_SIZE * Constants.GRID_MAX_SIZE_RATIO;
    let gridColumnsCount = Math.ceil((contentWidth - Constants.ALBUM_SET_MARGIN * 2 + Constants.ALBUM_SET_GUTTER)
    / (maxCardWidth + Constants.ALBUM_SET_GUTTER));
    Log.info(TAG, 'the grid count in a line is : ' + gridColumnsCount);
    return gridColumnsCount;
  }
}
