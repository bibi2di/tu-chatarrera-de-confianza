#!/usr/bin/bash

##Instalacion y Mantenimiento de una Aplicación Web
#Importar funciones de otros ficheros

#Vgrupal 13:12 11mayo

###########################################################
#                  1) INSTALAR NGINX                      #
###########################################################
function crearNuevaUbicacion()
{
    if [ -d /var/www/formulario/produccion ]
    then
        echo -e "Ya existe el direcctorio...\n"
    else
        echo "Creando directorio..."
        sudo mkdir -p /var/www/formulario/produccion
        echo "Cambiando permisos del directorio..."
        sudo chown -R $USER:$USER /var/www/formulario/produccion
        echo ""
    fi
    read -p "PULSA ENTER PARA CONTINUAR..."
}

###########################################################
#                  2) COPIAR FICHEROS                     #
###########################################################
function copiarFicherosProyectoNuevaUbicacion() 
{

    if [[ -d /var/www/formulario/desarrollo  && -d /var/www/formulario/produccion ]]
    then
	echo -e "Se van a pasar los archivos app.py, requirements.txt y la carpeta templates \n "
    	sudo cp /var/www/formulario/desarrollo/app.py /var/www/formulario/produccion/
    	sudo chown -R $USER:$USER /var/www/formulario/produccion/app.py
    	sudo cp /var/www/formulario/desarrollo/requirements.txt /var/www/formulario/produccion/
    	sudo chown -R $USER:$USER /var/www/formulario/produccion/requirements.txt
    	sudo touch /var/www/formulario/produccion/datos_guardados.txt
    	sudo chown -R $USER:$USER /var/www/formulario/produccion/datos_guardados.txt
    	sudo cp -r /var/www/formulario/desarrollo/templates/ /var/www/formulario/produccion/
    	sudo chown -R $USER:$USER /var/www/formulario/produccion/
    	echo -e "Se han pasado los archivos"
    else
    	echo -e "Tienes que crear la carpeta produccion"
    	echo -e "Es la primera opción del menu"
    fi
    read -p "PULSA ENTER PARA CONTINUAR..."
}

###########################################################
#                  3) EJECUTAR ENTORNO VIRTUAL            # 
###########################################################
function ejecutarEntornoVirtual()
{
     echo -e "Actualización del sistema..."
     sudo apt-get update #Actualizar el sistema
     echo -e "Instalación del paquete python3-pip..."
     sudo apt install python3-pip #Instala el paquete python3-pip
     echo -e "Instalación del paquete python3-dev..."
     sudo apt install python3-dev #Instala el paquete python3-dev
     echo -e "Instalación del paquete build-essential..."
     sudo apt install build-essential #Instala el paquete build-essential
     echo -e "Instalación del paquete libssl-dev..."
     sudo apt install libssl-dev  #Instala el paquete libssl-dev
     echo -e "Instalación del paquete libffi-dev..."
     sudo apt install libffi-dev  #Instala el paquete libffi-dev
     echo -e "Instalación del paquete python3-setuptools..."
     sudo apt install python3-setuptools  #Instala el paquete python3-setuptools
     echo -e "Instalación el paquete python3-env..."
     sudo apt install python3-venv " instalación que se había hecho en anteriores prácticas"
     sudo pip3 install virtualenv  #Instala el paquete python3-env
     if [ ! -d /var/www/formulario/produccion ] 
     then
     	echo -e "No existe el directorio...\n"
     	echo -e "Crealo con la opción 1"
     fi
     echo -e "Cambio de directorio"
     cd /var/www/formulario/produccion
     echo -e "Creando directorio..."
     sudo python3 -m venv venv
     echo -e "Cambiando permisos del directorio..."
     sudo chown -R $USER:$USER /var/www/formulario/produccion/venv
     echo -e "Activar el directorio"
     source venv/bin/activate
     echo -e ""
     read -p "PULSA ENTER PARA CONTINUAR..."	
}     

