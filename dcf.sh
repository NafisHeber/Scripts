#!/bin/bash

# Variaveis

USERSYS=well #Usuário do Repositório https://download.dataeasy.com.br
PASS=well    #Senha do Repositório https://download.dataeasy.com.br
	
echo "
\-------------------------------------------/
|         INSTALAÇÃO DO DOCFLOW             |
|                                           |
| 0  Instalação Completa                    |
| 1  Atualizar Sistema Operacional Linux    |
| 2  Desativar Firewall                     |
| 3  Desativar proteção do sistema SELINUX  |
| 4  Criar pasta de Instalação              |
| 5  Instalar UNZIP                         |
| 6  Remover versões do Java Instaladas     |
| 7  Alterar formato de Data no Sistema     |
| 8  Baixar Java                            |
| 9  Baixar Jboss                           |
| 10 Baixar Fontes (Aspose / Jasper)        |
| 11 Baixar arquivo Docflow WAR             |
| 12 Baixar arquivo Config-Files            |
| 13 Criar diretório Config-Files           |
| 14 Instalar Jboss                         |
| 15 Instalar Java                          |
| 16 Configurar Váriaveis de Ambiente       |
| 17 Instalar Fontes                        |
| 18 Remover arquivos desnecessários de Ins.|
| 19 Criar pasta de volume padrão           |
| 20 Criar usuário jboss no sistema         |
| 21 Dar permissões a pasta da aplicação    |
| 22 Configurar systemctl                   |
| 23 Ver regras do Firewall                 |
| 24 Editar arq. de Config-propreties	    |
| 25 Editar arq. de Banco de Dados 'Jboss'  |
| 26 Editar arq. de Banco de Dados 'Docflow'|
|                                           |
/-------------------------------------------\ "

echo "Digite a opção que deseja executar: "
read opcao

clear

if [ $opcao = "0" ]; then #Script Completo

    echo "Atualizando Sistema Operacional"
	yum update -y && yum upgrade -y
	sleep 5	
	
	echo "Desativando o Firewall do Sistema"
	systemctl stop firewalld && systemctl disable firewalld
	sleep 5
	
	 echo "
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=disabled
# SELINUXTYPE= can take one of three values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected. 
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted 
" > /etc/selinux/config

