# Autocomplete known hosts
hosts=($((( [ -r .ssh/known_hosts  ] && awk '{print $1}' .ssh/known_hosts | tr , '\n' );) | sort -u))

zstyle ':completion:*' hosts $hosts
zstyle ':completion:*:*:*:hosts' ignored-patterns localhost loopback ip6-localhost ip6-loopback localhost6 localhost6.localdomain6 localhost.localdomain
