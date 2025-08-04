#!/usr/bin/env zsh

mkdir test
repeat "$1"; do
	period=$((RANDOM % 300))
	id=$(curl -XPOST http://127.0.0.1:3000/count/$period)
	(
	begin=$(date +%s)
	while :; do
		resp=$(curl http://127.0.0.1:3000/count/$id)
		if [[ $resp = done ]] then break; fi
	done 2>/dev/null
	end=$(date +%s)
	echo $period $((end-begin))>test/$id.txt
	)&
done

wait
