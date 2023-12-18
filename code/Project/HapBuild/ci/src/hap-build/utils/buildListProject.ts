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

import { executeCommand } from "src/util";
import { CONFIG_PATH, COMPILE_SH_PATH, TEST_TOOL_PATH, PROJECT_PATH } from 'config.dev';
import { editLinuxContains } from "./editLinuxContains";
import { commitPRRequest } from '../../util/index';

interface TestResultProps {
    successNum?: string;
    failNum?: string;
    diedNum?: string;
    specialNum?: string;
    testNum?: string;
    testSuccessNum?: string;
    testFailNum?: string;
    testErrorNum?: string
};

export async function buildListProject(PRId: number, projectPath: Array<string>) {
    let resultArray: Array<string> = [];
    let result: string = '';
    await executeCommand('cd ~');
    for (const item of projectPath) {
        result = await executeCommand(`${COMPILE_SH_PATH} --p=${CONFIG_PATH} --compile_dir=${item}`);

        if (result.includes('hap_build success')) {
            resultArray.push(item + ' build success!\n');
        } else {
            resultArray.push(item + ' build fail!\n');
        };

        // 测试
        editLinuxContains(item);
        const testResult: string = await executeCommand(`python3 ${TEST_TOOL_PATH}`);
        const textResultObj: TestResultProps = {} as TestResultProps;
        ('successNum' + testResult.split('successNum')[1]).replace(/[\n\r]/g, '').split(' ').forEach(val => {
            const [key, value] = val.split(':');
            textResultObj[key] = value;
        });
        if (textResultObj.successNum == '1') {
            resultArray.push(item + ' test success!\n');
        } else {
            resultArray.push(item + ' test fail!\n');
        };
        console.log(resultArray);
    }

    console.log(resultArray);
    let comment = resultArray.join('');
    commitPRRequest(PRId, comment);
    return resultArray;
}