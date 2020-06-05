helm_template() {
  CHART_DIR=$1
  TEMPLATE_OPTS=$2

  pushd $CHART_DIR
  helm template $TEMPLATE_OPTS $(pwd) --output-dir /tmp/$CHART_DIR > /dev/null 2>&1
  popd
}

print_err() {
  if [ "$1" -ne 0 ]; then echo "$2" | grep "not ok"; fi
}