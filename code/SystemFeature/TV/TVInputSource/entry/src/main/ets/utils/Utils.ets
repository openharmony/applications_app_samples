/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { display } from '@kit.ArkUI';

interface ScreenSizeInfo {
    width: number;
    height: number;
    pageW: number;
    pageH: number;
    dpi: number;
    lpi: number;
}

interface VideoSizeInfo {
    width: number;
    height: number;
}

interface WindowRectInfo {
    width: number;
    height: number;
}

/**
 * 获取当前窗口对应的设计尺寸和缩放参数。
 * @returns Promise<ScreenSizeInfo> 返回页面宽高、窗口宽高和缩放比信息。
 */
export async function getScreenSize(): Promise<ScreenSizeInfo> {
    let width: number = 1280;
    // 应用所在 window 尺寸
    let rect: WindowRectInfo = {
        width: AppStorage.get<number>('screen_px_w') || 1920,
        height: AppStorage.get<number>('screen_px_h') || 1080
    };
    let height = rect.height * 1280 / rect.width;

    let lpi = parseFloat((rect.width / 1280).toFixed(3));

    let dis = await display.getDefaultDisplay();

    let dpi = parseFloat((dis.densityDPI / 160).toFixed(3));

    // 屏幕尺寸
    let res: ScreenSizeInfo = {
        width: width,
        height: Math.floor(height),
        pageW: rect.width,
        pageH: rect.height,
        dpi: dpi,
        lpi: lpi
    };
    console.info('getScreenSize res:' + JSON.stringify(res));
    return res;
}

/**
 * 返回基础对象类型名称，避免通过原型链调用触发 ArkTS 限制。
 * @param obj 待判断对象。
 * @returns string 返回 `null`、`undefined`、`array` 或 `typeof` 结果。
 */
export function objType(obj: Object | null | undefined): string {
    if (obj === null) {
        return 'null';
    }
    if (obj === undefined) {
        return 'undefined';
    }
    if (Array.isArray(obj as Object[])) {
        return 'array';
    }
    return typeof obj;
}

/**
 * 将毫秒数转换为时分秒显示字符串。
 * @param s 输入毫秒值。
 * @returns string 返回 `hh:mm:ss` 或 `mm:ss` 格式字符串。
 */
export function getTimeStr(s:number): string {
    console.info('getTimeStr s:' + s);
    let h = '';
    let m = '';
    let sec = '';
    let seconds = Math.floor(s/1000);
    console.info('getTimeStr seconds:' + seconds);
    let hour = Math.floor(seconds/3600);
    console.info('getTimeStr hour:' + hour);
    seconds = seconds - hour*3600;
    if(hour>0){
        h = `${hour}:`
    }
    let min = Math.floor(seconds/60);
    console.info('getTimeStr min:' + min);
    seconds = seconds - min*60;

    m = String(min).padStart(2, '0') + ':';
    sec = String(seconds).padStart(2, '0');

    return `${h}${m}${sec}`;
}

/**
 * 按指定画幅比例计算视频在页面中的显示尺寸。
 * @param pageW 页面宽度。
 * @param pageH 页面高度。
 * @param videoW 视频宽度。
 * @param videoH 视频高度。
 * @param type 目标画幅类型，如 `4:3` 或 `16:9`。
 * @returns VideoSizeInfo 返回适配后的宽高。
 */
export function getVideoSize(
    pageW: number,
    pageH: number,
    videoW: number,
    videoH: number,
    type: string
): VideoSizeInfo {
    let pageScale = pageW / pageH;
    let videoWidth = pageW;
    let videoHeight = pageH;
    switch (type) {
      case '4:3': { //4:3
        if (pageScale > (4 / 3)) {
          videoWidth = parseInt((pageH * 4 / 3).toFixed(0));
        } else {
          videoHeight = parseInt((pageW * 3 / 4).toFixed(0));
        }
        break;
      }
      case '16:9': { //16:9
        if (pageScale > (16 / 9)) {
          videoWidth = parseInt((pageH * 16 / 9).toFixed(0));
        } else {
          videoHeight = parseInt((pageW * 9 / 16).toFixed(0));
        }
        break;
      }
    }
    const videoSize: VideoSizeInfo = { width: videoWidth, height: videoHeight };
    return videoSize;
}

/**
 * 将时间戳转换为可读日期时间字符串。
 * @param sec 时间戳数值。
 * @returns string 返回 `yyyy-MM-dd HH:mm:ss` 格式字符串。
 */
export function secToStr(sec: number): string {
    let time = new Date(sec);
    let year: number = time.getFullYear();
    let month: string = String(time.getMonth() + 1);
    let day: string = String(time.getDate());
    let h: string = String(time.getHours());
    let m: string = String(time.getMinutes());
    let s: string = String(time.getSeconds());

    month = month.padStart(2, '0');
    day = day.padStart(2, '0');
    h = h.padStart(2, '0');
    m = m.padStart(2, '0');
    s = s.padStart(2, '0');
    return `${year}-${month}-${day} ${h}:${m}:${s}`;
}

/**
 * 判断文件名是否为支持的视频类型。
 * @param name 文件名。
 * @returns boolean 是否命中支持的视频扩展名。
 */
export function isVideoFile(name:string): boolean {
    if(name.includes('.')){
        const fileType = name.split('.').pop();
        if (fileType === undefined) {
            return false;
        }
        let type = fileType.toLocaleLowerCase();
        let types = 'mp4;mpeg-ts;webm;mkv'.toLocaleLowerCase();
        return types.includes(type);
    }
    return false;
}
