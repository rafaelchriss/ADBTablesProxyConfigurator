#!/bin/bash

# Função para exibir o banner
print_banner() {
    echo "========================================"
    echo "     ADB IPTABLES - PROXY CONFIG TOOL   "
    echo "========================================"
    echo
}

# Função para exibir uma mensagem de status com formatação
print_status() {
    echo "[*] $1"
}

# Função para habilitar as configurações
enable_configs() {
    print_status "Configurando iptables no dispositivo..."
    adb shell "iptables -t nat -A OUTPUT -p tcp --dport 80 -j DNAT --to-destination 127.0.0.1:8191"
    adb shell "iptables -t nat -A OUTPUT -p tcp --dport 443 -j DNAT --to-destination 127.0.0.1:8191"
    print_status "Regras de iptables configuradas com sucesso."

    print_status "Configurando reverse proxy para porta 8191..."
    adb reverse tcp:8191 tcp:8191
    print_status "Reverse proxy configurado."

    print_status "Configurando proxy HTTP global..."
    adb shell settings put global http_proxy 127.0.0.1:8191
    print_status "Proxy HTTP global configurado."
}

# Função para desabilitar as configurações
disable_configs() {
    print_status "Removendo regras de iptables..."
    adb shell "iptables -t nat -C OUTPUT -p tcp --dport 80 -j DNAT --to-destination 127.0.0.1:8191" 2>/dev/null && \
        adb shell "iptables -t nat -D OUTPUT -p tcp --dport 80 -j DNAT --to-destination 127.0.0.1:8191"
    adb shell "iptables -t nat -C OUTPUT -p tcp --dport 443 -j DNAT --to-destination 127.0.0.1:8191" 2>/dev/null && \
        adb shell "iptables -t nat -D OUTPUT -p tcp --dport 443 -j DNAT --to-destination 127.0.0.1:8191"
    print_status "Regras de iptables removidas com sucesso."

    print_status "Verificando e removendo reverse proxy..."
    adb reverse --list | grep -q "tcp:8191" && adb reverse --remove tcp:8191 && \
        print_status "Reverse proxy removido." || print_status "Reverse proxy não encontrado."

    print_status "Limpando proxy HTTP global..."
    adb shell settings delete global http_proxy 2>/dev/null && \
        print_status "Proxy HTTP global limpo." || \
        print_status "Proxy HTTP global já estava vazio."

    print_status "Garantindo que o proxy HTTP global está desativado..."
    adb shell settings put global http_proxy :0 2>/dev/null
    print_status "Proxy HTTP global desativado."
}

# Exibir o banner
print_banner

# Verificar se o adb está instalado
if ! command -v adb &> /dev/null; then
    echo "[X] Erro: adb não está instalado ou não está no PATH."
    exit 1
fi
print_status "ADB encontrado no sistema."

# Verificar se o dispositivo está conectado
if ! adb devices | grep -q "device$"; then
    echo "[X] Erro: Nenhum dispositivo conectado. Conecte um dispositivo e tente novamente."
    exit 1
fi
print_status "Dispositivo conectado."

# Perguntar ao usuário se deseja habilitar ou desabilitar as configurações
echo "Deseja habilitar ou desabilitar as configurações?"
echo "1. Habilitar"
echo "2. Desabilitar"
read -p "Escolha uma opção (1 ou 2): " choice

case $choice in
    1)
        enable_configs
        ;;
    2)
        disable_configs
        ;;
    *)
        echo "[X] Opção inválida. Saindo..."
        exit 1
        ;;
esac

# Exibir mensagem de conclusão
echo
echo "========================================"
echo "    OPERAÇÃO CONCLUÍDA COM SUCESSO! "
echo "========================================"