###########################################################
#                  4) INSTALAR LIBRERIAS                  #
###########################################################
function instalarLibreriasEntornoVirtual()
{
     if [ ! -d /var/www/formulario/produccion ] 
     then
     	echo -e "No existe el directorio...\n"
     	echo -e "Crealo con la opción 1"
     else
	     echo -e "Cambio de directorio"
	     cd /var/www/formulario/produccion
	     if [ ! -d /var/ww/formulario/produccion/venv ]
	     then
	     	echo -e "Creando directorio..."
	    	sudo python3 -m venv venv
	     	echo -e "Cambiando permisos del directorio..."
	     	sudo chown -R $USER:$USER /var/www/formulario/produccion/venv
	     fi
	     echo -e "Activar el directorio"
	     source venv/bin/activate
	     echo -e "Actualiza el pip3"
	     sudo pip3 install --upgrade pip 
	     echo -e "Instalar libreias del fichero requirements.txt"
	     pip install -r requirements.txt
     fi
     echo -e ""
     read -p "PULSA ENTER PARA CONTINUAR..."	
}

###########################################################
#                  5) EJECUTAR FLASK                      #
###########################################################
function probarFlask()
{
     if [ ! -d /var/www/formulario/produccion ] 
     then
     	echo -e "No existe el directorio...\n"
     	echo -e "Crealo con la opción 1..."
     fi
     echo -e "Cambio de directorio..."
     cd /var/www/formulario/produccion
     if [ ! -d /var/ww/formulario/produccion/venv ]
     then
     	echo -e "Creando directorio..."
    	sudo python3 -m venv venv
     	echo -e "Cambiando permisos del directorio..."
     	sudo chown -R $USER:$USER /var/www/formulario/produccion/venv
     fi
     #echo -e "Cambiando permisos del documento datos_guardados.txt..."
     #sudo chown -R $USER:$USER /var/www/formulario/produccion/datos_guardados.txt
     echo -e "Activar el directorio..."
     source venv/bin/activate
     echo -e "Ejecuta el flask..."
     echo -e "Se abrira el fichero en la dirección web http://127.0.0.1:5000/"
     echo -e "Para salir es necesario poner en la terminal Ctrl + C"
     python3 app.py | firefox http://127.0.0.1:5000/
     echo -e ""
     read -p "PULSA ENTER PARA CONTINUAR..."
}

###########################################################
#                  6) INSTALAR NGINX                      #
###########################################################
function instalarNGINX()
{
	aux=$(aptitude show nginx | grep "State: installed")
	aux1=$(aptitude show nginx | grep "Estado: instalado")
	aux3=$aux$aux1
	if [ -z "$aux3" ] # -z Comprueba si la cadena está vacía
	then 
		echo -e "Actualización del sistema..."
		sudo apt update
		echo -e "Instalación de Nginx"
		sudo apt install nginx
	else
		echo -e "Nginx ya está instalado"
	fi
	read -p "PULSA ENTER PARA CONTINUAR..."
}

###########################################################
#                  7) ARRANCAR NGINX                      #
###########################################################
function arrancarNGINX()
{
	aux=$(sudo systemctl status nginx | grep "Active: active")
	 if [ -z "$aux" ]
	 then
	 	echo -e "Activar el demonio nginx"
	 	sudo systemctl start nginx
	 else
	 	echo -e "El demonio nginx está activo"
	 fi
	 read -p "PULSA ENTER PARA CONTINUAR..."
	 
}

###########################################################
#                8) TestearPuertosNGINX                   #
###########################################################

function TestearPuertosNGINX(){
    aux=$(dpkg -l net-tools | grep "ii net-tools") 
    if [ -z "$aux" ]
    then 
    	echo -e "El paquete net-tools no está instalado"
    	echo -e "Instalando..."
    	sudo apt install net-tools
    else
    	echo -e "El paquete ya está instalado"
    fi
    echo "Información sobre los puertos en los que NGINX está escuchando:"
    #sudo netstat -ntlp | grep nginx
    sudo netstat -anp | grep nginx  # con anp es más completa
    read -p "PULSA ENTER PARA CONTINUAR..."
}


###########################################################
#                 9) visualizarIndex                      #
###########################################################

function visualizarIndex(){

    if ! [ -x "$(command -v google-chrome)" ]; then  #Localiza en que carpeta está google-chrome instalado y -x comprueba que el archivo es un ejecutable
    	echo "Google Chrome no está instalado. Instalando..."
        sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
        sudo apt update
	sudo dpkg -i google-chrome-stable_current_amd64.deb
	echo 'Google Chrome ha sido instalado exitosamente.'
    fi
    
    google-chrome-stable http://127.0.0.1
    read -p "PULSA ENTER PARA CONTINUAR..."

}

