#!/bin/sh

# Different ways to request options and wait for valid input

tput reset

################################################################################
# Number Selection, limited to 10, has to be hard coded
###############

OPT=0
echo "\nPlease choose from the following options"

tput sc
while [ ${OPT/[^0-9]/0} -gt 4 ] || [ ${OPT/[^0-9]/0} -le 0 ]; do
	tput rc
	echo "1. Do"
	echo "2. Do not"
	echo "3. Niether"
	echo "4. Do or do not, there is no try"
	read -p "Choose: " -n 1 -s OPT
	OPT=${OPT:-0}
done
echo $OPT


################################################################################
# Yes or no
###############


OPT=0
echo "\nPlease choose (y/n)? "

tput sc
until [ "${OPT/Y/y}" == "y" ] || [ "${OPT/N/n}" == "n" ]; do
	tput rc
	read -p "Choose: " -n 1 -s OPT
	OPT=${OPT:-0}
done
echo $OPT


################################################################################
# Letter Selection, limited to 26, has to be hard coded
###############


OPT=0
echo "\nPlease choose from the following options"

tput sc
until [[ "${OPT/[^A-z]/0}" == [A-D] ]] || [[ "${OPT/[^A-z]/0}" == [a-d] ]]; do
	tput rc
	echo "A. Do"
	echo "B. Do not"
	echo "C. Niether"
	echo "D. Do or do not, there is no try"
	read -p "Choose: " -n 1 -s OPT
	OPT=${OPT:-0}
done
echo $OPT


################################################################################
# Letter Selection, limited to 26, adapts to array
# Will crash if choosing [ or ] symbols
###############


echo "\nPlease choose from the following array options"

BABYNAMES=("True Wilson" "Noble Scot" "Legacy Smith" "Valor Allisons" "Jaxton Martins" "Jax Wright" "Elias Wringer" "Walker Falker" "Shane Young" "Jimmy Rae")
ALPHABET=({A..Z})

