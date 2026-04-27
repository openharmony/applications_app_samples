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
/*
 * 时间工具
 *
 *
 *
 *
 * */

/*
 * 毫秒转日期格式字符串
 * @param sec: 1678431640790
 * @return DateLib: 包含各种日期格式的数据字符串
 * */
export interface DateLib {
    year: string,
    month: string,
    day: string,
    hour: string,
    minute: string,
    second: string,
    yymm: string,
    yymmdd: string,
    mmdd: string,
    hhmmss: string,
    ymdhms: string,
}
export function secToDate(sec: number | string): DateLib {
    let time = new Date(sec);
    let year: any = time.getFullYear();
    let month: any = time.getMonth() + 1;
    let day: any = time.getDate();
    let hour: any = time.getHours();
    let minute: any = time.getMinutes();
    let second: any = time.getSeconds();
    let mon = String(month).padStart(2, '0');
    let d = String(day).padStart(2, '0');
    let h = String(hour).padStart(2, '0');
    let m = String(minute).padStart(2, '0');
    let s = String(second).padStart(2, '0');
    return {
        year,
        month,
        day,
        hour,
        minute,
        second,
        yymm: `${year}-${mon}`,
        yymmdd: `${year}-${mon}-${d}`,
        mmdd: `${month}-${d}`,
        hhmmss: `${h}:${m}:${s}`,
        ymdhms: `${year}-${mon}-${d} ${h}:${m}:${s}`,
    }
}
