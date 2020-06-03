name_prefix() {
  printf "rabbitmq"
}

chart_dir() {
  echo ${BATS_TEST_DIRNAME}/../../chart
}

app_version() {
  echo $(cat $(chart_dir)/Chart.yaml | yq r - 'appVersion')
}