tput sc
while true; do
	tput rc
	INDEXSTART=0
	INDEXEND=$(( ${#BABYNAMES[@]}-1 ))
	for INDEX in  $(eval echo \{0..$INDEXEND\}); do
		echo "${ALPHABET[INDEX]}. ${BABYNAMES[INDEX]}"
	done
	read -p "Choose: " -n 1 -s OPT
	
	OPT="${OPT/[^A-z]/0}"
	OPT=${OPT:-0}
	OPT=$(tr [:lower:] [:upper:] <<< $OPT)
	
	INDEX=$(echo ${ALPHABET[@]}|sed "s/$OPT.*//"|wc -w)
	[ $INDEX -le $INDEXEND ] && break
done

echo $OPT

echo "You choose: ${BABYNAMES[INDEX]}"

################################################################################
# Letter and number Selection, limited to 36, adapts to array
# Will crash if choosing [ or ] symbols
###############


echo "\nPlease choose from the following array options"

BABYNAMES=("Sammy Davis" "Sally Lu Hu" "Penny Lane" "Mae Fae" "Bobby McGee" "Betty Boo" "Peggy Robinson" "Trudy McCornmish" "Ted Bundy" "Freddy Mac" "Loyal Hudgins" "True Wilson" "Noble Scot" "Legacy Smith" "Valor Allisons" "Jaxton Martins" "Jax Wright" "Elias Wringer" "Walker Falker" "Shane Young" "Jimmy Rae" "Linchin Jmaes" "Rob schnider" "Abby Normal" "Victor von Frankenstien" "Bram Stoker" "Arthur Hardey" "Ellen de Ville" "Reneé Winkle" "Albert Jones")
ALPHABET=({{A..Z},{0..9}})

tput sc
while true; do
	tput rc
	INDEXSTART=0
	INDEXEND=$(( ${#BABYNAMES[@]}-1 ))
	for INDEX in  $(eval echo \{0..$INDEXEND\}); do
		echo "${ALPHABET[INDEX]}. ${BABYNAMES[INDEX]}"
	done
	read -p "Choose: " -n 1 -s OPT
	
	OPT=$(sed "s/[^[:alnum:]]//g" <<< "$OPT"); echo $OPT
	OPT=${OPT:-0}
	OPT=$(tr [:lower:] [:upper:] <<< $OPT)
	
	INDEX=$(echo ${ALPHABET[@]}|sed "s/$OPT.*//"|wc -w)
	[ $INDEX -le $INDEXEND ] && break
done

echo $OPT

echo "You choose: ${BABYNAMES[INDEX]}"


################################################################################
# Letter and number Selection, limited to 260, adapts to array
# Will crash if choosing [ or ] symbols
###############


echo "\nPlease choose from the following array options"

PARKS=("Akami-Uapishku-KakKasuak-Mealy Mountains (Reserve)" "Aulavik" "Auyuittuq" "Banff" "Bruce Peninsula" "Cape Breton Highlands" "Elk Island" "Forillon" "Fundy" "Georgian Bay Islands" "Glacier" "Grasslands" "Gros Morne" "Gulf Islands \(Reserve\)" "Gwaii Haanas[A] (Reserve)" "Ivvavik[B]" "Jasper" "Kejimkujik" "Kluane[C] (two units: a Park and a Reserve)"  "Kootenay" "Kouchibouguac" "La Mauricie" "Mingan Archipelago (Reserve)" "Mount Revelstoke" "Nahanni (Reserve)" "Nááts'ihch'oh[4] (Reserve)" "Pacific Rim (Reserve)" "Point Pelee" "Prince Albert" "Prince Edward Island" "Pukaskwa" "Qausuittuq" "Quttinirpaaq[E]" "Riding Mountain[F]" "Rouge Park" "Sable Island (Reserve)" "Sirmilik" "Terra Nova" "Thousand Islands" "Torngat Mountains" "Tuktut Nogait" "Ukkusiksalik" "Vuntut" "Wapusk" "Waterton Lakes[G]" "Wood Buffalo" "Northwest Territories" "Yoho")
ALPHABET=({A..Z}{0..9})

tput sc
while true; do
	tput rc
	INDEXSTART=0
	INDEXEND=$(( ${#PARKS[@]}-1 ))
	for INDEX in  $(eval echo \{0..$INDEXEND\}); do
		echo "${ALPHABET[INDEX]}. ${PARKS[INDEX]}"
	done
	read -p "Choose: " -n 2 -s OPT
	
	OPT=$(sed "s/[^[:alnum:]]//g" <<< "$OPT")
	OPT=$(tr [:lower:] [:upper:] <<< $OPT)
	
	INDEX=$(echo ${ALPHABET[@]}|sed "s/$OPT.*//"|wc -w)
	[ $INDEX -le $INDEXEND ] && [ ${#OPT} -eq 2 ] && break
done

echo $OPT
echo "You choose: ${PARKS[INDEX]}"


################################################################################
# 2 columns Letter and number Selection, limited to 260, adapts to array
# Will crash if choosing [ or ] symbols
###############


echo "\nPlease choose from the following array options"

COLUMNA=$(( $(tput cols) /2 ))
PARKS=("Akami-Uapishku-KakKasuak-Mealy Mountains (Reserve)" "Aulavik" "Auyuittuq" "Banff" "Bruce Peninsula" "Cape Breton Highlands" "Elk Island" "Forillon" "Fundy" "Georgian Bay Islands" "Glacier" "Grasslands" "Gros Morne" "Gulf Islands \(Reserve\)" "Gwaii Haanas[A] (Reserve)" "Ivvavik[B]" "Jasper" "Kejimkujik" "Kluane[C] (two units: a Park and a Reserve)"  "Kootenay" "Kouchibouguac" "La Mauricie" "Mingan Archipelago (Reserve)" "Mount Revelstoke" "Nahanni (Reserve)" "Nááts'ihch'oh[4] (Reserve)" "Pacific Rim (Reserve)" "Point Pelee" "Prince Albert" "Prince Edward Island" "Pukaskwa" "Qausuittuq" "Quttinirpaaq[E]" "Riding Mountain[F]" "Rouge Park" "Sable Island (Reserve)" "Sirmilik" "Terra Nova" "Thousand Islands" "Torngat Mountains" "Tuktut Nogait" "Ukkusiksalik" "Vuntut" "Wapusk" "Waterton Lakes[G]" "Wood Buffalo" "Northwest Territories" "Yoho")
ALPHABET=({A..Z}{0..9})

tput sc
while true; do
	tput rc
	INDEXSTART=0
	INDEXEND=$(( ${#PARKS[@]}-1 ))
	for INDEX in  $(eval echo \{0..$INDEXEND\}); do
		[ $(($INDEX%2)) -eq 0 ] && printf "${ALPHABET[INDEX]}. ${PARKS[INDEX]}\n" || tput hpa $COLUMNA;printf "${ALPHABET[INDEX]}. ${PARKS[INDEX]}"
		
	done
	printf "\n"
	read -p "Choose: " -n 2 -s OPT
	
	OPT=$(sed "s/[^[:alnum:]]//g" <<< "$OPT")
	OPT=$(tr [:lower:] [:upper:] <<< $OPT)
	
	INDEX=$(echo ${ALPHABET[@]}|sed "s/$OPT.*//"|wc -w)
	[ $INDEX -le $INDEXEND ] && [ ${#OPT} -eq 2 ] && break
done

echo $OPT
echo "You choose: ${PARKS[INDEX]}"



################################################################################
# Multiple columns, Letter and number Selection, limited to 260, adapts to array
# Will crash if choosing [ or ] symbols
###############


echo "\nPlease choose from the following array options"
COLUMNNUM=5
COLUMNWID=$(( $(tput cols) /COLUMNNUM ))
LISTSET=("s2p" "sdiff" "semodule" "set" "setmetamode" "sh" "showkey" "sleep" "smbspool" "source" "sshd" "start_udev" "stfileinfo" "stty" "suspend" 
"saslauthd" "secon" "semodule_deps" "setarch" "setpci" "sha1sum" "shred" "sln" "smbstatus" "splain" "sshd-keygen" "stat" "stfinddevice" "stvanity" "swapoff" 
"sasldblistusers2" "securetty" "semodule_expand" "setcap" "setsebool" "sha224sum" "shuf" "smbcacls" "smbtar" "split" "ssh-keygen" "status" "stgenfiles" "stwatchfile" "swapon" 
"saslpasswd2" "sed" "semodule_link" "setenforce" "setsid" "sha256sum" "shutdown" "smbclient" "smbta-util" "sprof" "ssh-keyscan" "stbench" "stindex" "su" "switch_root" 
"scp" "sedismod" "semodule_package" "setfacl" "setsysfont" "sha384sum" "signtool" "smbcontrol" "smbtree" "sqlite3" "ssltap" "stcli" "stop" "sudo" "sync" 
"scpit" "sedispol" "sendmail" "setfattr" "setterm" "sha512sum" "signver" "smbcquotas" "smtp-sink" "ss" "sss_cache" "stcompdirs" "strelaypoolsrv" "sudoedit" "syncthing" 
"script" "select" "sendmail.postfix" "setfiles" "setup-nsssysinit.sh" "sharesec" "size" "smbd" "smtp-source" "ssh" "sssd" "stdbuf" "strelaysrv" "sudoreplay" "sysctl" 
"scriptreplay" "selinuxconlist" "seq" "setfont" "sfdisk" "shift" "skill" "smbget" "snice" "ssh-add" "sss_ssh_authorizedkeys" "stdisco" "strings" "sulogin" "sys-unconfig" 
"scsi_id" "selinuxdefcon" "service" "setkeycodes" "sftp" "shopt" "slabtop" "smbpasswd" "soelim" "ssh-agent" "sss_ssh_knownhostsproxy" "stdiscosrv" "strip" "sum" 
"scxadmin" "selinuxenabled" "sestatus" "setleds" "sg" "showconsolefont" "slattach" "smbprint" "sort" "ssh-copy-id" "start" "stevents" "stsigtool" "sushell" )
ALPHABET=({A..Z}{0..9})

tput sc
while true; do
	tput rc
	INDEXSTART=0
	INDEXEND=$(( ${#LISTSET[@]}-1 ))
	for INDEX in  $(eval echo \{0..$INDEXEND\}); do
		tput hpa $(( COLUMNWID * (INDEX%COLUMNNUM) ))
		printf "${ALPHABET[INDEX]}. ${LISTSET[INDEX]}"
		[ $(($INDEX%COLUMNNUM)) -eq 0 ] && printf "\n"
	done
	printf "\n"
	read -p "Choose: " -n 2 -s OPT
	
	OPT=$(sed "s/[^[:alnum:]]//g" <<< "$OPT")
	OPT=$(tr [:lower:] [:upper:] <<< $OPT)
	
	INDEX=$(echo ${ALPHABET[@]}|sed "s/$OPT.*//"|wc -w)
	[ $INDEX -le $INDEXEND ] && [ ${#OPT} -eq 2 ] && break
done

echo $OPT
echo "You choose: ${LISTSET[INDEX]}"


################################################################################
# Auto columns, Letter and number Selection, limited to 260, adapts to array
# Will crash if choosing [ or ] symbols
###############


echo "\nPlease choose from the following array options"

LISTSET=("s2p" "sdiff" "semodule" "set" "setmetamode" "sh" "showkey" "sleep" "smbspool" "source" "sshd" "start_udev" "stfileinfo" "stty" "suspend" 
"saslauthd" "secon" "semodule_deps" "setarch" "setpci" "sha1sum" "shred" "sln" "smbstatus" "splain" "sshd-keygen" "stat" "stfinddevice" "stvanity" "swapoff" 
"sasldblistusers2" "securetty" "semodule_expand" "setcap" "setsebool" "sha224sum" "shuf" "smbcacls" "smbtar" "split" "ssh-keygen" "status" "stgenfiles" "stwatchfile" "swapon" 
"saslpasswd2" "sed" "semodule_link" "setenforce" "setsid" "sha256sum" "shutdown" "smbclient" "smbta-util" "sprof" "ssh-keyscan" "stbench" "stindex" "su" "switch_root" 
"scp" "sedismod" "semodule_package" "setfacl" "setsysfont" "sha384sum" "signtool" "smbcontrol" "smbtree" "sqlite3" "ssltap" "stcli" "stop" "sudo" "sync" 
"scpit" "sedispol" "sendmail" "setfattr" "setterm" "sha512sum" "signver" "smbcquotas" "smtp-sink" "ss" "sss_cache" "stcompdirs" "strelaypoolsrv" "sudoedit" "syncthing" 
"script" "select" "sendmail.postfix" "setfiles" "setup-nsssysinit.sh" "sharesec" "size" "smbd" "smtp-source" "ssh" "sssd" "stdbuf" "strelaysrv" "sudoreplay" "sysctl" 
"scriptreplay" "selinuxconlist" "seq" "setfont" "sfdisk" "shift" "skill" "smbget" "snice" "ssh-add" "sss_ssh_authorizedkeys" "stdisco" "strings" "sulogin" "sys-unconfig" 
"scsi_id" "selinuxdefcon" "service" "setkeycodes" "sftp" "shopt" "slabtop" "smbpasswd" "soelim" "ssh-agent" "sss_ssh_knownhostsproxy" "stdiscosrv" "strip" "sum" 
"scxadmin" "selinuxenabled" "sestatus" "setleds" "sg" "showconsolefont" "slattach" "smbprint" "sort" "ssh-copy-id" "start" "stevents" "stsigtool" "sushell" )
ALPHABET=({A..Z}{0..9})

LISTITEMWID=0
for LISTITEM in ${LISTSET[@]}; do
	[ $LISTITEMWID -lt ${#LISTITEM} ] && LISTITEMWID=${#LISTITEM}
done

COLUMNNUM=$(( $(tput cols) / (LISTITEMWID +5) ))
COLUMNWID=$(( $(tput cols) /COLUMNNUM ))

tput sc
while true; do
	tput rc
	INDEXSTART=0
	INDEXEND=$(( ${#LISTSET[@]}-1 ))
	for INDEX in  $(eval echo \{0..$INDEXEND\}); do
		tput hpa $(( COLUMNWID * (INDEX%COLUMNNUM) ))
		printf "${ALPHABET[INDEX]}. ${LISTSET[INDEX]}"
		[ $(($INDEX%COLUMNNUM)) -eq 0 ] && printf "\n"
	done
	printf "\n"
	read -p "Choose: " -n 2 -s OPT
	
	OPT=$(sed "s/[^[:alnum:]]//g" <<< "$OPT")
	OPT=$(tr [:lower:] [:upper:] <<< $OPT)
	
	INDEX=$(echo ${ALPHABET[@]}|sed "s/$OPT.*//"|wc -w)
	[ $INDEX -le $INDEXEND ] && [ ${#OPT} -eq 2 ] && break
done

echo $OPT
echo "You choose: ${LISTSET[INDEX]}"


exit 0
