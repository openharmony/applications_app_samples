# 图片压缩方案

## 用例表

| 测试功能                              | 预置条件                                | 输入                   | 预期输出                               | 是否自动 | 测试结果 |
|-----------------------------------|-------------------------------------|----------------------|------------------------------------|------|------|
| 自动模式 | 1. 需在真机测试 <br/> 2. 构建并安装测试hap | 1. 点击“自动模式” <br> 2. 点击“压缩” | 1. 弹框提示“压缩成功” <br> 2. 显示压缩后的图片 <br> 3. 在沙箱路径可以看到压缩后图片：/data/app/el2/100/base/com.examples.Imagecompression/haps/entry/files/output/result.jpg(heic) | 否    | Pass |
| 手动模式 | 1. 需在真机测试 <br/> 2. 构建并安装测试hap | 1. 点击“手动模式” <br> 2. 点击“压缩” | 1. 图片压缩目标大小区域禁用 <br> 2. 弹框提示“压缩成功” <br> 3. 显示压缩后的图片 <br> 4. 在沙箱路径可以看到压缩后图片：/data/app/el2/100/base/com.examples.Imagecompression/haps/entry/files/output/result.jpg(heic) | 否    | Pass |
| 图片压缩目标大小 | 1. 需在真机测试 <br/> 2. 构建并安装测试hap | 1. “图片压缩目标大小”输入框内输入80 <br> 2. 点击“压缩” | 1. 弹框提示“压缩成功” <br> 3. 显示压缩后的图片 <br> 4. 在沙箱路径可以看到压缩后图片：/data/app/el2/100/base/com.examples.Imagecompression/haps/entry/files/output/result.jpg(heic) <br> 5. “压缩后：”后面显示压缩后的图片大小，且大小接近80 | 否    | Pass |
| 输出格式：JPG | 1. 需在真机测试 <br/> 2. 构建并安装测试hap | 1. 点击输出格式的“JPG”选项 <br> 2. 点击“压缩” | 1. 弹框提示“压缩成功” <br> 3. 显示压缩后的图片 <br> 4. 在沙箱路径可以看到压缩后图片：/data/app/el2/100/base/com.examples.Imagecompression/haps/entry/files/output/result.jpg <br> 5. “压缩后：”后面的格式为“jpg” | 否    | Pass |
| 输出格式：HEIF | 1. 需在真机测试 <br/> 2. 构建并安装测试hap | 1. 点击输出格式的“HEIF”选项 <br> 2. 点击“压缩” | 1. 弹框提示“压缩成功” <br> 3. 显示压缩后的图片 <br> 4. 在沙箱路径可以看到压缩后图片：/data/app/el2/100/base/com.examples.Imagecompression/haps/entry/files/output/result.heic <br> 5. “压缩后：”后面的格式为“heif” | 否    | Pass |