# Sensor 测试用例归档

## 用例表

| 测试功能            | 预置条件      | 输入                              | 预期输出             | 是否自动 | 测试结果 |
| --------------- | --------- | ------------------------------- | ---------------- | ---- | ---- |
|                 | 设备正常运行    |                                 | 成功拉起应用           | 是    | Pass |
| 申请权限            | 成功拉起应用    |                                 | 弹出提示框            | 是    | Pass |
| 订阅传感器           | 选择一个传感器类型 | 点击subscribe按钮                   | 订阅成功，数据上报正常      | 是    | Pass |
| 去订阅传感器          | 选择一个传感器类型 | 点击unsubscribe按钮                 | 去订阅成功，数据停止上报     | 是    | Pass |
| 获取设备传感器信息列表     | 无         | 点击getSensorListDeviceSync按钮     | 设备传感器列表信息获取正常    | 是    | Pass |
| 获取指定设备指定类型传感器信息 | 无         | 点击getSingleSensorByDeviceSync按钮 | 指定设备的指定传感器信息获取正常 | 是    | Pass |
| 订阅扩展设备热插拔事件     | 无         | 点击on SensorStatusChange按钮       | 订阅正常             | 是    | Pass |
| 去订阅扩展设备热插拔事件    | 无         | 点击off SensorStatusChange按钮      | 去订阅正常            | 是    | Pass |
| 订阅传感器By SensorInfoParam    | 选择一个传感器类型 | 点击subscribeUseSensorInfoParam按钮                   | 订阅成功，数据上报正常      | 是    | Pass |
| 订阅传感器变化一次    | 选择一个传感器类型 | 点击onceSubscribe按钮                   | 订阅成功，数据上报正常      | 是    | Pass |
| 取消订阅传感器by SensorInfoParam    | 选择一个传感器类型 | 点击unSubscribeUseSensorInfoParam按钮                 | 去订阅成功，数据停止上报     | 是    | Pass |
| 获取某时刻地球上特定位置的地磁场信息    | 无         | 点击getGeomagneticInfo按钮      | 弹出提示框            | 是    | Pass |
| 根据气压值获取海拔高度    | 无         | 点击getDeviceAltitude按钮      | 弹出提示框            | 是    | Pass |
| 根据倾斜矩阵计算地磁倾角    | 无         | 点击getInclination按钮      | 弹出提示框            | 是    | Pass |
| 计算两个旋转矩阵之间的角度变化    | 无         | 点击getAngleVariation按钮      | 弹出提示框            | 是    | Pass |
| 根据旋转矢量获取旋转矩阵    | 无         | 点击getRotationMatrix按钮      | 弹出提示框            | 是    | Pass |
| 根据指定坐标系映射旋转矩阵    | 无         | 点击transformRotationMatrix按钮      | 弹出提示框            | 是    | Pass |
| 根据旋转向量计算归一化四元数    | 无         | 点击getQuaternion按钮      | 弹出提示框            | 是    | Pass |
| 根据旋转矩阵计算设备方向    | 无         | 点击getOrientation按钮      | 弹出提示框            | 是    | Pass |
| 根据重力矢量和地磁矢量计算旋转矩阵    | 无         | 点击getRotationMatrixTwoParam按钮      | 弹出提示框            | 是    | Pass |
| 获取指定传感器类型的属性信息    | 无         | 点击getSingleSensor按钮      | 弹出提示框            | 是    | Pass |
| 清除sensor信息列表    | 无         | 点击clean按钮                       | 列表显示恢复默认         | 是    | Pass |


