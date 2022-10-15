FROM cfee3a34e9c68ac1d16035a81a926786
ARG DEBIAN_FRONTEND=noninteractive
RUN echo 'exec zsh' > /root/.bashrc
RUN apt-get update && apt-get install -y --no-install-recommends curl dnsutils ipcalc iproute2 iputils-ping jq mtr-tiny nano netcat tcpdump termshark vim-nox zsh
RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common
RUN curl -L https://grml.org/zsh/zshrc > /root/.zshrc
RUN add-apt-repository ppa:ethereum/ethereum
RUN apt-get update && apt-get install --yes geth bootnode
COPY 082b96ec819c95ae773daebde675ef80 /start.sh
COPY d18858afc6bb66ec3a19d872077acfd2 /seedemu_sniffer
COPY 17ac2d812a99a91e7f747e1defb72a29 /seedemu_worker
RUN chmod +x /start.sh
RUN chmod +x /seedemu_sniffer
RUN chmod +x /seedemu_worker
COPY e01e36443f9f72c6204189260d0bd276 /ifinfo.txt
COPY d3d51fdf7f4bad30dc5db560a01ce629 /interface_setup
COPY f4d556a844298d3911e6d250e4a2d93b /tmp/eth-genesis.json
COPY 9859b953a2cc838d867992891cc2b63d /tmp/jwt.hex
COPY de771d89aa5ad4296ac43aaae6d3e3de /tmp/keystore/UTC--2022-10-12T13-26-18.493473000Z--24f6677bdd569cdb1c8fb2d9f7091e0a6c301952
COPY ada0d7cc97998b598864416b9d42c1b8 /tmp/keystore/UTC--2022-10-12T13-26-19.609421000Z--b34fd72d153b0d12d2a91ad9387b523c3be2ffb1
COPY bd25316b20c0888d6a4c83d708a0a0ad /tmp/keystore/UTC--2022-10-12T13-26-20.713464000Z--bb58730c550631b6e9977bf1e0bc901412037de0
COPY d2cdff8371aa6af79bb63954a87ac69f /tmp/eth-password
COPY 0bf749f51915d190035e14f6afa9a371 /tmp/eth-nodes
COPY 427fecb1e0b6c8dc8f669b5b71b8db71 /tmp/eth-bootstrapper
CMD ["/start.sh"]

