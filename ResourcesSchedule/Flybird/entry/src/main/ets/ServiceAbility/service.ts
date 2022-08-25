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

import rpc from "@ohos.rpc"
import wantAgent from '@ohos.wantAgent';
import backgroundTaskManager from '@ohos.backgroundTaskManager';
import featureAbility from '@ohos.ability.featureAbility';
import logger from '../MainAbility/utils/logger'

const TAG: string = '[flybirdDebug.ServiceAbility]'

class FirstServiceAbilityStub extends rpc.RemoteObject {
    constructor(des: any) {
        if (typeof des === 'string') {
            super(des)
        } else {
            return
        }
    }

    onRemoteRequest(code: number, data: any, reply: any, option: any) {
        logger.log(`${TAG}onRemoteRequest called`)
        if (code === 1) {
            let dataStr = data.readString()
            logger.log(`${TAG} string=${dataStr}`)
            if (dataStr === 'start_game') {
                this.startContinousTask();
                let result = 'ok start game'
                logger.log(`${TAG} result=${result}`)
                reply.writeString(result)
            } else if (dataStr === 'disconnect_service') {
                let result = 'ok disconnect service'
                logger.log(`${TAG} result=${result}`)
                reply.writeString(result)
            } 
            else {
                logger.log(`${TAG} error string}`)
            }
        } else {
            logger.log(`${TAG} unknown request code`)
        }
        return true;
    }

    startContinousTask() {
        logger.info(TAG + " start background continousTask api");

        let wantAgentInfo = {
            wants: [
                {
                    bundleName: "com.samples.flybird",
                    abilityName: "com.samples.flybird.MainAbility"
                }
            ],
            operationType:wantAgent.OperationType.START_ABILITY,
            requestCode: 0,
            wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
        };

    }
     callback(err, data) {
        if (err) {
            logger.error(TAG + "Operation failed Cause: " + err);
        } else {
            logger.info(TAG + "Operation succeeded");
        }
    }

}

export default {
    onStart() {
        logger.info(`${TAG} onStart`)
    },
    onStop() {
        logger.info(`${TAG} onStop`)
    },
    onConnect(want) {
        logger.log(`${TAG} onConnect, want:${JSON.stringify(want)}`)
        return new FirstServiceAbilityStub("first ts service stub")
    },
    onDisconnect(want) {
        logger.log(`${TAG} onDisconnect, want:${JSON.stringify(want)}`)
    },
    onCommand(want, startId) {
        logger.log(`${TAG} onCommand, want:${JSON.stringify(want)},startId:${startId}`)
    }
};