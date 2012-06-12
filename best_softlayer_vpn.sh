#!/bin/bash
_vpns="pptpvpn.dal01.softlayer.com pptpvpn.sea01.softlayer.com pptpvpn.wdc01.softlayer.com  pptpvpn.lax01.softlayer.com pptpvpn.den01.softlayer.com pptpvpn.chi01.softlayer.com pptpvpn.atl01.softlayer.com pptpvpn.nyc01.softlayer.com pptpvpn.mia01.softlayer.com"
_out=/tmp/vpn.$$
>"$_out"
echo -n "Testing please wait.."
for v in ${_vpns}
do
    avgtime=$(ping -c 5 $v | grep 'round-trip' | awk -F'/' '{ print $5}')
    echo "$v $avgtime" >> "$_out"
    echo -n "."
done
echo 
_best=$(sort -n -k2 "$_out" | head -n 1)
echo "Recommended vpn : $_best"
echo "-----------------------"
echo "Result"
echo "-----------------------"
sort -n -k2 "$_out"
rm -f "$_out"
