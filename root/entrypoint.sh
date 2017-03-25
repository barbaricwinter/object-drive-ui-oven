# This file is part of object-drive-ui-oven.
#
#    object-drive-ui-oven is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    object-drive-ui-oven is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with object-drive-ui-oven .  If not, see <http://www.gnu.org/licenses/>.

cd /code &&
    ssh-keygen -f ${HOME}/.ssh/id_rsa -P "${TITLE}" -C "" &&
	curl --data-urlencode "key=$(cat ${HOME}/.ssh/id_rsa.pub)" --data-urlencode "title=${TITLE}" https://gitlab.363-283.io/api/v3/user/keys?private_token=${GITLAB_PRIVATE_TOKEN}  &&
	cp /opt/docker/config ${HOME}/.ssh &&
	chmod 0600 ${HOME}/.ssh &&
    git init &&
    git config user.name "${GIT_USER_NAME}" &&
    git config user.email "${GIT_USER_EMAIL}" &&
    git remote add upstream ssh://upstream/cte/object-drive-ui.git &&
    git config remote.upstream.pushurl "you really didn't want to do that" &&
    git remote add origin ssh://origin/${GITLAB_USERID}/object-drive-ui.git &&
    cp /opt/docker/post-commit.sh .git/hooks/post-commit &&
    chmod 0500 .git/hooks/post-commit &&
    git fetch upstream develop &&
    git checkout upstream/develop &&
    npm set cafile ca.crt &&
    npm set registry https://npm.363-283.io &&
    echo "strict-ssl=false" >> ${HOME}/.npmrc &&
(npm adduser --registry https://npm.363-283.io <<EOF
${NPM_USERNAME}
${NPM_PASSWORD}
${NPM_EMAIL}
EOF
    ) &&
    echo "strict-ssl=false" >> ${HOME}/.npmrc &&
    npm install jspm &&
    sed -i "s#\"strictSSL\": true#\"strictSSL\": false#" ~/.jspm/config 
    export PATH=${PATH}:${PWD}/node_modules/.bin &&
    jspm config registries.github.remote https://github.jspm.io &&
    jspm config registries.github.auth ${GITHUB_REGISTRY_TOKEN} &&
    jspm config registries.github.maxRepoSize 0 &&
    jspm config registries.github.handler jspm-github &&
    ( npm install || bash )