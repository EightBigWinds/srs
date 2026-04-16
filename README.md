# srs

自动每小时同步上游域名列表，并生成 sing-box 可直接引用的二进制规则集文件。

当前产物路径是：

- `sing-box/source/cn-additional-list.txt`
- `sing-box/source/cn-additional-list.json`
- `sing-box/srs/cn-additional-list.srs`

如果仓库名和分支保持不变，给 sing-box 用的远程地址可以写成：

`https://raw.githubusercontent.com/EightBigWinds/srs/main/sing-box/srs/cn-additional-list.srs`
