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

import { CONTAINS_PATH, SIGN_FULL_PATH, SIGN_PUBLIC_PATH } from 'config.dev';
import { checkProjectIfInFull } from "./checkProjectIfInFull"
const fs = require('fs');

interface ContainsType {
    SIGN_HAP_PATH?: string;
    FA_MODAL_AND_LOWER_CASE_LIST?: string;
    INSTALL_LIST_CAPABILITY?: string;
    SAVE_XML_PATH?: string;
    COMBIN_CONFIG?: string;
    SPECIAL_LIST?: string;
    SPECIAL_HAP?: string;
    TARGET_PATH?: string;
};

function editLinuxContains(targetPath: string) {
    try {
        const config: ContainsType = {};
        const configContent = fs.readFileSync(CONTAINS_PATH, 'utf8');
        configContent.trim().split('\n').forEach((line: string) => {
            if (line.trim() !== '') {
                const [key = '', value = ''] = line.split('=');
                config[key.trim()] = value.trim();
            };
        });
        if (checkProjectIfInFull(targetPath)) {
            config.SIGN_HAP_PATH = `r'${SIGN_FULL_PATH}'`;
        } else {
            config.SIGN_HAP_PATH = `r'${SIGN_PUBLIC_PATH}'`;
        };
        const target = targetPath.split('/').join('_');
        config.TARGET_PATH = `r'${target}'`;
        console.log(Object.entries(config).length);
        const updatedConfigContent = Object.entries(config).map(([key, value]) => `${key} = ${value}`).join('\n');
        fs.writeFileSync(CONTAINS_PATH, updatedConfigContent);
        return {
            status: true,
            msg: ''
        };
    } catch (e) {
        return {
            status: false,
            msg: JSON.stringify(e)
        };
    };
}

export { editLinuxContains };