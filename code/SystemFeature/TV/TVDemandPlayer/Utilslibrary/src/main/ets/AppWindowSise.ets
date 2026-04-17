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
import { display } from '@kit.ArkUI';
import { initInfo } from './log';
let log = initInfo('getAppWindowSize');

interface WindowRectInfo {
    width: number;
    height: number;
}

interface WindowPropertiesInfo {
    windowRect: WindowRectInfo;
}

interface AppWindowLike {
    getProperties: () => Promise<WindowPropertiesInfo>;
}

interface AppWindowSizeResult {
    width: number;
    height: number;
    pageW: number;
    pageH: number;
    dpi: number;
    lpi: number;
}

export async function getAppWindowSize(win: AppWindowLike): Promise<AppWindowSizeResult> {
    let width = 1280; // src/main/resources/base/profile/main_pages.json 中的designWidth
    let prop: WindowPropertiesInfo = await win.getProperties();
    let rect: WindowRectInfo = prop.windowRect;
    let height = rect.height * width / rect.width;
    let lpi = parseFloat((rect.width / width).toFixed(3));
    //update start
    // let dis = await display.getDefaultDisplay();
    let dis = display.getDefaultDisplaySync();
    //update end
    let dpi = parseFloat((dis.densityDPI / 160).toFixed(3));
    let res: AppWindowSizeResult = {
        width: width,
        height: Math.floor(height),
        pageW: rect.width,
        pageH: rect.height,
        dpi: dpi,
        lpi: lpi
    };

    return res;
}
