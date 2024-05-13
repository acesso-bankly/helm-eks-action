#!/bin/sh

set -e

echo "${KUBE_CONFIG_DATA}" | base64 -d > kubeconfig
export KUBECONFIG="${PWD}/kubeconfig"
chmod 600 "${PWD}/kubeconfig"

if [[ -n "${INPUT_PLUGINS// /}" ]]
then
    plugins="$(echo "${INPUT_PLUGINS}" | tr ",")"

    for plugin in ${plugins}
    do
        echo "installing helm plugin: [${plugin}]"
        helm plugin install "${plugin}"
    done
fi

echo "running entrypoint with command(s): $INPUT_COMMAND"

if (sh -c "$INPUT_COMMAND") ; then
{
  echo "response<<EOF"
  echo "deployed successfully"
  echo "EOF"
} >> "$GITHUB_OUTPUT"    
else
{
  echo "response<<EOF"
  echo "deployment failed with error verify the logs for more details."
  echo "EOF"
} >> "$GITHUB_OUTPUT"    
fi