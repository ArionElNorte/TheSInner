#!/bin/bash
# Arion Slava

# - Sinstool location: /usr/bin
# - Installations work directory: /tmp/sinswd
# - Installed services directory : /usr/local/etc
#  + OpenSSH: 
#   * Privileges Separation Directory: /usr/local/$(service)/var/empty
# - Logs directory: /var/log/sinstool


#### TEXTS/MENUS/BANNERS

#Banner begining
b_bgn="

                           :=+#%@@@@@@%#*=:            
                       .=#@@@@#*++====++*%@@#+.        
                     -#@@@*-.              :+@@%-      
                   :%@@@+                     =@@%-    
                  *@@@@:                       :@@@*   
                 #@@@@-                         :@@@%  
                *@@@@%                           *@@@# 
               -@@@@@+                  .        :@@@@-
               #@@@@@=  +=:         :=#@@#        @@@@#
               @@@@@@= =@@@@#=   :#@@@@@@@#       %@@@@
               @@@@@@+ +@@@@@#   :#@@@@@@@%       %@@@@
               #@@@@@*  %@*=+=*@@+++==+#@@:       %@@@#
               -@@@@@#  .+#@@@@@@@@@@@@#*=        %@@@-
                #@@@@# =*#@@@@@@@@@@@@#=*@*      :@@@# 
                 #@@@% .**+*%@@@@@%**+#@@*.     -@@@%  
                  *@@@%-  -*#*****#@%*-:   .-=+%@@@*   
                   -%@@@%-   -+**+-.  .=*%@@@@@@@%-    
                    -%@@@@@@#+-:..:-+#@@@@@@@@@%=      
                       .+#@@@@@@@@@@@@@@@@@%+:          

 dBBBBBBP dBP dBP dBBBP    .dBBBBP   dBP dBBBBb  dBBBBb  dBBBP dBBBBBb
                            BP               dBP     dBP            dBP
   dBP   dBBBBBP dBBP       qBBBBb  dBP dBP dBP dBP dBP dBBP    dBBBBK 
  dBP   dBP dBP dBP            dBP dBP dBP dBP dBP dBP dBP     dBP  BB 
 dBP   dBP dBP dBBBBP     dBBBBP  dBP dBP dBP dBP dBP dBBBBP  dBP  dB 
 
" # Banner begining

#Main menu
m_main="
              ╔══════════════════════════════════════╗
              ║ 1. Install a service                 ║
              ║--------------------------------------║
              ║ 2. Uninstall a service               ║
              ║--------------------------------------║
              ║ 3. Show installed services           ║
              ╠══════════════════════════════════════╣
              ║ 4. Exit                              ║
              ╚══════════════════════════════════════╝
" # Main menu

#Services menu
m_svc="
              ╔══════════════════════════════════════╗
              ║ 1. OpenSSH                           ║
              ╠══════════════════════════════════════╣
              ║ 2. Exit                              ║
              ╚══════════════════════════════════════╝
" # Services menu
##

#### FUNCTIONS

# Readck: It allows to use the history of previous inputs using the cursor keys.
function readck {
    local v_prompt="$1"
    local v_input="$2"

    # Stores the result of a "read" in a history file and in a temporary file.
    # If a cursor key is detected, it displays previous entries stored in the history file.
    v_read=$(rlwrap -H ~/.sins_history -S "              $v_prompt" bash -c 'read r_input; echo "$r_input"')

    # Assigns the contents of $v_read (i.e. the input) to the variable stored in "$v_input" (i.e. the "$2" parameter of the function).
    eval "$v_input='$v_read'"

    # Delete the line and overwrite it formatted. 
    tput cuu1  
    tput el
    echo  "              $v_prompt $v_read"

} # Readck

# Logwr: It writes the logs that are also shown to the user.
function logwr() {	
	echo "$(date +%H:%M:%S): ${1}" | tee -a ${f_log}
    echo "" >> ${f_log}
} # Logwr

