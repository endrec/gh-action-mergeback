FROM alpine:3.9

RUN apk add --no-cache curl

LABEL "com.github.actions.name"="Merge back"
LABEL "com.github.actions.description"="Merge back master to develop"
LABEL "com.github.actions.icon"="chevrons-down"
LABEL "com.github.actions.color"="purple"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

