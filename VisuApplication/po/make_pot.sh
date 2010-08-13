#!/bin/sh

find ../../. | egrep -i '/src$' > tempFind

projets=`cat tempFind`

rm tempFind

for projet in $projets; do
    echo "Processing "$projet" ..."
    find $projet | egrep -i '\.as$|\.mxml$' >> files
done

xgettext --package-name Visu2 --package-version 0.1 --default-domain Visu2 --output Visu2.pot --from-code=UTF-8 -L C --keyword=_:1 -f files

rm files