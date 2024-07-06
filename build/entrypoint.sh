#!/bin/sh

base="/opt/magic_mirror"
default_dir="${base}/modules/default"
config_dir="${base}/config"
css_dir="${base}/css"

_info() {
  echo "[entrypoint $(date +%T.%3N)] [INFO]   $1"
}

_error() {
  echo "[entrypoint $(date +%T.%3N)] [ERROR]  $1"
}

# directories should be mounted, if not, create them:
mkdir -p ${default_dir}
mkdir -p ${config_dir}
mkdir -p ${css_dir}

if [ "$STARTENV" = "init" ]; then
  _info "chown modules and config folder ..."
  chown -R node:node ${base}/modules &
  chown -R node:node ${config_dir}
  chown -R node:node ${css_dir}
  _info "done."

  exit 0
fi

[ -z "$TZ" ] && export TZ="$(wget -qO - http://geoip.ubuntu.com/lookup | sed -n -e 's/.*<TimeZone>\(.*\)<\/TimeZone>.*/\1/p')"

if [ -z "$TZ" ]; then
  _info "***WARNING*** could not set timezone, please set TZ variable in docker-compose.yml, see https://khassel.gitlab.io/magicmirror/configuration/#timezone"
else
  ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
  echo "$TZ" > /etc/timezone
fi

[ ! -d "${default_dir}" ] && MM_OVERRIDE_DEFAULT_MODULES=true

if [ "${MM_OVERRIDE_DEFAULT_MODULES}" = "true" ]; then
  if [ -w "${default_dir}" ]; then
    _info "copy default modules"
    rm -rf ${default_dir}
    mkdir -p ${default_dir}
    cp -r ${base}/mount_ori/modules/default/. ${default_dir}/
  else
    _error "No write permission for ${default_dir}, skipping copying default modules"
  fi
fi

[ ! -f "${css_dir}/main.css" ] && MM_OVERRIDE_CSS=true

if [ "${MM_OVERRIDE_CSS}" = "true" ]; then
  if [ -w "${css_dir}" ]; then
    _info "copy css files"
    cp ${base}/mount_ori/css/* ${css_dir}/
    # create css/custom.css file https://github.com/MagicMirrorOrg/MagicMirror/issues/1977
    [ ! -f "${css_dir}/custom.css" ] && touch ${css_dir}/custom.css
  else
    _error "No write permission for ${css_dir}, skipping copying css files"
  fi
fi

if [ ! -f "${config_dir}/config.js" ]; then
  _info "copy default config.js"
  cp ${base}/mount_ori/config/config.js.sample ${config_dir}/config.js
fi

if [ "$MM_SHOW_CURSOR" = "true" ]; then
  _info "enable mouse cursor"
  sed -i "s|  cursor: .*;|  cursor: auto;|" ${base}/css/main.css
fi

[ -z "$MM_RESTORE_SCRIPT_CONFIG" ] || (${base}/create_restore_script.sh "$MM_RESTORE_SCRIPT_CONFIG" || true)

if [ "$STARTENV" = "test" ]; then
  set -e

  export NODE_ENV=test

  _info "start tests"

  Xvfb :99 -screen 0 1024x768x16 &
  export DISPLAY=:99

  cd ${base}

  echo "/mount_ori/**/*" >> .prettierignore
  npm run test:prettier
  npm run test:js
  npm run test:css
  npm run test:unit
  npm run test:e2e
  npm run test:electron
else
  _script=""
  if [ -f "start_script.sh" ]; then
    _script="${base}/start_script.sh"
  elif [ -f "config/start_script.sh" ]; then
    _script="${base}/config/start_script.sh"
  elif [ -f "/config/start_script.sh" ]; then
    _script="/config/start_script.sh"
  fi
  if [ -n "$_script" ]; then
    if [ ! -x "$_script" ] && [ -w "$_script" ] ; then
      chmod +x "$_script"
    fi

    if [ -x "$_script" ]; then
      _info "executing script $_script"
      . "$_script"
    else
      _error "script $_script is not executable and no permissions to change this"
    fi
  fi

  if [ $# -eq 0 ]; then
    # if no params are provided, add defaults depending if electron is installed:
    if command -v node_modules/.bin/electron > /dev/null; then
      exec env TZ=$TZ npm start
    else
      exec env TZ=$TZ npm run server
    fi
  else
    exec env TZ=$TZ "$@"
  fi
fi
