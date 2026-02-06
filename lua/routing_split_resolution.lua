-- listen
setLocal('192.168.1.253:53', { reusePort=true })
addLocal('172.16.0.253:53', { reusePort=true })

addACL('::/0')

-- default pool
newServer({address = "127.0.0.1:5301", pool="default"})

-- enable dnstap
fstl = newFrameStreamTcpLogger("127.0.0.1:6000")

-- enable dns caching
pc = newPacketCache(50000, {})
getPool("default"):setCache(pc)

-- block invalid resolution
kvs = newCDBKVStore("/etc/dnsdist/conf.d/blocklist.cdb", 3600)
addAction(KeyValueStoreLookupRule(kvs, KeyValueLookupKeyQName(false)), SetTagAction("policy", "block"))
addAction(TagRule("policy", "block"), DnstapLogAction("dnsdist_block", fstl))
addAction(TagRule("policy", "block"), SpoofAction({"127.0.0.1", "::1"}))

-- internal
addAction(AndRule({NetmaskGroupRule("192.168.1.0/24"),QTypeRule(DNSQType.A), RegexRule(".*\\.homelab\\.tld")}), SetTagAction("policy", "home"))
addAction(AndRule({NetmaskGroupRule("192.168.1.0/24"),QTypeRule(DNSQType.AAAA), RegexRule(".*\\.homelab\\.tld")}), SetTagAction("policy", "home"))

addAction(TagRule("policy", "home"), DnstapLogAction("dnsdist_home", fstl))
addAction(TagRule("policy", "home"), SpoofAction({"192.168.1.253"}))

-- vpn
addAction(AndRule({NetmaskGroupRule("172.16.0.0/12"),QTypeRule(DNSQType.A), RegexRule(".*\\.homelab\\.tld")}), SetTagAction("policy", "vpn"))
addAction(AndRule({NetmaskGroupRule("172.16.0.0/12"),QTypeRule(DNSQType.AAAA), RegexRule(".*\\.homelab\\.tld")}), SetTagAction("policy", "vpn"))

addAction(TagRule("policy", "vpn"), DnstapLogAction("dnsdist_vpn", fstl))
addAction(TagRule("policy", "vpn"), SpoofAction({"172.16.0.253"}))

-- handle the rest
addAction(AllRule(),  SetTagAction("policy", "pass"))
addAction(TagRule("policy", "pass"), DnstapLogAction("dnsdist_pass", fstl))
addResponseAction(TagRule("policy", "pass"), DnstapLogResponseAction("dnsdist_pass", fstl))
addCacheHitResponseAction(TagRule("policy", "pass"), DnstapLogResponseAction("dnsdist_pass", fstl))
addAction(TagRule("policy", "pass"), PoolAction("default"))