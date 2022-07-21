read -p "Nome de Usuario(Rede): " usuario
read -p "Senha do Usuario(Rede): " senha
touch /root/$usuario
echo -e "user=$usuario\npassword=$senha" > /root/$usuario
mkdir -p /mnt/srv_$usuario
read -p "Ip do servidor(arquivos): " ipserver
read -p "Nome da Pasta: " pasta
read -p "Nome do usuario local: " userlocal
echo -e "//$ipserver/$pasta /mnt/srv_$usuario cifs vers=1.0,uid=$userlocal,gid=$userlocal,users,credentials=/root/$usuario 0 0" >> /etc/fstab
ln -s /mnt/srv_$usuario /home/$userlocal/Desktop/
umount -av
sleep 2s
mount -av

