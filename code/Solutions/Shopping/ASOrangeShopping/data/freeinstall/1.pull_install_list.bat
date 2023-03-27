:: Copyright (c) 2023 Huawei Device Co., Ltd.
:: Licensed under the Apache License, Version 2.0 (the "License");
:: you may not use this file except in compliance with the License.
:: You may obtain a copy of the License at
::
::     http://www.apache.org/licenses/LICENSE-2.0
::
:: Unless required by applicable law or agreed to in writing, software
:: distributed under the License is distributed on an "AS IS" BASIS,
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
:: See the License for the specific language governing permissions and
:: limitations under the License.

@echo off
del install_list_capability.json
hdc kill

::配置与SDK相同的hdc工具例如D:\DevEco\full_sdk1\toolchains\3.2.10.11\hdc
set hdc=

%hdc% shell mount -o rw,remount /
%hdc% file recv /system/etc/app/install_list_capability.json .
pause