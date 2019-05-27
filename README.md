# docker-steamcmd-gs-updater
Docker container to update a steam game server (volume mount).  
This image can be run as cronjob, periodically update the game server files on a persistent volume claim.  

This image expects the following:
- Environment variable `STEAM_APP` set to the Steam APP ID you want to install/update
- The environment variable `PURGE` set to `yes`/`no` to delete all game server file on the PVC before proceeding with the installation/update  
- The drive/directory which is containing the game server file mounted to `/home/gs/gameserver`

The environment variable can be set in the deployment config:  
```yaml
  env:
    - name: "STEAM_APP"
      value: "740"
    - name: "PURGE"
      value: "no"
```

A cronjob template can be found at [templates/steamcmd-updater-cronjob.yml](templates/steamcmd-updater-cronjob.yml)
