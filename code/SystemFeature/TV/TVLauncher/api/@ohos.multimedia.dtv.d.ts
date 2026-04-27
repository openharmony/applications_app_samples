/**
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { AsyncCallback } from './basic';


/**
 * dtv
 * @since 6
 * @syscap SystemCapability.Multimedia.Dtv.Core
 */
declare namespace dtv {

    function onSystemEvent(event): void;

    export enum msgType {
        MSG_DVB_TUNE_SUCCESS = 10001,
        MSG_DVB_TUNE_FAILED = 10002,
        MSG_DVB_TUNE_SIGNAL_WEAK = 10003,
        MSG_DVB_TUNE_SIGNAL_LOST = 10004,
        MSG_DVB_TUNE_SIGNAL_RECOVER = 10005,
        MSG_DVB_SCAN_TUNER_FAILED = 10108,
        MSG_DVB_SCAN_NIT_FAILED = 10109,
        MSG_DVB_SCAN_PAT_FAILED = 10110,
        MSG_DVB_SCAN_PMT_FAILED = 10111,
        MSG_DVB_SCAN_SDT_FAILED = 10112,
        MSG_DVB_SCAN_CAT_FAILED = 10113,
        MSG_DVB_SCAN_START = 10025,
        MSG_DVB_SCAN_FINISHED = 10026,
        MSG_DVB_SCAN_FAILED = 10027,
        MSG_DVB_SCAN_FIND_SERVICES = 10028,
        MSG_DVB_SCAN_SAVE_SUCCESS = 10101,
        MSG_DVB_SCAN_SAVE_FAILED = 10102,
    }

    export enum dvbMode {
        DVB_C_MOD_UNDEFINED = 0,
        DVB_C_MOD_QAM16 = 1,
        DVB_C_MOD_QAM32 = 2,
        DVB_C_MOD_QAM64 = 3,
        DVB_C_MOD_QAM128 = 4,
        DVB_C_MOD_QAM256 = 5,
    }

    export enum deliveryType {
        DVB_DELIVERY_TYPE_DVB_C = 1,
        DVB_DELIVERY_TYPE_ABS_SS = 10,
        DVB_DELIVERY_TYPE_DTNB = 12,
    }

    /*
    * DT_Test
    *
    * */
    class DvbService {

        /*
         * DT_Test
         *
         * */

        getLocation() : string;

        getServiceId(): number; //获取频道ID

        getServiceName(): string; //获取频道名称
    }

    /*
     * DT_Test
     *
     * */
    class Channel {
        getService(): DvbService;
    }

    /*
    * DT_Test
    *
    * */
    class ChannelManager {
        getShutDownChannel(): string;

        setShutDownChannel(url:string):void;

        filter(type: number[], params: number[]): Channel[];
    }


    class DvbTune {
        /**
         * 调谐到指定频点
         *
         * @since 8
         * @param deliveryType Indicates the authentication type.
         * @param paramsObj Indicates the caller bundle name.
         * @return void.
         */
        tune(deliveryType: number, paramsObj: Object): void;

        /**
         * 获取Tuner信息，包括信号质量、信号强度、误码率、信号电平、信噪比。
         *
         * @since 8
         * @param deliveryType Indicates the authentication type.
         * @param paramsObj Indicates the caller bundle name.
         * @return void.
         */
        getTunerSignalInfotune(): void;

        /**
         * 获取当前系统支持的所有Tuner信息
         *
         * @since 8
         * @param deliveryType Indicates the authentication type.
         * @param paramsObj Indicates the caller bundle name.
         * @return void.
         */
        getAllTunerInfos(): void;
    }

    class DvbScan {
        /**
         * 保存频道数据
         *
         * @since 8
         * @return void.
         */
        save(): void;

        /**
         * 删除数据库所有频道
         *
         * @since 8
         * @return void.
         */
        deleteAll() : number;

        /**
         * 启动频道搜索
         *
         * @since 8
         * @return void.
         */
        startScan(scanType: number, deliveryType: number, objArray: Object[]): void;

        /**
         * 停止频道搜索
         *
         * @since 8
         * @param deliveryType Indicates the authentication type.
         * @param paramsObj Indicates the caller bundle name.
         * @return void.
         */
        stopScan(): void;
    }

    /**
     * 电子节目指南管理器对象
     */
    class EPGManager {
        /*
        根据url获取节目列表
        */
        getProgramsByService(serviceLocator: string): Object[];

        /*
         获取指定业务的当前节目。
        */
        getPresentProgram(serviceLocator: string): Object;

        //获取接下来的节目
        getFollowingProgram(serviceLocator:string):Object;

    }
}

export default dtv;