# docker-steamcmd-gs-updater
Docker container to update a steam game server (volume mount).

This image expects the following:
- Environment variable `STEAM_APP` set to the Steam APP ID you want to update
- The drive/directory which is containing the game server file mounted to `/home/steam/gameserver`


The environment variable can be set in the deployment config:  
```yaml
  env:
    - name: "STEAM_APP"
      value: "740"
```
