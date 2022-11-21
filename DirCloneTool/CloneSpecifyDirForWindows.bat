::/*
::* Copyright (c) 2022 Huawei Device Co., Ltd.
::* Licensed under the Apache License, Version 2.0 (the "License");
::* you may not use this file except in compliance with the License.
::* You may obtain a copy of the License at
::*
::*     http://www.apache.org/licenses/LICENSE-2.0
::*
::* Unless required by applicable law or agreed to in writing, software
::* distributed under the License is distributed on an "AS IS" BASIS,
::* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
::* See the License for the specific language governing permissions and
::* limitations under the License.
::*/

@echo off
git init
git config core.sparsecheckout true
set /p specifyDir=please input the project directory to download, end with /: 
if [%specifyDir%] == [] (
    echo ERROR: the project directory to download is empty.
) else (
    @echo %specifyDir% > .git/info/sparse-checkout

    git remote add origin https://gitee.com/openharmony/applications_app_samples.git
    git pull origin master
)

pause