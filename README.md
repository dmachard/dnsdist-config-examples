# Configurations for DNSdist

Configuration examples for DNSdist PowerDNS

**Default configuration provided**:

- Default configuration provided by PowerDNS
    * [LUA](./lua/default_config.lua)

**Enable console and web interface**:

- Enable web admin and console interfaces
    * [YAML](./yaml/admin_config.yml)
    * [LUA](./lua/admin_config.lua)

**Enable DoH, DoQ and DoT services**:

- Enable web admin and console interfaces
    * [YAML](./yaml/services_dox.yml)
    * [LUA](./lua/services_dox.lua)

**Routing DNS traffic**:

- [Match Qname with regular expression](./lua/routing_regex.lua)
- [Tag your traffic and applied specified rules on it](./lua/routing_tag_traffic.lua)
- [Match your traffic from ECS client subnet](./lua/decode_ecs.lua)
- [Passing source IP client with ProxyProtocol](./lua/routing_add_proxyprotocol.lua)

**Security configuration**:

- [Ads/Malwares blocking with external CDB database](./lua/security_blacklist_cdb.lua)
- [DNS tunneling blocking](./lua/security_blocking_dnstunneling.lua)
- [Blackhole/spoofing domains with external files](./lua/security_blackhole_domains.lua)
- [Blacklist IP addresses with DNS UPDATE control and dynamic blocking duration](./lua/security_blacklist_ip_dnsupdate.lua)
- [Blacklist IP during XX seconds, the list of IPs is managed with DNS notify and TTL for duration](./lua/security_blacklist_ip_notify.lua)
- [List of temporarily blocked domains, the list is managed with DNS notify](./lua/security_blocklist_domains.lua)
- [Spoofing DNS responses like TXT, A, AAAA, MX and more...](./lua/security_spoofing_qtype.lua)

**Logging DNS traffic**:

- Remote DNS logging with DNSTAP protocol and [DNScollector](https://github.com/dmachard/DNS-collector)
    * [YAML](./yaml/logging_dnstap.yml)
    * [LUA](./lua/logging_dnstap.lua)
- [Add extra informations in DNStap field](./lua/logging_dnstap_extra.lua)
- [Remote DNS logging with Protobuf protocol](./lua/logging_protobuf.lua)

**Miscs**:

- [Full configuration with load balancing on public DNS resolvers](./lua/miscs_basic_config.lua)
- [Flush cache for domain with DNS NOTIFY](./lua/miscs_cache_flush_notify.lua)
- [Echo capability of ip address from domain name for development](./lua/miscs_echoip.lua)
- [Resolve hostname from config](./lua/miscs_resolve_hostname.lua)
- [Add uniq ID between queries and replies and send it through EDNS ](./lua/miscs_add_uniqid.lua)
- [Set RequestorID with FFI](./lua/miscs_ffi_requestorid.lua)

## Run config from docker

Start dnsdist for v2.x

```bash
sudo docker run -d -p 8053:53/udp -p 8053:53/tcp -p 8083:8080 --name=dnsdist --volume=$PWD/lua/basic_config.lua:/etc/dnsdist/conf.d/dnsdist.conf:ro powerdns/dnsdist-20:2.0.0-alpha1 -C /etc/dnsdist/dnsdist.yml
```

Start dnsdist for v1.x

```bash
sudo docker run -d -p 8053:53/udp -p 8053:53/tcp -p 8083:8080 --name=dnsdist --volume=$PWD/lua/basic_config.lua:/etc/dnsdist/conf.d/dnsdist.conf:ro powerdns/dnsdist-18:1.8.0
```

Reload configuration

```bash
sudo docker stop dnsdist && sudo docker start dnsdist
```

Display logs

```bash
sudo docker logs dnsdist
dnsdist 1.8.0 comes with ABSOLUTELY NO WARRANTY. This is free software, and you are welcome to redistribute it according to the terms of the GPL version 2
Added downstream server 1.1.1.1:53
Listening on 0.0.0.0:53
ACL allowing queries from: 10.0.0.0/8, 100.64.0.0/10, 127.0.0.0/8, 169.254.0.0/16, 172.16.0.0/12, 192.168.0.0/16, ::1/128, fc00::/7, fe80::/10
Console ACL allowing connections from: 127.0.0.0/8, ::1/128
Marking downstream 1.1.1.1:53 as 'up'
Polled security status of version 1.8.0 at startup, no known issues reported: OK
```

Testing DNS resolution

```bash
dig @127.0.0.1 -p 8053 +tcp google.com
```

Testing Web console access

```bash
curl -u admin:open http://127.0.0.1:8083
```
