#! /bin/sh
testname="$(basename $0)"

parent="$(cd .. && pwd)"
if [[ -f "${parent}/ftsfind" ]]; then
    ftsfind="${parent}/ftsfind"
    oldfind="${parent}/find"
elif [[ -f "${parent}/oldfind" ]]; then
    ftsfind="${parent}/find"
    oldfind="${parent}/oldfind"
else
    echo "Cannot find the executables to test." >&2
    exit 1
fi

goldenfile="${srcdir}/test_escapechars.golden"
expected='hello^.^world'

for executable in "$oldfind" "$ftsfind"
do
    if result="$($executable . -maxdepth 0 \
	    -printf 'hello^\cthere' \
	    -exec printf %s {} \; \
	    -printf '^world\n' )"; then
        if [[ "${result}" != "${expected}" ]]; then
            exec >&2
            echo "$executable produced incorrect output:"
            echo "${result}"
            echo "Expected output was:"
            echo "${expected}"
            exit 1
        fi
    else
        echo "$executable returned $?" >&2
        exit 1
    fi
done
