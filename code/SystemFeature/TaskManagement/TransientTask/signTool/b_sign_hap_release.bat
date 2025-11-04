:: Copyright (c) 2023 Huawei Device Co., Ltd.
:: Licensed under the Apache License, Version 2.0 (the "License");
:: you may not use this file except in compliance with the License.
:: You may obtain a copy of the License at
::
::  http://www.apache.org/licenses/LICENSE-2.0
::
:: Unless required by applicable law or agreed to in writing, software
:: distributed under the License is distributed on an "AS IS" BASIS,
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
:: See the License for the specific language governing permissions and
:: limitations under the License.

@echo off
java -jar hap-sign-tool.jar sign-profile -mode "localSign" -keyAlias "OpenHarmony Application Profile Release" -keyPwd "123456" -inFile "UnsgnedReleasedProfileTemplate.json" -outFile "app1-profile.p7b" -keystoreFile "OpenHarmony.p12" -keystorePwd "123456" -signAlg "SHA256withECDSA" -profileCertFile "OpenHarmonyProfileRelease.pem"
java -jar hap-sign-tool.jar sign-app -keyAlias "openharmony application release" -signAlg "SHA256withECDSA" -mode "localSign" -appCertFile "OpenHarmonyApplication.pem" -profileFile "app1-profile.p7b" -inFile "../entry/build/default/outputs/default/entry-default-unsigned.hap" -keystoreFile "OpenHarmony.p12" -outFile "../entry/build/default/outputs/default/entry-signed-release.hap" -keyPwd "123456" -keystorePwd "123456
pause