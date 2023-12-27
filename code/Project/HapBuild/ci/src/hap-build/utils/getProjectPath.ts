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

import { buildListProject } from "./buildListProject";
import { PROJECT_PATH } from "config.dev";

function getProjectPath(PRId: number, modifyPath: Array<string>) {
    let projectPath = [];
    const fs = require('fs');
    modifyPath.forEach((item: string) => {
        let iteraterArray = item.split('/');
        let pathString = '';
        for (let i = 0; i < iteraterArray.length; i++) {
            if (!fs.existsSync(PROJECT_PATH + pathString + '/build-profile.json5')) {
                pathString = `${pathString}/${iteraterArray[i]}`;
            } else if (!projectPath.includes(pathString.substring(1))) {
                pathString = pathString.substring(1);
                projectPath.push(pathString);
                break;
            };
        };
    });
    console.log('PR修改文件的项目路径是： ');
    console.log(projectPath);
    return buildListProject(PRId, projectPath);
}

export { getProjectPath };