import commonEvent from '@ohos.commonEventManager';

export function commonEventPowerDataFunc(powerBoolean: boolean) {
  let commonEventData: commonEvent.CommonEventPublishData = {
    parameters: {
      powerBoolean: powerBoolean,
    }
  };
  try {
    commonEvent.publish('powerBoolean', commonEventData, (err) => {
      console.log("onSystemEvent powerBoolean Err:" + JSON.stringify(err));
    });
  } catch (err) {
    console.log("onSystemEvent  powerBoolean catch Err:" + JSON.stringify(err));
  }
}