###########################################################
#                  10) personalizarIndex                  #
###########################################################

function personalizarIndex(){
     if [ -f /var/www/html/index.nginx-debian.html ]
     then
     	echo -e "Eliminamos el index por defecto e introducimos el nuestro"
     	sudo rm /var/www/html/index.nginx-debian.html
     	#sudo gedit /var/www/html/index.html
     #else
	#sudo gedit /var/www/html/index.html
     fi
	firefox http://127.0.0.1/index.html 
     echo -e "Se ha copiado el index.html en /var/www/html "
     read -p "PULSA ENTER PARA CONTINUAR..."
}

###########################################################
#                   11) instalarGunicorn                  #
###########################################################

function instalarGunicorn(){

	#if ! command -v gunicorn &> /dev/null
	
	aux=$(ls -lias /var/www/formulario/produccion/venv/bin | grep gunicorn) 
   	 if [ -z "$aux" ]
   	 
   	 then
	    echo "Gunicorn no está instalado. Instalando..."

	   # Activar el entorno virtual
	     cd /var/www/formulario/produccion
	     source venv/bin/activate

	    # Instalar Gunicorn en el entorno virtual
	    
	    sudo /var/www/formulario/produccion/venv/bin/pip3 install gunicorn
	    pip install gunicorn
	    
	else
	    echo "Gunicorn ya está instalado."
	fi
	read -p "PULSA ENTER PARA CONTINUAR..."
}

###########################################################
#   12) CONFIGURACIÓN DE GUNICORN : PUNTO DE ENTRADA 	  #
###########################################################
function configurarGunicorn()
{
    aux=$(ls -lias /var/www/formulario/produccion | grep wsgi.py) #find /var/www/formulario/produccion -name wsgi.py)
   	 if [ -z "$aux" ]
   	 then
        	 echo -e "Creando un punto de entrada para nuestra aplicación en Gunicorn"
         # Servirá como punto de entrada para nuestra aplicación.
         # Crear el archivo wsgi.py en la carpeta /var/www/formulario/produccion
         	 touch /var/www/formulario/produccion/wsgi.py
        	 echo "from app import app" > /var/www/formulario/produccion/wsgi.py
   		 echo "if __name__ == '__main__':" >> /var/www/formulario/produccion/wsgi.py
   		 echo "	app.run()" >> /var/www/formulario/produccion/wsgi.py
   	 
   	 else
        	 echo -e "El archivo wsgi.py ya está creado "
    
         fi
         
         # Comprobar que Gunicorn pueda proveer correctamente la Aplicación de Flask.
         echo -e "Cambio de directorio"
   	 cd /var/www/formulario/produccion
   	 echo -e "Activar el directorio..."
   	 
   	 # Se visitará la página web para ver el resultado.
   	 echo -e "Visitamos la direcc http://127.0.0.1:5000/ para comprobar que el cliente es atendido correctamente por gunicorn"
   	 source venv/bin/activate
   	 gunicorn --bind 0.0.0.0:5000 wsgi:app | firefox http://127.0.0.1:5000
   	 
   	 # Se cierra el servicio
 	 echo -e "Para salir es necesario poner en la terminal Ctrl + C"
 	 read -p "PULSA ENTER PARA CONTINUAR..."
   	 
}

###########################################################
#       13) CONFIGURACIÓN DE GUNICORN : PERMISOS 	  #
###########################################################
function pasarPropiedadyPermisos()
{
         # Otorgar permisos: propiedad a usuario y grupo www-data (usuario con lo que nginx y gunicorn lo ejecutarán.)
   	 sudo chown -R www-data:www-data /var/www
   	 sudo chmod -R 755 /var/www/formulario   
   	 read -p "PULSA ENTER PARA CONTINUAR..."     
}

