/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import hilog from '@ohos.hilog'

export class Logger {
    private static DOMAIN: number = 0xFF00
    private static PREFIX: string = '[Sample_PlayBG]'
    private static FORMAT: string = '%{public}s'
    private static ENABLE_LOG: boolean = true

    public static info(...args: any[]) {
        if (this.ENABLE_LOG) {
            hilog.info(this.DOMAIN, this.PREFIX, this.FORMAT, args)
        }
    }

    public static debug(...args: any[]) {
        if (this.ENABLE_LOG) {
            hilog.debug(this.DOMAIN, this.PREFIX, this.FORMAT, args)
        }
    }

    public static warn(...args: any[]) {
        if (this.ENABLE_LOG) {
            hilog.warn(this.DOMAIN, this.PREFIX, this.FORMAT, args)
        }
    }

    public static error(...args: any[]) {
        if (this.ENABLE_LOG) {
            hilog.error(this.DOMAIN, this.PREFIX, this.FORMAT, args)
        }
    }
}