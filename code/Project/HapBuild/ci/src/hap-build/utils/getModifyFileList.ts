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

import { getProjectPath } from '../utils/getProjectPath';
import { logger, executeCommand } from 'src/util';
import { ACCESS_TOKEN, PROJECT_PATH } from 'config.dev';
const fetch = require('node-fetch');
const fs = require('fs');

async function getModifyFilelist(PRId: number) {
    console.log(PRId);
    const axios = require('axios');
    const owner = 'OpenHarmony';
    const repo = 'applications_app_samples';
    let filesModify = [];

    // 重置本地代码 
    let re1 = await executeCommand('git fetch --all', PROJECT_PATH);
    let re2 = await executeCommand('git reset --hard origin/master', PROJECT_PATH);
    let re3 = await executeCommand('git pull', PROJECT_PATH);

    await axios.get(`https://gitee.com/api/v5/repos/${owner}/${repo}/pulls/${PRId}/files?access_token=${ACCESS_TOKEN}`)
        .then((response: { data: any }) => {
            response.data.forEach(async (item: { raw_url: string, filename: string, patch: { new_path: string } }) => {
                console.log(JSON.stringify(item.patch.new_path));
                // 获取修改代码源文件
                const dirArr = item.filename.split('/');
                const savePath = PROJECT_PATH + '/' + item.filename;
                if (dirArr.length >= 2) {
                    let dir = PROJECT_PATH + '/' + dirArr[0]
                    for (let i = 1; i < dirArr.length; i++) {
                        if (!fs.existsSync(dir)) {
                            fs.mkdirSync(dir)
                        }
                        dir += ('/' + dirArr[i])
                    }
                }

                fetch(item.raw_url).then(res => {
                    const dest = fs.createWriteStream(savePath)
                    res.body.pipe(dest)
                }).catch(err => {
                    logger('GetModifyFile').log(`保存文件失败，err: ${JSON.stringify(err)}`);
                })

                filesModify.push(item.patch.new_path);
            })
            return filesModify;
        })
        .catch((error: any) => {
            console.log(JSON.stringify(error))
            return JSON.stringify(error)
        })
    console.log(filesModify)
    return getProjectPath(PRId, filesModify);
}
export { getModifyFilelist }