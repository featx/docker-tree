#!/usr/bin/env bash

shopt -s nullglob

PROVISION_REGISTRY_PATH="/usr/local/etc/.registry"
PROVISION_REGISTRY_PATH="/usr/local/etc/.registry"

###
 # Check if current user is root
 #
 ##
function rootCheck() {
    # Root check
    if [ "$(/usr/bin/whoami)" != "root" ]; then
        echo "[ERROR] Must be run as root"
        exit 1
    fi
}

###
 # Create named pipe
 #
 # $1 -> name of file
 #
 ##
function createNamedPipe() {
    rm --force -- "$1"
    mknod "$1" p
}

###
 # Escape value for sed usage
 #
 # $1     -> value
 # STDOUT -> escaped value
 #
 ##
function sedEscape() {
    echo "$(echo $* |sed -e 's/[]\/$*.^|[]/\\&/g')"
}

###
 # Replace text inside a file
 #
 # $1 -> source value
 # $2 -> target value
 # $3 -> path to file
 #
 ##
function replaceTextInFile() {
    SOURCE="$(sedEscape $1)"
    REPLACE="$(sedEscape $2)"
    TARGET="$3"

    sed -i "s/${SOURCE}/${REPLACE}/" "${TARGET}"
}

###
 # Run "entrypoint" scripts
 ##
function runEntrypoints() {
    ###############
    # Try to find entrypoint
    ###############

    ENTRYPOINT_SCRIPT="/usr/local/bin/entrypoint/${TASK}.sh"

    if [ -f "$ENTRYPOINT_SCRIPT" ]; then
        . "$ENTRYPOINT_SCRIPT"
    fi

    ###############
    # Run default
    ###############
    if [ -f "/usr/local/bin/entrypoint/default.sh" ]; then
        . /usr/local/bin/entrypoint/default.sh
    fi

    exit
}

###
 # Run "bootstrap" provisioning
 ##
function runProvisionBootstrap() {
    for FILE in /usr/local/provision/bootstrap/*.sh; do
        # run custom scripts, only once
        . "$FILE"
        rm -f -- "$FILE"
    done

    runDockerProvision bootstrap

    ## Reset bootstrap provision list (prevent re-run)
    rm -f ${PROVISION_REGISTRY_PATH}/provision.*.bootstrap
}

###
 # Run "build" provisioning
 ##
function runProvisionBuild() {
    for FILE in /usr/local/provision/build/*.sh; do
        # run custom scripts, only once
        . "$FILE"
        rm -f -- "$FILE"
    done

    runDockerProvision build
}

###
 # Run "onbuild" provisioning
 ##
function runProvisionOnBuild() {
    for FILE in /usr/local/provision/onbuild/*.sh; do
        # run custom scripts
        . "$FILE"
    done

    runDockerProvision onbuild
}

###
 # Run "entrypoint" provisioning
 ##
function runProvisionEntrypoint() {
    for FILE in /usr/local/provision/entrypoint/*.sh; do
        # run custom scripts
        . "$FILE"
    done

    runDockerProvision entrypoint
}

###
 # Add role to provision registry
 #
 # $1 -> registry type (bootstrap, onbuild, entrypoint...)
 # $2 -> role
 #
 ##
function provisionRoleAdd() {
    PROVISION_FILE="${PROVISION_REGISTRY_PATH}/$1"
    PROVISION_ROLE="$2"

    mkdir -p -- "${PROVISION_REGISTRY_PATH}"
    touch -- "${PROVISION_FILE}"

    echo "${PROVISION_ROLE}" >> "${PROVISION_FILE}"
}

###
 # Build list of roles for this registry provision type (playbook building)
 #
 # $1 -> registry type (bootstrap, onbuild, entrypoint...)
 #
 ##
function buildProvisionRoleList() {
    PROVISION_FILE="${PROVISION_REGISTRY_PATH}/$1"

    if [ -s "${PROVISION_FILE}" ]; then
        # Add registered roles
        for ROLE in $(cat "$PROVISION_FILE"); do
            echo "    - { role: \"$ROLE\" }"
        done
    fi
}

###
 # Run docker provisioning with dyniamic playbook generation
 #
 # $1 -> playbook tag (bootstrap, onbuild, entrypoint)
 #
 ##
function runDockerProvision() {
    ANSIBLE_PLAYBOOK="/usr/local/provision/playbook.yml"
    ANSIBLE_TAG="$1"
    ANSIBLE_DYNAMIC_PLAYBOOK=0


    ## Create dynamic ansible playbook file
    if [ ! -f "$ANSIBLE_PLAYBOOK" ]; then
        TMP_PLAYBOOK=$(mktemp /tmp/docker.build.XXXXXXXXXX)
        TMP_PLAYBOOK_ROLES=$(mktemp /tmp/docker.build.XXXXXXXXXX)

        ## Create dynamic playbook file
        echo "---

- hosts: all
  vars_files:
    - "./variables.yml"
  roles:
" > "$TMP_PLAYBOOK"

        ROLES_FILE=$(mktemp /tmp/docker.build.XXXXXXXXXX)

        buildProvisionRoleList "provision.startup.${ANSIBLE_TAG}" >> "$TMP_PLAYBOOK_ROLES"
        buildProvisionRoleList "provision.main.${ANSIBLE_TAG}"    >> "$TMP_PLAYBOOK_ROLES"
        buildProvisionRoleList "provision.finish.${ANSIBLE_TAG}"  >> "$TMP_PLAYBOOK_ROLES"

        # check if there is at last one role
        if [ -s "$TMP_PLAYBOOK_ROLES" ]; then
            cat "$TMP_PLAYBOOK" "$TMP_PLAYBOOK_ROLES" > $ANSIBLE_PLAYBOOK
            ANSIBLE_DYNAMIC_PLAYBOOK=1
        fi

        rm -f -- "$TMP_PLAYBOOK" "$TMP_PLAYBOOK_ROLES"
    fi

    # Only run playbook if there is one
    if [ -s "${ANSIBLE_PLAYBOOK}" ]; then
        bash /usr/local/bin/provision.sh "${ANSIBLE_PLAYBOOK}" "${ANSIBLE_TAG}"

        # Remove dynamic playbook file
        if [ "${ANSIBLE_DYNAMIC_PLAYBOOK}" -eq 1 ]; then
            rm -f "${ANSIBLE_PLAYBOOK}"
        fi
    fi
}

###
 # Startup supervisord
 #
 ##
function startSupervisord() {
    cd /
    exec /usr/local/bin/service/supervisor.sh
}
