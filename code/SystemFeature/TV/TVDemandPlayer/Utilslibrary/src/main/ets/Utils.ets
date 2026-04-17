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
import { screen } from '@kit.ArkUI';
import { initInfo } from './Log';

let log = initInfo('utils');

/*
 * 获取数据类型
 * return 'null'|'undefined'|'boolean'|'number'|'string'|'object'|'array'|'set'|'map'|'symbol'|'date'|'function'
 * */
export function objType(obj: Object | string | number | boolean | null | undefined): string {
    if (obj === null) {
        return 'null';
    }
    if (obj === undefined) {
        return 'undefined';
    }
    if (Array.isArray(obj)) {
        return 'array';
    }
    if (obj instanceof Set) {
        return 'set';
    }
    if (obj instanceof Map) {
        return 'map';
    }
    if (obj instanceof Date) {
        return 'date';
    }
    const objTypeValue: string = typeof obj;
    if (objTypeValue === 'boolean' || objTypeValue === 'number' || objTypeValue === 'string' ||
        objTypeValue === 'symbol' || objTypeValue === 'function') {
        return objTypeValue;
    }
    return 'object';
}

// 获取横竖屏
export async function getScreenOrientation() {
    let screenArr = await screen.getAllScreens();
    let orientation = screenArr[0].orientation;
    log('getScreenOrientation change orientation:' + orientation);
    return orientation;
}

export function isVideoFile(name: string) {
    if (name.includes('.')) {
        let ext: string | undefined = name.split('.').pop();
        if (ext === undefined) {
            return false;
        }
        let type: string = ext.toLocaleLowerCase();
        let types = 'mp4;mpeg-ts;webm;mkv;mpeg;mov;ts;avi;f4v;flv;m4v;mpg'.toLocaleLowerCase();
        return types.includes(type);
    }
    return false;
}


interface UtilApi {
    objType: (obj: Object | string | number | boolean | null | undefined) => string;
    getScreenOrientation: () => Promise<number>;
    isVideoFile: (name: string) => boolean;
}

export const util: UtilApi = { objType, getScreenOrientation, isVideoFile }
