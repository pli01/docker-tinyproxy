#!/bin/bash
set -x

image_name=${1:? $(basename $0) IMAGE_NAME VERSION needed}
version=${2:-latest}
namespace=tinyproxy
test_service=http_proxy

ret=0
echo "Check tests/docker-compose.yml config"
docker-compose -p ${namespace} config
test_result=$?
if [ "$test_result" -eq 0 ] ; then
  echo "[PASSED] docker-compose -p ${namespace} config"
else
  echo "[FAILED] docker-compose -p ${namespace} config"
  ret=1
fi

echo "Check tinyproxy version"
docker-compose -p ${namespace} run --name "test-http_proxy" --rm $test_service tinyproxy -v
test_result=$?
if [ "$test_result" -eq 0 ] ; then
  echo "[PASSED] tinyproxy version"
else
  echo "[FAILED] tinyproxy version"
  ret=1
fi

# test a small tinyproxy config
#echo "Check tinyproxy config"

# setup test
#echo "# setup env test:"
#test_compose=docker-compose.test.yml
#test_service=http_proxy
#test_config=tinyproxy.conf
#docker-compose -p ${namespace} -f $test_compose up -d --no-build $test_service
#container=$(docker-compose -p ${namespace}  -f $test_compose ps -q $test_service)
#docker cp $test_config ${container}:/etc/tinyproxy/tinyproxy.conf
#
## run test
#echo "# run test:"
#docker-compose -p ${namespace}  -f $test_compose exec -T $test_service tinyproxy -d -c /etc/tinyproxy/tinyproxy.conf
#docker-compose -p ${namespace} run --name "test-http_proxy" --rm $test_service tinyproxy -v
#test_result=$?
#
## teardown
#echo "# teardown:"
#docker-compose -p ${namespace}  -f $test_compose stop
#docker-compose -p ${namespace}  -f $test_compose rm -fv
#
#if [ "$test_result" -eq 0 ] ; then
#  echo "[PASSED] tinyproxy config check [$test_config]"
#else
#  echo "[FAILED] tinyproxy config check [$test_config]"
#  ret=1
#fi

exit $ret
