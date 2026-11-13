#!/bin/bash
# Liga as atualizações do MizOS num PC instalado com uma ISO de antes do
# repositório existir (as ISOs novas já vêm prontas).
# Uso: curl -fsSL https://killespg.github.io/mizos-atualizacoes/instalar.sh | sudo bash
set -euo pipefail
URL=https://killespg.github.io/mizos-atualizacoes

[[ $(id -u) == 0 ]] || { echo "Rode com sudo." >&2; exit 1; }

echo "==> Chave e endereço das atualizações do MizOS"
curl -fsSL -o /usr/share/keyrings/mizos.gpg "$URL/mizos.gpg"
# Igual ao arquivo do pacote: o dpkg assume o arquivo sem perguntar nada
curl -fsSL -o /etc/apt/sources.list.d/mizos.sources "$URL/mizos.sources"

# ISOs antigas: o comando mizos ficava em /usr/local/bin e esconderia o novo
rm -f /usr/local/bin/mizos

echo "==> Instalando os pacotes do MizOS"
apt-get update
# confnew: os arquivos que a ISO antiga copiou em /etc passam a ser os do pacote
DEBIAN_FRONTEND=noninteractive apt-get install -y \
	-o Dpkg::Options::=--force-confnew mizos-base mizos-desktop

echo "==> Pronto. Daqui em diante as atualizações aparecem em Configurações > Atualizações."
