git submodule update --init --recursive

if [ -z "$1" ]; then
  echo "Missing set name"
  exit 1
fi

sudo systemctl stop ipset.service
sudo iptables -t nat -F
sudo ipset destroy $1
sudo ipset create $1 hash:net

for ip_range in `cat ./china_ip_list/china_ip_list.txt`; do
  echo "Adding $ip_range to $1"
  sudo ipset --add $1 $ip_range
done

sudo sh -c 'ipset save > /etc/ipset.conf'
sudo systemctl restart iptables.service
