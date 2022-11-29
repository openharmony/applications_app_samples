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

/**
 * 头像背景色枚举类，主要承担如下职责
 * 1. 背景色枚举
 * 2. 随机生成背景色
 */
class ColorTemplates {
    private colors: string[]
    constructor() {
        this.colors = [
            'rgb(154,204,255)',
            'rgb(252,154,3)',
            'rgb(206,253,159)',
            'rgb(202,205,255)',
            'rgb(153,102,10)',
            'rgb(0,158,146)',
            'rgb(143,3,6)'
        ]
    }

    generateRandomColor(): string
    {
        return this.colors[Math.floor(Math.random()*7)]
    }
}

export default new ColorTemplates