###########################################################
#        	14) CREAR EL SERVICIO DE SYSTEMDFLASK     #	
###########################################################
function crearServicioSystemdFlask()
{
    aux=$(ls -lias  /etc/systemd/system | grep flask.service)
   	 if [ -z "$aux" ]
   	 then
        	 echo -e "Creando el archivo systemd /etc/systemd/system/flask.service"

         # Crear el archivo flask.service en la carpeta /etc/systemd/system/"
         	 sudo touch /etc/systemd/system/flask.service
         	 sudo chown -R $USER:$USER /etc/systemd/system/flask.service
        	 echo "[Unit]" > /etc/systemd/system/flask.service
   		 echo "Description=Gunicorn instance to serve Flask" >> /etc/systemd/system/flask.service
   		 echo "After=network.target" >> /etc/systemd/system/flask.service
   		 echo "[Service]" >> /etc/systemd/system/flask.service
   		 echo "User=www-data" >> /etc/systemd/system/flask.service
   		 echo "Group=www-data" >> /etc/systemd/system/flask.service
   		 echo "WorkingDirectory=/var/www/formulario/produccion" >> /etc/systemd/system/flask.service
   		 echo "Environment='PATH=/var/www/formulario/produccion/venv/bin' " >> /etc/systemd/system/flask.service
   		 echo "ExecStart=/var/www/formulario/produccion/venv/bin/gunicorn --bind 0.0.0.0:5000 wsgi:app" >> /etc/systemd/system/flask.service
   		 echo "[Install]" >> /etc/systemd/system/flask.service
   		 echo "WantedBy=multi-user.target" >> /etc/systemd/system/flask.service
   	 
   	 else
   		 echo -e "El archivo /etc/systemd/system/flask.service ya está creado "
    
         fi
         
         echo -e " Re-cargando el demonio systemd."
         sudo systemctl daemon-reload
         
         echo -e "Arrancar el servicio flask."
         sudo systemctl start flask
         
         # Se habilita el demonio para que se inicie automáticamente al iniciar el sistema
         sudo systemctl enable flask
    
         echo -e "Se verifica si el estado del demonio está arrancado y activo"
         
         sudo systemctl status flask  
         read -p "PULSA ENTER PARA CONTINUAR..."
}

###########################################################
#   15) CONFIG NGINX COMO PROXY INVERSO: CAMBIO PUERTO	  #
###########################################################
function cambiarPuertoNginx()
{
# Configurar Nginx para que funcione como un proxy inverso para servir la aplicación Flask a través del puerto 8888 creando un host virtual.


    aux=$(find  /etc/nginx/conf.d -name flask.conf)
   	 if [ -z "$aux" ]
   	 then
        	 echo -e "Creando el archivo  /etc/nginx/conf.d/flask.conf"
         	 sudo touch /etc/nginx/conf.d/flask.conf
         	 sudo chown -R $USER:$USER /etc/nginx/conf.d/flask.conf
        	 echo "server {" > /etc/nginx/conf.d/flask.conf
   		 echo "    listen 8888;" >> /etc/nginx/conf.d/flask.conf
   		 echo "    server_name localhost;" >> /etc/nginx/conf.d/flask.conf
   		 echo "    location / {" >> /etc/nginx/conf.d/flask.conf
   		 echo "		 include proxy_params;" >>  /etc/nginx/conf.d/flask.conf
   		 echo "   	 proxy_pass http://127.0.0.1:5000;" >> /etc/nginx/conf.d/flask.conf
   		 echo "    }" >> /etc/nginx/conf.d/flask.conf
   		 echo "}" >> /etc/nginx/conf.d/flask.conf
   	 else
   		 echo -e "El archivo /etc/nginx/sites-available/flask ya está creado "
    
         fi
         
        	 # Activa el proxy inverso, creando un enlace simbólico en la carpeta /etc/nginx/sites-enabled:
        	 
    sudo ln -s /etc/nginx/conf.d/flask.conf /etc/nginx/sites-enabled
    read -p "PULSA ENTER PARA CONTINUAR..."
}

###########################################################
#   	16) CARGAR CAMBIOS DE CONFIGURACIÓN NGINX     	  #
###########################################################
function cargarFicherosConfiguracionNginx()
{    
    # Para obligar a NGINX a cargar los nuevos cambios de la configuración:
    echo -e "Cargar los nuevos cambios de configuración de Nginx"
    sudo systemctl reload nginx
    read -p "PULSA ENTER PARA CONTINUAR..."
}

###########################################################
#              	17) REARRANCAR NGINX               	  #
###########################################################
function rearrancarNginx()
{    
    echo -e "Rearrancando el servicio nginx"
    sudo systemctl restart nginx
    read -p "PULSA ENTER PARA CONTINUAR..."
}
    
