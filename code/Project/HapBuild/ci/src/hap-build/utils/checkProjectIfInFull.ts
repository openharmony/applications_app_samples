/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { CONFIG_PATH } from 'config.dev';
const fs = require('fs');

interface ConfigType {
    name?: string,
    url?: string,
    branch?: string,
    fullSdkAssembleList?: string,
    basicSignList?: string,
    coreSignList?: string
    systemAppList?: string
};

function checkProjectIfInFull(projectName: string) {
    try {
        const config: ConfigType = {};
        const configContent = fs.readFileSync(CONFIG_PATH, 'utf8');
        configContent.split('\n').forEach((line: string) => {
            if (line.trim() !== '') {
                const [key = '', value = ''] = line.split('=');
                config[key.trim()] = value.trim();
            };
        });
        const fullSdkAssembleList: string[] = config.fullSdkAssembleList.split(';');
        return fullSdkAssembleList.includes(projectName);
    } catch (e) {
        return false;
    };
}

export { checkProjectIfInFull };