declare namespace testNapi {
  function usbSerialInit(deviceId:number):number;
  function config(item:number, nData:string):number;
  function readTemperature():number;
  function close():number;
  function releaseResource():void;
  function setTimeOut(time:number):number;
}
export default testNapi;