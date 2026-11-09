# Kali Linux em Docker Compose — laboratório Wi-Fi

Projeto de ambiente de laboratório para inspeção das interfaces Wi-Fi e ferramentas Kali no Linux. Use somente em redes próprias ou autorizadas.

## Pré-requisitos

Docker Engine e plugin Docker Compose (`docker compose version`) em um host Linux; adaptador sem fio e driver com suporte ao modo monitor se esse modo for necessário. Docker Desktop, VMs e drivers podem ter limitações adicionais.

## 1. Verificações no host

```bash
docker version
docker compose version
iw dev
iw list | grep -A 12 'Supported interface modes'
```

Instale o `iw` no hospedeiro se necessário. Procure `* monitor` na saída. Isso demonstra suporte anunciado pelo driver, não uma garantia de captura/funcionamento.

## 2. Inicialização segura (rede bridge)

```bash
docker compose up -d --build
docker compose exec kali bash
```

Dentro do container: `iw dev`, `nmap --version`. Por padrão a interface Wi-Fi física normalmente não estará visível.

## 3. Modo rede host (Linux)

Encerre a configuração anterior e execute explicitamente o arquivo adicional:

```bash
docker compose down
docker compose -f compose.yaml -f compose.wifi.yaml up -d --build
docker compose -f compose.yaml -f compose.wifi.yaml exec kali bash
```

Na mesma pasta do projeto, execute o script de inspeção no host ou copie seu conteúdo para o container:

```bash
# no host
bash scripts/check-wifi.sh
# dentro do container, disponível apenas se você copiar/montar o script:
iw dev
iw list
airmon-ng
```

> `network_mode: host` compartilha a pilha de rede do host; NET_ADMIN e NET_RAW ampliam capacidades. A rede do host pode cair se mudar o modo da interface que mantém a conexão. Recomendável usar adaptador Wi-Fi USB dedicado e conexão de internet separada.

Se necessário para seu equipamento, identifique permissões e acessos de dispositivo específicos em vez de adicionar `privileged: true`. O script apenas diagnostica; não ativa modo monitor.

## 4. Comandos úteis

```bash
# Container seguro
 docker compose ps
 docker compose exec kali bash
 docker compose logs
 docker compose down

# Configuração host (repita -f nos comandos)
 docker compose -f compose.yaml -f compose.wifi.yaml config
 docker compose -f compose.yaml -f compose.wifi.yaml down
```

Os arquivos criados em `workspace/` persistem no host. Pacotes adicionais instalados manualmente em um container não sobrevivem à remoção dele; inclua-os no Dockerfile e reconstrua.

## 5. Limitacões

- O container compartilha o kernel do hospedeiro; não instala drivers Wi-Fi próprios.
- `--network host` não garante acesso completo aos dispositivos, especialmente com Docker rootless ou virtualizado.
- A placa e o driver precisam suportar modo monitor.
- `wlan0` é apenas um nome de exemplo: descubra o nome real com `iw dev`.
- O comando `iw list` indica capacidades 802.11, não quais redes usam WPA/WPA2. Para ver a segurança anunciada, use uma varredura autorizada em modo managed (`nmcli` no host) ou ferramentas de captura com adaptador adequado.

Referências:
- https://www.kali.org/docs/containers/official-kalilinux-docker-images/
- https://docs.docker.com/compose/how-tos/networking/
- https://docs.docker.com/reference/compose-file/services/
