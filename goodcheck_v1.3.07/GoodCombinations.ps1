$combination_pool = @(
    '-f 2 -e 2',
    '--native-frag',
    '--reverse-frag',
    '--wrong-seq',
    '--wrong-chksum',
    '--frag-by-sni',
    '--set-ttl 3',
    '--set-ttl 4',
    '--set-ttl 5'
)

function Get-Combinations {
    param (
        [array]$items,
        [int]$length
    )

    if ($length -eq 1) {
        return $items | ForEach-Object { @($_) }
    }

    $results = @()
    for ($i = 0; $i -le $items.Count - $length; $i++) {
        $head = $items[$i]
        $tail = $items[($i + 1)..($items.Count - 1)]
        $subcombs = Get-Combinations -items $tail -length ($length - 1)
        foreach ($comb in $subcombs) {
            $results += ,(@($head) + $comb)
        }
    }
    return $results
}

$maxLen = $combination_pool.Count
for ($len = 1; $len -le $maxLen; $len++) {
    $combs = Get-Combinations -items $combination_pool -length $len
    foreach ($c in $combs) {
        $joined = ($c -join ' ')

        if ($joined -match '--native-frag' -and $joined -match '--reverse-frag') {
            continue
        }

        if ($(([regex]::Matches($joined, '--set-ttl\s+\d+')).Count) -gt 1) {
            continue
        }

        Write-Output "$joined"

    }
}

Write-Host "--max-payload"
Write-Host "--dns-addr 1.1.1.1 --dnsv6-addr 2606:4700:4700::1111"
Write-Host "--dns-addr 8.8.8.8 --dnsv6-addr 2001:4860:4860::8888"
Write-Host "--dns-addr 9.9.9.9 --dnsv6-addr 2620:fe::fe"
Write-Host "--dns-addr 94.140.14.14 --dnsv6-addr 2a10:50c0::ad1:ff"
Write-Host "--dns-addr 208.67.222.222 --dnsv6-addr 2620:119:35::35"
Write-Host "--dns-addr 77.88.8.8 --dnsv6-addr 2a02:6b8::feed:0ff"
Write-Host "-q"

pause

<#
ipconfig /flushdns
ipconfig /all

ping www.google.com
ping discord.com
ping www.wattpad.com

nslookup www.google.com
nslookup discord.com
nslookup www.wattpad.com

tracert www.google.com
tracert discord.com
tracert www.wattpad.com

https://www.cloudflare.com/ssl/encrypted-sni
https://dnscheck.tools

--dns-addr 1.1.1.1 --dnsv6-addr 2606:4700:4700::1111
--dns-addr 8.8.8.8 --dnsv6-addr 2001:4860:4860::8888
--dns-addr 9.9.9.9 --dnsv6-addr 2620:fe::fe
--dns-addr 94.140.14.14 --dnsv6-addr 2a10:50c0::ad1:ff
--dns-addr 208.67.222.222 --dnsv6-addr 2620:119:35::35
--dns-addr 77.88.8.8 --dnsv6-addr 2a02:6b8::feed:0ff

--dns-addr 1.1.1.1 --dns-port 53 --dnsv6-addr 2606:4700:4700::1111 --dnsv6-port 53
--dns-addr 8.8.8.8 --dns-port 53 --dnsv6-addr 2001:4860:4860::8888 --dnsv6-port 53
--dns-addr 9.9.9.9 --dns-port 53 --dnsv6-addr 2620:fe::fe --dnsv6-port 53
--dns-addr 94.140.14.14 --dns-port 53 --dnsv6-addr 2a10:50c0::ad1:ff --dnsv6-port 53
--dns-addr 208.67.222.222 --dns-port 53 --dnsv6-addr 2620:119:35::35 --dnsv6-port 53
--dns-addr 77.88.8.8 --dns-port 53 --dnsv6-addr 2a02:6b8::feed:0ff --dnsv6-port 53
#>
