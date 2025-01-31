#!/bin/bash +x

if ! command -v "buf" >/dev/null; then
    echo "ERROR: 'buf' utility is not installed, run 'make prereq'"
    exit 1
fi

LANG="$1"
PROTO_DIR_NAME="proto"

SCRIPT_DIR="$(pwd)/$(dirname "${BASH_SOURCE[0]}")"
BUF_DIR_PATH="$(realpath "${SCRIPT_DIR}/../")"
PROTO_DIR_PATH="${BUF_DIR_PATH}/${PROTO_DIR_NAME}"
IGNORE_PROTO_DIR="google"
SERVICE_PROTO_WILDCARD_NAME="*_service.proto"
PROTO_WILDCARD_NAME="*.proto"


case "${LANG}" in
go | java)
    echo "Generating proto sources for language: ${LANG}"
    ;;
*)
    echo "ERROR: unsupported protoc output language: ${LANG}"
    ;;
esac

generateGo() {
  local proto_dir_path=${PROTO_DIR_PATH}
  echo "proto_dir_path: ${proto_dir_path}"
  echo "buf path: ${BUF_DIR_PATH}"

  # Generate proto and openapi
  find "${proto_dir_path}" -type f -name "${SERVICE_PROTO_WILDCARD_NAME}" ! -path "${proto_dir_path}/${IGNORE_PROTO_DIR}/*"  | while read -r proto_file; do
    echo "Generating (with openapi) for proto file [${proto_file}]"
    buf generate --path "${proto_file}" --config "${BUF_DIR_PATH}"/buf.yaml --template "${BUF_DIR_PATH}"/buf_openapi.gen.yaml
    done

  # Generate other proto and ignore previos generated
  find "${proto_dir_path}" ! -path "${proto_dir_path}/${IGNORE_PROTO_DIR}/*" -type f -name "${PROTO_WILDCARD_NAME}"  ! -name "${SERVICE_PROTO_WILDCARD_NAME}"   | while read -r proto_file; do
    echo "Generating for proto file [${proto_file}]"
    buf generate --path "${proto_file}" --config "${BUF_DIR_PATH}"/buf.yaml --template "${BUF_DIR_PATH}"/buf.gen.yaml
    done

}

generateJava() {
  echo "Java currently unsupported"
}

cd "${BUF_DIR_PATH}" || exit
case "${LANG}" in
go)
    generateGo
    ;;
 java)
    generateJava
    ;;
esac