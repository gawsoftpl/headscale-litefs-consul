FROM ghcr.io/juanfont/headscale:latest as headscale

FROM flyio/litefs

COPY --from=headscale /ko-app/headscale /usr/local/bin/headscale
COPY exec-headscale.sh /usr/local/bin/exec-headscale.sh
RUN chmod +x /usr/local/bin/exec-headscale.sh


