if [[ "$#" -ne 1 ]]; then
  echo "Incorrect number of arguments" >>/dev/stderr
  exit 1
fi

case "$1" in
  1)
    pushd day01 > /dev/null
    make && ./sol
    popd > /dev/null
    ;;
  *)
    echo "Unimplemented day"
    ;;
esac
