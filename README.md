# srs

自动每小时同步上游域名列表，并生成 sing-box 可直接引用的二进制规则集文件。

当前产物路径是：

- `sing-box/source/cn-additional-list.txt`
- `sing-box/source/cn-additional-list.json`
- `sing-box/srs/cn-additional-list.srs`

如果仓库名和分支保持不变，给 sing-box 用的远程地址可以写成：

`https://raw.githubusercontent.com/EightBigWinds/srs/main/sing-box/srs/cn-additional-list.srs`

上游数据来源于@fastoo https://www.nodeseek.com/post-464238-1

https://static-file-global.353355.xyz/rules/cn-additional-list.txt
纯文本格式（每行一条）

https://static-file-global.353355.xyz/rules/cn-additional-list-clash.yaml
适用于 Clash Mihomo 核心的格式

https://static-file-global.353355.xyz/rules/cn-additional-list-clash-classical.yaml
适用于 Clash 核心的 Classical 格式

https://static-file-global.353355.xyz/rules/cn-additional-list.mrs
适用于 Clash Mihomo 核心的专用 MRS 文件

数据内容

中国大陆主流基础服务企业、互联网企业、云厂商、党政机关、高校、科研单位、APP开发者在工信部备案的域名。
数据条目

30000+条，不定期更新
数据来源

从 天眼查 爬取的国内主流企业在工信部存在【非经营性ICP备案号】或【许可证号】的域名
例如：

    京ICP备16045432号-4 -- feishu.cn
    粤B2-20090059-5 -- qq.com

法律依据

    根据国务院令第292号《互联网信息服务管理办法》和《非经营性互联网信息服务备案管理办法》规定，国家对经营性互联网信息服务实行许可制度，对非经营性互联网信息服务实行备案制度。未获取许可或者未履行备案手续的，不得从事互联网信息服务，否则属于违法行为。
    因此，所有对中国境内提供服务的网站/APP（非经营性互联网信息服务）都必须先进行 ICP 备案，备案成功并获取通信管理局下发的 ICP 备案号后才能开通访问。 腾讯云

实践建议

综上所述，此列表内的域名存在极高的可能性被解析到位于中国大陆的节点为大陆用户提供服务，故强烈建议将列表内的域名分流至【直连/Direct】以避免错误地将国内服务分流到代理链路。
相较其它常见中国域名列表的优势

维护本列表的初衷就是用于在代理工具中替代常见上游提供的中国域名列表 (geosite:cn)：

    felixonmars/dnsmasq-china-list
    v2fly/domain-list-community

为什么？

dnsmasq-china-list 设计之初是为国内域名的 DNS 解析优化、完全不适用于流量分流（dnsmasq-china-list 只检查域名的权威 DNS 服务器，因此有部分海外域名、因为 DNS 服务器位于中国大陆、依然被包含在 accelerated-domains.china.conf 中）。身处江苏、福建、河南、新疆等墙中墙地区的朋友应该深有体会... xhj024

而本人认为 v2fly/domain-list-community 项目也存在部分局限性，此项目对于国内域名数据的收集基本依靠社区反馈，而社区反馈大多依赖于抓包等技术手段，但其实在国内建过站的应该都不陌生，想用国内服务器/国内CDN节点提供服务，备案都是先决条件，故我们可以利用这一点，直接批量获取国内主流企事业单位主体的备案域名，实现更高的命中率。

由于国内大厂都存在大量分公司或关联主体，传统信息获取手段存在局限性，故我采用了天眼查这类第三方专业工具作为数据源，轻松探寻大厂在国内海量的关联主体。
关于国际企业在华主体

本项目原则上不收录国际在华企业（例如：苹果、三星、微软、英伟达、AWS中国、Cloudflare中国等）的备案域名，是权衡利弊后的结果，因为这些企业的情况较为特殊，往往存在大量由境外节点提供服务但使用备案域名的情况。

此项并不是绝对的，一些目测本地化较高的在华主体已收录（如百胜中国、麦当劳、星巴克等）。

互联网上已经存在大量较为成熟的相关规则，如果你需要可以酌情采用：
(以下规则来自 @Skk.Moe 大佬)

    https://ruleset.skk.moe/List/non_ip/apple_cdn.conf
    Apple 国内 CDN 域名

    https://ruleset.skk.moe/List/non_ip/microsoft_cdn.conf
    Microsoft 国内 CDN 域名

    https://ruleset.skk.moe/List/non_ip/apple_cn.conf
    云上贵州（icloud.com.cn）和苹果地图国内版等服务的域名，这部分域名需要国内直连访问。

    https://ruleset.skk.moe/List/non_ip/apple_services.conf
    排除了有国内 CDN 节点的域名和国区专用域名以后，苹果其余的域名。

    https://ruleset.skk.moe/List/non_ip/microsoft.conf
    排除了有国内 CDN 节点的域名和国区专用域名以后，微软其余的域名。

    https://ruleset.skk.moe/List/domainset/icloud_private_relay.conf
    iCloud Private Relay 域名列表。

温馨提示

为保障高命中率，平衡主流使用习惯及体验，列表内仍存在极少部分域名（或其子域名）被用于境外业务，但考虑到其在内地服务更为普遍，仍将其加入了本列表，例如：

    aliyuncs.com
    myqcloud.com
    ...

故建议有能力的用户根据自身实际情况将需要代理的国内域名手动加入代理列表。
收录规则

    不保证本列表的时效性、准确性及完整性，不建议用于生产环境
    原则上不收录备案主体为个人、个体工商户的域名
    政府及高校使用的专属域名（gov.cn / edu.cn / mil.cn）已收录，无需重复收录其子域名
    如需反馈，直接提供域名或备案号/主体名称在本帖即可
