clear
echo -e "#################    SCRIPT PARA MAPEAMENTO DE REDE VIA FSTAB  ######################"
echo -e "\n"
read -p "Nome de Usuario(Rede): " usuario
IFS= read -s -p 'Senha do Usuario(Rede): ' senha
touch /root/$usuario
#
echo -e "\nSalvando informacoes de login no arquivo...."
#
echo -e "user=$usuario\npassword=$senha" > /root/$usuario
echo -e "Criando pasta no /mnt...."
#
mkdir -p /mnt/srv_$usuario
#
read -p "Ip do servidor(arquivos): " ipserver
echo -e "Listando as pastas do Servidor...\n"
smbclient -L $ipserver --user=$usuario%$senha
read -p "Nome da Pasta: " pasta
read -p "Nome do usuario local: " userlocal
#
echo -e "Adicionando linha no /etc/fstab...."
#
echo -e "//$ipserver/$pasta /mnt/srv_$usuario cifs vers=1.0,uid=$userlocal,gid=$userlocal,users,credentials=/root/$usuario 0 0" >> /etc/fstab
#
echo -e "Criando link simbolico para area de trabalho...."
ln -s /mnt/srv_$usuario /home/$userlocal/Desktop/
#
umount -av
sleep 2s
mount -av
