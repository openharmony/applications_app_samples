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

import { Logger } from '@nestjs/common';
import { exec } from 'child_process';
import axios from 'axios';
import { ACCESS_TOKEN, PROJECT_PATH } from 'config.dev';

const FormData = require('form-data');

// 日志打印
const logger = (appName: string): Logger => new Logger(appName, { timestamp: true });

// 执行命令行
const executeCommand = (command: string, cwd: string = './'): Promise<string> => {
    return new Promise((resolve, reject) => {
        exec(command, { cwd }, (error, stdout, stderr) => {
            if (error) {
                logger('Command').error(JSON.stringify(error));
                reject(error);
            } else {
                logger('Command').log(JSON.stringify(stdout));
                resolve(JSON.stringify(stdout));
            }
        });
    });
};

const apiUrl = 'https://gitee.com/api/v5';
const owner = 'OpenHarmony';
const repo = 'applications_app_samples';

// 根据PR号获取
const getPRRequest = async (prNumber: string) => {
    try {
        const getPRUrl = `${apiUrl}/repos/${owner}/${repo}/pulls/${prNumber}`;
        const response = await axios.get(getPRUrl, {
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${ACCESS_TOKEN}`
            }
        });
        logger('GetPR').log('获取PR成功 ');
        return response.data;
    } catch (error) {
        logger('GetPR').error('获取PR失败 ' + JSON.stringify(error));
    }
}

const pullPRCode = async (prNumber: string) => {
    let PRMsg
    try {
        PRMsg = await getPRRequest(prNumber);
    } catch (error) {
        logger('pullPRCode').error('获取PR失败');
        return {
            status: 'failed',
            msg: '获取PR失败' + JSON.stringify(error)
        };
    }
    let msg = '';
    try {
        await executeCommand(`git remote add ${prNumber} git@gitee.com:${PRMsg.user.login}/${PRMsg.head.repo.path}.git`, '../../applications_app_samples');
        await executeCommand(`git fetch ${prNumber}`, '../../applications_app_samples');
        await executeCommand(`git checkout ${prNumber}/${PRMsg.head.ref}`, '../../applications_app_samples');
        logger('pullPRCode').log('拉取PR代码成功');
        msg = '拉取PR代码成功';
    } catch (error) {
        logger('pullPRCode').error('拉取PR代码失败 ' + JSON.stringify(error));
        msg = '拉取PR代码失败 ' + JSON.stringify(error);
    }
    return {
        status: 'success',
        msg
    };
}


// 评论指定PR
const commitPRRequest = async (prNumber: number, content: string) => {
    const commitPRUrl = `${apiUrl}/repos/${owner}/${repo}/pulls/${prNumber}/comments`;
    const form = new FormData();
    form.append('access_token', ACCESS_TOKEN);
    form.append('body', content);
    return axios.post(commitPRUrl, form, {
        headers: {
            'Content-Type': 'multipart/form-data'
        }
    }).then(response => {
        if (response.status === 201) {
            logger('CommitPR').log('评论指定PR成功');
            return {
                status: 'success'
            };
        }
        logger('CommitPR').log('评论指定PR失败');
        return {
            status: 'failed'
        };
    }, error => { });
}


export {
    executeCommand,
    logger,
    getPRRequest,
    commitPRRequest,
    pullPRCode
};