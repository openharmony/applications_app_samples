# UniformDataTypeDescriptors 测试用例归档

## 用例表

| 测试功能                      |预置条件| 输入          | 预期输出            |测试结果|
|---------------------------|--------------------------------|-------------|-----------------|--------------------------------|
| 拉起应用                      |	设备正常运行| 		          | 成功拉起应用          |Pass|
| 是否同一数据类型及是否存在归属关系功能测试     |	位于主页| 	点击uniformTypeDescriptorTest   | 打印数据类型相等、存在归属关系 |Pass|
| 通过文件后缀获取对应的MIMEType列表功能测试 |	位于主页| 	点击getMimeTypeByFilenameExtensions   | 打印对应mimeTypes类型 |Pass|
| 通过MIMEType获取对应的后缀列表功能测试   |	位于主页| 	点击getFilenameExtensionByMimeType   | 打印对应文件后缀名       |Pass|
