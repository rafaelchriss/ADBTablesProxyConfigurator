# ADBTablesProxyConfigurator
![ADBTablesProxyConfigurator](![app](https://github.com/user-attachments/assets/239b7063-06d5-4fdc-8730-1d384ecd3ae7)
)

## Descrição
**ADBTablesProxyConfigurator** é uma ferramenta de configuração de proxy via ADB que simplifica a configuração de regras iptables e proxy HTTP global em dispositivos Android.

## Funcionalidades
- Configuração de regras iptables para redirecionamento de tráfego.
- Configuração de reverse proxy para porta 8191.
- Configuração e limpeza de proxy HTTP global.
- Verificação de dependências ADB e conexão do dispositivo.

## Pré-requisitos
- **ADB** instalado e configurado no sistema.
- Dispositivo Android conectado via USB com a depuração ADB ativada.

## Como Usar
### Passo 1: Baixe ou clone o repositório
```sh
git clone https://github.com/rafaelchriss/ADBTablesProxyConfigurator.git
cd ADBTablesProxyConfigurator

### Passo 2: Torne o script executável
chmod +x ADBTablesProxyConfigurator.sh 

### Passo 3: Execute o script
./ADBTablesProxyConfigurator.sh