# Exerr: Exits when an error occurs and displays a warning.
function exerr() {
    if [ ${1} -ne 0 ]; then
        logwr "${2} has failed"
        echo "Check logs: $f_log"
        exit
    else
        logwr "${2} was successful"
    fi
} # Exerr

# ShowVersion: It shows the installed versions and indicates the result with an error message. It is used in "uninstall" and "show". 
function ShowVersion() {
    #Check for installed versions of the service
    if [[ -z $( ls /usr/local/etc/ | grep "openssh-" ) ]]; then
        echo "              This service is not installed" 
        read -p "              Press intro to return to the main menu: "
        clear
        printf "%s" "$b_bgn"
        return 1
    else
        #Show available versions of OpenSSH
        ls /usr/local/etc/ | grep -e "openssh-"
        return 0
    fi
} # ShowVersion
##

#### FILES

# Log file 
f_log="/var/log/sinstool/$(date +"sinlog_%m-%d-%y_%H:%M:%S")"
logwr "Start: $f_log" # Log File
##

#### START EXECUTION

#Clear the screen and display the beginning banner.
clear
printf "%s" "$b_bgn"

### Main loop
while [ true ]
do

    ## Main menu
    printf "%s" "$m_main"
	readck "Choose an option: " opc
    date +"%H:%M:%S MainMenu: opc: $opc" >> $f_log

    case $opc in 
    1)
        #Check if internet connection and dns are working.
        if [[ $( curl -s -I "openbsd.org" ) ]]
        then 
            while [ true ]; do
                ## Install service menu
                clear
                printf "%s" "$b_bgn"
                echo "Install"
                printf "%s" "$m_svc"
                readck "Choose a service: " opc_svc
                date +"%H:%M:%S InstallServiceMenu: opc_svc: $opc_svc" >> $f_log

                case $opc_svc in 
                1)
                    #Show available versions of OpenSSH
                    curl -s https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/ | grep -o "openssh-[8-9]\.[0-9]\+p[0-9]\+\.tar\.gz" | sort -V | uniq | column

                    #Select version and check if it is available
                    while [ true ]
                    do
                        readck "Choose a version (i.e. 8.1p1) or press q to quit: " version
                        date +"%H:%M:%S InstallOpenSSHMenu: version: $version" >> $f_log

                        if [[ -z $(curl -s -I "https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-${version}.tar.gz" | grep "200 OK") ]]
                        then
                            if [[ $version == "q" ]]
                            then
                                break
                            fi
                            
                            echo "              This version does not exist"
                        else
                            if [[ -n $(ls /usr/local/etc/ | grep "openssh-${version}") ]]
                            then
                                echo "              This version is already installed"
                            elif [[ ! ${version} =~ [8-9]\.[0-9]+p[0-9]+ ]]
                            then
                                echo "              This version is not available"
                            else
                                break
                            fi
                        fi
                    done

                    #Quits if user selects "q".
                    if [[ $version == "q" ]]
                    then
                        clear
                        printf "%s" "$b_bgn"
                        break
                    fi

                    ### Starts the installation
                    clear
                    logwr "Starting the installation: OpenSSH-$version"

                    #Save the current working directory to be able to return.
                    cwd=$(pwd)
                    logwr "Installing: Changing to Sinstool Working Directory: Saving cwd to return: $cwd"

                    mkdir /tmp/sinswd
                    cd /tmp/sinswd
                        #Get the installation package and extract it
                        logwr "Installing: Downloading compressed file: https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-${version}.tar.gz"
                        curl -O "https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-${version}.tar.gz" &>> $f_log
                        exerr $? "openssh-${version}.tar.gz download"

                        logwr "Installing: Extracting files: Compressed file: openssh-${version}.tar.gz" 
                        tar -xzvf "openssh-${version}.tar.gz" &>> $f_log
                        exerr $? "Installing: Extracting files: openssh-${version}.tar.gz extraction"

                        #Create the SSH privilege separation user specific to this version
                        logwr "Installing: Addition of privilege separation user: sshd-$usr_vr"
                        usr_vr=$(echo $version | tr '.' '-')
                        adduser --system --no-create-home "sshd-$usr_vr" &>> $f_log
                        exerr $? "Installing: Addition of privilege separation user: User addition sshd-$usr_vr"

                        #Execute the installation configuration file specifying the destination path, the privilege separation user and the path to the privilege separation directory.
                        logwr "Installing: Configure: ./openssh-${version}/configure --with-privsep-path=/usr/local/etc/openssh-${version}/var/empty --with-privsep-user=sshd-${usr_vr}"
                        ./openssh-${version}/configure --prefix=/usr/local/etc/openssh-${version} --with-privsep-path=/usr/local/etc/openssh-${version}/var/empty --with-privsep-user=sshd-${usr_vr} &>> $f_log
                        exerr $? "Installing: Configure: ./configure execution: Creation of the build environment"

                        #Make the installation file and run it.
                        logwr "Installing: Make execution"
                        make &>> $f_log
                        exerr $? "Installing: Make execution: make: Creation of the installation file"
                        logwr "Installing: MakeInstall execution: make install DESTDIR=/usr/local/etc/openssh-${version}"

                        make install &>> $f_log
                        exerr $? "Installing: MakeInstall execution: make install: Installation"
                    cd $cwd
                    rm -r /tmp/sinswd
                    logwr "End of Installation: OpenSSH-$version"

                    ### Start the configuration
                    logwr "Start of the Configuration: OpenSSH-$version"

                    #Creation of the above specified privilege separation directory .
                    logwr "Configuring: Creation of the privilege separation directory: /usr/local/etc/openssh-${version}/var/empty"
                    mkdir -p /usr/local/etc/openssh-${version}/var/empty
                    exerr $? "Configuring: Creation of the privilege separation directory: /usr/local/etc/openssh-${version}/var/empty" 

                    #Creation of the symlink pointing to the executable of the service.
                    logwr "Configuring: Creation of the executable symlink: ln -s /usr/local/etc/openssh-${version}/bin/ssh /usr/local/bin/ssh${version}"
                    ln -s /usr/local/etc/openssh-${version}/bin/ssh /usr/local/bin/ssh${version}
                    exerr $? "Configuring: Creation of the executable symlink: ln -s /usr/local/etc/openssh-${version}/bin/ssh /usr/local/bin/ssh${version}" 

                    ## Creation of the unit file.
                    logwr "Configuring: CreateUnitFile: /etc/systemd/system/sshd${version}.service"
                    unt_file="
                        [Unit]
                        Description=OpenSSH ${version} server daemon
                        After=network.target

                        [Service]
                        ExecStart=/usr/local/etc/openssh-${version}/sbin/sshd -f /usr/local/etc/openssh-${version}/etc/sshd_config

                        [Install]
                        WantedBy=multi-user.target
                        "
                    echo "$unt_file" > /etc/systemd/system/sshd${version}.service 2>> $f_log
                    exerr $? "Configuring: CreateUnitFile: /etc/systemd/system/sshd${version}.service"   

                    ## Modification of the file "sshd_config".

                    #Select port and check that it is valid and available.
                    while [ true ]
                    do
                        readck "Choose the port: " chport
                        date +"%H:%M:%S Configuring: ChoosePort: chport: $chport" >> $f_log

                        if [[ $chport =~ ^[0-9]+$ ]] && [[ $chport -ge 1 && $chport -le 65535 ]]; then
                            if [[ -z $( netstat -tuln | grep ":$chport " ) ]]; then
                                break
                            else
                                echo "              This port is already in use"
                            fi
                        else
                            echo "              Choose a valid port. Range: 1 - 65535. Not recommended range: 1 - 1024."
                        fi
                    done

                    #Adding a port to configuration file: sshd_config
                    cnf_sshd_port="Port ${chport}"
                    logwr "Configuring: /usr/local/etc/openssh-${version}/etc/sshd_config: Port to be added: $cnf_sshd_port"
                    echo "$cnf_sshd_port" >> /usr/local/etc/openssh-${version}/etc/sshd_config
                    exerr $? "Configuring: /usr/local/etc/openssh-${version}/etc/sshd_config: Port addition: $cnf_sshd_port"

                    #Cration of the keys
                    logwr "Configuring: SSH-KeyGen: /usr/local/etc/openssh-${version}/bin/ssh-keygen -N "" -t rsa -b 2048 -f /usr/local/etc/openssh-${version}/etc/ssh_host_rsa_key"
                    /usr/local/etc/openssh-${version}/bin/ssh-keygen -N "" -t rsa -b 2048 -f /usr/local/etc/openssh-${version}/etc/ssh_host_rsa_key
                    logwr "Configuring: SSH-KeyGen: /usr/local/etc/openssh-${version}/bin/ssh-keygen -N "" -t ecdsa -b 256 -f /usr/local/etc/openssh-${version}/etc/ssh_host_ecdsa_key"
                    /usr/local/etc/openssh-${version}/bin/ssh-keygen -N "" -t ecdsa -b 256 -f /usr/local/etc/openssh-${version}/etc/ssh_host_ecdsa_key
                    logwr "Configuring: SSH-KeyGen: /usr/local/etc/openssh-${version}/bin/ssh-keygen -N "" -t ed25519 -f /usr/local/etc/openssh-${version}/etc/ssh_host_ed25519_key"
                    /usr/local/etc/openssh-${version}/bin/ssh-keygen -N "" -t ed25519 -f /usr/local/etc/openssh-${version}/etc/ssh_host_ed25519_key

                    #Adding the keys to configuration file: sshd_config
                    cnf_sshd_keys="

        HostKey /usr/local/etc/openssh-${version}/etc/ssh_host_rsa_key
        HostKey /usr/local/etc/openssh-${version}/etc/ssh_host_ecdsa_key
        HostKey /usr/local/etc/openssh-${version}/etc/ssh_host_ed25519_key

                    "
                    echo "$cnf_sshd_keys" >> /usr/local/etc/openssh-${version}/etc/sshd_config
                    logwr "Configuring: /usr/local/etc/openssh-${version}/etc/sshd_config: Keys added: $cnf_sshd_keys"

                    #Ask if they want to allow root to connect and check that the answer is valid.
                    while [ true ]
                    do
                        readck "Do you want to permit root login? (y/n): " chroot
                        date +"%H:%M:%S Configuration: Permit root: chroot: $chroot" >> $f_log

                        if [[ $chroot == "y" ]] ; then
                            cnf_sshd_root="PermitRootLogin yes"
                            echo "$cnf_sshd_root" >> /usr/local/etc/openssh-${version}/etc/sshd_config
                            logwr "Configuring: /usr/local/etc/openssh-${version}/etc/sshd_config: Root added: $cnf_sshd_root"
                            break

                        elif [[ $chroot == "n" ]] ; then
                            break
                        else
                            echo "              Choose a valid option."
                        fi
                    done

                    #Open port in firewall
                    logwr "Configuring: OpenFirewallPort: $chport"
                    iptables -A INPUT -p tcp --dport ${chport} -j ACCEPT &>> $f_log
                    exerr $? "Open Firewall port"

                    #Reset daemons and enable, start and show installed service.
                    logwr "Configuring: ResetDaemons"
                    systemctl daemon-reload &>> $f_log
                    logwr "Configuring: Enableing service: sshd${version}.service"
                    systemctl enable sshd${version}.service &>> $f_log
                    logwr "Configuring: Starting service: sshd${version}.service"
                    systemctl start sshd${version}.service &>> $f_log
                    systemctl status sshd${version}.service &>> $f_log
                    systemctl status sshd${version}.service

                    logwr "The OpenSSH-$version installation was successful."
                    echo "Check the logs in the file $f_log"

                    echo 
                    read -p "Press intro to return to the main menu: "
                    clear
                    printf "%s" "$b_bgn"
                    break
                ;;
                2)
                    clear
                    printf "%s" "$b_bgn"
                    break
                ;;
                *)
                    echo "              Choose a valid option"
                ;;
                esac
            done
        else
            echo "              This function requires an internet connection. Check your network and DNS settings."
        fi
    ;;
    2)
        while [ true ]; do
            ## Uninstall services menu
            clear
            printf "%s" "$b_bgn"
            echo "Uninstall"
            printf "%s" "$m_svc"
            readck "Choose a service: " opc_svc
            date +"%H:%M:%S UnnstallServiceMenu: opc_svc: $opc_svc" >> $f_log

            case $opc_svc in 
            1)
                #Shows the installed versions
                ShowVersion
                if [ $? -ne 0 ]; then
                    break
                fi

                #Select version and check if it is installed.
                while [ true ]
                do
                    readck "Choose a version (i.e. 8.1p1) or press q to quit: " version
                    date +"%H:%M:%S Uninstall: ChooseVersion: version: $version" >> $f_log

                    if [[ -n $(ls /usr/local/etc/ | grep "openssh-${version}") ]] || [[ "$version" == "q" ]] && [[ "$version" != "" ]]
                    then
                        break
                    else
                        echo "              This version is not installed"    
                    fi
                done

                #Quits if user selects "q".
                if [[ $version == "q" ]]
                then
                    clear
                    printf "%s" "$b_bgn"
                    break
                fi

                ### Starts the uninstallation
                clear
                logwr "Starting the uninstallation: OpenSSH-$version"

                #Get the port used
                svcport=$( grep ^Port /usr/local/etc/openssh-${version}/etc/sshd_config | cut -d ' ' -f 2 )
                logwr "Uninstall: Obtaining the service port: Service Port: $svcport"

                #Stop the service and delete the service files, the symlink and the unit file
                logwr "Uninstall: Stoping service: sshd${version}.service"
                systemctl stop sshd${version}.service

                usr_vr=$(echo $version | tr '.' '-')
                logwr "Uninstall: Deleting separation privileges user: sshd-$usr_vr"
                deluser "sshd-$usr_vr" &>> $f_log
                exerr $? "Uninstall: Deletion of separation privileges user sshd-$usr_vr"

                logwr "Uninstall: Removing main directory: /usr/local/etc/openssh-${version}"
                rm -r /usr/local/etc/openssh-${version}
                exerr $? "Uninstall: Remove of main directory /usr/local/etc/openssh-${version}"

                logwr "Uninstall: Removing executable symlink: /usr/local/bin/ssh${version}"
                rm /usr/local/bin/ssh${version}
                exerr $? "Uninstall: Remove executable symlink /usr/local/bin/ssh${version}"

                logwr "Uninstall: Removing unit file: /etc/systemd/system/sshd${version}.service"
                rm /etc/systemd/system/sshd${version}.service
                exerr $? "Uninstall: Remove of unit file /etc/systemd/system/sshd${version}.service"

                #Close the port on the firewall
                logwr "Uninstall: Closing the firewall port: Service Port: $svcport" 
                iptables -D INPUT -p tcp --dport $svcport -j ACCEPT &>> $f_log
                exerr $? "Uninstall: Close of the firewall port: Service Port: $svcport"

                logwr "The OpenSSH-$version uninstallation was successful."

                echo 
                read -p "Press intro to return to the main menu: "
                clear
                printf "%s" "$b_bgn"
                break
            ;;
            2)
                clear
                printf "%s" "$b_bgn"
                break
            ;;
            *)
                echo "              Choose a valid option"
            ;;
            esac
        done
    ;;
    3)
        while [ true ]; do
            #Installed services menu
            clear
            printf "%s" "$b_bgn"
            echo "Show versions"
            printf "%s" "$m_svc"
            readck "Choose a service: " opc_svc

            case $opc_svc in
            1)
                #Shows the installed versions
                ShowVersion
                if [ $? -ne 0 ]; then
                    break
                fi
                
                echo
                read -p "Press intro to return to the main menu: "
                clear
                printf "%s" "$b_bgn"
                break
            ;;
            2)
                clear
                printf "%s" "$b_bgn"
                break
            ;;
            *)
                echo "              Choose a valid option"
            ;;
            esac
        done
    ;;
    4)
        clear
        break
    ;;
    *)
        echo "              Choose a valid option"
    ;;
    esac
done