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
::配置与SDK版本一致的toolchains路径 如：D:\DevEco\Full_SDK\NEW_SDK\9\toolchains
set hdc=

::卸载旧的元服务
%hdc%\hdc uninstall com.samples.asorangeshopping

::hsp包路径，有安装顺序
%hdc%\hdc install -r .\shoppingdata\build\default\outputs\default\shoppingdata-default-signed.hsp
%hdc%\hdc install -r .\search\build\default\outputs\default\search-default-signed.hsp
%hdc%\hdc install -r .\video\build\default\outputs\default\video-default-signed.hsp

::hap包路径，无安装顺序
%hdc%\hdc install -r .\entry\build\default\outputs\default\entry-default-signed.hap
%hdc%\hdc install -r .\productdetail\build\default\outputs\default\productdetail-entry-default-signed.hap
%hdc%\hdc install -r .\usercenter\build\default\outputs\default\usercenter-entry-default-signed.hap

%hdc%\hdc shell aa start -a EntryAbility -b com.samples.asorangeshopping
pause