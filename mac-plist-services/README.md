# Mac info

### If you want to use persistence service like a Linux, but only into MacOS, you can use plist manifests based on xml-format for auto start-up any commands.


## Please, use ~/Library/LaunchAgents directory for setting up your persistence service

## About Service

This service configuration file, com.test.easy-service-startup.plist, is used to create a persistent SSH tunnel on macOS, utilizing Apple’s launchd to manage its startup and execution. Here’s a breakdown of its function:

 1.	Persistent SSH Tunnel Setup: The service runs the SSH command to establish a tunnel, connecting to a remote server (8.15.1.4) as the user user_server, and it forwards local port 6447 to remote IP 192.168.0.3 on port 6443. This effectively allows access to the remote service on 192.168.0.3:6443 through localhost:6447.
 2.	Agent Forwarding and Connection Reliability: The ForwardAgent option enables SSH agent forwarding for secure access to downstream servers. Additionally, ServerAliveInterval=60 maintains the connection by sending keep-alive packets every 60 seconds, and ExitOnForwardFailure ensures the service only remains active if the forwarding is successfully established.
 3.	Automatic Startup and Logging:
  •	The service starts automatically when the system boots, thanks to the RunAtLoad key.
  •	It stays active due to the KeepAlive directive, which restarts the tunnel if it disconnects.
  •	Standard output and error are logged to /tmp/ssh-tunnel.com.test.easy-service-startup.out and /tmp/ssh-tunnel.com.test.easy-service-startup.err, respectively, for troubleshooting purposes.

To activate this service, it is loaded into launchd with the command launchctl load ~/Library/LaunchAgents/com.test.easy-service-startup.plist. This configuration provides a stable, self-restarting SSH tunnel service ideal for consistent, secure remote access.

### Stupid instructions:

1) Create manifest, for example: ~/Library/LaunchAgents/com.test.easy-service-startup.plist

```
cat << EOF > ~/Library/LaunchAgents/com.test.easy-service-startup.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.test.easy-service-startup</string>
    <key>UserName</key>
    <string>testlogin</string>
    <key>ProgramArguments</key>
    <array>
      <string>/usr/bin/ssh</string>
      <string>-l</string>
      <string>user_server</string>
      <string>-F</string>
      <string>/Users/your_username/.ssh/config</string>
      <string>-NT</string>
      <string>-o</string>
      <string>ForwardAgent=yes</string>
      <string>-o</string>
      <string>ServerAliveInterval=60</string>
      <string>-o</string>
      <string>ExitOnForwardFailure=yes</string>
      <string>-L</string>
      <string>0.0.0.0:6447:192.168.0.3:6443</string>
      <string>8.15.1.4</string>
    </array>
    <key>KeepAlive</key>
    <true/>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/ssh-tunnel.com.test.easy-service-startup.out</string>
    <key>StandardErrorPath</key>
    <string>/tmp/ssh-tunnel.com.test.easy-service-startup.err</string>
  </dict>
</plist>
EOF;
sudo launchctl load ~/Library/LaunchAgents/com.test.easy-service-startup.plist;
```

Where, you can change next params:
`user_server`
```
Login name to successfully connect to your server via ssh;
```
`your_username`
```
Login name for MacOS user, also, you want to change for confirmation;
```
(!) IP addresses are used to conceal the bastion access point, and ports are managed within the GitOps paradigm to securely store the kubeconfig file in Git. This approach enhances security by controlling access points and enables consistent and versioned storage of critical configuration files, aligning with infrastructure-as-code principles.