###########################################################
#            	18) TESTEAR EL HOST VIRTUAL          	  #
###########################################################
function testearVirtualHost()
{    
    echo -e "Testear el virtual host creado abriendo en el navegador la dirección http://127.0.0.1:8888."
    firefox http://127.0.0.1:8888 
    firefox http://localhost:8888/
    echo -e "Tenemos un aplicación web correctamente instalada en un servidor de producción."
    read -p "PULSA ENTER PARA CONTINUAR..."
}

###########################################################
#                19) VISUALIZAR ERRORES NGINX             #
###########################################################
function verNginxLogs()
{
	echo -e "Visualiza las 10 últimas lineas del fichero"
	sudo tail -n 10 /var/log/nginx/error.log
	read -p "PULSA ENTER PARA CONTINUAR..."
}

###########################################################
#             20) COPIAR FICHEROS ORDENADOR REMOTO        #
###########################################################
function copiarServidorRemoto()
{
	aux=$(aptitude show openssh-server | grep "State: installed")
	aux1=$(aptitude show openssh-server | grep "Estado: instalado")
	aux3=$aux$aux1
	if [ -z "$aux3" ] # -z Comprueba si la cadena está vacía
	then 
		echo -e "Actualización del sistema..."
		sudo apt update
		echo -e "Instalación de Nginx"
		sudo apt install openssh-server -y
	fi
	aux2=$(sudo systemctl status ssh | grep "Active: active")
	if [ -z "$aux2" ]
	then
	 	echo -e "Activar el demonio nginx"
	 	sudo systemctl start ssh
	else
	 	echo -e "El demonio nginx está activo"
	fi
	
	
	echo -e "Comprimimos la carpeta desarrollo..."
	sudo tar -cvzf desarollo.tar.gz /var/www/formulario/desarrollo/*
	
	read -p "Indica la ip del servidor remoto: " ip
	echo -e "Establece una conexión con el servidor... "
	scp desarollo.tar.gz $USER@$ip:/home/$USER/
	scp menu.sh $USER@$ip:/home/$USER/
	ssh $USER@$ip
	tar -zxvf desarollo.tar.gz
	sudo mv /home/$USER/desarrollo /var/www/formulario/
	
	
	#echo -e "Transferencia de archivos finalizada. Cerrando conexión SSH..."
	#ssh $USER@$ip "exit"
	read -p "PULSA ENTER PARA CONTINUAR..."
	
}

###########################################################
#                  21) CONTROLAR CONEXIONES SSH           #
###########################################################
function controlarIntentosConexionSSH()
{
	echo -e "Cambio de directorio a desarrollo..."
	cd /var/www/formulario/desarrollo
 	#supuestamente tenemos ya los permisos para entrar y leer archivos 
	#el nuevo .txt no tendría porque crearse en root, podemos crearlo en home de usuario pq es solo para visualizar y luego borrar
	sudo touch auth.log.txt
	sudo chown $USER:$USER auth.log.txt
	sudo touch out.txt
	sudo chown $USER:$USER out.txt
	echo -e "Metemos la información del fichero auth.log en auth.log.txt..."
	cat /var/log/auth.log* > auth.log.txt  # el nuevo .txt se crea solo y se meten todas las que son auth.log + auth.log.Nº  ... 
	echo -e "Añadimos la información del fichero auth.log.* que sean .zip  en el auth.log.txt..."
	zcat /var/log/auth.log*.gz >> auth.log.txt #Al ser archivos que están comprimidos se utiliza este comando para visualizarlo
	
	echo -e "Separamos el fichero por lineas en vez de por palabras"
	
	less auth.log.txt | tr -s ' ' '@' > out.txt  
	

	
	echo -e "Dentro de este fichero buscamos las líneas que tengan que ver con el comando sshd"
	
	for linea in $(grep "sshd" out.txt  | grep -E "Failed|Accepted")
	
	do   
	
		dia=$(echo $linea | cut -d '@' -f 2 | cut -c 1-2) # cut -d es un delimitador, delimita las líneas con @ y coge la primera columna 'f
		mes=$(echo $linea | cut -d '@' -f 1)
		hora=$(echo $linea | cut -d '@' -f 3)
		
		aux2=$(echo $linea | grep "repeated") #para errores repetidos la columna del usuario cambia
		if [ -z $aux2 ]
		then
			user=$(echo $linea | cut -d '@' -f 9)
		else
			user=$(echo $linea | cut -d '@' -f 14)
		fi
			
		aux=$(echo $linea | grep "Failed")
		
		if [ -z "$aux" ]
		then 
			status="accept"
		else
			status="fail"
		fi
		
		echo -e "Status: [$status] Account name: $user Date: $mes, $dia, $hora"
       
	done
	read -p "PULSA ENTER PARA CONTINUAR..."
	
	
	#sudo rm auth.log.txt
	#sudo rm out.txt

}

###########################################################
#                  22) FIN MENU                           #
###########################################################
function salirMenu()
{
  	echo -e "¿Quieres salir del programa?(S/N)\n"
        read respuesta
	if [ $respuesta == "S" ]
	then
		echo -e "Vamos paralizar los servicios de flask..."
		echo -e "Los miembros del grupo somos: Bidane León, Asier Larrazabal, Carmela García y Ander Gorocica"
		sudo service flask stop
	else
		opcionmenuppal=0
	fi	
}

###########################################################
#		 23) DESINSTALAR NGINX			 #
###########################################################
# function desinstalarNginx()
# {
	# aux=$(sudo systemctl status nginx | grep "Active: active")
	# if [ -z "$aux" ]
	# then
		# echo -e "nginx no está activo"
	# else 
		# echo -e "nginx sigue activo"
		# sudo systemctl stop nginx
	# fi
	# aux1=$(aptitude show nginx | grep "State: installed")
	# aux2=$(aptitude show nginx | grep "Estado: instalado")
	# aux3=$aux$aux1
	# if [ -z "$aux3" ]
	# then 
		# echo -e "nginx no está instalado"
	# else
		# echo -e "nginx está instalado"
		# sudo apt remove nginx
	# fi
# }


### Main ###
opcionmenuppal=0
while test $opcionmenuppal -ne 22
do
	#Muestra el menu
        echo -e "1 Crea la nueva ubicación \n"
        echo -e "2 Copia los ficheros del proyecto en una nueva ubicación \n"
        echo -e "3 Ejecuta el entorno virtual \n"
        echo -e "4 Instalar las librerias del entorno virtual \n"
        echo -e "5 Ejecutar flask \n"
        echo -e "6 Instalación de NGINX \n"
        echo -e "7 Arranca NGINX \n"
        echo -e "8 Testear puertos NGINX \n"
        echo -e "9 Visualizar indice \n"
        echo -e "10 Personalizar indice \n"
        echo -e "11 Instalar Gunicorn \n"
        echo -e "12 Configuración de Gunicorn: Punto de entrada \n"
        echo -e "13 Configuración de Gunicorn: Permisos \n"
        echo -e "14 Crear el Servicio de SystemFlask \n"
        echo -e "15 Cambiar puerto Nginx al puerto 8888\n"
        echo -e "16 Cargar los cambios de Config Nginx \n"
        echo -e "17 Rearrancar el demonio NGINX \n"
        echo -e "18 Testear el virtual host creado en el puerto 8888\n"
        echo -e "19 Mostrar los 10 últimas líneas de errores de Nginx \n"
        echo -e "20 Copiar los ficheros del proyecto en un ordenador remoto \n"
        echo -e "21 Mostrar información de los intentos de conexión a un ordenador remoto \n"
	echo -e "22 Salir del menu \n"
	read -p "Elige una opcion:" opcionmenuppal
	case $opcionmenuppal in
			1) crearNuevaUbicacion;;
			2) copiarFicherosProyectoNuevaUbicacion;;
			3) ejecutarEntornoVirtual;;
			4) instalarLibreriasEntornoVirtual;;
			5) probarFlask;;
			6) instalarNGINX;;
			7) arrancarNGINX;;
			8) TestearPuertosNGINX;;
			9) visualizarIndex;;
			10) personalizarIndex;;
			11) instalarGunicorn;;
			12) configurarGunicorn;;
			13) pasarPropiedadyPermisos;;
			14) crearServicioSystemdFlask;;
			15) cambiarPuertoNginx;;
			16) cargarFicherosConfiguracionNginx;;
			17) rearrancarNginx;;
			18) testearVirtualHost;;
			19) verNginxLogs;;
			20) copiarServidorRemoto;;
			21) controlarIntentosConexionSSH;;
			22) salirMenu;;

	esac 
done 

echo "Fin del Programa" 
exit 0 





