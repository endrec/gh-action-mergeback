FROM alpine:3.9

RUN apk add --no-cache curl bash

LABEL "com.github.actions.name"="Merge back"
LABEL "com.github.actions.description"="Merge back master to develop"
LABEL "com.github.actions.icon"="chevrons-down"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="http://github.com/endrec/gh-action-mergeback"
LABEL "homepage"="http://github.com/actions"
LABEL "maintainer"="Endre Czirbesz <endre@czirbesz.hu>"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
