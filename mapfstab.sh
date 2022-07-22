clear
echo -e "#################    SCRIPT PARA MAPEAMENTO DE REDE VIA FSTAB  ######################"

USUARIO=$(id -u)
UBUNTU=$(lsb_release -rs)
if [ "$USUARIO" == "0" ] && [ "$UBUNTU" == "20.1" ]
	then
		echo -e "O usuário é Root, continuando com o script..."
		echo -e "Distribuição é >= 20.1, continuando com o script..."
		sleep 2
	else
		echo -e "Usuário não é Root ($USUARIO) ou a Distribuição não é >= 20.1($UBUNTU)"
#		echo -e "Caso você não tenha executado o script com o comando: sudo -i"
		echo -e "Execute novamente o script para verificar o ambiente."
		exit 1
fi

FSTABDEP="cifs-utils"
    for name in $FSTABDEP
        do
            [[ $(dpkg -s $name 2> /dev/null) ]] || {
                    echo -en "\n\nO software: $FSTABDEP precisa ser instalado. \nUse o camando 'apt install $FSTABDEP'\n";
                    deps=1;
                    }
        done
            [[ $deps -ne 1 ]] && echo "Dependências.: OK" || { 
			echo -en "\nInstale as dependências acima e execute novamente este script\n";
            echo -en "\n";
			exit 1; 
			}
		    sleep 2

echo -e "\n"
read -p "Nome de Usuario(Rede): " usuario
IFS= read -s -p 'Senha do Usuario(Rede): ' senha
echo -e "\n"
read -p "Ip do servidor(arquivos): " ipserver
echo -e "Listando as pastas do Servidor...\n"
smbclient -L $ipserver --user=$usuario%$senha

RESULT=`smbclient -L $ipserver --user=$usuario%$senha`
#echo $RESULT
if [[ "$RESULT" == *"NT_STATUS_LOGON_FAILURE"* ]]; then
        { 
        echo -en "\n"
        echo "Usuario ou senha invalidos! Ou servidor nao encontrado!"
        echo -en "\n"
        exit 1;
        }
else

{
        echo -e "\nSalvando informacoes de login no arquivo...."
        touch /root/$usuario
        sleep 2s
        echo -e "user=$usuario\npassword=$senha" > /root/$usuario
        echo -e "Criando pasta no /mnt...."
        mkdir -p /mnt/srv_$usuario
        #
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
        }
fi
