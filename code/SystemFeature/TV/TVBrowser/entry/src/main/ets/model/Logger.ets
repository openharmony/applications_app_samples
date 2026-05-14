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
import { hilog } from '@kit.PerformanceAnalysisKit';

type LogArg = string | number | boolean | bigint | null | undefined;

class Logger {
    private domain: number;
    private prefix: string;
    private format: string = '%{public}s, %{public}s';

    constructor(prefix: string) {
        this.prefix = prefix;
        this.domain = 0xFF00;
    }

    private normalizeArgs(args: LogArg[]): string[] {
        return args.map((item: LogArg) => String(item));
    }

    debug(...args: LogArg[]) {
        hilog.debug(this.domain, this.prefix, this.format, ...this.normalizeArgs(args));
    }

    info(...args: LogArg[]) {
        hilog.info(this.domain, this.prefix, this.format, ...this.normalizeArgs(args));
    }

    warn(...args: LogArg[]) {
        hilog.warn(this.domain, this.prefix, this.format, ...this.normalizeArgs(args));
    }

    error(...args: LogArg[]) {
        hilog.error(this.domain, this.prefix, this.format, ...this.normalizeArgs(args));
    }
}

export default new Logger('[Browser]');