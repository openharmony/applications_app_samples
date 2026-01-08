# RPC_Client 测试用例归档

## 用例表

|测试功能|预置条件| 输入       |预期输出|测试结果|
|----------|-----------|----------|----------------|----------------|
|拉起应用|安装sample| 无        |成功拉起应用|Pass|
|检测首页UI|进入首页| 无        |首页UI显示正常|Pass|
|获取权限| getPermission 按钮显示正常| 点击 getPermission 按钮 |允许多设备协同弹窗正常弹出，符合预期|Pass|
|获取对端设备信息| getDeviceId 按钮显示正常| 点击 getDeviceId 按钮 |成功获取对端设备信息，弹窗显示“getDeviceId success”，符合预期|Pass|
|连接服务| connecAbility 按钮显示正常| 点击 connecAbility 按钮 |因服务端在后台运行，连接服务成功，弹窗显示“connectAbility success”，符合预期|Pass|
|发送字符串信息| sendRequest_String 按钮显示正常| 点击 sendRequest_String 按钮 |成功发送消息，并接收服务端返回的字符串，弹窗显示“sendRequest success”，符合预期|Pass|
|断开连接| disconnecAbility 按钮显示正常| 点击 disconnecAbility 按钮 |成功断开服务，弹窗显示“disconnectAbility success”，符合预期|Pass|
|死亡回调| 服务端应用手动kill或进行退出后台| 手动清理服务端所在后台应用 |服务端死亡，符合预期|Pass|
