# Configurations for DNSdist

Configuration examples for DNSdist PowerDNS

**Default configuration provided**:

- Default configuration provided by PowerDNS [LUA](./lua/default_config.lua)

**Administration**:

- Enable web admin and console interfaces for easier management [YAML](./yaml/admin_config.yml) / [LUA](./lua/admin_config.lua)

**DoX services**:

- Enable secure DNS protocols such as DoT (DNS over TLS), DoH (DNS over HTTPS), and DoQ (DNS over QUIC): [YAML](./yaml/services_dox.yml) / [LUA](./lua/services_dox.lua)

**Backend management**:

- Dynamic pool creation with hostname instead of IP [LUA](./lua/backend_hostname.lua)

**DNS Traffic Routing**:

- Match domain queries using regular expressions [YAML](./yaml/routing_regex.yml) / [LUA](./lua/routing_regex.lua)
- Tag DNS traffic and apply specific rules [YAML](./yaml/routing_tag_traffic.yml) / [LUA](./lua/routing_tag_traffic.lua)
- Route traffic based on ECS (EDNS Client Subnet): [YAML](./yaml/routing_decode_ecs.yml) / [LUA](./lua/decode_ecs.lua)
- Read client source IP via Proxy Protocol and apply custom routing [YAML](./yaml/routing_read_proxyprotocol.yml) / [LUA](./lua/routing_read_ip_proxyprotocol.lua)
- Add client source IP using Proxy Protocol [YAML](./yaml/routing_add_ip_proxyprotocol.yml) / [LUA](./lua/routing_add_proxyprotocol.lua)

**Security**:

- Ads/Malwares blocking with external CDB database [YAML](./yaml/security_blacklist_cdb.yml) / [LUA](./lua/security_blacklist_cdb.lua)
- Blackhole/spoofing domains with external files [YAML](./yaml/security_blackhole_domains.yml) / [LUA](./lua/security_blackhole_domains.lua)
- [DNS tunneling blocking](./lua/security_blocking_dnstunneling.lua)
- [Blacklist IP addresses with DNS UPDATE control and dynamic blocking duration](./lua/security_blacklist_ip_dnsupdate.lua)
- [Blacklist IP during XX seconds, the list of IPs is managed with DNS notify and TTL for duration](./lua/security_blacklist_ip_notify.lua)
- [List of temporarily blocked domains, the list is managed with DNS notify](./lua/security_blocklist_domains.lua)
- [Spoofing DNS responses like TXT, A, AAAA, MX and more...](./lua/security_spoofing_qtype.lua)

**Logging DNS traffic with [DNS-collector](https://github.com/dmachard/DNS-collector)**:

- Remote DNS logging with DNSTAP protocol [YAML](./yaml/logging_dnstap.yml) / [LUA](./lua/logging_dnstap.lua)
- Add extra informations in DNStap field [YAML](./yaml/logging_dnstap_extra.yml) / [LUA](./lua/logging_dnstap_extra.lua)
- Remote DNS logging with Protobuf protocol [YAML](./yaml/logging_protobuf.yml) / [LUA](./lua/logging_protobuf.lua)

**Miscs**:

- [Set RD (Recursive Desired) flag](./lua/miscs_set_rd_flags.lua)
- [Full configuration with load balancing on public DNS resolvers](./lua/miscs_basic_config.lua)
- [Flush cache for domain with DNS NOTIFY](./lua/miscs_cache_flush_notify.lua)
- [Echo capability of ip address from domain name for development](./lua/miscs_echoip.lua)
- [Resolve hostname from config](./lua/miscs_resolve_hostname.lua)
- [Add uniq ID between queries and replies and send it through EDNS](./lua/miscs_add_uniqid.lua)
- [Set RequestorID with FFI](./lua/miscs_ffi_requestorid.lua)

## Run config from docker

Choose the YAML configuration file you want to run from the yaml/ folder and copy it to dnsdist.yml in the project root:

```bash
cp yaml/<example_file>.yml ./dnsdist.yml
``` 
> Replace <example_file> with the configuration you want to test, e.g., admin_config.yml.

Then start dnsdist

```bash
sudo docker compose up -d
```

Display logs

```bash
sudo docker compose logs -f
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
dig @127.0.0.1 -p 5753 +tcp google.com
```

Testing Web console access

```bash
curl -u admin:badpassword http://127.0.0.1:8083
```
