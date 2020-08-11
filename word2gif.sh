#! /bin/sh -e

outputfile=${2:-output.gif}
if [ ${#1} != 0 ] && [ ${#1} = $(echo $1 | sed -e 's/\(.\)/\1\n/g' | xargs -I % find . -name %.gif | wc -l) ]; then
  idx=0
  echo $1 | sed -e 's/\(.\)/\1\n/g' | xargs -I % find . -name %.gif | while read gifpath; do
    if [ $idx = 0 ]; then
      cp $gifpath $outputfile
    else
      convert \( \
          $outputfile[0] \
          $gifpath[0] \
          +smush -15 \
		  -fuzz 30% -fill white -opaque red \
		  -set delay 50 \
        \) \
        \( $outputfile -delete 0 \( +clone -set delay 20 \) -delete -2 \) \
        \( $gifpath -delete 0 -repage +$((135*idx))+0\! \) \
        $outputfile      
    fi
    idx=$((idx+1))
  done
  exit 0
else
  echo "Error: not all characters found in image list (${#1} characters input)"
  exit 10
fi
