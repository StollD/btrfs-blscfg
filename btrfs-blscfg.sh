#!/bin/sh

BLSDIR="/boot/loader/entries/"
MACHINE=$(cat /etc/machine-id)
OUTDIR=$(mktemp -d)

# Remove old snapshot entries
rm $BLSDIR/$MACHINE-snapshot*.conf

# Iterate over all snapshots on the system
btrfs subvolume list -sa / | while read -d $'\n' s; do
	ID=$(echo "$s" | grep -oE 'ID [0-9]+' | sed 's|^ID ||g')
	TIME=$(echo "$s" | grep -oE 'otime [^ ]+ [^ ]+' | sed 's|^otime ||g')

	# Generate an entry to boot the snapshot with every kernel
	find "$BLSDIR" -type f -print0 | while read -d $'\0' file; do
		NEW=$(basename $file)
		NEW=$(echo $NEW | sed "s|^$MACHINE-|$MACHINE-snapshot.$ID.|g")
		NEW="$OUTDIR/$NEW"
		
		cp "$file" "$NEW"

		VERSION=$(cat "$NEW" | grep -E '^version' | sed 's|^version ||g')
		OPTS=$(cat "$NEW" | grep -E '^options' | sed 's|^options ||g')

		TITLE="Snapshot ($TIME) ($VERSION)"
		OPTS="$OPTS rootflags=subvolid=$ID"

		sed -i "s|^title.*$|title $TITLE|g" "$NEW"
		sed -i "s|^options.*$|options $OPTS|g" "$NEW"
	done
done

cp $OUTDIR/*.conf "$BLSDIR"
rm -r "$OUTDIR"
