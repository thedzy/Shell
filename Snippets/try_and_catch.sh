#!/bin/sh

{ #TRY
	# Will fail:
	mkdir /tmp/path/does/not exist
	
	# Will succeed
	#mkdir -p /tmp/path/does/not exist
} || 
{ # CATCH
    printf "Performing error correction\n"
}

exit 0