setenforce 0
echo "Proteção SELINUX Desabilitada"
	
	yum install unzip vim wget fontconfig-devel.x86_64 fontconfig.x86_64 -y
	
	yum remove *openjdk* -y	
	
	echo "Colocando data no history"
	echo "" >> /etc/profile
	echo 'export HISTTIMEFORMAT="%d/%m/%y %T"' >> /etc/profile
	source /etc/profile
	
	#Baixar Java
	wget --no-check-certificate --user=${USERSYS} --password=${PASS}  https://download.dataeasy.com.br/well/instaladores/java/java7/jdk-7u80-linux-x64.tar.gz	
	
	#Baixar Jboss
	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://download.dataeasy.com.br/well/instaladores/jboss/jboss-as-7.1.0.Final.zip
	
	#Baixar Fontes (Aspose / Jasper)
	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://download.dataeasy.com.br/well/instaladores/fontes/FontesAspose.zip
	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://download.dataeasy.com.br/well/instaladores/fontes/FontesJasper.zip
	
	#Baixar arquivo Docflow WAR 4.57.6 
	wget --no-check-certificate --user=${USERSYS} --password=${PASS}  https://download.dataeasy.com.br/well/instaladores/docflow4/docflow4.57.6/docflow4-web-4.57.6.war
	
	#Baixar arquivo Config-Files 
	wget --no-check-certificate --user=${USERSYS} --password=${PASS}  https://download.dataeasy.com.br/well/instaladores/docflow4/docflow4.57.6/config-files-4.57.6.zip
	
	#Criar diretório Config-Files 
	unzip config-files-4.57.6.zip
	mkdir -p /opt/sistemas/dataeasy/docflow/
	mv /opt/install/config-files/* /opt/sistemas/dataeasy/docflow/

	cd /opt/sistemas/dataeasy/docflow/
	if [ `pwd` = "/opt/sistemas/dataeasy/docflow" ]; then
	
			echo "A pasta foi criada com sucesso!"
		
	fi
	
	cd /opt/install/
	
	#Instalar Jboss
	unzip jboss-as-7.1.0.Final.zip
	mv jboss-as-7.1.0.Final/ /opt/
	ln -s /opt/jboss-as-7.1.0.Final/ /opt/jboss
	chmod 775 /opt/jboss/ -R
	cd /opt/jboss/
	if [ `pwd` = "/opt/jboss/" ]; then
	
			echo "Jboss instalado com sucesso!"

		
	fi
	
	cd /opt/install/
	
	#Instalar Java
	tar -zxvf jdk-7u80-linux-x64.tar.gz
	mv jdk1.7.0_80/ /opt/
	ln -s /opt/jdk1.7.0_80/ /opt/java
	
	cd /opt/java/
	if [ `pwd` = "/opt/java/" ]; then
			java -version
			echo "Java instalado com sucesso!"
		
	fi
	
	cd /opt/install/
	
	#Configurar Váriaveis de Ambiente
		echo "
#!/bin/bash
# JBoss
# Pasta: /etc/profile.d
# Arquivo: docflow.sh

JBOSS_HOME=/opt/jboss
JAVA_HOME=/opt/java
export JBOSS_HOME
export JAVA_HOME

	
# Atualizando a variaveis
export PATH=$PATH:$JAVA_HOME/bin:$JBOSS_HOME" > /etc/profile.d/docflow.sh

	chmod +x /etc/profile.d/docflow.sh
	source /etc/profile.d/docflow.sh
	
	#Instalar Fontes	
	mkdir -p /usr/share/fonts
	unzip FontesAspose.zip
	mv ./Fontes\ Aspose/* /usr/share/fonts/
	
	unzip FontesJasper.zip
	mv ./FontesJasper/* /opt/java/jre/lib/fonts/
	
	#Remover arquivos desnecessários de Instalação	
	rm -rf ./FontesJasper/
	rm -rf ./Fontes\ Aspose/
	rm -rf ./config-files/
	
	#Criar pasta de volume padrão
	mkdir -p /opt/sistemas/dataeasy/volume_I/
	mkdir -p /opt/sistemas/dataeasy/volume_I/thumbnails/
	mkdir -p /opt/sistemas/dataeasy/volume_I/client-images/

	cd /opt/sistemas/dataeasy/volume_I/client-images/

	if [ `pwd` = "/opt/sistemas/dataeasy/volume_I/client-images" ]; then
			
			echo "Pasta de Volume criada com sucesso!"
	fi		
	
	if [ `pwd` != "/opt/sistemas/dataeasy/volume_I/client-images" ]; then
			
			echo "Uma das pastas volume_I/ , client-images/ ou thumbnails/ não foi criada , tente novamente e verifique a pasta /opt/sistemas/dataeasy/volume_I/!"
	fi

	#Criar usuário jboss no sistema
	adduser jboss
	echo "Usuário criado com sucesso"
	
	#Dar permissões a pasta da aplicação
	cd /opt/
	chown jboss.jboss * -R
	echo "Permissão concedida ao usuário jboss"
	
	#Configurar systemctl
	echo "
# JBoss AS 7
# DIR = /etc/systemd/system
# FILE = jboss.service

[Unit]
Description=Jboss Application Server
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/etc/init.d/jboss start
ExecStop=/etc/init.d/jboss stop
#PIDFile=/var/run/jboss/jboss.pid

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/jboss.service

	mv /opt/jboss/bin/init.d/jboss/jboss /etc/init.d/
	chmod 777 /etc/init.d/jboss
	systemctl enable jboss
	#Ver regras do Firewall
	iptables -L
	
	echo "Será necessario reiniciar o computador para que as alterações sejam realizadas, deseja reiniciar agora? s = sim ou n = não"
	read reiniciar
	if [ $reiniciar = "s" ]; then
	
		reboot
	
	fi	
	

fi

if [ $opcao = "1" ]; then #Atualizar Sistema Operacional Linux
    echo "Atualizando Sistema Operacional"
	yum update -y && yum upgrade -y
	sleep 5
	
fi


if [ $opcao = "2" ]; then #Desativar Firewall
	echo "Desativando o Firewall do Sistema"
	systemctl stop firewalld && systemctl disable firewalld
	sleep 5

fi

if [ $opcao = "3" ]; then #Desativar proteção do sistema SELINUX
    echo "
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=disabled
# SELINUXTYPE= can take one of three values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected. 
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted 
" > /etc/selinux/config

setenforce 0
echo "Proteção SELINUX Desabilitada"

fi

if [ $opcao = "4" ]; then #Criar pasta de Instalação

	cd /opt/
	mkdir install
	
fi

if [ $opcao = "5" ]; then #Instalar UNZIP

	yum install unzip vim wget fontconfig-devel.x86_64 fontconfig.x86_64 -y
	
fi

if [ $opcao = "6" ]; then #Remover versões do Java Instaladas

	yum remove *openjdk* -y	
	
fi

if [ $opcao = "7" ]; then #Alterar formato de Data no Sistema

	echo "Colocando data no history"
	echo "" >> /etc/profile
	echo 'export HISTTIMEFORMAT="%d/%m/%y %T"' >> /etc/profile
	source /etc/profile
	
fi

if [ $opcao = "8" ]; then #Baixar Java 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS}  https://download.dataeasy.com.br/well/instaladores/java/java7/jdk-7u80-linux-x64.tar.gz	
	
fi

if [ $opcao = "9" ]; then #Baixar Jboss

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://download.dataeasy.com.br/well/instaladores/jboss/jboss-as-7.1.0.Final.zip
	
fi

if [ $opcao = "10" ]; then #Baixar Fontes (Aspose / Jasper) 

		wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://download.dataeasy.com.br/well/instaladores/fontes/FontesAspose.zip
		
	
fi

if [ $opcao = "11" ]; then #Baixar arquivo Docflow WAR

	echo "
Versões disponíveis:
4.57.19	 	 	
4.57.20	 	 	
4.57.21	 	 	
4.57.22	 	 	
4.57.26	 	 	
4.57.27	 	 	
4.57.28	 	 	
4.58.2	 	 	
4.58.3-sebraeAc	 	 	
4.59.0	 	 	
4.59.1	 	 	
4.60.0	 	 	
4.60.1	 	 	
4.61.6	 	 	
4.61.7	 	 	
4.61.8	 	 	
4.61.9	 	 	
4.61.10	 	 	
4.61.10-TCEMS	 	 	
4.61.10-TCEMS-1	 	 	
4.61.11	 	 	
4.61.12	 	 	
4.61.13	 	 	
4.61.14	 	 	
4.61.15	 	 	
4.61.16-saneago
"
	echo "Digite a versão que deseja instalar do Docflow?"
	read BaixarDocflow
	clear
	echo "Digite o usuário do repostitorio : 'repository.dataeasy.com.br'"
	read USERSYS
	echo "Digite a senha do usuário:"
	read PASS
	
	if [ $BaixarDocflow = "4.57.19" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.57.19/docflow4-web-4.57.19.war	
	
	fi
	
	if [ $BaixarDocflow = "4.57.20" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.57.20/docflow4-web-4.57.20.war
	
	fi
	if [ $BaixarDocflow = "4.57.21" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.57.21/docflow4-web-4.57.21.war
	
	fi
	
	if [ $BaixarDocflow = "4.57.22" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.57.22/docflow4-web-4.57.22.war
	
	fi

	if [ $BaixarDocflow = "4.57.26" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.57.26/docflow4-web-4.57.26.war
	
	fi
	
	if [ $BaixarDocflow = "4.57.27" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.57.27/docflow4-web-4.57.27.war
	
	fi

	if [ $BaixarDocflow = "4.57.28" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.57.28/docflow4-web-4.57.28.war	
	
	fi
	
	if [ $BaixarDocflow = "4.58.2" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.58.2/docflow4-web-4.58.2.war
	
	fi

	if [ $BaixarDocflow = "4.58.3-sebraeAc" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.58.3-sebraeAc/docflow4-web-4.58.3-sebraeAc.war
	
	fi
	
	if [ $BaixarDocflow = "4.59.0" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.59.0/docflow4-web-4.59.0.war	
	
	fi

	if [ $BaixarDocflow = "4.59.1" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.59.1/docflow4-web-4.59.1.war
	
	fi
	
	if [ $BaixarDocflow = "4.60.0" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.60.0/docflow4-web-4.60.0.war
	
	fi
	
	if [ $BaixarDocflow = "4.60.1" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.60.1/docflow4-web-4.60.1.war
	
	fi
	
	
	if [ $BaixarDocflow = "4.61.6" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.61.6/docflow4-web-4.61.6.war
	
	fi
	
	if [ $BaixarDocflow = "4.61.7" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.61.7/docflow4-web-4.61.7.war
	
	fi

	if [ $BaixarDocflow = "4.61.8" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.61.8/docflow4-web-4.61.8.war
	
	fi
	
	if [ $BaixarDocflow = "4.61.9" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.61.9/docflow4-web-4.61.9.war
	
	fi

	if [ $BaixarDocflow = "4.61.10" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.61.10/docflow4-web-4.61.10.war
	
	fi
	
	if [ $BaixarDocflow = "4.61.10-TCEMS" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.61.10-TCEMS/docflow4-web-4.61.10-TCEMS.war
	
	fi
	
	if [ $BaixarDocflow = "4.61.10-TCEMS-1" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.61.10-TCEMS-1/docflow4-web-4.61.10-TCEMS-1.war
	
	fi
	
	if [ $BaixarDocflow = "4.61.11" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.61.11/docflow4-web-4.61.11.war
	
	fi
	
	if [ $BaixarDocflow = "4.61.12" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.61.12/docflow4-web-4.61.12.war
	
	fi
	
	if [ $BaixarDocflow = "4.61.13" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.61.13/docflow4-web-4.61.13.war
	
	fi
	
	
	if [ $BaixarDocflow = "4.61.14" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.61.14/docflow4-web-4.61.14.war
	
	fi
	
	if [ $BaixarDocflow = "4.61.15" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.61.15/docflow4-web-4.61.15.war
	
	fi
	
	if [ $BaixarDocflow = "4.61.16-saneago" ]; then 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS} https://repository.dataeasy.com.br/repository/releases/br/com/dataeasy/docflow4-web/4.61.16-saneago/docflow4-web-4.61.16-saneago.war
	
	fi
	
	
fi

if [ $opcao = "12" ]; then #Baixar arquivo Config-Files 

	wget --no-check-certificate --user=${USERSYS} --password=${PASS}  https://download.dataeasy.com.br/well/instaladores/docflow4/docflow4.57.6/config-files-4.57.6.zip
	
fi

if [ $opcao = "13" ]; then #Criar diretório Config-Files 

	unzip config-files-4.57.6.zip
	mkdir -p /opt/sistemas/dataeasy/docflow/
	mv /opt/install/config-files/* /opt/sistemas/dataeasy/docflow/

	cd /opt/sistemas/dataeasy/docflow/
	if [ `pwd` = "/opt/sistemas/dataeasy/docflow" ]; then
	
			echo "A pasta foi criada com sucesso!"
		
	fi

fi


if [ $opcao = "14" ]; then #Instalar Jboss

	unzip jboss-as-7.1.0.Final.zip
	mv jboss-as-7.1.0.Final/ /opt/
	ln -s /opt/jboss-as-7.1.0.Final/ /opt/jboss
	chmod 775 /opt/jboss/ -R
	cd /opt/jboss/
	if [ `pwd` = "/opt/jboss/" ]; then
	
			echo "Jboss instalado com sucesso!"

		
	fi
	
fi

if [ $opcao = "15" ]; then #Instalar Java

	tar -zxvf jdk-7u80-linux-x64.tar.gz
	mv jdk1.7.0_80/ /opt/
	ln -s /opt/jdk1.7.0_80/ /opt/java
	
	cd /opt/java/
	if [ `pwd` = "/opt/java/" ]; then
			java -version
			echo "Java instalado com sucesso!"
		
	fi
	
fi


if [ $opcao = "16" ]; then #Configurar Váriaveis de Ambiente

	echo "
#!/bin/bash
# JBoss
# Pasta: /etc/profile.d
# Arquivo: docflow.sh

JBOSS_HOME=/opt/jboss
JAVA_HOME=/opt/java
export JBOSS_HOME
export JAVA_HOME

	
# Atualizando a variaveis
export PATH=$PATH:$JAVA_HOME/bin:$JBOSS_HOME" > /etc/profile.d/docflow.sh

	chmod +x /etc/profile.d/docflow.sh
	source /etc/profile.d/docflow.sh
	
	clear
	echo "Váriaveis de ambiente configuradas, será necessario reiniciar o computador, deseja reiniciar agora? s = sim ou n = não"
	read reiniciar
	if [ $reiniciar = "s" ]; then
	
		reboot
	
	fi	
	
fi


if [ $opcao = "17" ]; then #Instalar Fontes

	mkdir -p /usr/share/fonts
	unzip FontesAspose.zip
	mv ./Fontes\ Aspose/* /usr/share/fonts/
	
	unzip FontesJasper.zip
	mv ./FontesJasper/* /opt/java/jre/lib/fonts/
	
		
fi

if [ $opcao = "18" ]; then #Remover arquivos desnecessários de Instalação

	rm -rf ./FontesJasper/
	rm -rf ./Fontes\ Aspose/
	rm -rf ./config-files/
	
fi

if [ $opcao = "19" ]; then #Criar pasta de volume padrão

	mkdir -p /opt/sistemas/dataeasy/volume_I/
	mkdir -p /opt/sistemas/dataeasy/volume_I/thumbnails/
	mkdir -p /opt/sistemas/dataeasy/volume_I/client-images/

	cd /opt/sistemas/dataeasy/volume_I/client-images/

	if [ `pwd` = "/opt/sistemas/dataeasy/volume_I/client-images" ]; then
			
			echo "Pasta de Volume criada com sucesso!"
	fi		
		
fi

if [ $opcao = "20" ]; then #Criar usuário jboss no sistema

	adduser jboss
	echo "Usuário criado com sucesso"
fi

if [ $opcao = "21" ]; then #Dar permissões a pasta da aplicação


	cd /opt/
	chown jboss.jboss * -R
	echo "Permissão concedida ao usuário jboss"
	
fi

if [ $opcao = "22" ]; then #Configurar systemctl

	echo "
# JBoss AS 7
# DIR = /etc/systemd/system
# FILE = jboss.service

[Unit]
Description=Jboss Application Server
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/etc/init.d/jboss start
ExecStop=/etc/init.d/jboss stop
#PIDFile=/var/run/jboss/jboss.pid

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/jboss.service

	mv /opt/jboss/bin/init.d/jboss/jboss /etc/init.d/
	chmod 777 /etc/init.d/jboss
	systemctl enable jboss
	
fi

if [ $opcao = "23" ]; then #Ver regras do Firewall

		iptables -L

	
	
fi


if [ $opcao = "24" ]; then #Editar arq. de config-propreties	
		vim /opt/sistemas/dataeasy/docflow/config.properties
	
fi

if [ $opcao = "25" ]; then #Editar arq. de Banco de Dados 'Jboss' 
		vim /opt/jboss/standalone/configuration/standalone.xml
		
	
fi

if [ $opcao = "26" ]; then #Editar arq. de Conf. BD 'Docflow' 

		vim /opt/sistemas/dataeasy/docflow/dataSource.properties
	
fi

# -- FIM --

